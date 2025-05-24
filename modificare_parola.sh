#!/bin/bash

echo "Introduceti numele pentru schimbarea parolei:"
read username

# Verificam daca utilizatorul exista
linie=$(grep ",$username," utilizatori.csv)

if [ -z "$linie" ]; then
    echo "Utilizatorul $username nu exista."
    exit 1
fi

# Continuam cu schimbarea parolei
echo "Introduceti parola noua:"
read -s parolaNoua

# Criptam parola si extragem hash-ul folosind sed
parolaNouaHash=$(echo -n "$parolaNoua" | sha256sum | sed 's/^\([a-f0-9]\{64\}\).*/\1/')

# Actualizam doar campul parolei in fisierul utilizatori.csv
sed -i "s/^\([^,]*,$username,[^,]*,\)[^,]*/\1$parolaNouaHash/" utilizatori.csv

echo "Parola a fost schimbata cu succes pentru $username."
