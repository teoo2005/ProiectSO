#!/bin/bash

echo "Joc: piatra, foarfeca, hartie"
echo "Alege: piatra, foarfeca sau hartie"
read alegere

PFH=("piatra" "foarfeca" "hartie")
joc=${PFH[$RANDOM % 3]}

echo "Calculatorul a ales: $joc"

if [ "$alegere" == "$joc" ]; then
    echo "EGALTATE!"
    echo ""
elif [[ ( "$alegere" == "piatra" && "$joc" == "foarfeca" ) || \
        ( "$alegere" == "foarfeca" && "$joc" == "hartie" ) || \
        ( "$alegere" == "hartie" && "$joc" == "piatra" ) ]]; then
    echo "BRAVO MA ! Ai castigat!"
    echo ""
elif [[ ( "$alegere" == "piatra" && "$joc" == "hartie" ) || \
        ( "$alegere" == "foarfeca" && "$joc" == "piatra") || \
        ( "$alegere" == "hartie" && "$joc" == "foarfeca") ]]; then
    echo "Calculatorul a castigat!"
    echo ""
fi
