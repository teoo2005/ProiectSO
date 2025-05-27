#!/bin/bash
declare -a utlog=() # ca sa fie vizibil in autentificare si delogare 


while true; do
    echo -e "\nMeniu:"
    echo "Tasta 1 ->> Inregistrare"
    echo "Tasta 2 ->> Autentificare"
    echo "Tasta 3 ->> Iesire din contr"
    echo "Tasta 4 ->> Schimbare parola"
    echo "Tasta 5 ->> Iesire din program "
    echo "Tasta 6 ->> Joc "
    echo "Tasta 7 ->> Pacanea Jimmy "
    echo " TAsta 8 ->> Verificare utlog"
    echo "Alegeți o opțiune:"
    read option

    case $option in
        1)
            source inregistrare_utilizator.sh  # Apelăm scriptul de înregistrare
            ;;
        2)
            source ./autentificare_utilizator.sh  # Apelăm scriptul de autentificare
            ;;
        3)
            source logout.sh  # Apelăm scriptul de logout
            ;;
        4)
            source modificare_parola.sh  # Apelăm scriptul de modificare a parolei
            ;;
        5)
            echo "Ieșire din program."
            break
            ;;
        6) 
            source joc.sh
            ;;
        7) 
            source pacanea.sh
            ;;
            8)
            echo "Utilizatori logati: "
            echo "${utlog[@]}"
        *)
            echo "Opțiune invalidă. Vă rugăm să selectați din nou."
            ;;
    esac
done
