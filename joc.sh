#!/bin/bash

echo "Joc: piatra, foarfeca, hartie"
echo "Alege: piatra, foarfeca sau hartie"
read alegere

# vector de optiuni
PFH=("piatra" "foarfeca" "hartie")

# joc- adica ce alege calculatorul cu functia random
joc=${PFH[$RANDOM % 3]}

echo "Calculatorul a ales: $joc"

# facem o serie de if uri sa abordam taote cazurile
if [ "$alegere" == "$joc" ]; then
    echo "EGALTATE!"
elif [ "$alegere" == "piatra" ]; then
    if [ "$joc" == "foarfeca" ]; then
        echo "BRAVO MA ! Ai castigat!"
    else
        echo "Calculatorul a castigat!"
    fi
elif [ "$alegere" == "foarfeca" ]; then
    if [ "$joc" == "hartie" ]; then
        echo "BRAVO MA ! Ai castigat!"
    else
        echo "Calculatorul a castigat!"
    fi
elif [ "$alegere" == "hartie" ]; then
    if [ "$joc" == "piatra" ]; then
        echo "BRAVO MA ! Ai castigat!"
    else
        echo "Calculatorul a castigat!"
    fi
fi
