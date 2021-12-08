.data



.code

                #CALCOLO LA LUNGHEZZA DELLA STRINGA
#scanf("%s",STR)->SYS3
daddi $t0,r0,STR
sd $t0,ind_sys3(r0)
daddi $14,r0,p1_sys3
syscall 3             #->r1= dimensione stringa
