

INCLUDE Irvine32.inc


.data
Submittedby byte "   Created By:",10," Ahmad Razzaq ",10,"	Bank Management System",0
msgwelcome byte "*****************************************	Welcome To Banking System	****************************************",0
msgask byte "	Press 1 for New User",10,"	Press 2 for Existing customer",10,"	Press 3 to exit",0
err1 byte "Wrong input please enter correct input",0
msg3 byte " ",10,"Enter user",0
msg4 byte "Enter Password",0
erruser byte "Incorrect Details",0
user1 byte 20 dup (?)
amount1 byte 20 dup (?)
amountsize1 dword ?
filehandle dword ?
money2 byte 20 dup (?)
amountsize2 dword ?
count dword ?
moneyfile byte "moneyfile.txt",0
temp dword ?
amount2 byte 20 dup (?)
amount dword ?
customer byte"Customer:   ",0
amount12 byte "amount:     ",0
usersize1 dword ?
passsize1 dword ?
msg51 byte "	Press 1 for Deposit",10,"	Press 2 for Withdrawal",10,"	Press 3 for showing money",10,"	Press 4 to show details and Quit",0
pass1 byte 20 dup (?)
msg22 byte "Amount Deposited",0
msg23 byte " ",10,"Amount Withdrawed",0
err22 byte "Not enough money",0
userfile byte "user.txt",0
passfile byte "password.txt",0
msg10 byte " ",10,"Choose any transaction",0
user2 byte 20 dup (?)
msg15 byte "Enter Starting Amount",0
pass2 byte 20 dup (?)
usersize2 dword ?
passsize2 dword ?
msg12 byte "User Created",0
msgwithdrawal byte "Enter Withdrawal Amount",0
msgdeposit byte "Enter Deposit Amount",0

.code

main PROC

; Set text color to cyan on black
mov eax,yellow+(black*16)
call settextcolor

; Display welcome message
call crlf
call crlf
call crlf
mov edx,offset msgwelcome
call writestring
call crlf
call crlf

l0:

call crlf
call crlf

; Display menu
mov edx,offset msgask
call writestring
call crlf
call crlf

; Read user input
call readdec

cmp eax,2

; If user chooses option 2 (Existing customer)
je l1

cmp eax,1

; If user chooses option 1 (New user)
je l14

cmp eax,3

; If user chooses option 3 (Exit)
je l60

call crlf
call crlf

; Display error message for wrong input
mov edx,offset err1
call writestring
call crlf
call crlf

; Jump back to the menu
jmp l0

l60:
call crlf
call crlf
;Created By
mov edx,offset Submittedby
call writestring
call crlf
; Exit the program
exit

l1:


; Prompt for username
mov edx,offset msg3
call writestring
call crlf
call crlf

; Read username input
mov edx,offset user1
mov ecx,sizeof user1
call readstring
call crlf
call crlf

; Prompt for password
mov edx,offset msg4
call writestring
call crlf
call crlf

; Read password input
mov edx,offset pass1
mov ecx,sizeof pass1
call readstring

; Open user file for input
mov edx,offset userfile
call openinputfile

; Read stored username from file
mov edx,offset user2
mov ecx,lengthof user2
call readfromfile

; Open password file for input
mov edx,offset passfile
call openinputfile

; Read stored password from file
mov edx,offset pass2
mov ecx,lengthof pass2
call readfromfile

; Check if entered username and password match stored credentials
mov edx,offset user1
mov ecx,lengthof user1
mov esi,0

l2:

cmp user1[esi],0

je l3

inc esi

loop l2

l3:

mov eax,lengthof user1
sub eax,ecx
mov usersize1,eax

mov edx,offset user2
mov ecx,lengthof user2
mov esi,0

l4:

cmp user2[esi],0

je l5

inc esi

loop l4

l5:

mov eax,lengthof user2
sub eax,ecx
mov usersize2,eax

mov edx,offset pass1
mov ecx,lengthof pass1
mov esi,0

l6:

cmp pass1[esi],0

je l7

inc esi

loop l6

l7:

mov eax,lengthof pass1
sub eax,ecx
mov passsize1,eax

mov edx,offset pass2
mov ecx,lengthof pass2
mov esi,0

l8:

cmp pass2[esi],0

je l9

inc esi

loop l8

l9:

mov eax,lengthof pass2
sub eax,ecx
mov passsize2,eax

; Compare username and password sizes
mov ecx,usersize1
cmp ecx,usersize2

; If sizes don't match, go to label l12
jne l12

mov esi,0

l10:

; Compare characters of the usernames
mov al,user1[esi]
cmp al,user2[esi]

; If characters don't match, go to label l12
jne l12

inc esi

loop l10

; Compare password sizes
mov ecx,passsize1
cmp ecx,passsize2

; If sizes don't match, go to label l12
jne l12

mov esi,0

l13:

; Compare characters of the passwords
mov al,pass1[esi]
cmp al,pass2[esi]

; If characters don't match, go to label l12
jne l12

inc esi

loop l13

; If control reaches here, the entered credentials are correct
jmp l16

l12:

; Display error message for incorrect details
call crlf
call crlf

mov edx,offset erruser
call writestring
call crlf
call crlf

; Jump back to the menu
jmp l0

l14:

; If user chooses option 1 (New user), create a new user
call crlf
call crlf

; Prompt for username
mov edx,offset msg3
call writestring
call crlf
call crlf

; Read new username input
mov edx,offset user1
mov ecx,sizeof user1
call readstring
call crlf
call crlf

; Prompt for password
mov edx,offset msg4
call writestring
call crlf
call crlf

; Read new password input
mov edx,offset pass1
mov ecx,sizeof pass1
call readstring
call crlf
call crlf

; Open user file for output
mov edx, OFFSET userfile
call CreateOutputFile

; Write new username to file
mov edx,offset user1
mov ecx,lengthof user1
call writetofile

; Open password file for output
mov edx, OFFSET passfile
call CreateOutputFile

; Write new password to file
mov edx,offset pass1
mov ecx,lengthof pass1
call writetofile

; Display user created message
mov edx,offset msg12
call writestring
call crlf
call crlf

; Prompt for starting amount
mov edx,offset msg15
call writestring
call crlf
call crlf

; Read starting amount input
mov edx,offset amount1
mov ecx,sizeof amount1
call readstring

; Jump to label l89 to handle transactions
jmp l89

l16:

; If control reaches here, the user is successfully authenticated
; Open money file for input
mov edx,offset moneyfile
call openinputfile

; Save the file handle
mov filehandle,eax

; Read the current balance from the file
mov edx,offset amount1
mov ecx,lengthof amount1
call readfromfile

; Close the file
mov eax,filehandle
call closefile

l89:

; Initialize variables for processing amount
mov esi,0
mov ecx,lengthof amount1

; Loop to find the end of the amount string
l25:

mov al,amount1[esi]
cmp al,0

je l26

inc esi

loop l25

; Calculate the size of the amount string
l26:

mov eax,lengthof amount1
sub eax,ecx
mov amountsize1,eax

; Initialize variables for converting amount to integer
mov eax,0
mov esi,0

; Loop to convert amount string to integer
mov ecx,amountsize1

l31:

movzx ebx,amount1[esi]

sub ebx,'0'

mov edx,10

mul edx

add eax,ebx

inc esi

loop l31

; Save the converted amount to variable
mov amount,eax

; Display menu for transactions
mov edx,offset msg10
call writestring
call crlf
call crlf

; Display transaction options
l52:

mov edx,offset msg51
call writestring
call crlf
call crlf

; Read user input for transaction choice
call readdec

cmp eax,1
je l53

cmp eax,2
je l54

cmp eax,3
je l55

cmp eax,4
je l56

l53:
call crlf
; If user chooses option 1 (Deposit)
mov edx,offset msgdeposit
call writestring
call crlf
call crlf

; Read deposit amount input
call readdec

; Add the deposit amount to the current balance
add amount,eax

; Jump back to the transaction menu
jmp l52

l57:

; If the balance is not enough for withdrawal, display an error message
mov edx,offset err22
call writestring
call crlf
call crlf

; Jump back to the transaction menu
jmp l52

l54:
call crlf
; If user chooses option 2 (Withdrawal)
mov edx,offset msgwithdrawal
call writestring
call crlf
call crlf

; Read withdrawal amount input
call readdec

; Check if there is enough balance for withdrawal
cmp eax,amount
jnbe l57

; Subtract the withdrawal amount from the current balance
sub amount,eax

; Display success message for withdrawal
mov edx,offset msg23
call writestring
call crlf
call crlf

; Jump back to the transaction menu
jmp l52

l55:
call crlf
; If user chooses option 3 (Show balance)
mov eax,amount
call writedec
call crlf
call crlf

; Jump back to the transaction menu
jmp l52

l56:
call crlf
; If user chooses option 4 (Quit)

; Display user details and exit
mov edx,offset customer
call writestring
mov edx,offset user1
call writestring
call crlf

mov edx,offset amount12
call writestring
mov eax,amount
call writedec
call crlf

; Convert the balance to a string for writing to the file
mov esi,0
mov eax,amount
call crlf
call crlf
;Created By
mov edx,offset Submittedby
call writestring
call crlf
l71:

mov edx,0
mov ebx,10
div ebx

add edx,0
mov temp,edx

mov dl,byte ptr temp
add dl,'0'
mov amount1[esi],dl

cmp eax,0

je l72

inc esi

loop l71

l72:

; Find the end of the amount string
mov esi,0
mov ecx,lengthof amount1

l73:

mov al,amount1[esi]
cmp al,0

je l74

inc esi

loop l73

; Calculate the size of the amount string
l74:

mov eax,lengthof amount1
sub eax,ecx
mov amountsize1,eax

; Reverse the order of the amount string
mov esi,0
mov ecx,amountsize1

mov edx,amountsize1
sub edx,1

l76:

mov al,amount1[esi]

mov amount2[edx],al

inc esi
dec edx

loop l76

; Open money file for output
mov edx,offset moneyfile
call createoutputfile
mov filehandle,eax

; Write the updated balance to the file
mov edx,offset amount2
mov ecx,lengthof amount2
call writetofile

; Close the file
call closefile

; Exit the program
exit

main ENDP
END main