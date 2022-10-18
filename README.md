Testato     =:heavy_check_mark:
Non testato =:warning:

# [Compiti svolti](COMPITI.md) [:heavy_check_mark:]


# REGISTRI :warning::warning::warning:
![Registri](Registri.png)
### r0 = $0 = 0
Registro Nullo
### r14
Riservato e usato prima di SYSCALL
### r1 = $at 
usato come valore di ritorno di SYSCALL (v1 e v2 valori di ritorno) ($at è normalmente riservato al sistema)
### $sp
Stack pointer, può essere aumentato e diminuito di n*8 byte alla volta con daddi
### PC Program counter
Registro che incrementato tiene conto della prossima istruzione N*4  0,4,8,12,16.... (manipolandolo permette i jump!) 

### $a0-$a3
Registri per gli argomenti delle funzioni custom

### $t0-$t7
Registri temporanei

### $s0-$s7
Registri usati come indici per i loop

### $r31=$ra
Registro di jump return jr $ra

# ALLOCAZIONE STACK  :heavy_check_mark:
### (salvo nello stack i valori di ritorno di salto per le varie funzioni annidate)

(sposto il puntatore stando attento a non sconfinare nell'altra area di memoria causando uno Stack buffer overflow) 
```ruby
.data

stack: .space 32
```
In memoria:
```ruby
      stack:
0 [             ] 
8 [             ] 
16[             ] 
24[             ] 
```
-------------------------------------------------------------------------------------
```ruby
 .code
daddi $sp,r0,stack #carico l'indirizzo dello stack nel stack pointer 
daddi $sp,$sp,32   #e lo sposto di 4 righe alla fine dello stack al 32 esimo byte
```
In memoria:
```ruby
      stack:
0 [             ] 
8 [             ] 
16[             ] 
24[          |31] <-SP 
```
-------------------------------------------------------------------------------------

# (PUSH) Allocazione e salvataggio registri  :heavy_check_mark:
### (scrivo  nello stack e mi sposto indietro)
```ruby
daddi $sp,$sp,-8   #sposto lo stack INDIETRO di una riga
sd $s0, 0($sp)     # $s0 VARIABILE SALVATA nello stack
```

$s0= [BANANA]

In memoria:
```ruby
           stack:
     0 [             ] 
     8 [             ] 
     16[          |23]<-SP   TORNO INDIETRO
     24[  BANANA     ]       (E SCRIVO )  
```
-------------------------------------------------------------------------------------

# (POP) Ripristino dei registri e deallocazione della memoria  :heavy_check_mark:
### (leggo dallo stack e mi sposto avanti)
```ruby
ld  $s0,0($sp)     # $s0 VARIABILE CARICATA dallo stack
daddi $sp,$sp,8    #sposto lo stack AVANTI di una riga
```

$s0=[]  -->  $s0= [PERA]

In memoria:
```ruby
           stack:
     0 [             ] 
     8 [             ] 
     16[             ]       (LEGGO)
     24[   P**A   |31] <-SP  MI SPOSTO AVANTI E DIMENTICO
 ```
-------------------------------------------------------------------------------------
```ruby
.data -> STR: .space 16

     STR:
[0    ciao     7] STR(0)->STR(7)  
[8    mamma   15] STR(8)->STR(15)

```

# Indirizzi di Memoria
```ruby
daddi $a0,r0,STR      #indirizzo RAM del label STR in $a0
```
# Load da Registro a Memoria
```ruby
ld $a0,STR(r0)        carico $a0 in 0+indirizzo memoria STR
```


# DIVISIONE/MOLTIPLICAZIONE :heavy_check_mark:
## dividere per 2,4,8,16
SHIFT ARITMETICO A DX

1_shift
```ruby
dsra $t0,$t0,1   #DIVISO 2
```

2_shift
```ruby
dsra $t0,$t0,2   #DIVISO 4
```

3_shift
```ruby
dsra $t0,$t0,3   #DIVISO 8
```

# moltiplicare per 2,4,8,16 #
## ?

---------------------------------------------------------------------
# SYSTEM CALL
## CALCOLO LA LUNGHEZZA DELLA STRINGA :warning:
```ruby
.data
-- Testing--
str1: .asciiz "inserisci una stringa di numeri"
str2: .asciiz "la somma e' %d \n"

p1_sys3: .word 0
ind_sys3: .space 8
dim_sys3: .word 16
STR: .space 16
-- Testing--
.code

#scanf("%s",STR)->SYS3
daddi $t0,r0,STR
sd $t0,ind_sys3(r0)
daddi $14,r0,p1_sys3
syscall 3       

# Dopo la syscall trovo 
# r1 = dimensione stringa / numero parametri letti
move $a1,r1  # salvo il numero di byte letti

```
Tradotto in c:
```c
-- Testing---
```



## SYSCALL 3: READ/SCANF :warning:
```ruby
.data

STR: .space 16

p1_sys3:     .word 0     #0->STDIN oppure file descriptor
ind_str:	 .space 8    #dove salvare la stringa
dim: 	       .word 16    #quanti byte scrivere (16 Byte)

.code

daddi $t0,r0,STR     # ???
sd $t0,ind_str(r0)   # ???
daddi r14,r0,p1_sys3 # ???
syscall 3
move $a1,r1  # salvo il numero di byte letti $a1=r1
# Dopo la syscall trovo 
# r1 = dimensione stringa / numero parametri letti



```
Tradotto in c:
```c
scanf("%s",STR);
```

## SYSCALL 5: PRINTF :heavy_check_mark:

```ruby
.data
str1: .asciiz "Stampa solo questa riga”
str2: .asciiz "Stampa il numero %d”

p1_sys5: .space 8 # primo parametro che deve contenere l’indiririzzo della stringa da visualizzare (mess)
val1: .space 8       # SE nella stringa sono presenti N %d, seguono altri N parametri

.code
sd r1,val(r0)            # salvo il ritorno di una funzione in val(r0) ->OPZIONALE PER %d

daddi $t0,r0,str2        #metto l'indirizzo della stringa2 in t0     
sd $t0,p1_sys5(r0)       #salvo t0 come prima riga nel par1
daddi r14,r0,p1_sys5     #salvo il par1
syscall 5
```
Tradotto in c:
```c
printf("Stampa il numero %d",n);
```

## Caricare unsigned int:  :warning:

```ruby
 #include input_unsigned.s
 
 jal input_unsigned
 move $a2,r1
```
## Entrare in una sub-routing:  :warning:

```ruby
 jal funzione
 #r1=CONTIENE IL MIO VALORE?
 syscall 0
 
 
funzione:

      #PUSH
      daddi $sp,$sp,-16
      sd $s0,0($sp)
      sd $s1,8($sp)

      #ROUTINE

      #POP
      ld $s0,0($sp)
      ld $s1,8($sp)
      daddi $sp,$sp,16

jr $ra
 
 ```

# TO-DO
* slti 
* move
* for
* jal
* jr
* altri registri
