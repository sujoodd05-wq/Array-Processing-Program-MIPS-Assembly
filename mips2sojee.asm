.data

msg: .asciiz "Please keep entering integer numbers until you read word done\n"
doneMsg: .asciiz "done\n"
newline: .asciiz "\n"
goodbye: .asciiz "Good Bye\nSujood Ziad Daghlas\n"
sortedMsg: .asciiz "Sorted:\n"
posMsg: .asciiz "Positive: "
negMsg: .asciiz "Negative: "
avgMsg: .asciiz "Average: "
evenMsg: .asciiz "Even nums:\n"
oddMsg: .asciiz "Odd nums:\n"

.align 2
arrayA: .word 0:10
arrayB: .word 0:10
arrayC: .word 0:20

.text
.globl main

main:

li $v0,4
la $a0,msg
syscall

la $s0,arrayA
la $s1,arrayB

li $t0,0   # countA
li $t1,0   # countB

readLoop:
li $v0,5
syscall
move $t2,$v0
beq $t2,$zero,finishRead

andi $t3,$t2,1
beq $t3,$zero,storeEven
j storeOdd

storeEven:
beq $t0,10,finishRead
sw $t2,0($s0)
addi $s0,$s0,4
addi $t0,$t0,1
j readLoop

storeOdd:
beq $t1,10,finishRead
sw $t2,0($s1)
addi $s1,$s1,4
addi $t1,$t1,1
j readLoop

finishRead:
li $v0,4
la $a0,doneMsg
syscall

li $v0,4
la $a0,evenMsg
syscall
la $s0,arrayA
li $t4,0
printA:
beq $t4,$t0,endPrintA
lw $a0,0($s0)
li $v0,1
syscall
li $v0,4
la $a0,newline
syscall
addi $s0,$s0,4
addi $t4,$t4,1
j printA
endPrintA:

li $v0,4
la $a0,oddMsg
syscall
la $s1,arrayB
li $t4,0
printB:
beq $t4,$t1,endPrintB
lw $a0,0($s1)
li $v0,1
syscall
li $v0,4
la $a0,newline
syscall
addi $s1,$s1,4
addi $t4,$t4,1
j printB
endPrintB:

add $s3,$t0,$t1    # total elements = countA + countB

la $a0,arrayA
la $a1,arrayB
la $a2,arrayC
move $a3,$t0
move $t3,$t1
jal combine

li $v0,4
la $a0,sortedMsg
syscall
la $s2,arrayC
move $t6,$s3
li $t4,0
printC:
beq $t4,$t6,endPrintC
lw $a0,0($s2)
li $v0,1
syscall
li $v0,4
la $a0,newline
syscall
addi $s2,$s2,4
addi $t4,$t4,1
j printC
endPrintC:

#positive count
li $v0,4
la $a0,posMsg
syscall
move $a0,$s4
li $v0,1
syscall
li $v0,4
la $a0,newline
syscall

#negative count
li $v0,4
la $a0,negMsg
syscall
move $a0,$s5
li $v0,1
syscall
li $v0,4
la $a0,newline
syscall

#average
li $t4,0        
la $s2,arrayC    
li $t7,0        
sumLoop:
beq $t4,$t6,endSumLoop
lw $t5,0($s2)
add $t7,$t7,$t5
addi $s2,$s2,4
addi $t4,$t4,1
j sumLoop
endSumLoop:
li $v0,4
la $a0,avgMsg
syscall
div $t7,$t6
mflo $a0
li $v0,1
syscall
li $v0,4
la $a0,newline
syscall

li $v0,4
la $a0,goodbye
syscall
li $v0,10
syscall

combine:

move $s0,$a0  # pointer A
move $s1,$a1  # pointer B
move $s2,$a2  # pointer C

li $t4,0

copyA:
beq $t4,$a3,copyB
lw $t5,0($s0)
sw $t5,0($s2)
addi $s0,$s0,4
addi $s2,$s2,4
addi $t4,$t4,1
j copyA

copyB:
li $t4,0
copyBloop:
beq $t4,$t3,sortStart
lw $t5,0($s1)
sw $t5,0($s2)
addi $s1,$s1,4
addi $s2,$s2,4
addi $t4,$t4,1
j copyBloop

sortStart:
move $s2,$a2
add $t6,$a3,$t3  
li $t0,0
outerLoop:
beq $t0,$t6,countStart
move $s2,$a2
li $t1,0
innerLoop:
addi $t7,$t6,-1
beq $t1,$t7,nextOuter
lw $t4,0($s2)
lw $t5,4($s2)
ble $t4,$t5,noSwap
sw $t5,0($s2)
sw $t4,4($s2)
noSwap:
addi $s2,$s2,4
addi $t1,$t1,1
j innerLoop
nextOuter:
addi $t0,$t0,1
j outerLoop

countStart:
move $s2,$a2
li $s4,0    
li $s5,0   
li $t4,0
countLoop:
beq $t4,$t6,endCombine
lw $t5,0($s2)
bltz $t5,isNeg
addi $s4,$s4,1
j nextNum
isNeg:
addi $s5,$s5,1
nextNum:
addi $s2,$s2,4
addi $t4,$t4,1
j countLoop
endCombine:
jr $ra
