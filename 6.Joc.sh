#!/bin/bash

echo "Joc: piatra, foarfeca, hartie"
echo "Alege: piatra, foarfeca sau hartie"
read alegere

PFH=("piatra" "foarfeca" "hartie")
joc=${PFH[$RANDOM % 3]}

echo "Calculatorul a ales: $joc"

if [ "$alegere" == "$joc" ]; then
    echo "Egalitate!"
elif [[ ( "$alegere" == "piatra" && "$joc" == "foarfeca" ) || \
        ( "$alegere" == "foarfeca" && "$joc" == "hartie" ) || \
        ( "$alegere" == "hartie" && "$joc" == "piatra" ) ]]; then
    echo "Ai castigat!"
else
    echo "Calculatorul a castigat!"
fi
