#!/bin/bash

if [ ! -f utilizatori.csv ]; then
    touch utilizatori.csv  
    fi
    
while true; do
    # solicitam numele pentru inregistrare
    echo "Introduceti numele de utilizator pentru inregistrare:"
    read nume

    # verificam daca este utilizator existent cu acest nume
    grep -q ",$nume," utilizatori.csv            #  0 daca a gasit  
    if [ $? -eq 0 ]; then                        
        echo "EROARE! Utilizatorul $nume exista deja. Alegeti alt nume ."
        continue
    fi

    # while care face adresa de mail adresa de email
    while true; do
        echo "Introduceti adresa de email: "
        read email

        # verificam daca email-ul este cu gmail.com la final
        echo "$email" | grep -E -q "@gmail\.com$"    
        if [ $? -ne 0 ]; then
            echo "EROARE! Adresa de email trebuie sa fie de tipul @gmail.com. "
            continue
        fi

        # verificam daca email-ul exista deja
        grep -q ",$email," utilizatori.csv
        if [ $? -eq 0 ]; then
            echo "EROARE! Adresa de email $email este deja inregistrata. Alegeti un alt email."
            continue
        fi
        break
    done

    # while pt crearea parolei
    while true; do
        echo "Introdu parola (minim 8 caractere, cel putin o cifra):"
        read -s parola

        echo "Confirma parola :"
        read -s parolaConfirmare

        # verificare daca sunt la fel
        if [ "$parola" != "$parolaConfirmare" ]; then
            echo "EROARE! Parolele nu coincid. Va rugam sa introduceti parola de doua ori la fel "
            continue
        fi

        # se verifica orin if daca parola e de min 8 caract si cel putin o cifra
        if [ ${#parola} -lt 8 ] || [[ ! "$parola" =~ [0-9] ]]; then
            echo "EROARE! Parola trebuie sa aiba cel putin 8 caractere si sa contina cel putin o cifra."
            continue
        fi
        break
    done

    parolaHash=$(echo -n "$parola" | sha256sum | sed 's/\s.*//')

    # calcul pt  id utiliz
    numarLinii=$(wc -l < utilizatori.csv)   
    idUtilizator=$((numarLinii + 1))         # adaugam 1 pentru a obtine ID-ul , fiindca se incepe de la 0 

    # creem directorul home pentru utilizator 
    mkdir -p "/home/$idUtilizator" # -p face sa se creeze automat chiar daca nu ar exista directorul home , facand sa fie comanda mai puternica
    echo "Directorul home pentru utilizatorul $nume a fost creat la /home/$idUtilizator."

    echo "$idUtilizator,$nume,$email,$parolaHash" >> utilizatori.csv
    echo "Utilizatorul $nume a fost adaugat in fisierul utilizatori.csv."

    echo "Inregistrarea a fost realizata cu succes!"
    echo "ID : $idUtilizator"
    echo "Nume : $nume"
    echo "Email: $email"
    echo "Parola criptata: $parolaHash"

    # comanda msmtp pt mail de confirmare
    echo -e "Subject: Salut $nume, contul este gata!\n\nSalutare, $nume!\n\nContul tau a fost creeat cu succes :)" | msmtp $email
    echo "Email-ul a fost trimis la adresa $email."  | cowsay

    # cd "/home/$idUtilizator" -- trb eliminate 
    # echo "Esti acum in directorul tau personal. Poti incepe sa lucrezi aici."

    break
done
