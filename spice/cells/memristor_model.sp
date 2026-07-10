* SPDX-License-Identifier: GPL-3.0-or-later
* Copyright (C) 1993-2026 Abhishek Choudhary. All rights reserved. · AyeAI
* Behavioral bipolar memristor sub-circuit (voltage-dependent threshold drift).
.SUBCKT memristor_model PLUS MINUS
  .PARAM R_hrs=10Meg R_lrs=10k V_thr=0.8
  * Internal state variable tracking oxygen vacancy migration
  C_state STATE_VAR 0 1nF
  R_leak  STATE_VAR 0 100Meg
  * Voltage-controlled behavioral current source (state drift)
  G_drift 0 STATE_VAR CUR='V(PLUS,MINUS) > V_thr ? 1m*V(PLUS,MINUS) : (V(PLUS,MINUS) < -V_thr ? 1m*V(PLUS,MINUS) : 0)'
  * Effective device resistance as a function of state voltage
  G_memristor PLUS MINUS VALUE='V(PLUS,MINUS) / (R_lrs + (R_hrs - R_lrs)*V(STATE_VAR))'
.ENDS memristor_model
