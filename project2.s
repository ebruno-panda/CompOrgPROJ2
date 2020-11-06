#My ID is 02935002 | (02935002 % 11) + 26 = 30
.data
	userInput:  .space 11 #how many characters allowed
	out:		.asciiz "\n"

.text
	main:
		li $s1, 0x61 # $s1 = 'a' 
		li $s2, 0x74 # $s2 = 't' 
