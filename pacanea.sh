#!/bin/bash

symbols=("🍒" "🍋" "7" "BAR" "⭐")

echo "Apasa SPACE pentru a roti sloturile, orice alta tasta pentru a iesi."

while true; do
  read -rsn1 key  # citeste o tasta fara a afișa

  if [[ $key != " " ]]; then
    echo -e "\nJoc terminat. Mult noroc data viitoare!"
    break
  fi

  # Genereaza 3 simboluri aleatorii
  slot1=${symbols[$RANDOM % ${#symbols[@]}]}
  slot2=${symbols[$RANDOM % ${#symbols[@]}]}
  slot3=${symbols[$RANDOM % ${#symbols[@]}]}

  # Afisam simbolurile cu delay pentru efect "slot machine"
  echo -n -e "\nRezultat: | "
  echo -n "$slot1 | "
  sleep 0.5
  echo -n "$slot2 | "
  sleep 0.5
  echo "$slot3 |"

  if [[ "$slot1" == "$slot2" && "$slot2" == "$slot3" ]]; then
    echo "Felicitari! Ai castigat!"
  else
    echo "Mai incearca!"
  fi
done
