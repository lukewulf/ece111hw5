.text
    lw  $t0,  0($t0)
    lw  $t1,  4($t0)
    and $t2, $t0, $t1
    or  $t3, $t0, $t1
    sw  $t2, 8($t4)
    sw  $t3, 12($t4)