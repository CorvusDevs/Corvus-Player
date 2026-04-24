#!/usr/bin/env python3
"""
bundle-dylibs.py — Collect libmpv and all transitive Homebrew dependencies,
copy them into deps/lib/, and rewrite install names to @rpath/.

Usage:
    python3 scripts/bundle-dylibs.py [--source /opt/homebrew] [--root-lib libmpv.2.dylib]

The script:
  1. Starts from the root library (libmpv.2.dylib by default)
  2. BFS-walks all transitive dependencies via otool -L
  3. Copies each Homebrew dylib into deps/lib/ with its canonical short name
  4. Rewrites each dylib's LC_ID_DYLIB to @rpath/<name>
  5. Rewrites each dylib's LC_LOAD_DYLIB references to @rpath/<name>
  6. Also copies mpv headers into deps/include/

Run this whenever you update Homebrew's mpv/ffmpeg.
"""

import os
import re
import shutil
import subprocess
import sys
from pathlib import Path


def get_deps(lib_path: str) -> list[str]:
    """Return list of dependency paths from otool -L output."""
    try:
        out = subprocess.check_output(
            ["otool", "-L", lib_path], stderr=subprocess.DEVNULL, text=True
        )
    except subprocess.CalledProcessError:
        return []
    deps = []
    for line in out.splitlines()[1:]:  # skip first line (the lib itself)
        line = line.strip()
        if not line:
            continue
        path = line.split()[0]
        deps.append(path)
    return deps


def canonical_name(full_path: str) -> str:
    """Extract the short library name, e.g. libmpv.2.dylib from a full path."""
    name = os.path.basename(os.path.realpath(full_path))
    # Collapse version suffixes: libfoo.1.2.3.dylib -> libfoo.1.dylib
    # Keep only the major version number before .dylib
    m = re.match(r"(lib\w+?)\.(\d+)(?:\.\d+)*\.dylib$", name)
    if m:
        return f"{m.group(1)}.{m.group(2)}.dylib"
    # Handle: libfoo.dylib (no version)
    m = re.match(r"(lib\w+?)\.dylib$", name)
    if m:
        return name
    # Handle Python framework
    if "Python.framework" in full_path:
        return "Python"
    return name


def is_homebrew(path: str, homebrew_prefix: str) -> bool:
    """Check if a path is a Homebrew-managed library."""
    real = os.path.realpath(path)
    return real.startswith(homebrew_prefix) or path.startswith(homebrew_prefix)


def is_system(path: str) -> bool:
    """Check if a path is a system library (should NOT be bundled)."""
    return (
        path.startswith("/usr/lib/")
        or path.startswith("/System/")
        or path.startswith("/Library/")
    )


def collect_deps(root_lib: str, homebrew_prefix: str) -> dict[str, str]:
    """BFS-walk all transitive Homebrew dependencies.
    Returns {canonical_name: real_path} for all libs to bundle."""
    to_bundle: dict[str, str] = {}  # canonical_name -> real_path
    visited: set[str] = set()
    queue: list[str] = [root_lib]

    while queue:
        lib = queue.pop(0)
        real = os.path.realpath(lib)
        if real in visited:
            continue
        visited.add(real)

        if not os.path.isfile(real):
            print(f"  WARNING: {lib} -> {real} does not exist, skipping")
            continue

        cname = canonical_name(real)

        # Skip system libs
        if is_system(real):
            continue

        # Only bundle Homebrew libs
        if is_homebrew(real, homebrew_prefix):
            if cname not in to_bundle:
                to_bundle[cname] = real
                print(f"  Found: {cname} ({real})")

            # Recurse into this lib's dependencies
            for dep in get_deps(real):
                dep_real = os.path.realpath(dep)
                if dep_real not in visited and is_homebrew(dep, homebrew_prefix):
                    queue.append(dep)

    return to_bundle


def copy_and_rewrite(
    to_bundle: dict[str, str], deps_lib: Path, homebrew_prefix: str
):
    """Copy dylibs to deps/lib/ and rewrite all paths to @rpath/."""
    # Build reverse map: real_path -> canonical_name (for rewriting references)
    # Also map original otool paths to canonical names
    path_to_canonical: dict[str, str] = {}
    for cname, real_path in to_bundle.items():
        path_to_canonical[real_path] = cname

    # First pass: copy all dylibs
    for cname, real_path in to_bundle.items():
        dest = deps_lib / cname
        shutil.copy2(real_path, dest)
        os.chmod(dest, 0o755)  # make writable for install_name_tool

    # Second pass: rewrite install names
    for cname in to_bundle:
        dest = deps_lib / cname
        dest_str = str(dest)

        # Change the library's own ID
        subprocess.run(
            ["install_name_tool", "-id", f"@rpath/{cname}", dest_str],
            check=True,
            capture_output=True,
        )

        # Rewrite all dependency references
        for dep_path in get_deps(dest_str):
            if is_system(dep_path):
                continue
            dep_real = os.path.realpath(dep_path)
            # Try to find canonical name
            dep_cname = path_to_canonical.get(dep_real)
            if not dep_cname:
                # Try matching by basename
                dep_cname = canonical_name(dep_path)
                if dep_cname not in to_bundle:
                    continue

            if dep_path != f"@rpath/{dep_cname}":
                subprocess.run(
                    [
                        "install_name_tool",
                        "-change",
                        dep_path,
                        f"@rpath/{dep_cname}",
                        dest_str,
                    ],
                    check=True,
                    capture_output=True,
                )

    print(f"\nRewrote {len(to_bundle)} dylibs in {deps_lib}")


def copy_headers(homebrew_prefix: str, deps_include: Path):
    """Copy mpv headers to deps/include/."""
    mpv_include = Path(homebrew_prefix) / "opt" / "mpv" / "include" / "mpv"
    if not mpv_include.is_dir():
        print(f"WARNING: mpv headers not found at {mpv_include}")
        return

    dest = deps_include / "mpv"
    if dest.exists():
        shutil.rmtree(dest)
    shutil.copytree(mpv_include, dest)
    headers = list(dest.glob("*.h"))
    print(f"Copied {len(headers)} mpv headers to {dest}")


def verify(deps_lib: Path, homebrew_prefix: str):
    """Verify all dylibs only reference @rpath/ or system paths."""
    errors = 0
    for dylib in sorted(deps_lib.glob("*.dylib")):
        for dep in get_deps(str(dylib)):
            if dep.startswith("@rpath/") or is_system(dep):
                continue
            if dep.startswith(homebrew_prefix) or dep.startswith("/opt/homebrew"):
                print(f"  ERROR: {dylib.name} still references {dep}")
                errors += 1
    if errors:
        print(f"\n{errors} absolute Homebrew references remain!")
        sys.exit(1)
    else:
        print("Verification passed — all references use @rpath/ or system paths")


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Bundle libmpv dylibs for standalone release")
    parser.add_argument("--source", default="/opt/homebrew", help="Homebrew prefix")
    parser.add_argument("--root-lib", default=None, help="Root library path")
    args = parser.parse_args()

    homebrew_prefix = os.path.realpath(args.source)

    # Find libmpv
    if args.root_lib:
        root_lib = args.root_lib
    else:
        root_lib = os.path.join(homebrew_prefix, "opt", "mpv", "lib", "libmpv.2.dylib")

    if not os.path.isfile(root_lib):
        print(f"ERROR: Root library not found: {root_lib}")
        sys.exit(1)

    # Project paths
    project_root = Path(__file__).resolve().parent.parent
    deps_lib = project_root / "deps" / "lib"
    deps_include = project_root / "deps" / "include"

    print(f"Project root: {project_root}")
    print(f"Homebrew prefix: {homebrew_prefix}")
    print(f"Root library: {root_lib}")
    print(f"Output: {deps_lib}")
    print()

    # Clean and create output dirs
    if deps_lib.exists():
        shutil.rmtree(deps_lib)
    deps_lib.mkdir(parents=True)
    deps_include.mkdir(parents=True, exist_ok=True)

    # Collect all dependencies
    print("Collecting transitive dependencies...")
    to_bundle = collect_deps(root_lib, homebrew_prefix)
    print(f"\nTotal dylibs to bundle: {len(to_bundle)}")
    print()

    # Copy and rewrite
    print("Copying and rewriting install names...")
    copy_and_rewrite(to_bundle, deps_lib, homebrew_prefix)
    print()

    # Copy headers
    print("Copying mpv headers...")
    copy_headers(homebrew_prefix, deps_include)
    print()

    # Verify
    print("Verifying...")
    verify(deps_lib, homebrew_prefix)

    # Summary
    total_size = sum(f.stat().st_size for f in deps_lib.glob("*")) / (1024 * 1024)
    print(f"\nDone! {len(to_bundle)} dylibs ({total_size:.1f} MB) in {deps_lib}")
    print(f"Next: update Xcode build settings to use deps/ instead of Homebrew")


if __name__ == "__main__":
    main()
