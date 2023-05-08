#####################################################################
# Assignment FINAL	Programmer: Jourdan Rampoldi
# Due Date: 			Course: CSC 2025 1N2
# Last Modified: 
#####################################################################
# Functional Description: Menu driven program will allow user to call
# a function to measure recursive calls, a function to enter a list and 
# test for repeating values, and a function to use recursion to 
# find GCD among two entered values.
##################################################
# Pseudocode:
#	cout << menuOptions;
#	cin >> userResponse
#	switch(userResponse)
#	{
#		case 1:
#			initRecProc();
#			printResult();
#			againOption();
#			break;
#		case 2:
#			initInputList();
#			printResult();
#			againOption();
#			break;
#		case 3:
#			initANS();
#			printResult();
#			againOption;
#			break;
#		case 4:
#			quitProgram();
#	}
#	initRecProc()
#	{
#		cout << recursionAmount;
#		cin >> A;
#		recProc(A);
#	}
#	initInputList()
#	{
#		while(true)
#		{
#			if (userResponse == -999)
#				break;
#			else
#				listArray[i] = userResponse;
#			i++
#		}
#		inputList(listArray);
#	}
#	initANS()
#	{
#		cout << enter a and b;
#		cin >> a and b;
#		ANS(a, b);
#	}
#
#	ANS(A, B)
#	{
#		if (A == 0)
#			return B;
#		else if (B == 0)
#			return A;
#		else
#			B = A % B;
#			A = B;
#			ANS(A, B);
#	}	
#	recProc(A)
#	{
#		count++;
#		if (A == 0)
#			return count;
#		else
#			A --;
#	}
#	inputList()
#	{
#		for (i = 0; i < length; i++)
#			for (j = 0; j < length; j++)
#				if (array[i] == array[j])
#					return true;
#		return false;
#	}
######################################################################
# Register Usage:
# NOTE: Because of the nature of recursion in MIPS, all registers used
# are multiuse for the specific task at hand. Below registers are used 
# based on temp, long use, or address storage/manipulation.
# $t0 - $t6: temp registers used for data manip and moving values
# $s0 - $s4: registers used for variables and pointers
# $ra: used for recursion return address
# $sp: used to maintain accurate recursion return
# $a0 - $a1: pass param to procedure - also used for syscall
# $v0: used for return values - also used for syscall
######################################################################
.data
	startMsg:	.asciiz "\nEnter one of the following:\n\t1. recProc\n\t2. inputList\n\t3. ANS\n\t4. Exit\nSelection: "
	badResponse:	.asciiz "\nERROR: Bad entry detected..."
	repeatProgram:	.asciiz "\nEnter 1 to enter another option: "
	endString:	.asciiz "\nTerminating Program..."
	startRec:	.asciiz "\nEnter amount of recursive calls: "
	countResult:	.asciiz "\nAmount of recursive calls: "
	startInput:	.asciiz "\nEnter up to 100 Values.\nEnter -999 to stop loop."
	enterVal:	.asciiz "\nValue: "
	boolTrue:	.asciiz "\nFound 2 values that equal each other."
	boolFalse:	.asciiz "\nNo two values matched."
	enterA:		.asciiz "\nEnter value A: "
	enterB:		.asciiz "\nEnter value B: "
	valueGCD:	.asciiz "\nThe GCD is: "
	testOption:	.asciiz "\nWould you like to test ANS functionality?\nEnter 0 for yes, anything else for no: "
	testValues:	.asciiz "\nTest Values:\n\tValue A: 270\n\tValue B: 192"
	NUMTIMES:	.word 0
	numTimesKeep:	.word 0
	recCount:	.word 0
	userArray:	.space 400
.text
	main:
		li	$v0, 4							# print_string sys code
		la	$a0, startMsg						# load address of string
		syscall

		li	$v0, 5							# read_int sys code
		syscall

		move	$a0, $v0						# move user entry to param
		jal	testEntry						# error_handling entry

		jal	menuSelect						# jump to menu selection

		jal	reloadOption						# give choice to user to restart

		j	terminate						# program termination

# -------------------------------------------- RETURN FUNCTION ------------------------------------------------- #
	back:									# function for returning to address
		j	$ra 							# jump to address in $ra

# -------------------------------------------- BAD_ENTRY FUNCTION ---------------------------------------------- #
	badEntry:								# function for detection of error
		li	$v0, 4							# print_string sys code
		la	$a0, badResponse					# load string
		syscall

		j	terminate						# terminate program

# ------------------------------------------ ERROR_HANDLING PROCEDURE ------------------------------------------ #
	testEntry:								# error_handling procedure
		li	$t0, 4							# comparison variable
		li	$t1, 1							# comparison variable

		bgt	$a0, $t0, badEntry					# user number outside scope
		blt	$a0, $t1, badEntry					# user number outside scope

		j	back							# return to main
		
# ------------------------------------------ START_SELECT PROCEDURE -------------------------------------------- #
	menuSelect:
		li	$t0, 1							# comparison variable
		li	$t1, 2							# comparison variable
		li	$t2, 3							# comparison variable

		beq	$a0, $t0, initRecProc					# branch to initialize recProc
		beq	$a0, $t1, initInputList					# branch to initialize inputList
		beq	$a0, $t2, initANS					# branch to initialize ANS
		
		j	terminate						# error has occured

# ------------------------------------------ RECURSION PROCEDURE ----------------------------------------------- #
	initRecProc:
		la	$s0, NUMTIMES						# pointer variable to NUMTIMES address
		la	$s1, recCount						# pointer variable to recursion count address
		la	$s4, numTimesKeep					# address for kept value 

		li	$v0, 4							# print_string syscode
		la	$a0, startRec						# string address
		syscall
	
		li	$v0, 5							# read_int sys code
		syscall

		sw	$v0, 0($s0)						# save number of times entry
		sw	$v0, 0($s4)						# save copy for comparison

		lw	$s2, 0($s0)						# first value

	recProc:
		beqz	$s2, back						# begin recursion

		lw	$s2, 0($s0)						# load number from NUMTIMES
		addi	$s2, $s2, -1						# NUMTIMES--
		sw	$s2, 0($s0)						# save value

		addi	$sp, $sp, -4						# make room on stack for $ra
		sw	$ra, 0($sp)						# save address for future use

		jal	recProc							# link $ra for recursion

		la	$s1, recCount						# pointer to recCount

		lw	$s3, 0($s1)						# pull value from recCount
		addi	$s3, $s3, 1						# increment value
		sw	$s3, 0($s1)						# save value into address

		lw	$ra, 0($sp)						# pull address
		addi	$sp, $sp, 4						# restore previous position of pointer

		lw	$s5, 0($s4)						# comparison value
		
		beq	$s5, $s3, printRecProc					# branch if count is equal to original val

		j	recProc							# loop back through
	
	printRecProc:
		li	$v0, 4							# print_string sys code
		la	$a0, countResult					# load address
		syscall

		la	$t0, recCount						# temp pointer to recCount
		lw	$a0, 0($t0)						# pull value from pointer


		li	$v0, 1							# print_int sys code 
		syscall

		j	back


# ------------------------------------------- INPUT_LIST PROCEDURE --------------------------------------------- #
	initInputList:
		la	$s0, userArray						# pointer to userArray
		li	$s1, -999						# end variable

		li	$v0, 4							# print_string sys code
		la	$a0, startInput						# pointer to string
		syscall

	inputLoop:
		li	$v0, 4							# print_string syscode
		la	$a0, enterVal						# pointer to string
		syscall

		li	$v0, 5							# read_int sys code
		syscall

		beq	$v0, $s1, initLoop					# last entry, begin comparison

		sw	$v0, 0($s0)						# store to list
		addi	$s0, $s0, 4						# increment
		
		j	inputLoop						# loop for next value
	
	initLoop:
		add	$t0, $0, $0						# clear counter
		add	$t2, $0, $0						# clear counter
		add	$s1, $s0, $0						# length of array
		la	$s0, userArray						# pointer at beginning of array

	outerLoop:
		addi	$t1, $0, 4						# value starts at 4 for inner

	innerLoop:
		add	$t2, $t1, $s0						# userArray[j] address
		lw	$t3, 0($s0)						# load userArray[i]
		lw	$t4, 0($t2)						# load userArray[j]

		bgt	$t2, $s1, notFound					# break if over

		beq	$t3, $t4, found						# break if values are same
		addi	$t1, $t1, 4						# j++
		bne	$t2, $s1, innerLoop					# end of array?
		beq	$s0, $s1, notFound					# no values are similar

		addi	$s0, $s0, 4						# i++

		j	outerLoop

	found:
		li	$v0, 4							# print_string sys code
		la	$a0, boolTrue						# load string
		syscall

		j	back							# return

	notFound:
		li	$v0, 4							# print_string syscode
		la	$a0, boolFalse						# load string
		syscall

		j	back

# -------------------------------------------- ANS PROCEDURE --------------------------------------------------- #
	initANS:
		addi	$sp, $sp, -4						# room for return address on stack
		sw	$ra, 0($sp)						# place on stack

		jal	testANS							# let user test functionality

		beqz	$v0, main						# send user back to main
 
		li	$v0, 4							# print_string sys code
		la	$a0, enterA						# enter value a
		syscall

		li	$v0, 5							# read_int sys code
		syscall

		move 	$t0, $v0						# move for later use

		li	$v0, 4							# print_string sys code
		la	$a0, enterB						# enter value a
		syscall

		li	$v0, 5							# read_int sys code
		syscall

		move 	$a1, $v0						# move to param
		move 	$a0, $t0						# move to param 2

		jal	ANS							# call to recursive GCD
		
		move 	$a0, $v0						# move GCD to param for print


		jal	printAB							# call to print procedure

		lw	$ra, 0($sp)						# pull value from stack
		addi	$sp, $sp, 4						# restore stack

		j	back							# return to main
	ANS:
		addi	$sp, $sp, -4						# make room on stack
		sw	$ra, 0($sp)						# save return address

		move	$t0, $a0						# move value for A
		move 	$t1, $a1						# move value for B

		move 	$v0, $t1						# b in return reg if A == 0
		beqz	$t0, back						# if a == 0, return B

		move 	$v0, $t0						# a in return reg if B == 0
		beqz	$t1, back						# if b == 0, return A

		rem	$t2, $t0, $t1						# get A % B: R


		move	$a0, $t1
		move	$a1, $t2						# move new values to param

		jal	ANS							# next recursive call

		lw	$ra, 0($sp)						# get next return address
		addi	$sp, $sp, 4						# restore stack position

		j	back

	printAB:
		move	$t0, $a0						# keep value
		
		li	$v0, 4							# print_string sys code
		la	$a0, valueGCD						# value of GCD is
		syscall

		li	$v0, 1							# print_int sys code
		move	$a0, $t0						# place GCD into param
		syscall

		j	back

	testANS:
		li	$v0, 4							# print_string sys code
		la	$a0, testOption						# would user like to test
		syscall

		li	$v0, 5							# read_int sys code
		syscall
		
		beqz	$v0, testProc						# user request test

		j	back							# request denied

	testProc:

		li	$v0, 4							# print_string sys code
		la	$a0, testValues						# show values
		syscall
	
		li	$a0, 270
		li	$a1, 192

		addi	$sp, $sp, -4
		sw	$ra, 0($sp)						# make room and store return address

		jal	ANS

		jal	printAB


		lw	$ra, 0($sp)
		addi	$sp, $sp, 4						# restore sp and ra

		li	$v0, 0							# tell return procedure to exit to againOption

		j	back

# ------------------------------------------ RESTART_PROGRAM PROCEDURE ----------------------------------------- #
	reloadOption:
		li	$v0, 4							# print_string sys code
		la	$a0, repeatProgram					# load string address
		syscall

		li	$v0, 5							# read_int sys code
		syscall	

		li	$t0, 1							# comparison variable
	
		beq	$v0, $t0, main						# restart program

		j	back							# continue to termination

# ------------------------------------------ TERMINATE_PROGRAM FUNCTION --------------------------------------- #
	terminate:
		li	$v0, 4						# print_string sys code
		la	$a0, endString					# load address
		syscall
			
		li	$v0, 10						# terminate program sys code
		syscall