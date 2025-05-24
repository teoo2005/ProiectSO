#!/bin/bash
# aici nu stiu cat de eficient este , fiindca cand se sterge utiliz.
# ar putea ramane spatiu gol in vector;

echo "Introduceti numele de utilizator pentru logout:"
read nume

# Verificam daca utilizatorul este autentificat in lista utlog
if [[ " ${utlog[@]} " =~ " $nume " ]]; then
    # Eliminam utilizatorul din lista de autentificati
    utlog=("${utlog[@]/$nume}")
    echo "Utilizatorul $nume a fost deconectat."
else
    echo "Utilizatorul $nume nu este autentificat."
fi
