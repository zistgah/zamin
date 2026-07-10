* SPDX-License-Identifier: GPL-3.0-or-later
* Copyright (C) 1993-2026 Abhishek Choudhary. All rights reserved. · AyeAI
* PLACEHOLDER 30nm MTCMOS device models for the PRATIK ternary cells.
* Replace with a foundry PDK (BSIM4/BSIM-CMG) before any tape-out.
* Vth allocation (design intent): LOW +-0.15V, MED +-0.30V, HIGH +-0.45V.
.MODEL PMOS_LOW_VTH   PMOS (LEVEL=54 VTH0=-0.15)
.MODEL NMOS_LOW_VTH   NMOS (LEVEL=54 VTH0= 0.15)
.MODEL PMOS_MED_VTH   PMOS (LEVEL=54 VTH0=-0.30)
.MODEL NMOS_MED_VTH   NMOS (LEVEL=54 VTH0= 0.30)
.MODEL PMOS_HIGH_VTH  PMOS (LEVEL=54 VTH0=-0.45)
.MODEL NMOS_HIGH_VTH  NMOS (LEVEL=54 VTH0= 0.45)
.MODEL HV_PMOS        PMOS (LEVEL=54 VTH0=-0.60)
.MODEL HV_NMOS        NMOS (LEVEL=54 VTH0= 0.60)
* NOTE: LEVEL/params are illustrative placeholders, not silicon-calibrated.
