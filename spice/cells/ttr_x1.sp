* SPDX-License-Identifier: GPL-3.0-or-later
* Copyright (C) 1993-2026 Abhishek Choudhary. All rights reserved. · AyeAI
* PRATIK Phase II Ternary TSV Vertical Routing Switch (TTR_X1) — bidirectional
* three-way vertical mux; routes +-0.6V execution and +-1.4V spawning pulses.
.SUBCKT TTR_X1 XY_NODE_INT TSV_UP TSV_DOWN CTRL_UP CTRL_DOWN VDD_HV VEE_HV GND
  X_PROT_UP   CTRL_UP   GND Protected_Ctrl_Up   high_voltage_clamp
  X_PROT_DOWN CTRL_DOWN GND Protected_Ctrl_Down high_voltage_clamp
  M_P_UP1 TSV_UP XY_NODE_INT Protected_Ctrl_Up   VDD_HV HV_PMOS W=480n L=90n
  M_N_UP1 TSV_UP XY_NODE_INT Protected_Ctrl_Down VEE_HV HV_NMOS W=360n L=90n
  M_P_DN1 TSV_DOWN XY_NODE_INT Protected_Ctrl_Down VDD_HV HV_PMOS W=480n L=90n
  M_N_DN1 TSV_DOWN XY_NODE_INT Protected_Ctrl_Up   VEE_HV HV_NMOS W=360n L=90n
  M_C_UP   TSV_UP   Protected_Ctrl_Up   GND GND HV_NMOS W=120n L=60n
  M_C_DOWN TSV_DOWN Protected_Ctrl_Down GND GND HV_NMOS W=120n L=60n
.ENDS TTR_X1
