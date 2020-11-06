#My ID is 02935002 | (02935002 % 11) + 26 = 30
.data
	userInput:  .space 11 #how many characters allowed
	out:		.asciiz "\n"

.text
	main:
		li $s1, 0x61 # $s1 = 'a' 
		li $s2, 0x74 # $s2 = 't'
		li $s3, 0x41 # $s3 = 'A' 
		li $s4, 0x54 # $s4 = 'T' 
		li $s5, 0x30 # $s5 = '0' 
		li $s6, 0x39 # $s6 = '9'

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
