#!/bin/bash
declare -a utlog=() # ca sa fie vizibil in autentificare si delogare 


while true; do
    echo -e "\nMeniu:"
    echo "Tasta 1 ->> Inregistrare"
    echo "Tasta 2 ->> Autentificare"
    echo "Tasta 3 ->> Iesire din cont"
    echo "Tasta 4 ->> Schimbare parola"
    echo "Tasta 5 ->> Verificare utlog"
    echo "Tasta 6 ->> Joc  "
    echo "Tasta 7 ->> Generare raport utilz "
    echo "Tasta 8 ->> Iesire din program "
    echo "Alegeți o opțiune:"
    read option

    case $option in
        1)
            source inregistrare_utilizator.sh  
            ;;
        2)
            source ./autentificare_utilizator.sh  
            ;;
        3)
            source logout.sh  
            ;;
        4)
            source modificare_parola.sh  
            ;;
        5)
            echo "Utilizatori logati: "
            echo "${utlog[@]}"
            ;;
            
        6) 
            source joc.sh
            ;;
        7) 
            source raport.sh
            ;;
            8)
            echo "Ieșire din program."
            break
            ;;
        *)
            echo "Incearca o optiune valida "
            ;;
    esac
done
