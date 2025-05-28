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
    sed -i "s/^\([^,]*,$nume,[^,]*,[^,]*\).*/\1,$timp/" utilizatori.csv

    # extragere id-ul utilizatorului
    id=$(echo "$contor" | cut -d',' -f1)

    # Adaugam utilizatorul la lista de utilizatori logati utlog.txt 
    utlog+=("$nume")
    echo "Utilizatorul $nume este acum autentificat si logat."
    
        echo "Autentificare reusita! Esti acum in directorul tau personal: /home/$id"
       cd "/home/$id" || exit 1 # daca nu merge, te scoate in main , inseamna ca o dat eroare
       $SHELL # inlocuieste procesul curent shell cu un nou shell în directorul utilizatorului

       # Loop-ul pentru activitatea utilizatorului in directorul sau personal
    while true; do
        echo -n "Daca vrei sa iesi din directorul personal, scrie 'exit'. Pentru a continua, apasa orice tasta si apasa ENTER: "
        read comanda

        if [ "$comanda" == "exit" ]; then
            echo "Iesire din directorul personal..."
            cd ..
            break  # iei utilizatorul inapoi in meniul principal
        else
            echo "Continua sa lucrezi in directorul tau personal..."
        fi
    done
    
    break  # Iesi din bucla principala si revii in main.sh
done
  
