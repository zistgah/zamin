* SPDX-License-Identifier: GPL-3.0-or-later
* Copyright (C) 1993-2026 Abhishek Choudhary. All rights reserved. · AyeAI
* PRATIK Phase I MTCMOS Sign-Frustration Transient Testbench.
* Verifies the high-Vth isolation prevents +0.6V/-0.6V rail short-circuit.
.OPTIONS POST PROBE ACCURATE=1
.INCLUDE "./models/mtcmos_30nm.sp"
.INCLUDE "./cells/tcg_x1.sp"
.INCLUDE "./cells/tel_x1.sp"

V_VDD VDD 0 DC=0.6
V_VEE VEE 0 DC=-0.6
V_GND GND 0 DC=0.0

* Quiescent(0) -> Active(+1) -> Frustrated(-1) -> Poised(0)
V_EV_IN EV_IN 0 PULSE(0.0 0.6 1ns 100ps 100ps 2ns 5ns)
V_CTX   C     0 PWL(0ns 0.0 0.5ns 0.6 3ns 0.6 3.2ns 0.0 6ns 0.0)
V_WE    WE    0 PULSE(0.0 0.6 0.2ns 50ps 50ps 4ns 10ns)

X_GATE1 EV_IN C GATED_NET VDD VEE GND TCG_X1
X_MEM1  GATED_NET WE STATE_OUT VDD VEE GND TEL_X1

R_LOAD STATE_OUT 0 50k
C_LOAD STATE_OUT 0 12fF

.TRAN 10ps 12ns
.MEASURE TRAN Dynamic_Current_Peak MAX I(V_VDD) FROM=0ns TO=12ns
.MEASURE TRAN Settlement_Delay TRIG V(EV_IN) VAL=0.3 RISE=1 TARG V(STATE_OUT) VAL=0.3 RISE=1
.END
