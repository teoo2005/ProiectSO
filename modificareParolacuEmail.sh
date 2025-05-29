#!/bin/bash

echo "Introdu numele ca sa ti schimbi parola"
read nume

# Se face verificarea cu contor, ca la autentificare
contor=$(grep ",$nume," utilizatori.csv)

if [ -z "$contor" ]; then
    echo "Utilizatorul $nume nu exista."
    return
fi

# extragem adresa de email folosind sed
email=$(echo "$contor" | sed 's/^[^,]*,[^,]*,\([^,]*\),.*$/\1/')

# se genereaza un cod de 3 cifre
cod_verificare=$((RANDOM % 900 + 100))  # Generează un număr aleatoriu între 100 și 999

echo -e "Subject: Cod Schimbre Parola \n\nCodul este: $cod_verificare " | msmtp $email

# cod citi de la tastatura
echo "Introduceti codul de verificare de pe email "
read cod_utilizator

# verificaam cele 2 coduri
if [ "$cod_utilizator" != "$cod_verificare" ]; then
    sleep 1 & echo "Codul scris este incorect "
    return
fi

# daca codul este corect se poate schimba parola
echo "Pune ti parola noua:"
read -s parolaNoua

# criptare noua parola
parolaNouaHash=$(echo -n "$parolaNoua" | sha256sum | sed 's/\s.*//')

# dupa ce se face hash-ul , il actualizam in fisier folosind sed
sed -i "s/^\([^,]*,$nume,[^,]*,\)[^,]*/\1$parolaNouaHash/" utilizatori.csv

echo "Parola a fost schimbata,  $nume."

