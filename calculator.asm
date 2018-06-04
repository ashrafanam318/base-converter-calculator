; multi-segment executable file template.

data segment                    
    
    num1 dw 0
    num2 dw 0
    op db ?
    ansL dw 0
    ansH dw 0
    
    sign1 db 0
    sign2 db 0
    sign db 0
    
    msg0 db "number1: $"
    msg1 db "operator (+, -, *, /): $"
    msg2 db "number2: $"
    msg3 db "result: $"
    msg4 db "reminder: $"
    
    decInt db 5 dup(0)
    decIntL db 5 dup(0)
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
    mov ax, data
    mov ds, ax
    mov es, ax 
    
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    
    lea dx, msg0
    mov ah, 9
    int 21h
         
        mov ah, 1
        mov cx, 5
        mov bx, 10 
        
        takeNum1:
        
             int 21h;
             
             cmp al, 0Dh;
             je takeOp;
             
             cmp al, 2Dh
             je setSign1
             
             sub al, 30h
             push ax
             mov ax, num1
             mul bx
             mov num1, ax
             pop ax
             push bx
             mov bh, ah
             xor ah, ah
             add ax, num1
             mov num1, ax
             mov ah, bh
             pop bx
             loop takeNum1
             
             jmp takeOp
             setSign1:
                mov al, 1
                mov sign1, al
                add cx, 1
                loop takeNum1
            
        
        takeOp:
              
            mov ah, 2
            mov dl, 0Ah
            int 21h
            mov dl, 0Dh
            int 21h  
             
            lea dx, msg1
            mov ah, 9
            int 21h 
              
             mov ah, 1
             int 21h
             mov op, al
             
             
        mov ah, 2
        mov dl, 0Ah
        int 21h
        mov dl, 0Dh
        int 21h
        
        lea dx, msg2
        mov ah, 9
        int 21h 
                  
        mov ah, 1
        mov cx, 5
        mov bx, 10
             
        takeNum2:
             
             int 21h;
             
             cmp al, 0Dh;
             je calculate;
             
             cmp al, 2Dh
             je setSign2
             
             sub al, 30h
             push ax
             mov ax, num2
             mul bx
             mov num2, ax
             pop ax
             push bx
             mov bh, ah
             xor ah, ah
             add ax, num2
             mov num2, ax
             mov ah, bh
             pop bx
             loop takeNum2     
             
             setSign2:
                mov al, 1
                mov sign2, al
                add cx, 1
                loop takeNum2
             
        
        calculate:
            
            mov bl, op
            
            cmp bl, 2Bh
            je plus
            
            cmp bl, 2Dh
            je minus
            
            cmp bl, 2Ah
            je cross
            
            cmp bl, 2Fh
            je slash
            
       
           plus:   
              
              mov al, sign1
              mov bl, sign2
              cmp al, bl
              je doPlus
              jng doMinus
              jg  num1Neg
              
                num1Neg:
                    mov ax, num1
                    mov bx, num2
                    mov num1, bx
                    mov num2, ax  
                    jmp doMinus
                    
             doPlus:
                 
                 mov cl, sign1
                 mov sign, cl
                    
                 mov ax, num1
                 add ax, num2
                 mov ansL, ax
                 jmp printAns
             
             doMinus:
            
                 mov ax, num1
                 cmp ax, num2
                 jng negAns
                 
                 posAns:         
                     
                     mov cl, 0
                     mov sign, cl
                     sub ax, num2
                     mov ansL, ax
                     jmp printAns
              
                 negAns:
                 
                     mov cl, 1
                     mov sign, cl
                     
                     mov bx, num2
                     sub bx, ax
                     mov ansL, bx
                     jmp printAns
        
        
        
           minus: 
           
                mov al, sign2
                xor al, 1 
                mov sign2, al
                jmp plus
        
        
          cross:
             
             mov al, sign1
             xor al, sign2
             mov sign, al
             xor al, al
             
             mov ax, num1
             mov bx, num2
             mul bx
             mov ansL, ax
             mov ansH, dx
             jmp printAns
        
        
        
           slash:
             
             mov al, sign1
             xor al, sign2
             mov sign, al
             xor al, al
             xor dx, dx
             
             
             mov ax, num1
             mov bx, num2
             div bx
             mov ansL, ax
             mov ansH, dx
             jmp printAns
             
             
       printAns:
         
        mov ah, 2
        mov dl, 0Ah
        int 21h
        mov dl, 0Dh
        int 21h
        
        mov bx, ansH
        cmp bx, 0
        je level1
        
        mov al, op
        cmp al, 2Ah
        je printMul
                   
        cmp al, 2Fh
        je printDiv
             
        level1:
             
             xor ax, ax
             xor bx, bx
             xor cx, cx
             xor dx, dx
             
             mov ax, ansL
             mov cx, 5
             mov si, 4
             mov bx, 10
             
             nextDec1:
             
               div bx

               add dl, 30h
               mov decInt[si], dl
               xor dx, dx
               sub si, 1
   
               loop nextDec1
                
               lea dx, msg3
               mov ah, 9
               int 21h
               
               cmp sign, 1
               je printMinus1
                
                level2:              
                mov ah, 2
                mov cx, 5
                mov di, 0
                printDec1:
                    
                    mov dl, decInt[di]
                    int 21h
                    
                    inc di
                    loop printDec1
        
                
                jmp exit
                printMinus1:
                     mov ah, 2
                     mov dl, 2Dh
                     int 21h
                     jmp level2
                
                
        jmp exit
        printMul:
        
             xor ax, ax
             xor bx, bx
             xor cx, cx
             xor dx, dx
            
             mov ax, ansH
             mov cx, 5
             mov si, 4
             mov bx, 10
             
             nextDec2:
             
               div bx

               add dl, 30h
               mov decInt[si], dl
               xor dx, dx
               sub si, 1
   
               loop nextDec2
              
              
             mov ax, ansL
             mov cx, 5
             mov si, 4
             mov bx, 10
             xor dx, dx
             nextDec3:
             
               div bx

               add dl, 30h
               mov decIntL[si], dl
               xor dx, dx
               sub si, 1
   
               loop nextDec3
                 
                 
                lea dx, msg3
                mov ah, 9
                int 21h 
                
                cmp sign, 1
               je printMinus2 
                 
                
                level3:              
                mov ah, 2
                mov cx, 5
                mov di, 0
                printDec2:
                    
                    mov dl, decInt[di]
                    int 21h
                    
                    inc di
                    loop printDec2

                mov cx, 5
                mov di, 0
                printDec3:
                    
                    mov dl, decIntL[di]
                    int 21h
                    
                    inc di
                    loop printDec3
                    
                
                jmp exit
                printMinus2:
                     mov ah, 2
                     mov dl, 2Dh
                     int 21h
                     jmp level3
            
            
        jmp exit
        printDiv:
             
             xor ax, ax
             xor bx, bx
             xor cx, cx
             xor dx, dx
             
             mov ax, ansH
             mov cx, 5
             mov si, 4
             mov bx, 10
             
             nextDec4:
             
               div bx

               add dl, 30h
               mov decInt[si], dl
               xor dx, dx
               sub si, 1
   
               loop nextDec4
             
             mov ax, ansL
             mov cx, 5
             mov si, 4
             mov bx, 10
             xor dx, dx
             
             nextDec5:
             
               div bx

               add dl, 30h
               mov decIntL[si], dl
               xor dx, dx
               sub si, 1
   
               loop nextDec5
                            
                
                lea dx, msg3
                mov ah, 9
                int 21h            
                
                cmp sign, 1
                je printMinus3
                
                level4:              
                mov ah, 2
                mov cx, 5
                mov di, 0
                printDec5:
                    
                    mov dl, decIntL[di]
                    int 21h
                    
                    inc di
                    loop printDec5
                
                 
                 
                mov ah, 2
                mov dl, 0Ah
                int 21h
                mov dl, 0Dh
                int 21h 
                
                lea dx, msg4
                mov ah, 9
                int 21h
        
         
                mov ah, 2    
                mov cx, 5
                mov di, 0
                printDec4:
                    
                    mov dl, decInt[di]
                    int 21h
                    
                    inc di
                    loop printDec4
                              
                  
                jmp exit
                printMinus3:
                     mov ah, 2
                     mov dl, 2Dh
                     int 21h
                     jmp level4  
                  
    exit:    
    mov ax, 4c00h
    int 21h    
ends

end start 