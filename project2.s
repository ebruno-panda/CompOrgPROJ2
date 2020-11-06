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
