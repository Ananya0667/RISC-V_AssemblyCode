.data
# matrix= A|B[5][6]
# IEEE 754 32 bit floating point representation

matrix : 
.float -2 4 6 -9 3 -50
.float -8 6 -4 4 -5 11 
.float -3 -5 1 -7 9 -29
.float  2 3 -6 -5 17 -3
.float  -7 -9 -10 5 9 12    
# .float 1 1 1 1 1 3 
# .float 1 1 1 1 1 4 
# .float 1 1 1 1 1 5 
# .float 1 1 1 1 1 6 
# .float 1 1 1 1 1 7 


# .float 2 3 1 4 5 10
# .float 3  5  2  3  7 20
# .float  1 2 3  2 4 15
# .float  4 7 5 6 9 30
# .float  2 4 1 3 6 19 

# .float 1 2 3 4 5 33.21
# .float 2 4 6 8 10 66.42
# .float 0 0 91.23 51.24 10 2
# .float 123.45 21.23 2.45 34.67 33 11
# .float 44.33 27 87.34 0 64 23

# .float -6 4 6 -8 -3 -50 
# .float -4 3 4 -4 -9 11 
# .float -3 -1 -1 -6 2 -29
# .float -2 -4 6 -5 7 -53
# .float -7 -9 -10 5 9 12
# .float 1 1 1 1 1 1 
# .float 1 1 1 1 1 1 
# .float 1 1 1 1 1 1 
# .float 1 1 1 1 1 1 
# .float 1 1 1 1 1 1

  
case1_msg : 
    .asciiz "No solution exists"  
case2_msg : 
    .asciiz "Infinitely many solution exist " 
case3_msg:
    .asciiz "Unique Solution "
case_singluar:
    .asciiz "Singular matrix "
msg_x:
    .asciiz "Solution for x" 
space:
    .asciiz " "     
newline:
    .asciiz "\n"    
equal:
    .asciiz "= " 

N:
    .word 5
X :     # output matrix  X
    .word 0 0 0 0 0 

loop_counters : 
    .word 0 0 0 # i , j , k loop counters

temp :
     .word    



.text
.globl main

gaussian_elimination:

label1: #for(i=0;i<m-1;i++)
    la a0,loop_counters #  base addr of loop_counters
    lw a1,N

    li s1,1
    sub a1,a1,s1 

    # addi a1,a1,-1 # a1 = N - 1
    lw a2,0(a0) # a2 = i
    #we check the opposite case of high level code
    bge a2,a1,label2 # branch if(i >= N - 1 )
    addi a2,a2,1 # a2 = i + 1
    sw a2,8(a0) # k = i+1 for next label 3 loop
    j label3   

label3 : #(k = i+1;k<m;k++)
    la a0,loop_counters
    la t3,matrix # base address of matrix

    lw a1,8(a0) # a1 = k
    lw a2,N
    bge a1,a2,label4 # k >= N 
    lw a1,0(a0) # a1 = i
    mul a3,a1,a2 # a3 =  i*N
    addi a2, zero,4 
    mul a3,a3, a2 #i*N*4
    slli a1,a1,2 # 4 * i,1 word= 4 bytes
    add a3,a3,a1 # a3 = N*4* i + 4 * i (offset)
    add a3,a3,t3 # effective address =(base addr + offset)

    flw ft1,0(a3) # ft1 = matrix[i][i]
    fabs.s ft1,ft1 # ft1 = abs(ft1)

    lw a3,8(a0) # a3 = k
    lw a2,N 
    mul a3,a3,a2
    addi a2,x0,4
    mul a3,a3,a2 
    add a3,a3,a1 # 4 * i 
    add a3,a3,t3 #  effective address = base + offset
    flw ft2,0(a3) # ft2 = matrix[k][i]
    fabs.s ft2,ft2 # ft2 = abs(ft2)

    #we compare ft1 and ft2 for partial pivoting and row swapping operation
    flt.s a3,ft1,ft2 # a3 = bool( ft1 < ft2)
    xori a3,a3,1 # If a3 is T then result is F, else if a3 is F, then result is T
    bnez a3,label5 # branch if ft1 > ft2, i.e no swapping needed
    # otherwise do row swapping 
    sw x0,4(a0) # initializing j = 0 for next loop
    j label6

label2:
    la a0,loop_counters
    lw a1,N 
    li s1,1
    sub a1,a1,s1 

    # addi a1,a1,-1 # a1 = N-1
    sw a1,0(a0) # i = N-1
    j label13  

label5:
    la a0,loop_counters
    lw a1,8(a0) # a1 = k
    addi a1,a1,1 # k=k+1
    sw a1 , 8(a0)
    j label3

label6:
    la a0, loop_counters
    la t3,matrix # base addr of matrix
    lw a1,4(a0) # a1 = j
    lw a2,N 
    addi a2,a2,1
    bge a1,a2,label5 #  j >= n

    lw a1 , 0(a0) # a1 = i
    lw a2 , 4(a0) # a2 = j
    lw a3 , 8(a0) # a3 = k

    addi a4 , x0 , 24 # a4 = 24(5*4)
    mul t4 , a4 , a1 # t4 = 5*4 * i
    slli a2,a2,2 #  4 * j

    add t4 , t4 , a2 # t4 = 5*4 * i + 4 * j
    add t4, t4, t3 # effective address = (base + offset)
    flw ft0 , 0(t4) # ft0 = matrix[i][j]

    mul t5 , a4 , a3 # t5 = 5*4 * k 
    add t5 , t5 , a2 # t5 = 5*4 * k + 4 * j
    add t5,t5,t3 # effective address =( base + offset)
    flw ft1 , 0(t5) # ft1 = matrix[k][j]
    fsw ft1, 0(t4) # matrix[i][j] = ft1 = matrix[k][j]
    fsw ft0, 0(t5) # matrix[k][j] = ft0 
    lw a1 , 4(a0) # a1 = j
    addi a1 , a1, 1 # j = j+1
    sw a1 , 4(a0)
    j label6

## Gaussian elimination 

label4:
    la a0,loop_counters
    lw a1,0(a0) # a1 = i
    addi a1,a1,1 # a1 = i + 1
    sw a1 , 8(a0) # k = i + 1
    j label8

label8: #for(k=i+1;k<m;k++)
    la a0,loop_counters
    la t3,matrix #base addr of matrix
    lw a1 , 8(a0) # a1 = k
    lw a2,N
    bge a1 , a2 ,label9 # k>=m 
    lw a1,0(a0) # a1 = i

    lw a2,N
    mul a3,a2,a1
    li s1,1
    sub a2,a2,s1 
    # addi a2,a2,-1
    mul a2,a2,a3

    slli a1 , a1 ,2 #  4 * i
    add a2 , a2, a1 # a2 = 24 * i + 4 * i(offset)
    add t3 , t3 ,a2 #  offset + base address

    flw ft0 , 0(t3) # ft0 = matrix[i][i]
    flw ft1 , 0(x0) # ft1 = 0 
    feq.s a3, ft0 , ft1
    xori a3, a3 , 1 # if matrix[i][i] == 0 then a3 = 1
    bnez a3 , label10
    j label9

label10:
    #temp = matrix[k][i]/matrix[i][i]
    la a0,loop_counters
    la t3,matrix
    lw a1,0(a0) # a1 = i

    addi a2, zero,24 # a2 = 24
    mul a3,a1,a2 # a3 = 24 * i 
    slli a1,a1,2 # 4 * i
    add a3,a3,a1 # 24 * i + 4 * i  
    add a3,a3,t3 # effective address =( base + offset)
    flw ft0,0(a3) 
    lw a3,8(a0) # a3 = k
    mul a3,a3,a2 # a3 = 5*4*k
    la a2,temp # store ft1 temporarily
    add a3,a3,a1 # 5*4 * k + 4 * i
    add a3,a3,t3 # effective address =( base + offset)
    flw ft1,0(a3) 
    fdiv.s ft1,ft1,ft0 # matrix[k][i]/matrix[i][i]
   
    fsw ft1,0(a2) #matrix[k][i]/matrix[i][i]
    mv a1,zero
    sw a1, 4(a0) #j = 0
    j label11

label11:
    la a0,loop_counters
    la t3,matrix # base addr of matrix
    lw a1,4(a0) # x1 = j
    lw a2,N 
    addi a2,a2,1
    bge a1,a2,label12 # j >= n

    lw a1 , 0(a0) # a1 = i
    lw a2 , 4(a0) # a2 = j
    slli a2,a2,2 # 4 * j
    addi a4 , x0 , 24 # a4 = 5*4
    mul t4 , a4 , a1 # 5*4 * i
    
    add t4 , t4 , a2 #  5*4 * i + 4 * j 
    add t4, t4, t3 # effective address =( base + offset)
    flw ft0 , 0(t4) # ft0 = matrix[i][j]
    lw a3 , 8(a0) # a3 = k
    mul t5 , a4 , a3 #  24 * k 
    add t5 , t5 , a2 # t5 = 5*4 * k + 4 * j 
    add t5,t5,t3 # effective address =( base + offset)
    flw ft1 , 0(t5) # ft1 = matrix[k][j]
    la a4,temp
    flw ft2,0(a4) # ft2 = temp
    fmul.s ft2, ft2 , ft0 #  temp * matrix[i][j]
    fsub.s ft1, ft1 , ft2 # matrix[k][j] - temp * matrix[i][j]
    fsw ft1 , 0(t5) # matrix[k][j] = ft1
    lw a1 , 4(a0) # a1 = j
    addi a1 , a1, 1 # j = j+1
    sw a1 , 4(a0)
    j label11

label12:
    la a0,loop_counters
    lw a1,8(a0) # a1 = i
    addi a1,a1,1 # a1 = i + 1
    sw a1 , 8(a0) # k = k + 1
    j label8

label9:
    la a0,loop_counters
    lw a1,0(a0) # a1 = i
    addi a1,a1,1 # i = i+1
    sw a1,0(a0)
    j label1

#Back substitution
#loop_counters : .word 0 0 0  # i , j , k

label13:
    la a0,loop_counters
    la t3,matrix 
    la t4,X 
    lw a1,0(a0) # a1 = i
    lw a2,N 
    blt a1,x0,label14 # i < 0 
    
    addi a2,a2,1
    li s1,1
    sub a2,a2,s1 
    slli a2,a2,2 # a2 = (n-1) * 4  effective address
    addi a3,x0,24 # a3 = 24
    mul a3,a3,a1 # a3 = 24 * i
   
    add a3,a3,a2 # 24 * i + (n-1) * 4
    add t3,t3,a3 # base address + 5*4 * i + (n-1) * 4
    flw ft0,0(t3) 
    slli a2,a1,2 #  i * 4 
    add t4,t4,a2 #  X + i * 4
    fsw ft0,0(t4) # X[i]= matrix[i][n-1]
   
    addi a1,a1,1 # a1 = i+1
    sw a1,4(a0) # j = i+1
    j label15

label15:
    la a0,loop_counters
    la t3,matrix 
    la t4,X 
    lw a1,N 
    addi a1,a1,1
    addi a1,a1,-1 # a1 = n - 1
    lw a2,4(a0) # a2 = j
    
    bge a2,a1,label16 # j >= n - 1
    lw a1,0(a0) # a1 = i
    lw a2,4(a0) # a2 = j
    addi a3,x0,24 # a3 = 5*4
    mul a3,a3,a1 # 5*4 * i
    slli a2,a2,2 # j * 4 
    add a3,a3,a2 #  5*4 * i + j * 4
    add a2,a2,t4 #  4 * j + X 
    add t3,t3,a3 #  base address + 5*4 * i + j * 4
    flw ft0,0(t3) 
    flw ft1,0(a2) 
    slli a2,a1,2 # i * 4 
    fmul.s ft0,ft0,ft1 #matrix[i][j] * X[j]
    
    add t4,t4,a2 # X + i * 4 
    flw ft1,0(t4) # 
    fsub.s ft1,ft1,ft0 # X[i] - matrix[i][j]*X[j]
    fsw ft1,0(t4) # X[i] - matrix[i][j]*X[j]
    lw a1,4(a0) # a1 = i
    addi a1,a1,1 # j++
    sw a1,4(a0)
    j label15

label16:
    la a0,loop_counters 
    la t3,X 
    lw a2,0(a0) # a2 = i
    slli a2,a2,2 #i * 4 
    add t3,t3,a2 #  X + i * 4
    flw ft0,0(t4) # ft0 = X[i]  
    add a1 a1,x0
    flw ft1,0(a1) # ft1 = 0
    feq.s a0,ft0,ft1 # if X[i] == 0 then  a0 = 1
    xori a0,a0,1
    bnez a0,label17
    lw a1,0(a0) # a1 = i
    la t3,matrix
    
    addi a2 , x0 , 24 # a2 = 24
    mul a2,a2,a1 # a2 = 5*4 * i
    slli a1 , a1 ,2 # 4 * i
    add a2 , a2, a1 # 5*4 * i + 4 * i
    add t3 , t3 ,a2 # 5*4 * i + 4 * i + base address
    flw ft0 , 0(t3) 
    ####
    # li t5, 0xFFC00000 
    add t5, t5,x0
    flw ft1 , 0(t5) # ft1 = 0 
    feq.s a3, ft0 , ft1

    # li a0,4 #ecall ID 4, which corresponds to print strings.
    # la a1,case_singluar # address of s should be in a1
    # ecall
    # li a0,4
    # la a1,newline
    # ecall
    # la a1,case1_msg # address of s should be in a1  #Infinitely many soln
    bnez a3 , infinite_soln
    j label17

label17:
    la a0,loop_counters 
    la t3,X 
    lw a2,0(a0) # a2 = i
    add a1,a1,x0
    slli a2,a2,2 # i * 4 
    add t3,t3,a2 # X + i * 4 
    flw ft0,0(t4) # X[i]  
    la t3,matrix 
    flw ft1,0(a1) # ft1 = 0
    feq.s a0,ft0,ft1 # if X[i] == 0 then sets a0 = 1
    bnez a0,label18 # exit if a0 = 1 = X[i]=0
    
    lw a1,0(a0) # a1 = i
    addi a2 , x0 , 24 # a2 = 5*4
    mul a2,a2,a1 # a2 = 5*4 * i
    slli a1 , a1 ,2 #  4 * i
    add a2 , a2, a1 # 5*4 * i + 4 * i
    add t3 , t3 ,a2 # 5*4 * i + 4 * i + base addr
    flw ft0 , 0(t3) # matrix[i][i]
    add t5,t5,x0
    # li t5, 0xFFC00000 
    flw ft1 , 0(t5) # ft1 = 0 
    feq.s a3, ft0 , ft1

    bnez a3,no_soln
    j label18
   

label18:
    la a0,loop_counters
    la t3,matrix # base addr of matrix
    la t4,X 
    lw a1,0(a0) # a1 = i
    addi a2 , zero , 24
    mul a2,a2,a1 # 5*4 * i
    slli a1 , a1 ,2 # 4 * i
    add a2 , a2, a1 #5*4 * i + 4 * i
    add t3 , t3 ,a2 #offset+ base addr
    flw ft0 , 0(t3) 
    add t4,a1,t4 # X + 4 * i
    flw ft1,0(t4) 
    fdiv.s ft1,ft1,ft0 # X[i] / matrix[i][i]
    fsw ft1,0(t4) # X[i] = X[i] / matrix[i][i]
    lw a1,0(a0) # a1 = i
    li a2,1
    sub a1,a1,a2 # a1 = i - 1
    sw a1,0(a0) # i = i - 1
    j label13

label14:
    li a0,4 #ecall ID 4, which corresponds to print strings.
    la a1,case3_msg # address of s should be in a1
    ecall
    li a0,4
    la a1,newline
    ecall

    li a0,4
    la a1,newline
    ecall

    la t3,X 
    lw t4,N # total elements in X to be printed 
    lw t5,N

    li s1,1
    sub t5,t5,s1 

    # addi t5,t5,-1 
    li t1, 1  # counter for curr element being printed.
    j Display

infinite_soln:
    li a0,4 #ecall ID 4, which corresponds to print strings.
    la a1,case_singluar # address of s should be in a1
    ecall

    li a0,4
    la a1,newline
    ecall
    
    la a1,case2_msg # address of s should be in a1  #Infinitely many soln
    j exit_label

no_soln:
      #no soln exists
    li a0,4 #ecall ID 4, which corresponds to print strings.
    la a1,case_singluar # address of s should be in a1
    ecall
    li a0,4
    la a1,newline
    ecall
    la a1,case1_msg # address of s should be in a1
    j exit_label

Display:
    li a0,4 #ecall ID 4, which corresponds to print strings.
    la a1,msg_x # address of s should be in a1
    ecall

    li a0,1         #Loads 1 into register a0, indicating that you want to print an integer.
    mv a1,t1     #Loads the integer value at the address t5 into register a1.
    ecall           #Calls the operating system to perform the system call, 
                        #which, in this case, is printing the integer value in a1.

    li a0,4
    la a1,equal
    ecall

    li a0,34 # ecall ID 34 to print hexadecimal.
    lw a1,0(t3)
    ecall   #ecall to print the hexadecimal value stored in a1.
    # ecall to print a space character between elements
    li a0,4         #Loads 4 into register a0, indicating that you want to print a string.
    la a1, space    #Loads the address of the space string into register a1
    ecall
    li a0,4
    la a1,newline
    ecall
    add t3,t3,t5
    bge t1,t4,exit_label
    addi t1,t1,1
    j Display    #unconditional jump

exit_label:
    jr ra   # return from function

main:
    jal gaussian_elimination
    li a7,10     #This is the label for the end of the program. It exits the program by loading 
    #10(the exit system call) into register a7 and then executing an ecall   
    ecall
