##*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_##
# Mmn 11 - Q3 - Almog Shtaigmann #
##*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_##


main:	# main

#--- print message to user and then  gget the user input ---#

 	li $v0, 4 #  set v0 to 4 in order to print string
	la $a0, prompt_welcome  # load to a0 the prompt
	syscall # print instruction
	
#--- get input from the user ---#
    li $v0, 8 # set v0 to 8 in order to print string
	la $a0, string_buffer # load the address of input by the string buffer
	li $a1, 31 # the maximum num of chars to read id 30+ 1 for end of string
	syscall # read the string into $a0
	
#--- count string lengths ---#
	la $a3, 0($a0) # load the string address to $a3
	li $t2, 0 # $t2 is index for the array, so we can print each char 
	li $t4, 0 # $t4 is counter for the length of the string

# we will call this loop - loop1	
string_len_loop:
	add $t5, $t2, $a3
	lb $a0, 0($t5) # load the next char(in place t5) into a0

	beq $a0, 0x0a, end_string_len_loop # if the char is the place of index is at the end of the string. if so, skip this loop
	
    #handel counters
	addi $t2, $t2, 1 # add 1 to index
	addi $t4, $t4, 1 # add 1 to length counter
	
	j string_len_loop #jump the the top of the loop
	
	end_string_len_loop: # end of this loop
		           
#--- handle printing ---#
	add $t0, $t4, $zero # t0 is loop1 counter - set it to string length
	li $t2, 0 # t2 is array (of string chars) index
	
outer_loop:
	beq $t0, $zero, end_outer_loop # if counter equals 0 exit loop
	
	add $t1, $t0, $zero # set loop1 counter to t0 (minus 1 each loop)
	li $t2, 0 # initialize t2-array index as 0
	li $t5, 0 # initialize t5
	
	inner_loop:
		beq $t1, $zero, end_inner_loop # if counter equals 0 exit loop
		
		add $t5, $t2, $a3
		lb $a0, 0($t5)  # load the next char into a0
		
		li $v0, 11  #  code 11 to print the current char
		syscall # print char (in a0)
		
		addi $t2, $t2, 1 # add 1 to array index
		sub $t1, $t1, 1 # sub 1 from inner_loop counter
		
		j inner_loop
		
		end_inner_loop:
		
	#print new line
 	li $v0, 4
 	la $a0, new_line # load string "\n" address into a0
	syscall # print new line
		
	sub $t0, $t0, 1 # sub 1 from outer_loop counter
	
	j outer_loop
	
	end_outer_loop:
	
	#Jump the the end pf the program and exit
	j end_program
 
 
# exit 
end_program:
	li $v0, 10 # exit program with code 10
	syscall


#----------------------------

#---Data---#
.data

new_line:        .asciiz    "\n"
string_buffer:   .space     31 # extra sapce for the last char EOL
prompt_welcome:  .asciiz    "Hi, Please enter a string(up to 31 chars!):"


#---Text---#
.text
.globl	main #define main as global label 
