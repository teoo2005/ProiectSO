#!/bin/bash

echo "Introduceti numele de utilizator pentru logout:"
read username

# Verificam daca utilizatorul este autentificat in lista utlog
if [[ " ${utlog[@]} " =~ " $username " ]]; then
    # Eliminam utilizatorul din lista de autentificati
    utlog=("${utlog[@]/$username}")
    echo "Utilizatorul $username a fost deconectat."
else
    echo "Utilizatorul $username nu este autentificat."
fi
