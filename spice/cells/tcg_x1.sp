* SPDX-License-Identifier: GPL-3.0-or-later
* Copyright (C) 1993-2026 Abhishek Choudhary. All rights reserved. · AyeAI
* PRATIK Primitive Ternary Gating Cell (TCG_X1) — physicalizes the context
* gate (odot): OUT passes IN when C is active; C=0 => high-impedance (poised 0).
.SUBCKT TCG_X1 IN C OUT VDD VEE GND
  * 1. Context Detection Sub-Network (High-Vth Isolation)
  M_C1 Node_PullUp   C VDD VDD PMOS_HIGH_VTH W=120n L=30n
  M_C2 Node_PullDown C VEE VEE NMOS_HIGH_VTH W=120n L=30n
  * 2. Trajectory Switching Sub-Network (Low-Vth Signal Paths)
  M_S1 OUT IN Node_PullUp   VDD PMOS_LOW_VTH W=240n L=30n
  M_S2 OUT IN Node_PullDown VEE NMOS_LOW_VTH W=240n L=30n
  * 3. Poised Zero Stabilization Network (clamp to GND only if both pulls inactive)
  M_Z1 OUT Node_PullUp   GND GND NMOS_MED_VTH W=60n L=30n
  M_Z2 OUT Node_PullDown GND GND PMOS_MED_VTH W=60n L=30n
.ENDS TCG_X1
