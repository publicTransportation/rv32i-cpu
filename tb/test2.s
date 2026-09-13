.globl _start
.text # load into execution memory
_start: 
    # ----------------------------------------------------
    # Phase 1: Set up x1 (256) & scratchpad values
    # ----------------------------------------------------
    # 1. lui
    lui   x13, 1                 # x13 = 0x00001000
    # 2. srai
    srai  x1, x13, 4             # x1 = 256 (0x00000100) -> golden ref_rf[1] = 256

    # ----------------------------------------------------
    # Phase 2: Memory Ops (Stores & Loads) using x1 as base
    # Tests: sw, sh, sb, lw, lh, lhu, lb, lbu
    # ----------------------------------------------------
    # 3. addi
    addi  x14, x0, 0x5A          # x14 = 0x0000005A (90)
    # 4. slli
    slli  x15, x14, 8            # x15 = 0x00005A00
    # 5. ori
    ori   x15, x15, 0xEF         # x15 = 0x00005AEF

    # 6. sw
    sw    x15, 0(x1)             # mem[0x100..0x103] = 0x00005AEF
    # 7. sh
    sh    x14, 4(x1)             # mem[0x104..0x105] = 0x005A
    # 8. sb
    sb    x15, 6(x1)             # mem[0x106] = 0xEF (-17 signed)

    # 9. lw
    lw    x16, 0(x1)             # x16 = 0x00005AEF
    # 10. lh
    lh    x17, 0(x1)             # x17 = 0xFFFF5AEF (-42257)
    # 11. lhu
    lhu   x18, 0(x1)             # x18 = 0x00005AEF
    # 12. lb
    lb    x19, 6(x1)             # x19 = 0xFFFFFFEF (-17)
    # 13. lbu
    lbu   x20, 6(x1)             # x20 = 0x000000EF (239)

    # ----------------------------------------------------
    # Phase 3: Immediate Arithmetic, Shifts & Logic
    # ----------------------------------------------------
    # 14. slti
    slti  x21, x19, 0            # -17 < 0 -> x21 = 1
    # 15. sltiu
    sltiu x22, x20, 10           # 239 < 10 (unsigned) -> x22 = 0
    # 16. xori
    xori  x23, x21, 14           # 1 ^ 14 = 15 (0x0000000F) -> x23 = 15
    # 17. andi
    andi  x3, x23, 7             # 15 & 7 = 7 -> golden ref_rf[3] = 7
    # 18. srli
    srli  x24, x23, 1            # 15 >> 1 = 7

    # ----------------------------------------------------
    # Phase 4: Register-Register Operations
    # ----------------------------------------------------
    # 19. add
    add   x2, x0, x23            # golden ref_rf[2] = 15
    # 20. sub
    sub   x7, x2, x21            # 15 - 1 = 14
    # 21. or
    or    x4, x0, x2             # golden ref_rf[4] = 15
    # 22. and
    and   x7, x7, x3             # 14 (0b1110) & 7 (0b0111) = 6 -> golden ref_rf[7] = 6
    # 23. xor
    xor   x6, x0, x4             # golden ref_rf[6] = 15
    # 24. sll
    sll   x25, x21, x7           # 1 << 6 = 64
    # 25. srl
    srl   x26, x25, x21          # 64 >> 1 = 32
    # 26. sra
    sra   x27, x19, x21          # -17 >> 1 = -9 (0xFFFFFFF7)
    # 27. slt
    slt   x9, x27, x25           # -9 < 64 (signed) -> golden ref_rf[9] = 1
    # 28. sltu
    sltu  x28, x25, x27          # 64 < 0xFFFFFFF7 (unsigned) -> x28 = 1

    # ----------------------------------------------------
    # Phase 5: Populate Remaining Golden Registers (x5, x8, x11, x12)
    # ----------------------------------------------------
    add   x5, x2, x3             # 15 + 7 = 22 -> golden ref_rf[5] = 22
    or    x8, x5, x9             # 22 (0b10110) | 1 (0b00001) = 23; 23 | 8 = 31
    ori   x8, x8, 8              # golden ref_rf[8] = 31
    sub   x11, x4, x4            # x11 = 0
    ori   x11, x11, 11           # golden ref_rf[11] = 11
    slli  x12, x21, 5            # 1 << 5 = 32
    add   x12, x12, x11          # 32 + 11 = 43
    sub   x12, x12, x9           # 43 - 1 = 42 -> golden ref_rf[12] = 42

    # ----------------------------------------------------
    # Phase 6: Branch & Jump Instructions
    # Tests: beq, bne, blt, bge, bltu, bgeu, jal, jalr, auipc
    # ----------------------------------------------------
    # 29. beq
    beq   x2, x4, t_beq          # 15 == 15 (taken)
    addi  x10, x0, 99            # skipped

    # 30. bne
    bne   x2, x3, t_bne          # 15 != 7 (taken)
    addi  x10, x0, 99            # skipped

    # 31. blt
    blt   x27, x2, t_blt         # -9 < 15 signed (taken)
    addi  x10, x0, 99            # skipped

    # 32. bge
    bge   x2, x27, t_bge         # 15 >= -9 signed (taken)
    addi  x10, x0, 99            # skipped

    # 33. bltu
    bltu  x2, x27, t_bltu        # 15 < 0xFFFFFFF7 unsigned (taken)
    addi  x10, x0, 99            # skipped

    # 34. bgeu
    bgeu  x27, x2, t_bgeu        # 0xFFFFFFF7 >= 15 unsigned (taken)
    addi  x10, x0, 99            # skipped

    # 35. jal
    jal   x29, t_jal             # x29 gets return address (PC + 4)
    addi  x10, x0, 99            # skipped

    # 36. auipc
    auipc x30, 0                 # x30 = PC
    addi  x30, x30, 16           # target address = t_jalr

    # 37. jalr
    jalr  x31, x30, 0            # jump to t_jalr, x31 gets PC + 4
    addi  x10, x0, 99            # skipped

    # ----------------------------------------------------
    # Phase 7: Scratchpad Cleanup (Reset x13..x31 back to 0)
    # ----------------------------------------------------
    xor   x13, x13, x13
    xor   x14, x14, x14
    xor   x15, x15, x15
    xor   x16, x16, x16
    xor   x17, x17, x17
    xor   x18, x18, x18
    xor   x19, x19, x19
    xor   x20, x20, x20
    xor   x21, x21, x21
    xor   x22, x22, x22
    xor   x23, x23, x23
    xor   x24, x24, x24
    xor   x25, x25, x25
    xor   x26, x26, x26
    xor   x27, x27, x27
    xor   x28, x28, x28
    xor   x29, x29, x29
    xor   x30, x30, x30
    xor   x31, x31, x31 

    jal x0, 0