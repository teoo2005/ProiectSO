#!/bin/bash

echo "Introduceti numele de utilizator pentru schimbarea parolei:"
read username

# Verificam daca utilizatorul exista
user_line=$(grep "^$username," utilizatori.csv)

if [ -z "$user_line" ]; then
    echo "Utilizatorul $username nu exista."
    exit 1
fi

# Continuam cu schimbarea parolei
echo "Introduceti parola noua:"
read -s parolaNoua

# Criptam parola si extragem hash-ul folosind sed
parolaNouaHash=$(echo -n "$parolaNoua" | sha256sum | sed 's/^\([a-f0-9]\{64\}\).*/\1/')

# Actualizam fisierul utilizatori.csv cu noua parola
sed -i "s/^$username,[^,]*,[^,]*,[^,]*$/$username,$parolaNouaHash/" utilizatori.csv
echo "Parola a fost schimbata cu succes pentru $username."
