
.data
    str: .space 1024  # Space for input string
    prompt: .asciiz "Input: "
   

# Determine base_n, beta, and delta values based on your Howard ID
# Howard ID : 03057357
# N = 26 + (3057357 % 11) = 26 + 6 = 32
# M = 22
# Beta: 'v'
# Delta: 'V'

.text
.globl main

main:
    # Display prompt
    li $v0, 4
    la $a0, prompt
    syscall

     # Read input string
    li $v0, 8
    la $a0, str
    li $a1, 1001
    syscall

    # Process the input string
    jal process_whole_string

    # The process_whole_string  identifies and handles substrings

process_whole_string:

    #Get the current character and check if its the end of string

    lb $t3, 0($a0)  
    beq $t3, $zero, check_end  
    
    #Save the pointer to the start of the string on the Stack and make room on stack for string address

    sub $sp, $sp, 4
    
    #Store the address on the stack
    sw $a0, 0($sp)

    find_slashes:
    
        #Increment pointer by 1 and search for a / and replace with a null terminator
        addi $a0, $a0, 1
        li $t3, '/'
        lb $t4, 0($a0)
    
        beq $t3, $t4, null_term
        li $t3, 10 #newline character
        lb $t4, 0($a0)
    
        beq $t3, $t4, null_term
        j find_slashes
    
    null_term:
        # "/" or newline character recognized
        sb $zero, 0($a0)
        
        # When a slash or end of string is found, process the substring
        jal process_substring
    
        #After processing substring, restore the stack, advance the string pointer by 1, and repeat
        addi $sp, $sp, 4
        addi $a0, $a0, 1
        
        #Print the return value of process_substring in $v0
        # Reset $a1 to point to the next character as the start of the next substring
        add $s7, $a0, $zero
        li $t3, '-'

        beq $t3, $v0, dash_print
        add $a0, $v0, $zero
        li $v0, 1
        syscall
        j print_slash

    dash_print:
        #Print "-" for invalid characters
        li $v0, 11
        li $a0, '-'
        syscall

     print_slash:
        #Print a seperator character if the next charactor is not the end of string
    
        #restore $a0
        add $a0, $s7, $zero
        lb $t4, 0($a0)
        li $t3, 0
        beq $t3, $t4, skip_print_slash
    
        li $v0, 11
        li $a0, '/'
        syscall
    
        #restore $a0
        add $a0, $s7, $zero

    skip_print_slash:
        j process_whole_string
    
    check_end:
        li $v0, 10
        syscall
    
    process_substring:
        #Load the pointer to the address on the Stack into $s0
        lw $s0, 0($sp)
        add $v0, $zero, $zero
    
        add $t8, $zero, $zero
    
        case_checker:
            #Load byte at the pointer into $s1
            lb $s1, 0($s0)
        
            #Break out of loop if character is null
            beq $s1, $zero, end_while
            
            #If character is uppercase, convert it to lowercase, use $t0 and $t1
            li $t1, 'A'
            bge $s1, $t1, test_upper
            j not_uppercase
        
        test_upper:
            li $t1, 'Z'
            ble $s1, $t1, is_uppercase
            j not_uppercase
        
        is_uppercase:
            addi $s1, $s1, 32
            
        not_uppercase:
            #If character >= '0' and <= '9'
            li $t1, '0'
            bge $s1, $t1, check_num
            j next_symbol
        
        check_num:
            li $t1, '9'
            ble $s1, $t1, is_num
            j not_num
        
        is_num:
            addi $s1, $s1, -48
            add $v0, $v0, $s1
            addi $t8, $t8, 1
            j next_symbol
        
        not_num:
            #Else if character >= 'a' and <= 'v':
            li $t1, 'a'
            bge $s1, $t1, letter_range
            j next_symbol
        
        letter_range:
            li $t1, 'v'
            ble $s1, $t1, is_letter
            j next_symbol
        
        is_letter:
            addi $s1, $s1, -87
            add $v0, $v0, $s1
            addi $t8, $t8, 1

        next_symbol:
            #Move to next character by incrementing $s0
            addi $s0, $s0, 1
            j case_checker
        
        end_while:
            #if $t8 > 0, at least one valid character, return v0 else return '-'
            beq $t8, $zero, return_dash
            j return_normal
        
        return_dash:
            li $v0, 45
        
        return_normal:
            jr $ra

        

        

    

    

