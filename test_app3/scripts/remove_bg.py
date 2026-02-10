"""
Remove background from PNG image.
Detects the background color from edges, then flood-fills to make it transparent.

Usage: python scripts/remove_bg.py
"""
from PIL import Image
import math

def remove_background(input_path, output_path, color_tolerance=35, edge_feather=3):
    img = Image.open(input_path).convert('RGBA')
    pixels = img.load()
    w, h = img.size

    # Sample edge pixels to determine background color
    edge_colors = []
    for x in range(w):
        edge_colors.append(pixels[x, 0][:3])
        edge_colors.append(pixels[x, h - 1][:3])
    for y in range(h):
        edge_colors.append(pixels[0, y][:3])
        edge_colors.append(pixels[w - 1, y][:3])

    # Average background color
    avg_r = sum(c[0] for c in edge_colors) // len(edge_colors)
    avg_g = sum(c[1] for c in edge_colors) // len(edge_colors)
    avg_b = sum(c[2] for c in edge_colors) // len(edge_colors)
    print(f'Detected background color: RGB({avg_r}, {avg_g}, {avg_b})')

    def is_bg(r, g, b):
        """Check if pixel color is close to the detected background."""
        dist = math.sqrt((r - avg_r) ** 2 + (g - avg_g) ** 2 + (b - avg_b) ** 2)
        return dist < color_tolerance

    # Flood fill from all edge pixels
    visited = set()
    bg_pixels = set()
    stack = []

    for x in range(w):
        stack.append((x, 0))
        stack.append((x, h - 1))
    for y in range(h):
        stack.append((0, y))
        stack.append((w - 1, y))

    while stack:
        x, y = stack.pop()
        if x < 0 or x >= w or y < 0 or y >= h:
            continue
        if (x, y) in visited:
            continue
        visited.add((x, y))

        r, g, b, a = pixels[x, y]
        if is_bg(r, g, b):
            bg_pixels.add((x, y))
            stack.append((x + 1, y))
            stack.append((x - 1, y))
            stack.append((x, y + 1))
            stack.append((x, y - 1))

    # Build distance map for feathering
    result = img.copy()
    rp = result.load()

    for x in range(w):
        for y in range(h):
            if (x, y) in bg_pixels:
                rp[x, y] = (0, 0, 0, 0)
            elif edge_feather > 0:
                # Check if near background for feathering
                min_dist = edge_feather + 1
                for dx in range(-edge_feather, edge_feather + 1):
                    for dy in range(-edge_feather, edge_feather + 1):
                        nx, ny = x + dx, y + dy
                        if (nx, ny) in bg_pixels:
                            dist = math.sqrt(dx * dx + dy * dy)
                            if dist < min_dist:
                                min_dist = dist
                if min_dist <= edge_feather:
                    r, g, b, a = pixels[x, y]
                    factor = min_dist / edge_feather
                    rp[x, y] = (r, g, b, int(a * factor))

    result.save(output_path, 'PNG')

    transparent = sum(1 for x in range(w) for y in range(h) if rp[x, y][3] == 0)
    total = w * h
    pct = transparent * 100 // total
    print(f'Done! {output_path}')
    print(f'Transparent: {transparent}/{total} ({pct}%)')
    print(f'Subject retained: {total - transparent} pixels')

if __name__ == '__main__':
    remove_background(
        'Gemini_Generated_Image_71f45571f45571f4.png',
        'assets/app_icon_clean.png',
        color_tolerance=35,
        edge_feather=3,
    )
