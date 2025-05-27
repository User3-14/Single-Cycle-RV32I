8:  addi x1, x0, 5
12: slli x2, x1, 5
16: or x3, x1, x2
20: addi x4, x1, -6
24: xor x5, x3, x4
28: blt x1, x2, 8
32: addi x6, x0, -1
36: addi x6, x0, 1
40: sh x4, 0(x1)
44: lbu x7, -1(x1)