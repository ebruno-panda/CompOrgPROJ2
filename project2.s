#My ID is 02935002 | (02935002 % 11) + 26 = 30
.data
	whoops:  	.asciiz "Invalid input\n" #Error message
	userInput:	.word 4 #take in a word

.text
	main:
		li $s0, 0x20 #s0 = 'SPACE'
		li $s1, 0x61 # $s1 = 'a' 
		li $s2, 0x7B # $s2 = '{'
		li $s3, 0x41 # $s3 = 'A' 
		li $s4, 0x5B # $s4 = '[' 
		li $s5, 0x30 # $s5 = '0' 
		li $s6, 0x3A # $s6 = ':' 
		li $s7, 0xA #s7 = 'ENTER'
		li $t4, 0 # $t4 = 0 for current character
		li $t6, 0 # $t6 = 0 for non blank character count

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

	charNconv:
		addi $t3, $t3, -48 # convert to integer	
		add $t0, $t0, $t3 #adds to total value tracker $t0
		j impostor #checks base and moves on, else counts "impostors"

	charUconv:
		addi $t3, $t3, -55 # convert: ‘A’=10,‘B’=11,etc
		add $t0, $t0, $t3 #adds to total value tracker $t0
		j impostor #checks base and moves on, else counts "impostors"

	charLconv:
		addi $t3, $t3, -87 # convert: ‘a’=10,‘b’=11,etc
		add $t0, $t0, $t3 #adds to total value tracker $t0
		j impostor #checks base and moves on, else counts "impostors"
	

	EnterAlert:
		addi $t1, $t1, 1 #counts character in input individually
		addi $t2, $t2, 1 #moves to next character
		
		beq $t3, $s7, iterar #value 'ENTER' will be sorted out in iterar and eventually to function finalizer
		beq $t1, 5, hmm #if input counter exceeds 4, branches to function "hmm" to deal with this instance

		j iterar #back to center function


	tabberspace:
		addi $t4, $zero, 0 #are there characters that are not blank?
		beqz $t6, EnterAlert
		#else, there are spaces/tabs after other characters
		addi $t7, $zero, 1
		j EnterAlert


	hmm:
		la $a0, whoops #calls invalde message
		li $v0, 4
		syscall


	impostor:
		#Again, $t5 is referenced to determine N in baseN
		slt $t5, $t3, 30 #Not right base? then...
		beqz $t5, hmm #invalid base, there for input is invalid
		
		#wrong charcater type alert. Impostor(s) detected. Count all
		add $t4, $zero, 1
		add $t6, $zero, 1

		#blanks in between impostors --> REPORT
		beq $t7, 1, hmm
		j EnterAlert


	finalizer:
		#finish looping
		li $v0, 1
		move $a0, $t0
		syscall

#finish it
li $v0, 10
syscall	
