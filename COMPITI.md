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
