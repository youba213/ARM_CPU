
/*----------------------------------------------------------------
//           test bt                                           //
----------------------------------------------------------------*/
	.text
	.globl	_start 
_start:
	mov r4, #24
	mov r3,	#26
	add r4, r4, #2  
	mov r2,	#10  
    CMP r4, r3
    BEQ _good 
	orr r1,	r1, #5
	sub r2,	r2, #3 
    nop
	nop
_bad :
	nop
	nop
_good :
	nop
	nop
AdrStack:  .word 0x80000000
