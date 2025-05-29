#!/bin/bash

echo "Numele utilizator pentru raport:"
read nume

linie=$(grep ",$nume," utilizatori.csv)

if [ -z "$linie" ]; then
    echo "Eroare: Utilizatorul $nume nu este inregistrat.Inregistrati va mai intai."
    exit 0
fi

# extragem id-ul  folosind sed , primul camp pana la prima virgula
id=$(echo "$linie" | sed 's/,.*//')

# raportul asincron (in fundal cum e pe gitbook )
{
    echo "Se genereaza raportul pentru utilizatorul $nume "
    nrFis=$(find "/home/$id" -type f | wc -l) # pt putty ./$id
    nrDir=$(find "/home/$id" -type d | wc -l)
    dimensiune=$(du -sh "/home/$id" | sed 's/\s.*//')

    raport="/home/$id/raport.txt"             # pt putty ./$id
    echo "Raport pentru utilizatorul $nume" > "$raport"
    echo "Numar de fisiere este de $nrFis" >> "$raport"
    echo "Numar de directoare este de $nrDir" >> "$raport"
    echo "Dimensiune totala pe disc este de $dimensiune" >> "$raport"

    
} &
echo "S-a  generat  raportull in: $raport"


