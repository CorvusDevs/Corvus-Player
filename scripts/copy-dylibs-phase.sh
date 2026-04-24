FRAMEWORKS_DIR="${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}"
DEPS_LIB="${SRCROOT}/deps/lib"

mkdir -p "${FRAMEWORKS_DIR}"

if [ -d "${DEPS_LIB}" ]; then
    for dylib in "${DEPS_LIB}"/*; do
        cp -f "${dylib}" "${FRAMEWORKS_DIR}/"
        codesign --force --sign - "${FRAMEWORKS_DIR}/$(basename "${dylib}")"
    done
    echo "Copied $(ls "${DEPS_LIB}" | wc -l | tr -d ' ') dylibs to ${FRAMEWORKS_DIR}"
else
    echo "warning: deps/lib not found — using Homebrew fallback"
fi
