* SPDX-License-Identifier: GPL-3.0-or-later
* Copyright (C) 1993-2026 Abhishek Choudhary. All rights reserved. · AyeAI
* PRATIK Ternary Event Accumulator Latch (TEL_X1) — three stable states
* (-1,0,+1) with a high-impedance retention node; stores poised 0 at charge
* neutrality (zero static holding current).
.SUBCKT TEL_X1 EV_IN WRITE_ENABLE STATE_OUT VDD VEE GND
  * 1. Pass-Gate Access Transistors (Low-Vth for instantaneous capture)
  M_P1 Internal_Node EV_IN WRITE_ENABLE VDD PMOS_LOW_VTH W=180n L=30n
  M_N1 Internal_Node EV_IN WRITE_ENABLE VEE NMOS_LOW_VTH W=180n L=30n
  * 2. Cross-Coupled Ternary Inverter Pair (Feedback Loop)
  M_F1 State_Inv     Internal_Node VDD VDD PMOS_HIGH_VTH W=240n L=45n
  M_F2 Internal_Node State_Inv     GND GND NMOS_HIGH_VTH W=120n L=45n
  M_F3 State_Inv     Internal_Node VEE VEE NMOS_HIGH_VTH W=240n L=45n
  M_F4 Internal_Node State_Inv     GND GND PMOS_HIGH_VTH W=120n L=45n
  * 3. Output Buffer Interface
  M_O1 STATE_OUT Internal_Node VDD VDD PMOS_MED_VTH W=120n L=30n
  M_O2 STATE_OUT Internal_Node VEE VEE NMOS_MED_VTH W=120n L=30n
.ENDS TEL_X1
