; multi-segment executable file template.
data segment
    
    dummy db 16 dup(0) 
    
    binArrInt db 16 dup(0)
    
    binArrFrac db 4 dup(0)
    
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
    mov cx, 16
    mov si, 0
    
    takeBinInt:
    
        int 21h
        
        cmp al, 0Dh
        je arrangeInt
        
        
        cmp al, 2Eh
        je arrangeInt
        
        
        sub al, 30h
        mov dummy[si], al
        inc si
        
        loop takeBinInt
        
     mov ah, 2
     mov dl, 2Eh
     int 21h
      
     arrangeInt:
        
        mov firstIdx, cx
         
         mov cx, 16
         sub cx, firstIdx
         mov si, 0
         
         cmp cx, 0
         je inputFraction
         
         nextDigit:
             
             mov bl, dummy[si]
             push si
             add si, firstIdx
             mov binArrInt[si], bl
             pop si
             inc si
             
             loop nextDigit
             
         cmp al, 0Dh
         je binToIF
         
                               
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
           
     takeBinFrac:
         
         int 21h
         
         cmp al, 0Dh
         je binToIF
         
         sub al, 30h
         
         mov binArrFrac[si], al
         inc si
         
         loop takeBinFrac
         
                               
  
  ;conversion starts
  binToIF:
  
                               
  ; convertion, binary to integer
                        
    binToInteger:
    
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        xor si, si
        
                                            
        mov cx, 16
        sub cx, firstIdx
        
        cmp cx, 0
        je binToFraction
        
        mov si, 15
        mov bl, 2
        
        buildInt:         
           
           push bx
           mov al, binArrInt[si]
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
        
        
        
        
        
   ;converting binary to fraction
   
   binToFraction:
   
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        xor si, si
        
                                            
        mov cx, 4
        mov bx, 2
        mov divisor, bx
        mov bx, 10000
        mov mltpl, bx
        mov si, 0
        
        buildFrac:
        
        mov al, binArrFrac[si]
        mov bx, mltpl     
        mul bx                     
         
        mov bx, divisor            
        div bx                     
        
        add ax, fraction 
        mov fraction, ax
        
        mov ax, divisor
        mov bx, 2
        mul bx          
        mov divisor, ax
        
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