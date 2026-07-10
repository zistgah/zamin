# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 1993-2026 Abhishek Choudhary. All rights reserved. · AyeAI
#
# PRATIK Phase II microfluidic interposer layout generator.
# Maps TSVs + Keep-Out Zones down the centre-lines of the 15um structural fin
# walls; the exclusion radius (2.4um KOZ + 4.5um clearance = 6.9um) is < the
# wall half-width (7.5um), so the exclusion zones stay inside the solid silicon
# pillars, isolated from the fluid channels. Requires: pip install gdsfactory
import math
import gdsfactory as gf


def generate_circle_points(radius: float, num_points: int = 64) -> list:
    """Helper to generate localized polygon coordinates for circular targets."""
    points = []
    for i in range(num_points):
        theta = 2 * math.pi * i / num_points
        points.append((radius * math.cos(theta), radius * math.sin(theta)))
    return points


@gf.cell
def pratik_fluidic_interposer(
    num_channels: int = 16,
    channel_length: float = 1000.0,
    channel_width: float = 25.0,
    wall_width: float = 15.0,
    tsv_pitch_y: float = 48.0,
    tsv_koz_radius: float = 2.4,
    tsv_clearance: float = 4.5,
    layer_channels: tuple = (1, 0),   # Layer 1: Etched Fluid Channels
    layer_tsvs: tuple = (2, 0),       # Layer 2: Copper TSV Pillars
    layer_koz: tuple = (3, 0),        # Layer 3: Keep-Out Zone Boundaries
) -> gf.Component:
    """Generates layout geometries for the interleaved microfluidic infrastructure.

    Ensures that the 4.5um clearance threshold from the outer edge of the 2.4um KOZ
    is verified and maintained relative to the fluid channel boundaries.
    """
    c = gf.Component("PRATIK_PhaseII_Fluidic_Interposer")

    pitch_x = channel_width + wall_width
    total_exclusion_radius = tsv_koz_radius + tsv_clearance
    half_wall = wall_width / 2.0

    # 1. Physical Sanity Boundary Check
    if total_exclusion_radius > half_wall:
        raise ValueError(
            f"Layout Violation: Combined exclusion radius ({total_exclusion_radius}um) "
            f"exceeds the wall's structural half-width ({half_wall}um). "
            f"Fluid channel wall breach imminent."
        )

    # 2. Instantiate Microfluidic Channels (Etched Fluidic Troughs)
    for i in range(num_channels):
        x_left = i * pitch_x
        channel_poly = [
            (x_left, 0.0),
            (x_left + channel_width, 0.0),
            (x_left + channel_width, channel_length),
            (x_left, channel_length),
        ]
        c.add_polygon(channel_poly, layer=layer_channels)

    # 3. Instantiate TSV Core and KOZ Arrays (Centered inside Structural Walls)
    circle_tsv_base = generate_circle_points(tsv_koz_radius)
    circle_koz_base = generate_circle_points(total_exclusion_radius)

    for i in range(num_channels - 1):
        wall_center_x = (i * pitch_x) + channel_width + half_wall
        current_y = tsv_pitch_y / 2.0
        while current_y < channel_length:
            tsv_points = [(x + wall_center_x, y + current_y) for x, y in circle_tsv_base]
            koz_points = [(x + wall_center_x, y + current_y) for x, y in circle_koz_base]
            c.add_polygon(tsv_points, layer=layer_tsvs)
            c.add_polygon(koz_points, layer=layer_koz)
            current_y += tsv_pitch_y

    return c


if __name__ == "__main__":
    interposer_design = pratik_fluidic_interposer()
    gds_filename = "pratik_microfluidics_interposer.gds"
    interposer_design.write_gds(gds_filename)
    print(f"Success: Component layout file saved as '{gds_filename}'")
