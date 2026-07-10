* SPDX-License-Identifier: GPL-3.0-or-later
* Copyright (C) 1993-2026 Abhishek Choudhary. All rights reserved. · AyeAI
* PRATIK Phase II Ternary Memristive Crossbar Node (TMC_NODE) — complementary
* dual-memristor differential cell; +1 (M+ LRS), -1 (M- LRS), 0 (both max HRS).
.SUBCKT TMC_NODE ROW_IN COL_OUT_POS COL_OUT_NEG WRITE_EN VDD VEE GND
  M_ROW_GATE Internal_Row ROW_IN WRITE_EN VDD PMOS_HIGH_VTH W=180n L=45n
  M_GND_GATE Internal_Row ROW_IN WRITE_EN VEE NMOS_HIGH_VTH W=180n L=45n
  X_Mplus  Internal_Row COL_OUT_POS memristor_model
  X_Mminus Internal_Row COL_OUT_NEG memristor_model
.ENDS TMC_NODE
