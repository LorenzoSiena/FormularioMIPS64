# MASTER TEMPLATE
```asm
.data
stack:  .space 32
ST:  .space  16 ; buffer

msg1:     .asciiz "Metti un numero\n"
msg2:     .asciiz "Metti una stringa\n"
msgVal:    .asciiz "printf con valore= %d\n"

;DATA syscall 3 
stdin:    .word   0   ; stdin
str_sys3:  .space  8 ; indirizzo buffer
dim_sys3:   .word   16 ; Nbyte da leggere

;DATA syscall 5
str_sys5:  .space  8 ;indirizzo stringa da stampare <- [msg1,msg2,msgval]
ris:        .space  8       ;%d



.code
;STACK INIT
daddi   $sp, $0, stack
daddi   $sp, $sp, 32  


daddi   $s0, $0, 0              ; i = 0

for:	

	slti $t0,$s0,4                  ;;FOR 4 VOLTE
	beq $t0,r0,end
	daddi $s0,$s0,1	 ; SPOSTAMI! ( i++ )
	j for 		; SPOSTAMI! (ricomincia il for)	

	;PRINTF1 ------------------------------------------
	daddi   $t0, $0, msg1
    	sd      $t0, str_sys5($0)
    	daddi   r14, $0, str_sys5
	syscall 5                   	; printf("METTI UN NUMERO\n");
	; -----------------------------------------------------
	 jal     input_unsigned      ; scanf("%d",&num) SYSCALL_UN_NUMERO 
	move    $a0, r1	 ; PRIMO ARGOMENTO



	;PRINTF2 ------------------------------------------
	daddi   $t0, $0, msg2
    	sd      $t0, str_sys5($0)
    	daddi   r14, $0, str_sys5
	syscall 5                   	; printf("Metti una stringa\n");
	; -----------------------------------------------------
	
	;SCANF STRINGA -------------------------
	daddi   $t0, $0, ST
    	sd      $t0, str_sys3($0)
    	daddi   r14, $0, stdin
    	syscall 3                   ; scanf("%s",ST);
	;-----------------------------------------------
    	move    $a1, r1             ; SE VOGLIO LA LUNGHEZZA DELLA STRINGA $a1 = strlen(ST) SECONDO ARGOMENTO
	;------------------------------------------------
	

	;con a0,a1,a2(?) completati vado nella funzione esterna
	jal funz
	sd      r1, ris($0)  ; salvo in ris il valore restituito utile alla printf

	;   printf(" Valore= %d n",ris);
	daddi $t0,$0,msgVal  ; con msgVal dichiaro di voler leggere anche il valore dopo str_sys5
	sd $t0,str_sys5($0)
	daddi r14,$0,str_sys5
	syscall 5

	
	
end: 
syscall 0




funz:
     ;PUSH s0s1
      daddi $sp,$sp,-16
      sd $s0,0($sp)
      sd $s1,8($sp)
	
	;ROUTINE  con a0,a1,a2

	lbu $t1, 0($t0)  ;$t1=str[i]


      move r1,$s7 ; SALVO IL RISULTATO da s7 a r1
      
     ;POP s0s1
      ld $s0,0($sp)
      ld $s1,8($sp)
      daddi $sp,$sp,16
      jr $ra

#include input_unsigned.s


```

# 28/06/2022 T1
Scrivere un programma in linguaggio Assembly MIPS che traduce il seguente programma C
```c
int calcola(char *st, int d, int val)
{
    int j, cnt;
    cnt = 0;
    for (j = 0; j < d; j++)
        if (st[j] - 48 == val)
            cnt++;
    return cnt;
}
main()
{
    char ST[16];
    int VAL[3];
    int i, num;
    printf("Inserisci una stringa di soli numeri \n");
    scanf("%s", ST);
    for (i = 0; i < 3; i++)
    {
        printf("Inserisci un numero a una cifra");
        scanf("%d", &num); // usare input_unsigned
        VAL[i] = calcola(ST, strlen(ST), num);
        printf(" V[%d]= %d \n", i, VAL[i]);
    }
}
```
### ASSEMBLY MIPS
```asm
```
# 28/06/2022 T2
Scrivere un programma in linguaggio Assembly MIPS che traduce il seguente programma C
```c
int confronta(char *st1, char *st2, int d)
{
    int j, cnt;
    cnt = 0;
    for (j = 0; j < d; j++)
        if (st1[j] == st2[j])
            cnt++;
    return cnt;
}
main()
{
    char ST1[16], ST2[16];
    int i, num, ris;
    for (i = 0; i < 3; i++)
    {
        printf("Inserisci una stringa\n");
        scanf("%s", ST1);
        printf("Inserisci una stringa \n");
        // Si assuma di inserire una stringa con almeno lo stesso numero di
        caratteri della prima stringa
            scanf("%s", ST2);
        ris = confronta(ST1, ST2, strlen(ST1));
printf("Il numero di caratteri uguali nella stessa posizione e' %d
\n",ris);
    }
}
```
### ASSEMBLY MIPS
```asm
```

# 14/03/2022 T1
Scrivere un programma in linguaggio Assembly MIPS che traduce il seguente programma C
```c
int elabora(char *vet, int d)
{
    int i, conta;
    conta = 0;
    for (i = 0; i < d; i++)
        if (vet[i] < 58)
            conta++;
    return (conta % 4);
}
main()
{
    char VAL[32];
    int i, ris, numero;
    for (i = 0; i < 3; i++)
    {
        printf("Inserisci un numero\n");
        scanf("%d", &numero);
        if (numero < 4)
            ris = numero;
        else
        {
            printf("Inserisci una stringa con almeno %d caratteri\n", numero);
            scanf("%s", VAL);
            ris = elabora(VAL, strlen(VAL));
        }
        printf(" Ris[%d]= %d \n", i, ris);
    }
}
```
### ASSEMBLY MIPS
```asm
```
# 14/03/2022 T2
Scrivere un programma in linguaggio Assembly MIPS che traduce il seguente programma C
```c
int elabora(char *vet, int d)
{
    int i, pari;
    pari = 0;
    for (i = 0; i < d; i++)
        if (vet[i] % 2 == 0)
            pari++;
    return pari;
}
main()
{
    char VAL[32];
    int i, ris, numero;
    for (i = 0; i < 3; i++)
    {
        printf("Inserisci una stringa con almeno 4 caratteri \n");
        scanf("%s", VAL);
        if (strlen(VAL) < 4)
        {
            printf("Inserisci un numero maggiore di %d \n", strlen(VAL));
            scanf("%d", &ris);
        }
        else
            ris = elabora(VAL, strlen(VAL));
        printf(" Ris[%d]= %d \n", i, ris);
    }
}
```
### ASSEMBLY MIPS
```asm
```
# 24/02/2022 T1
Scrivere un programma in linguaggio Assembly MIPS che traduce il seguente programma C
```c
int calcola(char *st, int d, int val)
{
    int j, cnt;
    cnt = 0;
    for (j = 0; j < d; j++)
        if (st[j] - 48 < val)
            cnt++;
        else
            cnt += 2;
    return cnt;
}
main()
{
    char ST[16];
    int i, num, ris;
    i = 0;
    do
    {
        printf("Inserisci una stringa di soli numeri \n");
        scanf("%s", ST);
        printf("Inserisci un numero a una cifra");
        scanf("%d", &num);
        ris = calcola(ST, strlen(ST), num);
        printf(" Valore= %d \n", ris);
        i++;
    } while (i < 3);
}
```
### ASSEMBLY MIPS
```asm
.data   
stack:      .space  32
ST:         .space  16

hint_a:     .asciiz "Inserisci una stringa di soli numeri\n"
hint_b:     .asciiz "Inserisci un numero a una sola cifra\n"
ans_str:    .asciiz " Valore= %d\n"

fd_sys3:    .word   0
_str_sys3:  .space  8
dim_sys3:   .word   16

_str_sys5:  .space  8
ris:        .space  8

.code
; inizializzo lo stack
daddi   $sp, $0, stack
daddi   $sp, $sp, 32        
daddi   $s0, $0, 0              ; i = 0
do: daddi   $t0, $0, hint_a
    sd      $t0, _str_sys5($0)
    daddi   r14, $0, _str_sys5
    syscall 5                   ; printf("Inserisci una stringa di soli numeri\n");

    daddi   $t0, $0, ST
    sd      $t0, _str_sys3($0)
    daddi   r14, $0, fd_sys3
    syscall 3                   ; scanf("%s",ST);
    move    $s1, r1             ; $s1 = strlen(ST)

    daddi   $t0, $0, hint_b
    sd      $t0, _str_sys5($0)
    daddi   r14, $0, _str_sys5
    syscall 5                   ; printf("Inserisci un numero a una cifra");

    jal     input_unsigned      ; scanf("%d",&num);  
    ; salvo come terzo parametro per calcola il valore restituito dalla chiamata
    move    $a2, r1

; il primo parametro è l'indirizzo della stringa
    daddi   $a0, $0, ST        
; Il secondo parametro è la lunghezza della stringa che ho memorizzato in $s1
    move    $a1, $s1
    jal     calcola
; salvo in ris il valore restituito utile alla printf
    sd      r1, ris($0)

    daddi   $t0, $0, ans_str
    sd      $t0, _str_sys5($0)
    daddi   r14, $0, _str_sys5
    syscall 5                   ; printf(" Valore= %d \n",ris);

    daddi   $s0, $s0, 1         ; i++
    slti    $t0, $s0, 3         ; $t0 = 0 <- $s0 >= 3
    beq     $t0, $0, end        ; se $t0 = 0 esci dal ciclo, altrimenti salta a do
    j       do
end:    syscall 0

calcola:    daddi   $sp, $sp, -16
            sd      $s0, 0($sp)
            sd      $s1, 8($sp)

daddi       $s0, $0, 0              ; i = 0
daddi       $s1, $0, 0              ; cnt = 0
for:        slt     $t0, $s0, $a1
            beq     $t0, $0, end_f

            dadd    $t1, $a0, $s0   ; $t1 = &st[i]
            lbu     $t1, 0($t1)     ; $t1 = st[i]
            daddi   $t0, $t1, -48   ; $t0 = st[i] - 48

            slt     $t0, $t0, $a2
            beq     $t0, $0, inc_2  ; incrementa cnt di due se $a2 >= $t0
            daddi   $s1, $s1, 1     ; cnt++
            j       inc_i
inc_2:      daddi   $s1, $s1, 2

inc_i:      daddi   $s0, $s0, 1     ; i++
            j       for
end_f:      move    r1, $s1         ; salvo il valore di ritorno
; carico i dati dallo stack
            ld      $s1, 8($sp)
            ld      $s0, 0($sp)
            daddi   $sp, $sp, 16

            jr      $ra

#include input_unsigned.s

```
#  24/02/2022 T2
Scrivere un programma in linguaggio Assembly MIPS che traduce il seguente programma C
```c
int calcola(char *a0)
{
    int j, cnt;
    j = 0;
    cnt = 0;
    do
    {
        if (a0[j] < 58)
            cnt++;
        j++;
    } while (a0[j] != 48);
    return cnt;
}
main()
{
    char ST[16];
    int i, num, ris;
    for (i = 0; i < 4; i++)
    {
        printf("Inserisci una stringa terminata con il carattere 0 \n");
        scanf("%s", ST);
        printf("Inserisci un numero");
        scanf("%d", &num);
        ris = calcola(ST) + num;
        printf(" Valore= %d \n", ris);
    }
}
```
### ASSEMBLY MIPS
```asm
.data
str: .space 16
stack: .space 32

str1: .asciiz "Inserisci una stringa terminata con il carattere 0 \n"
str2: .asciiz "Inserisci un numero"
str3: .asciiz " Valore= %d \n"

;parametri  syscall 3
p1s3: .word 0
p2s3: .space 8
p3s3: .word 16

;parametri syscall 5
p1s5: .space 8
ris: .space 8

.code
;inizializzazione stack
daddi $sp,$0,stack
daddi $sp,$sp,32

; for(i=0;i<4;i++) {
	daddi $s0,$0,0
for: 	slti $t0,$s0,4
	beq $t0,$0,fine_for

;    printf("Inserisci una stringa terminata con il carattere 0 n");
	daddi $t0,$0,str1
	sd $t0,p1s5($0)
	daddi r14,$0,p1s5
	syscall 5

;   scanf("%s",ST);
	daddi $t0,$0,str
	sd $t0,p2s3($0)
	daddi r14,$0,p1s3
	syscall 3

;   printf("Inserisci un numero");
	daddi $t0,$0,str2
	sd $t0,p1s5($0)
	daddi r14,$0,p1s5
	syscall 5

;   scanf("%d",&num);
	jal input_unsigned
	move $s1,r1

;   ris= calcola(ST)+num;
	daddi $a0,$0,str
	jal calcola
	dadd $t0,r1,$s1
	sd $t0,ris($0)

;   printf(" Valore= %d n",ris);
	daddi $t0,$0,str3
	sd $t0,p1s5($0)
	daddi r14,$0,p1s5
	syscall 5

;	i++
	daddi $s0,$s0,1
	j for

fine_for: syscall 0

;--------------------------------------------------------

;int calcola(char *a0)
calcola: daddi $sp,$sp,-16
	sd $s0,0($sp)
	sd $s1,8($sp)

;   j=0;
	daddi $s0,$0,0
;  cnt=0;
	daddi $s1,$0,0

;  do{
;  	if(a0[j]<58)

do: 	dadd $t0,$a0,$s0
	lbu $t1,0($t0)
	slti $t0,$t1,58

	beq $t0,$0,incr_j ; saltiamo all'incremento di j se la condizione a0[j] < 58 è falsa
 
;	cnt++;
	daddi $s1,$s1,1
;	j++
incr_j: daddi $s0,$s0,1

; } while (a0[j]!=48);
	  daddi $t0,$0,48
	  bne $t1,$t0,do

	move r1,$s1
	ld $s1,8($sp)
	ld $s0,0($sp)
	daddi $sp,$sp,16
	jr r31

#include input_unsigned.s

```
#  31/01/2022
Scrivere un programma in linguaggio Assembly MIPS che traduce il seguente programma C
```c
int processa(char *st, int d)
{
    int i;
    for (i = 0; i < d; i++)
        if (st[i] >= 58)
            break;
    return i;
}
main()
{
    char STRNG[16];
    int i, val, num;
    for (i = 0; i < 3; i++)
    {
        do
        {
            printf("Indica quanti caratteri (numeri) vuoi inserire (>=3))\n");
            scanf("%d", &num);
        } while (num < 3);
        printf("Inserisci la stringa con %d numeri \n", num);
        scanf("%s", STRNG);
        val = processa(STRNG, num);
        printf(" Valore= %d \n", val);
    }
}
```
### ASSEMBLY MIPS
```asm
.data
STRNG: .space 16

msg1: .asciiz "Indica quanti caratteri(numeri) vuoi inserire (>=3)) \n"
msg2: .asciiz "Inserisci la stringa con %d numeri\n"
msg3: .asciiz "Valore= %d \n"

p1s3: .word 0
inds3: .space 8
dim: .word 16

p1s5: .space 8
val: .space 8

stack: .space 32

.code
daddi $sp, $0, stack
daddi $sp, $sp, 32

daddi $s0, $0, 0 ;i=0

; for(i=0;i<3;i++) {
for: 	slti $t0, $s0, 3 ;i<3
	beq $t0, $0, endfor

; do{ printf("Indica quanti caratteri(numeri) vuoi inserire (>=3)) \n");
	daddi $t0, $0, msg1
	sd $t0, p1s5($0)  ; lo metto prima del do così lo eseguo una sola volta
do: 	daddi r14, $0, p1s5 
	syscall 5
; scanf("%d",&num);
	jal input_unsigned
	move $s1, $at ;num
; }while(num<3);
	slti $t0, $s1, 3
	bne $t0, $0, do

; printf("Inserisci la stringa con %d numeri\n",num);
	sd $s1, val($0)
	daddi $t0, $0, msg2
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5

; scanf("%s",STRNG);
	daddi $a0, $0, STRNG
	sd $a0, inds3($0)
	daddi r14, $0, p1s3
	syscall 3

; val=processa(STRNG,num); 
	move $a1, $s1
	jal processa

; printf(" Valore= %d \n",val); 
	sd r1, val($0)
	daddi $t0, $0, msg3
	sd $t0, p1s5($0)
	daddi r14, $0, p1s5
	syscall 5

daddi $s0, $s0, 1 ;i++
j for

endfor:
syscall 0

;int processa(char *st, int d)
;{ int i;
 
; for(i=0;i<d;i++)
; if(st[i]>=58)
; break; 
 
; return i;
;}
processa:   daddi $sp, $sp, -8
		sd $s0, 0($sp)

; for(i=0;i<d;i++)
		daddi $s0, $0, 0
forf: 	slt $t0, $s0, $a1
	beq $t0, $0, return

; if(st[i]>=58)
	dadd $t0, $s0, $a0
	lbu $t1, 0($t0)
	slti $t0, $t1, 58
	; break; 
	beq $t0, $0, return ; saltiamo a return se la condizione st[i]<58 e' falsa

incr:   daddi $s0, $s0, 1  ; i++
	j forf

; return i;
return: move r1, $s0
	  ld $s0, 0($sp)
	  daddi $sp, $sp, 8
	  jr $ra

#include input_unsigned.s
```

#  Esempio1 lezione del 14 dicembre 2021
Scrivere un programma in linguaggio Assembly MIPS che traduce il seguente programma C
```c
int processa(char *st, int d)
{
    int i;
    for (i = 0; i < d; i++)
        if (st[i] >= 58)
            break;
    return i;
}
main()
{
    char STRNG[16];
    int i, val, num;
    for (i = 0; i < 3; i++)
    {
        do
        {
            printf("Indica quanti caratteri (numeri) vuoi inserire (>=3))\n");
            scanf("%d", &num);
        } while (num < 3);
        printf("Inserisci la stringa con %d numeri \n", num);
        scanf("%s", STRNG);
        val = processa(STRNG, num);
        printf(" Valore= %d \n", val);
    }
}
```
### ASSEMBLY MIPS
```asm
???
```


#  Esempio2 lezione del 14 dicembre 2021
Scrivere un programma in linguaggio Assembly MIPS che traduce il seguente programma C
```c
int elabora(char *a0, int a1)
{
    int i;
    for (i = 0; i < a1; i++)
        if (a0[i] < 48)
            return -1;
    return a1;
}
main()
{
    char STRINGA[16];
    int A[4], i, n;
    for (i = 0; i < 4; i++)
    {
        printf("Inserire una stringa\n");
        scanf("%s", STRINGA);
        printf("Inserisci un numero minore di %d \n", strlen(STRINGA));
        scanf("%d", &n)
            A[i] = elabora(STRINGA, n);
        printf("A[%d]=%d", i, A[i]);
    }
}
```
### ASSEMBLY MIPS
```asm
???
```
