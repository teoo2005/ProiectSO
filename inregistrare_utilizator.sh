#!/bin/bash

while true; do
    # solicitam numele pentru inregistrare
    echo "Introduceti numele de utilizator pentru inregistrare:"
    read nume

    # Verifica daca utilizatorul exista deja in fisierul utilizatori.csv
    grep -q ",$nume," utilizatori.csv            # -q doar returneaza 0 daca a gasit  sau 1 
    if [ $? -eq 0 ]; then                        # $?-variabila care stocheaza rezultatul lui grep
        echo " Utilizatorul $nume EXISTA deja. Alegeti alt nume de utilizator."
        continue
    fi

    # while care face adresa de mail adresa de email
    while true; do
        echo "Introduceti adresa de email: "
        read email

        # verificam daca email-ul este cu gmail.com la final
        echo "$email" | grep -E -q "@gmail\.com$"    # -E e folosit ca sa trateze toate expresiile regulate, iar $ ca sa arate sfarsitul sirului
        if [ $? -ne 0 ]; then
            echo "Eroare! Adresa de email trebuie sa fie de tipul @gmail.com. "
            continue
        fi

        # verificam daca email-ul exista deja
        grep -q ",$email," utilizatori.csv
        if [ $? -eq 0 ]; then
            echo "Eroare: Adresa de email $email este deja inregistrata. Va rugam sa alegeti un alt email."
            continue
        fi

        # validam adresa de email folosind regex
        # echo "$email" | grep -E -q "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$"
        #  if [ $? -ne 0 ]; then
        #    echo "Eroare: Adresa de email introdusa nu este valida. Va rugam sa introduceti un email valid (ex: exemplu@domeniu.com)."
        #     continue
        #  fi
        break
    done

    # while pt crearea parolei
    while true; do
        echo "Introduceti parola (minim 8 caractere, cel putin o cifra):"
        read -s parola # acel s nu afiseaza caracterele pe  ecran 

        # aici parola trebuie sa aiba mai mult de 8 caract si sa aiba si o cifra 
        if [ ${#parola} -lt 8 ] || [[ ! "$parola" =~ [0-9] ]]; then
            echo "Eroare! Parola trebuie sa aiba CEL PUTIN 8 caractere si sa contina CEL PUTIN o cifra."
            continue
        fi
        break
    done

    # criptarea parolei folosind sha256sum
    parolaHash=$(echo -n "$parola" | sha256sum | sed 's/\s.*//')
    #      s/ este o comanda de substituie a cuvantului; \s este caracter de spatiu
    #     .* — înseamnă „orice caracter (.) repetat de zero 
    #       sau mai multe ori (*)”, adică tot ce urmează după primul spațiu.
    #      // — înlocuiește tot ce s-a găsit cu nimic (șterge).

    # calcul pt  ID-ul utilizatorului
    numarLinii=$(wc -l < utilizatori.csv)   # numarul de linii din fisier
    idUtilizator=$((numarLinii + 1))         # adaugam 1 la nr de linii ca sa fie utilizatorul curent si ca sa nu inceapa utilizatorii d la 0 

    # aici se creaza directorul home al utiliz. folosind de id 
    mkdir -p "/home/$idUtilizator" # -p face sa se creeze automat chiar daca nu ar exista directorul home , facand sa fie comanda mai puternica
    echo "Directorul home pentru utilizatorul $nume a fost creat la /home/$idUtilizator."

    # se salveaza utilizatorul si toate datele lui in utilizatori.csv
    echo "$idUtilizator,$nume,$email,$parolaHash" >> utilizatori.csv
    echo "Utilizatorul $nume a fost adaugat in fisierul utilizatori.csv."

    # Confirmam inregistrarea
    echo "Inregistrarea a fost realizata cu succes!"
    echo "ID : $idUtilizator"
    echo "Nume : $nume"
    echo "Email: $email"
    echo "Parola criptata: $parolaHash"

    # Trimiterea unui email de confirmare
    echo -e "Subject: Salut $nume, contul este gata!\n\nBuna $nume\n\nContul tau a fost creeat cu succes " | msmtp $email
    # -e in echo ii spune sa interpreze corect \n pt linie noua sau \n\n ca sa faca o linie in plus de spatiu pt lizibilitate

    echo "Email-ul a fost trimis la adresa scrisa ." | cowsay

    # daca totul e corect, break inchide programul si ne aduce in main.sh
    break
done
