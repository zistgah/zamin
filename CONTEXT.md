<!-- context: https://zistgah.org/zamin/ -->
# CONTEXT — cold-start map for Zamin

_A fresh AI session or contributor rebuilds full context from this file plus the sources it
points to. © 1993–2026 Abhishek Choudhary. All rights reserved. · AyeAI · GPL-3.0-or-later._

## Mission (one line)
The physical realization of the PRATIK balanced-ternary substrate for the PEDLER Event
Algebra — where the 0 V ground reference and the poised-zero computational state are the
same node, and language collisions spawn new physical dimensions on a memristive 3D crossbar.

## Rebuild context from three sources, in order
1. **[`CONTRACT.md`](CONTRACT.md)** — what PEDLER/PRATIK *is* and how to handle it. Read first.
2. **The paper** — [`paper/index.html`](paper/index.html) (also https://zistgah.org/zamin/paper/) —
   the full argument: MTCMOS ternary logic → memristive spawning → spatial compilation → thermal.
3. **The repository** — the executable/simulable proof: `index.html` (WYSIWYG simulator),
   `spice/` (cell library + testbench), `layout/` (gdsfactory generator), `manuscript/` (IEEE .tex).

## Invariants (never violate)
- Alphabet is balanced ternary `{-1,0,+1}`; the `0` state is a physical **high-impedance
  ground**, never a resistive mid-rail divider.
- `odot` (context gate) drives to high-Z on control 0; `boxplus` resolves `+1 boxplus -1 = 0` to ground.
- The spawning operator `*` is a physical event: a max-HRS (0) memristive node programmed 0→±1.
- Nothing here is measured silicon; SPICE models are placeholders pending a foundry PDK.
- Verify by execution; honest figures; flag, don't fake. Preserve SPDX + copyright headers.

## File map
| Path | Role |
|---|---|
| `index.html` | WYSIWYG ternary circuit simulator (Pages landing) |
| `paper/index.html` | the hardware-realization paper (monograph + AI-seed) |
| `spice/cells/`, `spice/sign_frustration_tb.sp` | SPICE cell library + transient testbench |
| `spice/models/` | placeholder 30 nm MTCMOS models (replace with PDK) |
| `layout/pratik_fluidic_interposer.py` | gdsfactory microfluidic interposer generator |
| `manuscript/pratik_phase2.tex` | IEEE-style archival manuscript |
| `references.bib` | verified bibliography |
| `doi/misty.json` | DOI deposit metadata |
| `zistgah_seed_zamin.sh` | seed repo + mint DOI + OpenTimestamps |

## Working rules
fork → PR → review → merge; PRs loud; incremental patches; no irreversible step without a
typed confirmation; tokens from the environment only.
