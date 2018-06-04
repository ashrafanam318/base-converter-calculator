; multi-segment executable file template.
data segment
    
    hexDummy db 4 dup(0) 
    
    hexArrInt db 4 dup(0)
    
    hexArrFrac db 4 dup(0)
    
    decInt db 5 dup(0)
    
    decFrac db 4 dup(0)
    
    firstIdx dw 0
    
    mltpl dw 1
    
    divisor dw 1
    
    integer dw 0
    
    fraction dw 0
    
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    
    ;taking binary integer Input
    
 inputInteger:
    
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx
    xor si, si
    mov firstIdx, dx
    mov integer, dx
    mov fraction, dx    
    
    mov ah, 1
    mov cx, 4
    mov si, 0
    
    takeHexInt:
    
        int 21h
        
        cmp al, 0Dh
        je arrangeInt
        
        
        cmp al, 2Eh
        je arrangeInt
        
        
        cmp al, 39h
        jg setAlph_1
        
        sub al, 30h
        
        setvalue1:
        
        mov hexDummy[si], al
        inc si
        
        loop takeHexInt
        
     mov ah, 2
     mov dl, 2Eh
     int 21h
      
      jmp arrangeInt
      setAlph_1:
      
         sub al, 37h
         jmp setValue1
     
     
     arrangeInt:
        
        mov firstIdx, cx
         
         mov cx, 4
         sub cx, firstIdx
         mov si, 0
         
         cmp cx, 0
         je inputFraction
         
         nextDigit:
             
             mov bl, hexDummy[si]
             push si
             add si, firstIdx
             mov hexArrInt[si], bl
             pop si
             inc si
             
             loop nextDigit
             
         cmp al, 0Dh
         je hexToIF
         
                               
  ; taking the binary fraction part
  
  inputFraction:
                               
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        xor si, si
           
        mov ah, 1
        mov cx, 4
        mov si, 0
           
     takeHexFrac:
         
         int 21h
         
         cmp al, 0Dh
         je hexToIF
         
         cmp al, 39h
         jg setAlph_2
         
         sub al, 30h
         
         setValue2:
         mov hexArrFrac[si], al
         inc si
         
         loop takeHexFrac
         
      jmp hexToIF
      setAlph_2:
      
         sub al, 37h
         jmp setValue2                         
              
              
  ;conversion starts
  hexToIF:
  
                               
  ; convertion, binary to integer
                        
    hexToInteger:
    
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        xor si, si
        
                                            
        mov cx, 4
        sub cx, firstIdx
        
        cmp cx, 0
        je hexToFraction
        
        mov si, 3
        mov bl, 16
        
        buildInt:         
           
           push bx
           mov al, hexArrInt[si]
           mov bx, mltpl
           
           mul bx
           
           add ax, integer
           mov integer, ax
           
           pop bx
           mov ax, mltpl
           mul bx 
           mov mltpl, ax
           xor ax, ax
           
           sub si, 1
           
           loop buildInt
        
        
        
        
        
   ;converting octal to fraction
   
   hexToFraction:
   
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        xor si, si
        
                                            
        mov cx, 3
        mov bx, 16
        mov divisor, bx
        mov bx, 10000
        mov mltpl, bx
        mov si, 0
        
        buildFrac:
        
        mov al, hexArrFrac[si]
        mov bx, mltpl     
        mul bx                     
         
        mov bx, divisor            
        div bx                     
        
        add ax, fraction 
        mov fraction, ax
        
        xor dx, dx
        mov ax, divisor
        mov bx, 16
        mul bx          
        mov divisor, ax
        
        xor ax, ax
        
        inc si
        
        loop buildFrac             
                  
                  
    
    ;conversion starts
    decConversion:
        
        ;converting ingeter part
        decIntegerConversion:
             
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
             
             mov ax, integer
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
           
                
         ;converting the fraction part
         decFractionConversion:
         
             mov ax, fraction
             mov cx, 4
             mov si, 3
             mov bx, 10
             
             nextDec2:
             
               div bx

               add dl, 30h
               mov decFrac[si], dl
               xor dx, dx
               sub si, 1
   
               loop nextDec2
                
                 
                               
         printDec:  
         
         ;call pthis 
;         db 10, 13, 10, 13, 'dec: ', 0
                
                mov ah, 2
                
                mov dl, 0Ah
                int 21h
                mov dl, 0Dh
                int 21h
                
                ;;printing the sign
;                
;                mov dl, sign
;                int 21h
                
                mov cx, 5
                mov di, 0
                printDec1:
                    
                    mov dl, decInt[di]
                    int 21h
                    
                    inc di
                    loop printDec1
                
                
                mov bx, fraction
                cmp bx, 0
                je Exit
                
                mov dl, 2Eh
                int 21h
                
                mov cx, 4
                mov si, 0
                printDec2:
                    
                    mov dl, decFrac[si]
                    int 21h
                    inc si
                    loop printDec2
        
    EXIT:    
        
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
   
   
   
   
   
              ;cmp al, 41h
;          je setA
;          
;          cmp al, 42h
;          je setB
;          
;          cmp al, 43h
;          je setC
;          
;          cmp al, 44h
;          je setD
;          
;          cmp al, 45h
;          je setE
;          
;          cmp al, 46h
;          je setF
;          
;          setA:
;          mov al, 10
;          jmp setAlph_1
;          
;          
;          setB:
;          mov al, 11
;          jmp setAlph_1
;          
;          setC:
;          mov al, 12
;          jmp setAlph_1
;          
;          setD:
;          mov al, 13
;          jmp setAlph_1
;          
;          setE:
;          mov al, 14
;          jmp setAlph_1
;          
;          setF:
;          mov al, 15
;          jmp setAlph_1
   
   
   
   
   
   ;mov ah, 2
;    mov dl, 0Ah
;    int 21h
;    mov dl, 0Dh
;    int 21h                             
;                               
;          mov ah, 2
;          
;          mov si, 0
;          
;          mov cx, 16
;                                 
;          btdPrint1:
;           
;           mov dl, binArrInt[si]
;           add dl, 30h
;           int 21h
;           
;           inc si
;           
;           loop btdPrint1
;           
;           
;           mov dl, 2Eh
;           int 21h
;           
;           
;           mov cx, 4
;           mov si, 0
;                                    
;           btdPrint2:
;                               
;              mov dx, binArrFrac[si]
;              add dx, 30h
;              int 21h
;              inc si
;              
;              loop btdPrint2