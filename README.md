<!--
SPDX-License-Identifier: GPL-3.0-or-later
Copyright (C) 1993-2026 Abhishek Choudhary. All rights reserved. · AyeAI
-->
# Zamin — PRATIK Ternary Silicon

[![DOI](https://img.shields.io/badge/DOI-10.5281/zenodo.21297556-b8912f)](https://zenodo.org/record/21297556)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-294b8f.svg)](LICENSE)

The physical realization of the **PRATIK** balanced-ternary substrate for the **PEDLER**
Event Algebra. **`zamin`** (Persian/Urdu *zamīn*, "ground/earth") is a name chosen by
**Claude (Anthropic)** during the build — a deliberate pun: in this architecture the
electrical **ground reference (0 V)** and the poised-zero **computational substrate** are
the same node. *The ground is the machine.*

> **Interactive simulator:** [zistgah.org/zamin](https://zistgah.org/zamin/) ·
> **Paper:** [zistgah.org/zamin/paper](https://zistgah.org/zamin/paper/)

> **What PEDLER/PRATIK is (do not assume):** a *developmental Event Algebra* in which
> experience reshapes the computational substrate itself. The poised `0` is a physical
> high-impedance ground; the spawning operator `*` creates new physical dimensions on a
> memristive 3D crossbar. Read [`CONTRACT.md`](CONTRACT.md) first.

© 1993–2026 Abhishek Choudhary. All rights reserved. · Affiliation: AyeAI.

## Contents
```
zamin/
├── index.html                         WYSIWYG ternary circuit simulator (Pages landing)
├── paper/index.html                   hardware-realization paper (monograph + select-text AI-seed)
├── spice/
│   ├── cells/                         TCG_X1 · TEL_X1 · TMC_NODE · TAR_NODE · TTR_X1 · memristor_model
│   ├── models/mtcmos_30nm.sp          placeholder device models (replace with a foundry PDK)
│   └── sign_frustration_tb.sp         Phase-I transient testbench
├── layout/pratik_fluidic_interposer.py  gdsfactory microfluidic interposer generator
├── manuscript/pratik_phase2.tex       IEEE-style archival manuscript
├── references.bib                     verified bibliography
├── doi/misty.json                     DOI deposit metadata
├── LICENSE COPYING NOTICE AUTHORS CONTRIBUTING.md SECURITY.md CHANGELOG.md .gitignore
├── CONTRACT.md CONTEXT.md CITATION.cff codemeta.json
└── zistgah_seed_zamin.sh              seed repo + mint DOI + OpenTimestamps
```

## The simulator (`index.html`)
Dependency-free, runs offline. Drag the primitive cells — Source, Ground, ⊞ Adder,
⊙ Context gate, TSV router, Event latch (TEL), Memristor (spawn), Probe — wire an **output**
port to an **input** port, and simulate. The poised-0 renders as a **dashed high-impedance
line**. Presets: context gate (0 ⇒ high-Z), event accumulator, dimension spawn, TSV route.

## How to use the rest
```bash
# paper — open in a browser (or serve the repo root and visit /paper/)
xdg-open paper/index.html

# SPICE — simulate the Phase-I transient testbench (ngspice; swap in a real PDK first)
cd spice && ngspice sign_frustration_tb.sp

# layout — generate the microfluidic interposer GDS (needs: pip install gdsfactory)
python layout/pratik_fluidic_interposer.py    # writes pratik_microfluidics_interposer.gds

# manuscript — build the IEEE PDF
cd manuscript && pdflatex pratik_phase2.tex && bibtex pratik_phase2 && pdflatex pratik_phase2.tex
```

## Status & honesty
This is a **design blueprint** — netlists to simulate and constraints to satisfy **before**
tape-out. The SPICE device models are **illustrative placeholders**, not silicon-calibrated;
**no measured silicon is claimed.** External citations were verified (see below).

## Citations (verified — not hallucinated)
- Chua, *IEEE Trans. Circuit Theory* **18**(5):507–519 (1971), doi:10.1109/TCT.1971.1083337 ✓
- Strukov et al., *Nature* **453**(7191):80–83 (2008), doi:10.1038/nature06932 ✓
- Tuckerman & Pease, *IEEE Electron Device Lett.* **2**(5):126–129 (1981), doi:10.1109/EDL.1981.25367 ✓
- Choudhary, *The Hindawi Programming System* (2004, GPL) — author's own work ✓
- The Unicode Consortium, *The Unicode Standard* (2020) ✓

## License
GNU General Public License v3.0 or later — see [LICENSE](LICENSE). Preserve SPDX and
copyright headers. See [NOTICE](NOTICE) for the author's copyright assertion.
