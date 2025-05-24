#!/bin/bash

echo "Introduceti numele pentru schimbarea parolei:"
read nume

#se face iar verificare cu conotr, ca la autentificare
contor=$(grep ",$nume," utilizatori.csv)

if [ -z "$contor" ]; then
    echo "Utilizatorul $nume nu exista."
    exit 1
fi

#daca e ok , se modif parola
echo "Introduceti parola noua:"
read -s parolaNoua

# Criptam parola si extragem hash-ul folosind sed
#parolaNouaHash=$(echo -n "$parolaNoua" | sha256sum | sed 's/^\([a-f0-9]\{64\}\).*/\1/') 
#varianta mai grea dar sigura
parolaNouaHash=$(echo -n "$parolaNoua" | sha256sum | sed 's/\s.*//')


# dupa extragere hash se actuaalizaeaza la campul potrivit noul hash
sed -i "s/^\([^,]*,$nume,[^,]*,\)[^,]*/\1$parolaNouaHash/" utilizatori.csv

echo "Parola a fost schimbata cu succes pentru $nume."
