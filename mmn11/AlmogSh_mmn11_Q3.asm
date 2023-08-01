##*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_##
# Mmn 11 - Q3 - Almog Shtaigmann #
##*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_##


main:

# Print the relevant prompt to the user and then get the user input

 	li $v0, 4 #  set v0 to 4 in order to print string
	la $a0, prompt_welcome  # load to a0 the prompt
	syscall # print instruction
	
# Get input from the user 
	li $v0, 8 		# set v0 to 8 in order to print string
	la $a0, string_buffer	# load the address of input by the string buffer
	li $a1, 31 		# the maximum num of chars to read id 30+ 1 for end of string
	syscall 		# read the string into $a0
	
# Count string lengths 
	la $a3, 0($a0) 	# load the string address to $a3
	li $t2, 0 	# $t2 is index for the array, so we can print each char 
	li $t4, 0 	# $t4 is counter for the length of the string

    j string_len_loop

string_len_loop:
	add $t5, $t2, $a3
	lb $a0, 0($t5) 				        # Load the next char(in place t5) into a0

	beq $a0, 0x0a, end_string_len_loop 	# If the char is the place of index is at the end of the string. if so, skip this loop
	beq $t2, 31, end_string_len_loop	# Handle edage case, where enters 30 cahrs
	
	#handel counters
	addi $t2, $t2, 1  	# Increment the value in register $t2 by 1 (add 1 to index).
	addi $t4, $t4, 1  	# Increment the value in register $t4 by 1 (add 1 to length counter).

	
	j string_len_loop 	#jump the the top of the loop
	
	end_string_len_loop: 	# end of this loop
		           
#handle printing 
	li $t2, 0 		# Load the immediate value 0 into register $t2 (initialize t2 as array index).
	add $t0, $t4, $zero 	# Copy the value from register $t4 to register $t0 (t0 is loop1 counter - set it to string length).


        
    outer_loop:
        beq $t0, $zero, end_outer_loop # if counter equals 0 exit loop
        
	add $t1, $t0, $zero	# Copy the value from register $t0 to register $t1 (set loop1 counter to t0 - decrement 1 each loop).
	li $t5, 0		# Load the immediate value 0 into register $t5 (initialize t5).
	li $t2, 0		# Load the immediate value 0 into register $t2 (initialize t2 as array index).

        
       inner_loop:
        	beq $t1, $zero, end_inner_loop  # If the counter in register $t1 equals 0, exit the loop.
	        add $t5, $t2, $a3               # Add the value in register $t2 (array index) to the value in register $a3 (string address) and store the result in register $t5. This calculates the memory address of the next character in the string.
	        
	        lb $a0, 0($t5)                  # Load the byte at the memory address specified in $t5 into register $a0. This fetches the next character from the string.
	        li $v0, 11                      # Set the syscall code 11 to print the character.
	        syscall                         # Print the character in register $a0.
	        
	        sub $t1, $t1, 1                 # Decrement the value in register $t1 by 1 (subtract 1 from inner_loop counter) to track the loop's progress.
       	        addi $t2, $t2, 1                # Increment the value in register $t2 by 1 (add 1 to array index) to move to the next character in the string.

	        j inner_loop                    # Jump to the beginning of the inner loop for the next iteration.
	        
		end_inner_loop:                       # End of the inner loop.

       # Print a new line
	li $v0, 4               # Set the syscall code to 4 to print a string.
	la $a0, new_line        # Load the address of the string "\n" into register $a0.
	syscall                 # Print a new line.

	sub $t0, $t0, 1         # Subtract 1 from the value in register $t0 (sub 1 from outer_loop counter) to track the loop's progress, effectively reducing the counter by one for the next iteration.
	j outer_loop            # Jump to the beginning of the outer loop for the next iteration.

	end_outer_loop:         # End of the outer loop.

	# Jump to the end of the program and exit.
	j end_program

 
 
# exit 
end_program:
	li $v0, 10 	# exit program with code 10
	syscall


#-----------Defines-----------------

# Data
.data

new_line:        .asciiz    "\n"
string_buffer:   .space     31      # extra sapce for the last char EOL
prompt_welcome:  .asciiz    "Hi Welocome to Q3 mmn11, Lets start.\nEnter a string(up to 31 chars!):\n"


# Text
.text
.globl	main #define main as global label 
