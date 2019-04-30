# Project ECE 30 Spring 2017
# MaxNeg Subarray Sum
# Student 1 : 
# Sheikh Mohamed, Reem
# Student 2 :
# Fidan, Umut
 
.data ## Data declaration section
## String to be printed:
string_newline: .asciiz "\n" # newline character
string_space: .asciiz " " # space character
string_MaxNegSubArraySum: .asciiz "MaxNeg Sub Array Sum is: "
array1: .word 2, 5, -6, 2, 3, -1, -5, 6
size: .word 7
.text ## Assembly language instructions go in text segment
 
main: ## Start of code section
li $a1, 0   		#a1 contains s
la $a2, size 		
lw $a2, 0($a2)		#a2 contains e
la $a0, array1		#a0 contains arr[]
jal MaxNegSubArraySum # MaxNegSubArraySum(arr,0, size-1);
move $a0,$v0 		#result of MaxNegSubArraySum is stored in $v1 store that as argument of
#print sum
jal printsum
li $v0, 10 # terminate program
syscall
 
##########################################################
printsum: # Function to print the contents of the array
# $a0 = value to be printed
move $t0, $a0
	
# print newline character
la $a0, string_newline
li $v0, 4
syscall
   
la $a0,  string_MaxNegSubArraySum
li $v0, 4
syscall
	
# print the integer at the address $a0
li $v0, 1
move $a0,$t0
syscall
jr $ra  # Return back
 
##########################################################
MaxNegSumBoundary:
#	$a0 contains address to arr[].
#	$a1 contains s
#	$a2 contains e
#	$a3 is the direction (either 0 or 1)
#	$v0 returns the maximum subarray
#   Write your code here
addi $sp,$sp,-24	#$sp=x-24 now(the first iteration)
sw $ra, 0($sp) 	# save the return address
sw $a0, 4($sp) 	# arr[]
sw $a1, 8($sp) 	# s
sw $a2, 12($sp) 	# e
sw $a3, 16($sp) 	# original direction
li $t1,1 			
beq $a1,$a2, loopequal	
beq $a3,$zero,zerobranch	#if this condition is not met, we go to onebranch regardless of what- #-d value is, since that is what the assignment describes

onebranch:		#d=1; arr[], s+1, e, 1; a0, a1, a2, a3
lw $a0, 4($sp)		#arr[]
lw $a1, 8($sp)		#s
lw $a2, 12($sp)	#e
addi $a1,$a1, 1 	#$a1=$a1+1
li $a3,1                        # making sure d is 1 in case there has been another value put into d
jal MaxNegSumBoundary
move $s0, $v0		
lw $a0, 4($sp)		#restoring the original arr[]
lw $a1, 8($sp)		#restoring the original s
sll $a1,$a1,2  		#multiplying the index by 4
add $a0,$a0,$a1	#the complete address of arr[s]
lw $s1, 0($a0)		#putting the value of arr[s] into the register $s1
sub $a0,$a0,$a1	#restoring the original address of arr[]
move $a1,$s1
add $a2, $s0,$s1
jal FindMaxNeg2 	#picks the biggest one between arr[s]+x and arr[s]
lw $ra, 0($sp)		
addi $sp,$sp, 24	#close stack
jr $ra
 
zerobranch:		#d=0 arr[], s, e-1, 0   a0, a1, a2, a3
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $a2, 12($sp)	#restoring the registers just in case
addi $a2,$a2,-1 	#$a2=$a2-1
li $a3,0                        # making sure d is 0 in case there has been another value put into d
jal MaxNegSumBoundary
move $s0,$v0		
lw $a0, 4($sp)		#restoring the original arr[]
lw $a2, 12($sp)	#restoring the original e
sll $a2,$a2,2  		#multiplying the index by 4
add $a0,$a0,$a2	#the complete address of arr[e]
lw $s1, 0($a0)		#putting the value of arr[e] into the register $s1
sub $a0,$a0,$a2	#restoring the original address of arr[]
move $a1,$s1		#putting the result into $a1 for FindMaxNeg2
add $a2, $s0,$s1
jal FindMaxNeg2 	#picks the biggest one between arr[e]+x and arr[e]
lw $ra, ($sp)		
addi $sp,$sp, 24
jr $ra

# Call  MaxNegSumBoundary(arr,s,e-1,0) and save the result in a register x
# Return MaxNeg(arr[e], arr[e]+ x)


loopequal:
lw $a0, 4($sp)		#arr[]
lw $a1, 8($sp)		#s
lw $a2, 12($sp)	#e
sll $a1,$a1,2		#multiplying the index by four since the next element’s address is a 4 bit #far away
add $a0,$a0,$a1	# the complete address of arr[s]
lw $v0, 0($a0)	 	#the result=arr[s]
sub $a0, $a0, $a1
lw $ra, 0($sp)
addi $sp,$sp,24	#$sp=x returns stack
jr $ra





 
##########################################################
MaxNegCrossingSum:
#	$a0 contains arr[]
#	$a1 contains s
#	$a2 contains m
#	$a3 contains e
#	$v0 returns the maximum sum of arrays that cross the midpoint
#   Write your code here
#	1. Call MaxNegSumBoundary on the left subarray a[s,m] with direction 0.
#	2. Call MaxNegSumBoundary on the right subarray a[m+1,e] with direction 1.
#	3. Return the sum of the above two values.
addi $sp,$sp, -28	# $sp=X-28 now
sw $ra, 0($sp)          	# storing the address of the line that called this function
sw $a0, 4($sp)    	# storing the original arr[]
sw $a1, 8($sp)	# storing the original s value 
sw $a2, 12($sp)	# storing the original m value 
sw $a3, 16($sp)	# storing the original e value 
li $a3, 0 		#change the direction to 0, we don’t have to change anything else

jal MaxNegSumBoundary #call MaxNegSumBoundary left subarray a[s,m] with direction 0.
sw $v0, 20($sp)	#storing the first result into 20($sp)
lw $a1, 12($sp)	#load m into $a1
addi $a1, $a1, 1	#m=m+1
lw $a2, 16($sp)	#load $a2 the original e value
li $a3, 1		#change the direction to 1
jal MaxNegSumBoundary	#call MaxNegSumBoundary right subarray a[m+1,e] with direction 1
li $t0,0
lw $t0, 20($sp)
add $v0,$t0,$v0	#returning the sum of the results of the previous MaxNegSumBoundary’s
lw $ra, 0($sp)		#getting the return address back
addi $sp,$sp, 28	#closing the stack
jr $ra
 
##########################################################
MaxNegSubArraySum:
#	$a0 contains arr[].
#	$a1 contains s
#	$a2 contains e
#   Write your code here

addi $sp,$sp,-40	#opening up space in the stack
sw $ra, 0($sp) 	#address that called the first function!
sw $a0, 4($sp)        	#arr[]
sw $a1, 8($sp)            #s
sw $a2, 12($sp)          #e
beq $a1,$a2,equal  	#if s==e go to the equal branch
li $a3,0
add $a3, $a1, $a2   	#$a3=$a1+$a2 or $a3=s+e
srl $a3,$a3,1           	#I store m value into the $a3 register, shifting right by 1=dividing by 2
sw $a3, 16($sp)      	#store m into stack
move $a2,$a3         	#$a2=$a3

jal MaxNegSubArraySum  #compute the maximum subarray sum of the left subarray arr[s…m].
sw $v0, 20($sp)      	#first result into 20($sp)
lw $a3, 16($sp)	#retrieve the original m
addi $a3, $a3, 1      	#m=m+1
move $a1,$a3         	#m+1 is our new s value for MaxNegSubArraySum.
lw $a0, 4($sp)        	#arr[]
lw $a2, 12($sp)      	#retrieving the original e for MaxNegSubArraySum 

jal MaxNegSubArraySum 	# MaxNegSubArraySum(arr[], m+1, e)
sw $v0, 24($sp)      	#second result into 24($sp)
lw $a0, 4($sp)		#retrieving arr[]
lw $a1, 8($sp)        	#s
lw $a2, 12($sp)      	#e
lw $a3, 16($sp)      	#and m   	    
move $t0, $a2         	#creating a temporary variable as we are about to swap $a2 and $a3
move $a2, $a3        	#$a2=$a3
move $a3,$t0          	#$a3=old $a2
li $t0, 0
jal MaxNegCrossingSum   #compute the maximum subarray sum of the right subarray arr[m+1 e]
sw $v0, 28($sp)      	#third result into 28($sp)

lw $a1, 20($sp)
lw $a2, 24($sp)
lw $a3, 28($sp)       	#putting the result of the previous called functions into registers $a1-3
jal FindMaxNeg3
sw $v0, 32($sp)      	#putting the result of MaxNegSubArraySum to the 32($sp) just in case  
lw $a1, 8($sp)        	#s
lw $a2, 12($sp)      	#e
lw $a3, 16($sp)      	#m 
lw $ra, 0($sp)		#retrieving the address of the line+4 that called MaxNegSubArraySum:
addi $sp,$sp, 40      	#$sp=x  
jr $ra			
 
equal:
lw $a1, 8($sp)		#retrieving s value from the stack 
sll $a1, $a1, 2      	 #multiplying s by 4 since we are trying to access n+1’th element
add $a0,$a1,$a0  	#I am adding the base address to the index*4
lw $v0, 0($a0)	    	#Accessing the arr[s] value
sub $a0,$a0,$a1  	#retrieving the original address
lw $ra, 0($sp)
addi $sp,$sp,40      	#closing the stack
jr $ra
 
##########################################################
FindMaxNeg2:
 
#	$a1 holds the first number.
#	$a2 holds the second number.
#	$v0 contains the maximum between the 2 input numbers.
#   Write your code here

li $t0, 1   #defining it just in case  
li $t1, 1   #to compare with $t0
slt $t0, $a2, $a1    # if a2<a1 $t0=1   
beq $t0, $t1, a2smaller  #take branch if $t0=1
 

a1smaller:
move $v0, $a1 	 #a1 is smaller so it is copied into $v0
jr $ra  			 #return safely
 
a2smaller:		#a2 is smaller so it is copied into $v0
move $v0, $a2
jr $ra			 #return safely
 
FindMaxNeg3:
##########################################################
#	$a1 holds the first number.
#	$a2 holds the second number.
#	$a3 holds the third number.
#	$v0 contains the maximum negative among the 3 numbers
#   Write your code here
addi $sp, $sp, -16 
sw $ra, 4($sp)	        # save the return address
jal FindMaxNeg2     	# finding the maximum negative between a1 and a2
move $a1,$v0    	#moving the biggest value amongst them to a0 since MaxNeg works with a1,a2
move $a2,$a3    	#a2=a3
jal FindMaxNeg2      	#the most negative one among the 3 is inside v0 now
lw $ra, 4($sp)     	#changing the ra again since jal changed it to the address of MaxNeg
addi $sp,$sp, 16 	#closing the stack
jr $ra

#Calls MaxNeg on the first 2 numbers and store return value.
#Calls MaxNeg on the return value in the previous step and the third number; returns the #maximum negative of the result.
