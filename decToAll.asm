
include 'emu8086.inc'

.ORG    100h


; >>>>>>>>DECIMAL TO All<<<<<<<

data segment
    
    integer dw 0;
    
    fraction dw 0;
    
    modLength dw 0;
    
    sign db 0;
    
    binInt db 16 dup(0)
    
    binFrac db 4 dup(0)
    
    octInt db 6 dup(0)
    
    octFrac db 4 dup(0)
    
    hexInt db 4 dup(0)
    
    hexFrac db 4 dup(0)
    
    
ends

code segment
start:

;call pthis
;db '>>>input a decimal Number and press "Enter" to start the converstion<<<', 0 
;
;
;call pthis
;db 10, 13, 10, 13, 'The decimal Number: ', 0 

;Taking the Integer part of the decimal number
    takeIntPart:
        
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        xor si, si
        xor di, si
        mov integer, dx
        mov fraction, dx
        mov modLength, dx
        mov sign, 0
        
        
        
        mov ah, 1
        mov cx, 5
        mov bx, 10 
        
        takeIntDigit:
        
             int 21h;
             
             ;cmp al, 2Dh
;             je setSign
             
             cmp al, 02Eh;
             je takeFracPart;
             
             cmp al, 0Dh;
             je conversion;
             
             sub al, 30h
             push ax
             mov ax, integer
             mul bx
             mov integer, ax
             pop ax
             push bx
             mov bh, ah
             xor ah, ah
             add ax, integer
             mov integer, ax
             mov ah, bh
             pop bx
             loop takeIntDigit;
             
             
             ;setSign: 
;             mov sign, al 
;             inc cx
;             loop takeIntDigit
;             
            mov ah, 2
            mov dl, 02Eh 
            int 21h       ;for the decimalpoint after the 16th digit    

;taking the fraction part of the decimal number
    
    takeFracPart:
    
        
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
        
        mov ah, 1
        mov cx, 4
        mov bx, 1000 
        
        takeFracDigit:
             
             int 21h;
             
             cmp al, 0Dh;
             je conversion;
             
             ;push bx
;             mov bx, modLength
;             add bx, 1
;             mov modLength, bx ;counting the number of digits afte the decimal point, mxValue = 4
;             pop bx
;             
;             sub al, 30h
;             push ax
;             mov ax, fraction
;             mul bx
;             mov fraction, ax
;             pop ax
;             push bx
;             mov bh, ah
;             xor ah, ah
;             add ax, fraction
;             mov fraction, ax
;             mov ah, bh
;             pop bx

             sub al, 30h
             
             push ax
             xor ah, ah
             mul bx
             
             add ax, fraction
             mov fraction, ax
             
             mov ax, bx
             mov bx, 10
             div bx
             mov bx, ax
             
             pop ax
             
             loop takeFracDigit;
             
             
             
            
conversion:

;conversion to binary

    binaryConversion:
        
        ;converting ingeter part
        binIntegerConversion:
             
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
             
             mov ax, integer
             mov cx, 16
             mov si, 15
             mov bx, 2
             
             nextBin1:
             
               div bx

               add dl, 30h
               mov binInt[si], dl
               xor dx, dx
               sub si, 1
   
               loop nextBin1
           
                
         ;converting the fraction part
         binFractionConversion:
         
         xor ax, ax
         xor bx, bx
         xor cx, cx
         xor dx, dx
       
               ;calculating modular
               
               ;mov cx, modLength
;               cmp cx, 0
;               je printBin
;               mov ax, 1
;               mov bx, 10
;               
;               countModBin:
;                    mul bx
;                    loop countModBin
               
               
               ;conversion starts
               
               mov cx, 4
               mov bx, 10000 ; the modular is in bx
               mov si, 0
               mov ax, fraction
               
               nextBin2:
                push bx
                mov bx, 2
                mul bx
                
                pop bx
                div bx
                
                add al, 30h
                mov binFrac[si], al
                xor ax, ax
                mov ax, dx
                xor dx, dx
                inc si
                loop nextBin2 
                
                 
                               
         printBin:  
         
         ;call pthis 
;         db 10, 13, 10, 13, 'bin: ', 0
                
                mov ah, 2
                
                mov dl, 0Ah
                int 21h
                mov dl, 0Dh
                int 21h
                
                ;;printing the sign
;                
;                mov dl, sign
;                int 21h
                
                mov cx, 16
                mov di, 0
                printBin1:
                    
                    mov dl, binInt[di]
                    int 21h
                    
                    inc di
                    loop printBin1
                
                mov bx, fraction ;no fraction to print
                cmp bx, 0
                je octConversion
                
                mov dl, 2Eh
                int 21h
                
                mov cx, 4
                mov si, 0
                printBin2:
                    
                    mov dl, binFrac[si]
                    int 21h
                    inc si
                    loop printBin2
                
 ;--------------------------------------------------------------------------
 
 
    ;converting to octal
    
    octConversion: 
           
        ;converting ingeter part
        octIntegerConversion:
             
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
             
             mov ax, integer
             mov cx, 6
             mov si, 5
             mov bx, 8
             
             nextOct1:
             
               div bx

               add dl, 30h
               mov octInt[si], dl
               xor dx, dx
               sub si, 1
   
               loop nextOct1
           
                
         ;converting the fraction part
         octFractionConversion:
         
         xor ax, ax
         xor bx, bx
         xor cx, cx
         xor dx, dx
         xor si, si
         
       
               ;calculating modular
               
              ; mov cx, modLength
;               cmp cx, 0
;               je printOct
;               mov ax, 1
;               mov bx, 10
;               
;               countModOct:
;                    mul bx
;                    loop countModOct
               
               
               ;conversion starts
               
               mov cx, 4
               mov bx, 10000 ; the modular is in bx
               mov si, 0
               mov ax, fraction
               
               nextOct2:
                push bx
                mov bx, 8
                mul bx
                
                pop bx
                div bx
                
                add al, 30h
                mov octFrac[si], al
                xor ax, ax
                mov ax, dx
                xor dx, dx
                inc si
                loop nextOct2 
                
                 
                               
                               
         printOct:  
         
         ;call pthis 
;         db 10, 13, 10, 13, 'oct: ', 0
                
                mov ah, 2
                
                mov dl, 0Ah
                int 21h
                mov dl, 0Dh
                int 21h
                
                ;;printing the sign
;                
;                mov dl, sign
;                int 21h
                
                mov cx, 6
                mov di, 0
                printOct1:
                    
                    mov dl, octInt[di]
                    int 21h
                    
                    inc di
                    loop printOct1
                    
                    
                mov bx, fraction ;no fraction to print
                cmp bx, 0
                je hexConversion
                
                mov dl, 2Eh
                int 21h
                
                mov cx, 4
                mov si, 0
                printOct2:
                    
                    mov dl, octFrac[si]
                    int 21h
                    inc si
                    loop printOct2                      
                         
  ;----------------------------------------------------------------
  
  
  
  ;conversion to HexaDecimal

   hexConversion: 
         
        ;converting ingeter part
        hexIntegerConversion:
             
        xor ax, ax
        xor bx, bx
        xor cx, cx
        xor dx, dx
             
             mov ax, integer
             mov cx, 4
             mov si, 3
             mov bx, 16
             
             nextHex1:
             
               div bx

               add dl, 30h
               cmp dl, 39h
               jg getAlph_1
                
               setAlph_1: 
               
               mov hexInt[si], dl
               xor dx, dx
               sub si, 1
   
               loop nextHex1
               
               getAlph_1:
                    add cx, 1
                    add dl, 7h
                    loop setAlph_1
               
                
         ;converting the fraction part
         hexFractionConversion:
         
         xor ax, ax
         xor bx, bx
         xor cx, cx
         xor dx, dx
         xor si, si
         
       
               ;calculating modular
               
               ;mov cx, modLength
;               cmp cx, 0
;               je printHex
;               mov ax, 1
;               mov bx, 10
;               
;               countModHex:
;                    mul bx
;                    loop countModHex
               
               
               ;conversion starts
               
               mov cx, 4
               mov bx, 10000 ; the modular is in bx
               mov si, 0
               mov ax, fraction
               
               nextHex2:
                push bx
                mov bx, 16
                mul bx
                
                pop bx
                div bx
                
                add al, 30h
                cmp al, 39h
                jg getAlph_2
                
                setAlph_2:
                
                mov hexFrac[si], al
                xor ax, ax
                mov ax, dx
                xor dx, dx
                inc si
                loop nextHex2
                 
                getAlph_2:
                    
                    add cx, 1
                    add al, 7h
                    loop setAlph_2 
                 
                               
         printHex:  
         
         ;call pthis 
;         db 10, 13, 10, 13, 'hex: ', 0
                
                mov ah, 2
                
                mov dl, 0Ah
                int 21h
                mov dl, 0Dh
                int 21h
                
                ;;printing the sign
;                
;                mov dl, sign
;                int 21h
                
                mov cx, 4
                mov di, 0
                printHex1:
                    
                    mov dl, hexInt[di]
                    int 21h
                    
                    inc di
                    loop printHex1
                
                mov bx, fraction ;no fraction to print
                cmp bx, 0
                je EXIT
                
                mov dl, 2Eh
                int 21h
                
                mov cx, 4
                mov si, 0
                printHex2:
                    
                    mov dl, hexFrac[si]
                    int 21h
                    inc si
                    loop printHex2
  
    
    
   ;------------------------------------------------------------- 
                         
            
EXIT:
    mov ax, 4c00h ; exit to operating system.
    int 21h
      
ends  

;DEFINE_SCAN_NUM
;DEFINE_PRINT_STRING
;DEFINE_PRINT_NUM
;DEFINE_PRINT_NUM_UNS  ; required for print_num.
;DEFINE_PTHIS

end start 


                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                          ;mov ah, 2
;                mov dl, 0Ah
;                int 21h
;                mov dl, 0Dh
;                int 21h
;                
;                mov si, idxI
;                mov bx, 16
;                sub bx, si
;                mov cx, bx
;                strt2:
;                    
;                    mov dl, binInt[si]
;                    int 21h
;                    
;                    inc si
;                    loop strt2
;                
;                








