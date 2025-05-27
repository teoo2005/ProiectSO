#!/bin/bash

while true; do
    # solicitam numele pentru inregistrare
    echo "Introduceti numele de utilizator pentru inregistrare:"
    read nume

    # Verifica daca utilizatorul exista deja in fisierul utilizatori.csv
    grep -q "^$nume," utilizatori.csv
    if [ $? -eq 0 ]; then
        echo "Eroare: Utilizatorul $nume exista deja. Alegeti alt nume de utilizator."
        continue
    fi

    # Adresa de email
    while true; do
        echo "Introduceti adresa de email:"
        read email

        # Verificam daca email-ul este cu gmail.com la final
        echo "$email" | grep -E -q "@gmail\.com$"
        if [ $? -ne 0 ]; then
            echo "Eroare! Adresa de email trebuie sa fie de tipul @gmail.com."
            continue
        fi

        # Verificam daca email-ul exista deja
        grep -q "^$email," utilizatori.csv
        if [ $? -eq 0 ]; then
            echo "Eroare: Adresa de email $email este deja inregistrata. Va rugam sa alegeti un alt email."
            continue
        fi

        break
    done

    # while pt crearea parolei
    while true; do
        echo "Introduceti parola (minim 8 caractere, cel putin o cifra):"
        read -s parola

        # Confirmarea parolei
        echo "Confirma parola (introduceți din nou parola):"
        read -s parolaConfirmare

        # Verificam daca parolele coincid
        if [ "$parola" != "$parolaConfirmare" ]; then
            echo "Eroare: Parolele nu coincid. Va rugam sa introduceti parola de doua ori la fel."
            continue
        fi

        # Validam complexitatea parolei (minim 8 caractere si cel putin o cifra)
        if [ ${#parola} -lt 8 ] || [[ ! "$parola" =~ [0-9] ]]; then
            echo "Eroare! Parola trebuie sa aiba cel putin 8 caractere si sa contina cel putin o cifra."
            continue
        fi
        break
    done

    # Criptam parola folosind sha256sum
    parolaHash=$(echo -n "$parola" | sha256sum | sed 's/\s.*//')

    # calcul pt ID-ul utilizatorului
    numarLinii=$(wc -l < utilizatori.csv)
    idUtilizator=$((numarLinii + 1))

    # Cream directorul home pentru utilizator, folosind ID-ul
    mkdir -p "/home/$idUtilizator"
    echo "Directorul home pentru utilizatorul $nume a fost creat la /home/$idUtilizator."

    # Adaugam utilizatorul in fisierul utilizatori.csv
    echo "$idUtilizator,$nume,$email,$parolaHash" >> utilizatori.csv
    echo "Utilizatorul $nume a fost adaugat in fisierul utilizatori.csv."

    # Confirmam inregistrarea
    echo "Inregistrarea a fost realizata cu succes!"
    echo "ID : $idUtilizator"
    echo "Nume : $nume"
    echo "Email: $email"
    echo "Parola criptata: $parolaHash"

    # Trimiterea unui email de confirmare
    echo -e "Subject: Salut $nume, contul este gata!\n\nSalutare, $nume!\n\nContul tau a fost creeat cu succes.:)" | msmtp $email
    echo "Email-ul a fost trimis la adresa $email."

    # Daca totul este corect, iesim din bucla while
    break
done

