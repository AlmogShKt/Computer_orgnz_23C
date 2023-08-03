##*_*_*_*_*_*_*_*_**_*_*_**_*_*_**_*_*_**_*_*_**_*_*_**_*_*_**_*_*_**_*_*_*_*_*_*_*_*_*_#
#           Mmn 11 -            Q4          -            Almog Shtaigmann               #
# This program is getting a string im format that represent a numbers in base 8 (OCTA)  #
# The program will check if the string is valid, and then convert it to base 10 numbers #
# Then the program will sort the new converted numbers and print it                     #
##*_*_*_*_*_*_*_*_**_*_*_**_*_*_**_*_*_**_*_*_**_*_*_**_*_*_**_*_*_**_*_*_*_*_*_*_*_*_*_#

# Jump main to start the program
j main


# this function check if the input is valid 
is_valid_input:
    li $t2, 0 			# Initialize array index to 0
    li $t4, 0 			# Initialize character counter to 0
    li $t5, 0 			# Initialize counter string to 0
    li $t8, 0 			# Initialize pair counter for output
    la $a3, 0($a0) 		# Load the input string address

	
    loop:
        add $t5, $t2, $a3 	# Add the current index to the base address to get the current string position
        lb $a0, 0($t5) 		# load the next char into a0
        addi $t4, $t4, 1 	# add 1 to char counter
        beq $a0, 0x0a, end_is_valid_input # check if we reached to the end of the string, if so skip the loop
        #else 

        #-- Lets validate that the input are valid --#
        #If the counter is either 1 ,and the character is either $ or not within the range of 0-7, then it's considered incorrect.
        beq  $t4, 3, inner_step_1 # if counter is 3 jump to next step
        beq  $a0, 0x24, handle_invalid_input # 0x24 is the ascii of '$', if the char is $ at this point it is mean that the input is invalid
        bgt $a0, 55, handle_invalid_input # If character is not a valid base 8 digit, jump to wrong function
        blt $a0, 48, handle_invalid_input  # If character is not a valid base 8 digit, jump to wrong function
        
        inner_step_1:
       
        # If character counter equals 3 and character is not $, handle invalid input
        bne $t4, 3, inner_step_2 		# If character counter is not 3, skip next step
        bne $a0, 0x24, handle_invalid_input   # f character is not $
        
        li $t4, 0 		# If character counter is 3 and digits are valid, reset character counter
        
        inner_step_2:
        bne $t4, 2, inner_step_3 	# If character counter equals 2, increment pair counter
        addi $t8, $t8, 1 		# Increment pair counter
        
        inner_step_3:
        addi $t2, $t2, 1 # If character counter is not 2, increment array index
        

        j loop # Jump back to the start of the loop
        
        end_is_valid_input:
        
        # If character counter is not 1 then string did not end with $, print wrong input
        bne $t4, 1, handle_invalid_input
        add $v0, $t8, $zero # Load number of digit pairs into v0
        
        # Return to the calling function
        jr $ra

handle_invalid_input:
	li $v0, 4 			#  set v0 to 4 in order to print string
	la $a0, prompt_invalid_input   # load to a0 the prompt
	syscall #
	
	li $v0, 0 			# Clear v0 register
	j main 				# Return to the main function to get new input

# print array with numbers
print:
	li $v0, 4                     # Set syscall to '4' which stands for 'print string' in MIPS assembly
	la $a0, prompt_start_printing # load to a0 the prompt
	syscall                       # print the relevant prompt
	
	li $t2, 0  		       # Initialize the array index to 0
	
    loop_keep_printing:
        beq $t1, $zero, end_loop_keep_printing # If counter is 0 (no more numbers in array), exit the loop
        
        # Print number
        add $t3, $t0, $t2             # Calculate the address of the current number in array
        lbu $a0, ($t3)                # Load the current number into $a0.
        li $v0, 1                     # Set syscall to '1' which stands for 'print int' in MIPS assembly
        syscall  
        
        # Print 2 white spaces between the numbers
        li $v0, 4                     # Set syscall to '4' which stands for 'print string'
        la $a0, white_space_2         # Load the address of the string into $a0
        syscall 
        
        addi $t2, $t2, 1              # Increment the array index by 1.
        sub $t1, $t1, 1               # Decrement the counter by 1.
        
        j loop_keep_printing
        
        end_loop_keep_printing:
        
       # new line
        li $v0, 4                     # Set syscall to '4' which stands for 'print string'
        la $a0, new_line               # Load the address of the string 'newline' into $a0
        syscall                       # Print the newline character
	
	jr $ra                        # Return from the function after printing all numbers.

# convert OCTA(base 8) number to decimal number #
convert:
	la $t0, stringocta      # t0 points to the input string array named stringocta
	la $t1, NUM             # t0 points to the input string array named NUM
	
   	add $t2, $v0, $zero # t2 stores number of pairs

	li $t3, 0       # Initialize array index to 0
	li $t7, 0       # Initialize new array index // it will be NUM
	
    loop_keep_convert:
        add $t5, $t3, $t0      # $t5 now contains the address of the next character to be processed.
        lb $t4, 0($t5)         # Load the ASCII value of the next character from the string into $t4.

        # If the loaded character is a newline (ASCII value 0x0A), it signifies the end of the input string.
        beq $t4, 0x0a, end_loop_keep_convert  
        
        # else

        # Conversion of first digit of octal number to decimal:
        sub $t4, $t4, 48       # Subtract ASCII value of '0' (48) from ASCII value of the digit to convert it to actual numeric value.
        sll $t6, $t4, 3        # Multiply the first digit by 8 (2^3) to account for its place value in the octal number. Store this in $t6.

       # Convert second digit of octal number to decimal:
        lb $t4, 1($t5)         # Load the ASCII value of the next character (2nd digit of octal number) into $t4.
        sub $t4, $t4, 48       # Subtract ASCII value of '0' from ASCII value of the digit to convert it to actual numeric value.
        add $t6, $t6, $t4      # Add this to the first digit (which has already been multiplied by 8), thus forming the decimal equivalent.

        
       # Store decimal value in new array:
        add $t8, $t1, $t7      # $t8 now contains the address of the next storage spot in the new array (NUM).
        sb $t6, ($t8)          # Store the computed decimal value at this address.
        addi $t7, $t7, 1       # Increment the index to point to the next location in the NUM array.

        addi $t3, $t3, 3       # Increment the index to skip to the next octal number (octal numbers are 3 characters apart) in the input array.

        # Loop back to process the next octal number:
        j loop_keep_convert
        
    end_loop_keep_convert:
        jr $ra

# We will sort the array with "Selection Sort" algorithm 
sort:
	li $v0, 4                    # set v0 to 4 in order to print string
	la $a0, prompt_start_sorting # load to a0 the prompt
	syscall                      # print the relevant prompt
	
	la $t0, SORT_ARRAY      # Load the address of the sorted array into $t0
	la $t1, NUM             # Load the address of the NUM array into $t1
	li $t2, 0               # Initialize $t2 to 0, which will be used to store the number of bytes in NUM
	add $s2, $t9, $zero     # Copy the value in $t9 to $s2, to store the number of bytes in NUM for sorting
	
	
	li $t3, 0               # Initialize $t3 to 0, it's used as sorted array index
	
    # The outer loop: iterates until all numbers in NUM have been sorted and copied to SORT_ARRAY
    sort_outer_loop:

        beq $s2, $zero,  end_sort_outer_loop    # If the number of elements left to sort is zero, exit the loop
        lb $t5, 0($t1)                          # Load the first byte in NUM, set it as the current maximum
        
        move $t2, $t9          # Reset the counter to the length of the NUM array
        li $t4, 0              # Initialize $t4 to 0, which will be used as the NUM index
        
        # The inner loop: finds the maximum number in NUM in each iteration and stores it in SORT_ARRAY
        sort_inner_loop:
        
            beq $t2, $zero, end_sort_inner_loop   # If the counter reaches zero, exit the inner loop
        
            add $t6, $t1, $t4    # Calculate the address of the current element in NUM
		    lb $t7, ($t6)        # Load the current byte into $t7
        
            # t5 will hols th max number we found in the inner loop
            blt $t7, $t5, continue_iteration    # If the current number is smaller than the current max, continue
            move $t5, $t7                       # If the current number is larger than the current max, update the max to the current number
            move $s1, $t6                       # Store the address of the max number, so we can reset it to 0 later
        
            continue_iteration:
    		addi $t4, $t4, 1     # Move to the next index in NUM
		sub $t2, $t2, 1      # Subtract 1 from the counter of the inner loop
	
            j sort_inner_loop
        
        end_sort_inner_loop:
        
        add $t8, $t0, $t3      # Calculate the address of the current empty cell in SORT_ARRAY
        sb $t5, ($t8)          # Store the maximum number found in this iteration in SORT_ARRAY
        sb $zero, ($s1)        # Reset the maximum number in NUM to 0, so we can skip it in the next iteration
        
        addi $t3, $t3, 1       # Move to the next index in SORT_ARRAY
        sub $s2, $s2, 1        # Subtract 1 from the counter of the outer loop
        
        j sort_outer_loop      # Jump back to the start of the outer loop
        
        end_sort_outer_loop:
	
	jr $ra                      # Return from the 'sort' function

main:
	
# print prompt
 	li $v0, 4 #  set v0 to 4 in order to print string
	la $a0, prompt_welcome # load to a0 the prompt
	syscall # print the relevant prompt
	
# get input string
	li $v0, 8 # syscall code 8 to read string
	la $a0, stringocta # load address of input buffer
	li $a1, 31 # max num of chars to read
	syscall # read string into a0

#  is_valid_input
	jal is_valid_input
	
# Convert ocota to dec
	jal convert
	
# Print the numbers
	la $t0, NUM              # Load the address of the NUM array into $t0.
	add $t1, $v0, $zero      # Copy the value in $v0 to $t1. $t1 now stores the number of elements to print.
	add $t9, $v0, $zero      # Copy the value in $v0 to $t9. This is saved for use later in the program.
	jal print                # Call the 'print' function. This will jump to the 'print' label and save the return address in $ra.

# sort the array with Selection Sort algorithm
	jal sort

# print the numbers again, but now they sorted #
	la $t0, SORT_ARRAY
	add $t1, $t9, $zero
	jal print

# exit 
end_program:
	li $v0, 10 # exit program with code 10
	syscall


#-------------Defines-------------

    #---Data---#
    .data

    # prompts:
    prompt_welcome:  		.asciiz	"Hi welocome to Q4 mmn11, lests start.\nEnter a string(up to 31 chars!):\n"
    prompt_invalid_input: 	.asciiz "wrong input\n"
    prompt_start_printing: 	.asciiz "All set, This is the number in base 10:\n"
    prompt_start_sorting: 	.asciiz "Program has start sorting the input.\nThis is the sorted array:\n"
    new_line:        		.asciiz "\n"
    white_space_2: 		.asciiz "  " # just a while space for printing
    valid_input_test : 		.asciiz "12$77$23$56$76$00$76$07$"
    Invalid_input_test : 	.asciiz "12$77$23$56$76$0$$0767$"

    stringocta:   		.space	31 # eciiz xtra sapce for the last char EOL
    NUM: 			.space	10
    SORT_ARRAY: 		.space	10

    
    #---Text---#
    .text
    .globl	main 	#define main as global label 
