	.arch armv8-a
	.text

// print function is complete, no modifications needed
    .global	print
print:
      stp    x29, x30, [sp, -16]! //Store FP, LR.
      add    x29, sp, 0
      mov    x3, x0
      mov    x2, x1
      ldr    w0, startstring
      mov    x1, x3
      bl     printf
      ldp    x29, x30, [sp], 16
      ret

startstring:
	.word	string0

    .global	towers
towers:
   /* Save calllee-saved registers to stack */
    stp    x29, x30, [sp, -64]!
    add    x29, sp, 0
    stp    x19, x20, [sp, 16]
    stp    x21, x22, [sp, 32]
    str    x23, [sp, 48]  /* x23 used for steps */
    /* Save a copy of all 3 input parameters onto the stack */
    
    
   /* Save a copy of all 3 incoming parameters to callee-saved registers */
    mov    x19, x0 /* NumOfDisks */
    mov    x20, x1 /* Start */
    mov    x21, x2 /* Goal */
if:
   /* Compare numDisks with 2 or (numDisks - 2)*/
   /* Check if less than, else branch to else */
    cmp   x19, 2
    B.ge  else
   /* set print function's start to incoming start */
   /* set print function's end to goal */
    mov   x0, x20
    mov   x1, x21
   /* call print function */
    bl    print
  /* Set return register to 1 */
   /* branch to endif */
    mov   x0, #1
    b     endif
else:
/*calculate peg */
    mov   x9, #6      /* Use the 0 to load -6 into x9 */
    sub   x22, x9, x1   /* Calcualte peg */
    sub   x22, x22, x2    /* x22 stores peg */

   /* subtract 1 from original numDisks and store it to numDisks parameter */
    sub   x0, x19, 1
    mov   x1, x20
    mov   x2, x22
    /* Call towers function */
    bl    towers
    
    mov   x23, x0

    mov   x0, #1
    mov   x1, x20
    mov   x2, x21
    bl    towers
    add   x23, x23, x0

    sub   x0, x19, 1
    mov   x1, x22
    mov   x2, x21
    bl    towers
    add   x0, x23, x0
   /* Set end parameter as temp */
   /* Save result to callee-saved register for total steps */
   /* Set numDiscs parameter to 1 */
   /* Set start parameter to original start */
   /* Set goal parameter to original goal */
   /* Call towers function */
   /* Add result to total steps so far */
   
   /* Set numDisks parameter to original numDisks - 1 */
   /* set start parameter to temp */
   /* set goal parameter to original goal */
   /* Call towers function */
   /* Add result to total steps so far and save it to return register */

endif:
   /* Restore Registers */
    ldp    x19, x20, [sp, 16]
    ldp    x21, x22, [sp, 32]
    ldr    x23, [sp, 48]
    ldp    x29, x30, [sp], 64

   /* Return from towers function */
    ret

// Function main is complete, no modifications needed
    .global	main
main:
      stp    x29, x30, [sp, -32]!
      add    x29, sp, 0
      ldr    w0, printdata 
      bl     printf
      ldr    w0, printdata + 4
      add    x1, x29, 28
      bl     scanf
      ldr    w0, [x29, 28] /* numDisks */
      mov    x1, #1 /* Start */
      mov    x2, #3 /* Goal */
      bl     towers
      mov    w4, w0
      ldr    w0, printdata + 8
      ldr    w1, [x29, 28]
      mov    w2, #1
      mov    w3, #3
      bl     printf
      mov    x0, #0
      ldp    x29, x30, [sp], 16
      ret
end:

printdata:
	.word	string1
	.word	string2
	.word	string3

string0:
	.asciz	"Move from peg %d to peg %d\n"
string1:
	.asciz	"Enter number of discs to be moved: "
string2:
	.asciz	"%d"
	.space	1
string3:
	.ascii	"\n%d discs moved from peg %d to peg %d in %d steps."
	.ascii	"\012\000"
