;The beginning of a linked list implementation
;@AUTHOR: Simon Lally-Shultz 

INCLUDE Irvine32.inc

Node                 STRUCT  

info                 DWORD            ?
next                 DWORD            ?

Node                 ENDS

HANDLE               TEXTEQU          <DWORD>

GetProcessHeap       PROTO

HeapAlloc            PROTO,
                     hHeap:HANDLE,
                     dwFlags:DWORD,
                     dwBytes:DWORD

HeapFree             PROTO,
                     hHeap:DWORD,
                     dwFlags:DWORD,
                     lpMem:DWORD

printf               MACRO            arg

                     push             edx
                     mov              edx, arg
                     call             writeString
                     pop              edx

                     ENDM

putc                 MACRO            arg

                     push             eax
                     mov              al, arg
                     call             writeChar
                     pop              eax

                     ENDM

printh               MACRO            arg

                     push             edx
                     mov              edx, arg
                     call             writeHex
                     pop              edx

                     ENDM

printd               MACRO            arg

                     push             edx
                     mov              edx, arg
                     call             writeDec
                     pop              edx

                     ENDM

alloc                MACRO            arg

                     push             arg
                     call             malloc

                     ENDM

delete               MACRO            arg

                     push             arg
                     call             free

                     ENDM

prntList             MACRO            

                     call             printlist           

                     ENDM

removeNode           MACRO

                     call             remove

                     ENDM

addNode              MACRO            arg

                     push             arg
                     call             strQuery

                     push             eax
                     call             createNode

                     push             eax
                     call             append

                     ENDM

.data

prmt                 BYTE             'add data to a node:  ',0
head                 DWORD            ?

.code

malloc               PROC

                     push             ebp
                     mov              ebp, esp

                     INVOKE           GetProcessHeap
                     INVOKE           HeapAlloc, eax, 8, [ebp+8]

                     pop              ebp

                     ret              4

malloc               ENDP

free                 PROC

                     push             ebp
                     mov              ebp, esp

                     INVOKE           GetProcessHeap
                     INVOKE           HeapFree, eax, 0, [ebp+8]

                     pop              ebp

                     ret              4

free                 ENDP

setHead              PROC

                     push             ebp
                     mov              ebp, esp

                     mov              eax, [ebp+8]
                     mov              head, eax

                     pop              ebp

                     ret              4

setHead              ENDP

getHead              PROC

                     push             ebp
                     mov              ebp, esp

                     mov              eax, head

                     pop              ebp

                     ret              

getHead              ENDP

createNode           PROC

                     push             ebp
                     mov              ebp, esp

                     push             ebx

                     mov              ebx, [ebp+8]
                    
                     alloc            SIZEOF NODE           

                     mov              (NODE PTR[eax]).info, ebx
                     mov              (NODE PTR[eax]).next, 0

                     pop              ebx
                     pop              ebp                     

                     ret              4

createnode           ENDP

append               PROC

                     push             ebp
                     mov              ebp, esp

                     push             ebx
                     push             ecx
                     push             edx

                     mov              ebx, [ebp+8]
                     mov              ecx, ebx

                     call             getHead
                     mov              edx, eax

                     cmp              edx, 0
                     jne              check
                     mov              eax, [ebp+8]

                     push             eax
                     call             setHead

                     jmp              finish
 

check:
                     call             getHead

walk:        
                     cmp              (NODE PTR[eax]).next, 0
                     je               assign
                     mov              eax, (NODE PTR[eax]).next
                     jmp              walk

assign:
                     mov              (NODE PTR[eax]).next, ecx
                     jmp              finish

finish:
                     
                     pop              edx
                     pop              ecx
                     pop              ebx
                     pop              ebp

                     ret              4

append               ENDP

remove               PROC

                     push             ebp
                     mov              ebp, esp

                     push             ebx
                     push             ecx
                     push             edx

                     call             getHead
                     mov              ebx, eax
                     mov              ecx, ebx
                     mov              ebx, (NODE PTR[ebx]).next
                     
                     push             ebx
                     call             setHead
                     
                     delete           ecx
                     call             CRLF
                     printh           eax
                        
                     pop              edx
                     pop              ecx
                     pop              ebx
                     pop              ebp      

                     ret              

remove               ENDP              

printlist            PROC

                     push             ebp
                     mov              ebp, esp

                     push             ebx
                     push             ecx

                     call             getHead
                     mov              ebx, eax

                     cmp              ebx, 0
                     je               finish

prnt:
                     
                     call             CRLF
                     printf           (NODE PTR[ebx]).info

                     cmp              (NODE PTR[ebx]).next, 0
                     je               finish
                     mov              ebx, (NODE PTR[ebx]).next
                     jmp              prnt

finish:
                     pop              ecx
                     pop              ebx
                     pop              ebp                     

                     ret              

printlist            ENDP

strQuery             PROC

                     push             ebp
                     mov              ebp, esp

                     push             edx
                     push             ecx

                     mov              edx, [ebp+8]
                     call             writeString

                     alloc            4

                     mov              edx, eax
                     mov              ecx, 8
                     call             readString

                     mov              eax, edx

                     pop              ecx
                     pop              edx
                     pop              ebp
    
                     ret              4

strQuery             ENDP

main                 PROC

                     addNode          OFFSET prmt
                     addNode          OFFSET prmt
                     addNode          OFFSET prmt

                     prntlist
                     removeNode

                     prntlist
                     removeNode

                     prntlist
                     removeNode

                     prntlist

                     exit

main                 ENDP

                     END              main