* SPDX-License-Identifier: GPL-3.0-or-later
* Copyright (C) 1993-2026 Abhishek Choudhary. All rights reserved. · AyeAI
* PRATIK Ternary Address Resolution Column Routing Node (TAR_NODE) — drives a
* crossbar row to +0.6V / -0.6V, or clamps to 0.0V (hi-Z) for dormant paths.
.SUBCKT TAR_NODE ADDR_BIT_IN SELECT_LNE ROW_LINE_OUT VDD VEE GND
  M_P1 Net_Pos ADDR_BIT_IN SELECT_LNE VDD PMOS_LOW_VTH W=180n L=30n
  M_N1 Net_Neg ADDR_BIT_IN SELECT_LNE VEE NMOS_LOW_VTH W=180n L=30n
  M_D1 ROW_LINE_OUT Net_Pos VDD VDD PMOS_HIGH_VTH W=320n L=45n
  M_D2 ROW_LINE_OUT Net_Neg VEE VEE NMOS_HIGH_VTH W=320n L=45n
  M_C1 ROW_LINE_OUT ADDR_BIT_IN GND GND NMOS_MED_VTH W=90n L=30n
  M_C2 ROW_LINE_OUT ADDR_BIT_IN GND GND PMOS_MED_VTH W=90n L=30n
.ENDS TAR_NODE
