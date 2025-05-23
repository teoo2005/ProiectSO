#!/bin/bash

while true; do
    # Solicitam numele de utilizator pentru autentificare
    echo "Introduceti numele de utilizator pentru autentificare:"
    read nume

    # Cautam utilizatorul in fisierul utilizatori.csv
    contor=$(grep ",$nume," utilizatori.csv)

    # Daca utilizatorul nu este gasit, afisam mesaj si cerem din nou numele
    if [ -z "$contor" ]; then
        echo "Eroare: Utilizatorul $nume nu exista inregistrat. Va rugam sa va inregistrati mai intai."
        echo "Mergeti in meniul principal la inregistrare."
        continue
    fi

    # Extragem parola criptata
    parolaStocata=$(echo "$contor" | sed 's/^[^,]*,[^,]*,[^,]*,\([^,]*\).*$/\1/')

    # Solicitam parola
    echo "Introduceti parola:"
    read -s parolaTastata

    # Criptam parola introdusa
    parolaTastataHash=$(echo -n "$parolaTastata" | sha256sum | sed 's/^\([a-f0-9]\{64\}\)\s.*$/\1/')

    # Verificam daca hash-ul parolei este corect
    if [ "$parolaTastataHash" != "$parolaStocata" ]; then
        echo "Eroare: Parola introdusa nu este corecta. Asigurati-va ca respectati exact parola introdusa la inregistrare."
        continue
    fi

    # Daca parola este corecta, actualizam campul last_login
    timp=$(date '+%Y-%m-%d %H:%M:%S')
    sed -i "s/^$nume,[^,]*,[^,]*,[^,]*$/&,$timp/" utilizatori.csv

    # Extragem id-ul utilizatorului
    id=$(echo "$contor" | cut -d',' -f1)

    echo "Autentificare reusita! Esti acum in directorul tau personal: /home/$id"
    cd "/home/$id"
    
    # Adaugam utilizatorul la lista de utilizatori logati
    utlog+=("$nume")
    echo "Utilizatorul $nume este acum autentificat si logat."
    echo "Scrie 'exit' pentru a iesi din acest director personal."
    echo "Scrie 'raport' pentru a genera raportul."
    echo "Daca folosesti orice alta comanda, trebuie folosit sudo."

    # Mini-shell personalizat cu acceptarea oricaror comenzi
    while true; do
        echo -n "(HOME-$id) $ "
        read -r comanda

        case $comanda in
            "raport")
                # Generare raport pentru utilizatorul curent
                echo "Se genereaza raportul pentru utilizatorul $nume..."
                nrFis=$(find "/home/$id" -type f | wc -l)
                nrDir=$(find "/home/$id" -type d | wc -l)
                dimensiune=$(du -sh "/home/$id" | sed 's/^\([^[:space:]]*\).*/\1/')

                # Creăm raportul
                raport="/home/$id/raport.txt"
                echo "Raport pentru utilizatorul $nume" > "$raport"
                echo "Numar de fisiere: $nrFis" >> "$raport"
                echo "Numar de directoare: $nrDir" >> "$raport"
                echo "Dimensiune totala pe disc: $dimensiune" >> "$raport"
                
                echo "Raportul a fost generat si salvat in: $raport"
                ;;

            "exit")
                echo "Iesire din directorul personal..."
                break
                ;;

            *)
                # Executa orice alta comanda data in mini-shell
                eval "$comanda"
                ;;
        esac
    done

    break
done
