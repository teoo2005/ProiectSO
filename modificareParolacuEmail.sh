#!/bin/bash

echo "Introdu numele ca sa ti schimbi parola"
read nume

# Se face verificarea cu contor, ca la autentificare
contor=$(grep ",$nume," utilizatori.csv)

if [ -z "$contor" ]; then
    echo "Utilizatorul $nume nu exista."
    return
fi

# Extragem adresa de email din fisierul utilizatori.csv folosind sed
email=$(echo "$contor" | sed 's/^[^,]*,[^,]*,\([^,]*\),.*$/\1/')

# Generăm un cod de verificare simplu de 3 cifre, între 100 și 999
cod_verificare=$((RANDOM % 900 + 100))  # Generează un număr aleatoriu între 100 și 999

# Trimiterea unui email cu codul de verificare folosind msmtp
echo -e "Subject: Cod Schimbre Parola \n\nCodul este: $cod_verificare " | msmtp $email


# Solicităm codul de verificare de la utilizator
echo "Introduceti codul de verificare de pe email:"
read cod_utilizator

# Verificăm dacă codul introdus de utilizator este corect
if [ "$cod_utilizator" != "$cod_verificare" ]; then
    sleep 1 & echo "Codul este incorect. "
    return
fi

# Daca codul este corect, se poate schimba parola
echo "Pune ti parola noua:"
read -s parolaNoua

# Criptam parola si extragem hash-ul folosind sha256sum
parolaNouaHash=$(echo -n "$parolaNoua" | sha256sum | sed 's/\s.*//')

# Dupa extragerea hash-ului, se actualizează câmpul corespunzător în fișierul utilizatori.csv folosind sed
sed -i "s/^\([^,]*,$nume,[^,]*,\)[^,]*/\1$parolaNouaHash/" utilizatori.csv

echo "Parola a fost schimbata,  $nume."

