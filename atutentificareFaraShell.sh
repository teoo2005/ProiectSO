#!/bin/bash

while true; do
    echo "Scrie numele de utilizator pentru autentificare:"
    read nume

    # salvam intrun contor sa vedem daca se gaseste numele sau nu
    contor=$(grep ",$nume," utilizatori.csv)

    # daca contorul e gol , adica nu s a gasit numele , te duce in main
    if [ -z "$contor" ]; then
        echo "EROARE! Utilizatorul $nume nu exista. Inregistreaza te mai intai."
        echo "Mergi in meniu la sectia de inregistrare."
     break  #break folosim ca sa iasa din script si sa te poti duce inapoi in main
    fi

    # extragem parola stocata deja , cea cu hash
    parolaStocata=$(echo "$contor" | sed 's/^[^,]*,[^,]*,[^,]*,\([^,]*\).*$/\1/')
   # ^[^,]*, — de la începutul liniei (^), selectează orice caractere care nu sunt virgule ([^,]*) urmate de o virgulă (de 3 ori).
   #\([^,]*\) — apoi captează (\(...\)) tot ce nu e virgulă, adică al patrulea câmp, care este parola criptată (hash-ul).
   #.*$ — restul liniei (oricare caractere până la sfârșit).


    # parola autentificare
    echo "Scrie parola:"
    read -s parolaTastata

    # criptare parola
    parolaTastataHash=$(echo -n "$parolaTastata" | sha256sum | sed 's/\s.*//') # varianta mai simpla

    # verificare daca hash ul parolei este corect
    if [ "$parolaTastataHash" != "$parolaStocata" ]; then
        echo "EROARE! Parola nu este corecta. Trebuie sa fie exact parola inttrodusa la inregistrare ."
        continue
    fi

    # daca parola este corecta, actualizam campul de last login
    timp=$(date '+%Y-%m-%d %H:%M:%S')
    sed -i "s/^\([^,]*,$nume,[^,]*,[^,]*\).*/\1,$timp/" utilizatori.csv

    # extragere id-ul utilizatorului
   id=$(echo "$contor" | sed  's/^\([^,]*\),.*$/\1/') #id=$(echo "$contor" | sed 's/,.*//')

#verificare daca exista utilizator logat deja 
if [[ " ${utlog[@]} " =~ " $nume " ]]; then
    echo "Utilizatorul $nume exista deja in utlog "
else
    utlog+=("$nume")
    echo "Utilizatorul $nume este acum logat in utlog ."
fi

    echo "Acum esti autenfificat"

        echo "Autentificare reusita! Esti acum in directorul tau : /home/$id"
       cd "/home/$id"   
       $SHELL # inlocuieste procesul curent shell cu un nou shell în directorul utilizatorului

       # while folosit ca sa poti iesi din directorul tau
    while true; do
        echo -n "Daca vrei sa iesi din director, scrie 'iesire'. Pentru a continua, apasa orice tasta si apasa ENTER: "
        read comanda

        if [ "$comanda" == "iesire" ]; then
            cd /mnt/c/Users/teodo # aici asa am eu directorul, voi va puneti unde il rulati voi, special pt fiecare
                                  #pt putty  cd /home/stud1018
            break  # iei utilizatorul inapoi in meniul principal
        else
            echo "Continua sa lucrezi in directorul tau personal"
        fi
    done

    break  
done
