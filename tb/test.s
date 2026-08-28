# tb/test.s

    # Initialization
    addi x1, x0, 256
    addi x2, x0, 15
    addi x3, x0, 7

    # Load / Store
    sw   x2, 16(x1)
    lw   x4, 16(x1)

    # R-Type Arithmetic & Logic
    add  x5, x4, x3
    sub  x6, x5, x3
    and  x7, x5, x6
    or   x8, x5, x6
    slt  x9, x7, x8

    # Branch Test
    beq  x6, x4, target
    addi x10, x0, 999       # Should be skipped

target:
    addi x11, x9, 10
    add  x12, x11, x8

    unimp