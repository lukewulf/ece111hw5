.data 
array: 1 2 3 4 5 
sum:   0
.text
	addi	$t1, $t0, 0x00000000
	addi	$t2, $t1, 0x00000014
	addi	$t3, $t0, 0
L1:
	beq	$t1, $t2, store
	lw	$t4, 0($t1)
	add	$t3, $t3, $t4
	addi	$t1, $t1, 4
	j	L1
store:
	sw	$t3, 0($t2)