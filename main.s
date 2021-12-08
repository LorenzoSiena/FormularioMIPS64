CALCOLO LA LUNGHEZZA DELLA STRINGA

.data

????

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
