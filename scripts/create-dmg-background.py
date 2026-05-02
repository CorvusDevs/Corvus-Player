#!/usr/bin/env python3
"""Generate the DMG installer background image for Corvus Player."""

from PIL import Image, ImageDraw, ImageFont
import sys
import math

WIDTH, HEIGHT = 660, 400

def main():
    output = sys.argv[1] if len(sys.argv) > 1 else "dmg-background.png"

    img = Image.new("RGBA", (WIDTH * 2, HEIGHT * 2), (18, 18, 22, 255))
    draw = ImageDraw.Draw(img)

    # Subtle accent line at top
    draw.rectangle([(0, 0), (WIDTH * 2, 3)], fill=(45, 127, 249, 255))

    # Fonts
    try:
        title_font = ImageFont.truetype("/System/Library/Fonts/SFProDisplay-Bold.otf", 48)
        sub_font = ImageFont.truetype("/System/Library/Fonts/SFProDisplay-Regular.otf", 26)
    except (IOError, OSError):
        try:
            title_font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 48)
            sub_font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 26)
        except (IOError, OSError):
            title_font = ImageFont.load_default()
            sub_font = title_font

    # Title
    title = "Corvus Player"
    bbox = draw.textbbox((0, 0), title, font=title_font)
    tw = bbox[2] - bbox[0]
    draw.text(((WIDTH * 2 - tw) // 2, 55), title, fill=(232, 232, 237, 255), font=title_font)

    # Subtitle
    sub = "Drag to Applications to install"
    bbox = draw.textbbox((0, 0), sub, font=sub_font)
    sw = bbox[2] - bbox[0]
    draw.text(((WIDTH * 2 - sw) // 2, 120), sub, fill=(124, 124, 132, 255), font=sub_font)

    # Arrow between icon positions
    # Icons will be at 1x coords ~(180, 220) and ~(480, 220)
    # In 2x: app at ~360, applications at ~960, y ~470
    arrow_y = 470
    arrow_x1 = 480
    arrow_x2 = 840

    # Arrow shaft
    draw.line([(arrow_x1, arrow_y), (arrow_x2, arrow_y)], fill=(200, 200, 210, 160), width=3)

    # Arrowhead
    head_size = 18
    draw.polygon([
        (arrow_x2, arrow_y),
        (arrow_x2 - head_size, arrow_y - head_size // 2 - 3),
        (arrow_x2 - head_size, arrow_y + head_size // 2 + 3),
    ], fill=(200, 200, 210, 160))

    # Resize to 1x
    img = img.resize((WIDTH, HEIGHT), Image.LANCZOS)
    img.save(output, "PNG")
    print(f"Created {output} ({WIDTH}x{HEIGHT})")

if __name__ == "__main__":
    main()
