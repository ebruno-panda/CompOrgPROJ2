#My ID is 02935002 | (02935002 % 11) + 26 = 30
.data
	userInput:  .space 11 #how many characters allowed
	out:		.asciiz "\n"

.text
	main:
		li $s1, 0x61 # $s1 = 'a' 
		li $s2, 0x7B # $s2 = '{'
		li $s3, 0x41 # $s3 = 'A' 
		li $s4, 0x5B # $s4 = '[' 
		li $s5, 0x30 # $s5 = '0' 
		li $s6, 0x3A # $s6 = ':'

		#gets user input
		la $a0, userInput
		la $a1, userInput
		li $v0, 8
		syscall

		move $t0, $zero #sum tracker
		move $t1, $zero #len(userInput)
		
		la $t2, userInput #assigns input to address


	iterar:
		lb $t3, ($t2) #each bit of input in $t2 is looked at in $t3
		beqz $t3, finalizer #if end of string, get ready to end program
		j charspecs #look at what type of character is being loaded 

	charspecs:
		beq $t3, 0x9, tabberspace # If *tab* is detected, go to function tabberspace (and treat both the same)
		beq $t3, 0x20, tabberspace # If *space* is detected, go to function tabberspace (and treat both the same)
		beq $t3, 0xA, EnterAlert #If *Enter* is detected, go to function EnterAlert

		#NOTE: t5 is used as an evaluator type boolean ; based on order of ASCII table numbers, uppercase letters, and lowercase letters will be dealt with respectively due to the nature of hoe "slt" works
		slt $t5, $t3, $s5 #is ascii < 0?
       	        beq $t5, 1, hmm #if t5 is one, character is invalid
       	        slt $t5, $t3, $s4 #if ascii value < ":", it's a lowercase letter
	        beq $t5, 1, charNconv #if t5 is one then go to charNconv
		
		slt $t5, $t3, $s3 #is ascii < "A"?
	        beq $t5, 1, hmm #if t5 is one, character is invalid
       	 	slt $t5, $t3, $s4 #if ascii value < "[", it's an uppercase letter
       	        beq $t5, 1, charUconv #if t5 is one then go to charUconv

		slt $t5, $t3, $s1 #is ascii < "a"?
        	beq $t5, 1, hmm #if t5 is one, character is invalid
        	slt $t5, $t3, $s2 #if ascii value < "{", it's a lowercase letter
        	beq $t5, 1, charLconv #if t5 is one then go to charLconv
        	j EnterAlert #reached end of input after considering all possibilities, so go to EnterAlert
