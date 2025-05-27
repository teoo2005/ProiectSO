#!/bin/bash

echo "Introduceti numele utilizatorului pentru raport:"
read nume

# Cautam linia utilizatorului in fisier
linie=$(grep ",$nume," utilizatori.csv)

if [ -z "$linie" ]; then
    echo "Eroare: Utilizatorul $nume nu exista inregistrat. Va rugam sa va inregistrati mai intai."
    echo "Va intoarceti in meniul principal."
    exit 0
fi

# Extragem id-ul utilizatorului folosind sed (primul camp pana la prima virgula)
id=$(echo "$linie" | sed 's/,.*//')

# Generam raportul asincron (in fundal)
{
    echo "Se genereaza raportul pentru utilizatorul $nume..."
    nrFis=$(find "/home/$id" -type f | wc -l)
    nrDir=$(find "/home/$id" -type d | wc -l)
    dimensiune=$(du -sh "/home/$id" | sed 's/\s.*//')

    raport="/home/$id/raport.txt"
    echo "Raport pentru utilizatorul $nume" > "$raport"
    echo "Numar de fisiere: $nrFis" >> "$raport"
    echo "Numar de directoare: $nrDir" >> "$raport"
    echo "Dimensiune totala pe disc: $dimensiune" >> "$raport"

    echo "Raportul a fost generat si salvat in: $raport"
} &

echo "Generarea raportului a pornit in fundal. Puteti continua folosirea programului."

