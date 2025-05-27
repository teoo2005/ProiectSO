#!/bin/bash

echo "Introduceti numele de utilizator pentru autentificare:"
read nume

contor=$(grep ",$nume," utilizatori.csv)

if [ -z "$contor" ]; then
  echo "Utilizatorul $nume nu exista inregistrat."
  return  # daca e rulat cu source, revine in main fara iesire de proces
fi

parolaStocata=$(echo "$contor" | sed 's/^[^,]*,[^,]*,[^,]*,\([^,]*\).*$/\1/')
echo "Introduceti parola:"
read -s parolaTastata

parolaTastataHash=$(echo -n "$parolaTastata" | sha256sum | sed 's/\s.*//')

if [ "$parolaTastataHash" != "$parolaStocata" ]; then
  echo "Parola introdusa nu este corecta."
  return
fi

id=$(echo "$contor" | cut -d',' -f1)

echo "Autentificare reusita! Te afli acum in directorul tau personal: /home/$id"
cd "/home/$id"
utlog+=("$nume")
echo "Utilizatorul $nume este autentificat."

# aici NU mai face alt shell, doar revii in main
