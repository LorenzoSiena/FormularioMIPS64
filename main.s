# r0 = $0 = 0
# r14 = PreCall Parametro
# r1 = $at -> usato come valore di ritorno di SYSCALL (v1 e v2 valori di ritorno) ($at è normalmente riservato al sistema)
# $sp = Stack pointer, può essere aumentato e diminuito di n*8 byte alla volta con daddi


ALLOCAZIONE STACK(ci salvo i valori di ritorno di salto per le varie funzioni annidate)
??? FIX 8 byte stack!!!!!!!!!!!!!!!!!!!,????????????????????????
     stack:
[             ] 0
[             ] 8
[             ] 16
[             ] 24
[             ] 32 <- SP
[-------------]

.data

stack: .space 32

.code
daddi $sp,r0,stack # carico l'indirizzo dello stack nel stack pointer
daddi $sp,$sp,32   # e lo sposto di 4 righe alla fine dello stack


#allocazione e salvataggio registri (scrivo  nello stack e mi sposto indietro)
daddi $sp,$sp,-8   #sposto lo stack INDIETRO di una riga
sd $s0, 0($sp)     # $s0 VARIABILE SALVATA nello stack

$s0= [xxx]

     stack:
0 [             ] 
8 [             ] 8
16[             ] 16
24[     xxx        ] 24 <- SP
[          ] 32 

# ripristino dei registri e deallocazione della memoria (leggo dallo stack e mi sposto avanti)
ld  $s0,0($sp)     # $s0 VARIABILE CARICATA dallo stack
daddi $sp,$sp,8    #sposto lo stack AVANTI di una riga


$s0=[]  -->  $s0= [xxx]

     stack:
[             ] 0
[             ] 8
[             ] 16
[             ] 24 
[     xxx     ] 32 <- SP

-------------------------------------------------------------------------------------
.data -> STR: .space 16

     STR:
[      ciao      ] STR(0)->STR(7)  
[     mamma      ] STR(8)->STR(15)
[     guardami   ] STR(16)->STR()



[Indirizzi/puntatore]
daddi $a0,r0,STR      #salvo indirizzo stringa in a0

[Valori]
ld $a0,STR(r0)        #salvo il primo elemento di SRT[0,1,2,3,4,5,6,7] in $a0 =[0]

---------------------------ESERCIZI-----------------------------------------------------------
CALCOLO LA LUNGHEZZA DELLA STRINGA

.data

str1: .asciiz "inserisci una stringa di numeri"
str2: .asciiz "la somma e' %d \n"

p1_sys3: .word 0
ind_sys3: .space 8
dim_sys3: .word 16
STR: .space 16

.code

#scanf("%s",STR)->SYS3
daddi $t0,r0,STR
sd $t0,ind_sys3(r0)
daddi $14,r0,p1_sys3
syscall 3             #->r1= dimensione stringa


--------------------------------------------------------------------------------------
SYSCALL 3: READ/SCANF

.data
buffer: .space 8
par: .space 8  #descrittore
ind: .space 8  #indirizzo di partenza
num_byte: .word 8

.code

sd r0,par(r0)   # stdin
daddi $t0, r0, buffer # copia il valore buffer in $t0
sd $t0, ind(r0) # salva l’indirizzo buffer in ind
daddi r14, r0, par
syscall 3       #->r1= stringa inserita
-----------------------------------------------------------------------------------------
SYSCALL 5: PRINTF

.data
mess: .asciiz "Stampa i numeri %d e %d”
arg_printf: .space 8 # primo parametro che deve contenere l’indiririzzo della stringa da visualizzare (mess)
                     # Poiché nella stringa sono presenti 2 %d, seguono altri 2 parametri
num1: .word 255
num2: .space 8
str: .asciiz "stringa non usata"

.code

daddi $t0, r0, mess       #copia on $t0 l’indirizzo di mess
sd $t0, arg_printf(r0)    #salva nel primo parametro l’ind. di mess
daddi $t0, r0, 50         #la scelta di 50 é arbitraria
sd $t0, num2(r0)
daddi r14, r0, arg_printf

syscall 5                #stampa la stringa
