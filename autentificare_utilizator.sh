#!/bin/bash

while true; do
    echo "Introduceti numele de utilizator pentru autentificare:"
    read nume

    # salvam intrun contor sa vedem daca se gaseste numele sau nu 
    contor=$(grep ",$nume," utilizatori.csv)

    # daca contorul e gol , adica nu s a gasit numele , te duce in main 
    if [ -z "$contor" ]; then
        echo "Eroare: Utilizatorul $nume nu exista inregistrat. Va rugam sa va inregistrati mai intai."
        echo "Mergeti in meniul principal la inregistrare."
     break  #break folosim ca sa iasa din script si sa te poti duce inapoi in main 
    fi

    # extragem parola stocata deja , cea cu hash 
    parolaStocata=$(echo "$contor" | sed 's/^[^,]*,[^,]*,[^,]*,\([^,]*\).*$/\1/')
   # ^[^,]*, — de la începutul liniei (^), selectează orice caractere care nu sunt virgule ([^,]*) urmate de o virgulă (de 3 ori).
   #\([^,]*\) — apoi captează (\(...\)) tot ce nu e virgulă, adică al patrulea câmp, care este parola criptată (hash-ul).
   #.*$ — restul liniei (oricare caractere până la sfârșit).
   
    
    # parola autentificare
    echo "Introduceti parola:"
    read -s parolaTastata

    # criptare parola 
    # parolaTastataHash=$(echo -n "$parolaTastata" | sha256sum | sed 's/^\([a-f0-9]\{64\}\)\s.*$/\1/')
    
    parolaTastataHash=$(echo -n "$parolaTastata" | sha256sum | sed 's/\s.*//') # varianta mai simpla 
    
    # Verificam daca hash-ul parolei este corect
    if [ "$parolaTastataHash" != "$parolaStocata" ]; then
        echo "Eroare: Parola introdusa nu este corecta. Trebuie sa fie exact parola inttrodusa la inregistrare ."
        continue
    fi

    # Daca parola este corecta, actualizam campul de last login 
    timp=$(date '+%Y-%m-%d %H:%M:%S')
    sed -i "s/^$nume,[^,]*,[^,]*,[^,]*$/&,$timp/" utilizatori.csv

    # extragere id-ul utilizatorului
    id=$(echo "$contor" | cut -d',' -f1)

    echo "Autentificare reusita! Esti acum in directorul tau personal: /home/$id"
    cd "/home/$id"
    
    # Adaugam utilizatorul la lista de utilizatori logati utlog.txt 
    utlog+=("$nume")
    echo "Utilizatorul $nume este acum autentificat si logat."
    echo "Scrie 'exit' pentru a iesi din acest director personal."
    echo "Scrie 'raport' pentru a genera raportul."
    echo "Daca folosesti orice alta comanda, trebuie folosit sudo."

    # Mini-shell personalizat cu acceptarea oricaror comenzi
    while true; do
        echo -n "(homeMini-$id) $ "
        read -r comanda

        case $comanda in
            "raport")
                # Generare raport pentru utilizatorul curent
                echo "Se genereaza raportul pentru utilizatorul $nume..."
                nrFis=$(find "/home/$id" -type f | wc -l)
                nrDir=$(find "/home/$id" -type d | wc -l)
                dimensiune=$(du -sh "/home/$id" | sed 's/^\([^[:space:]]*\).*/\1/')

                # Creare raport 
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
