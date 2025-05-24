#!/bin/bash

symbols=("CHERRY" "LEMON" "7" "BAR" "STAR")

echo "Apasa ENTER pentru a roti sloturile, scrie orice altceva apoi ENTER pentru a iesi."

while true; do
  read -r input

  if [[ -n "$input" ]]; then
    echo "Joc terminat. Mult noroc data viitoare!"
    break
  fi

  slot1=${symbols[$RANDOM % ${#symbols[@]}]}
  slot2=${symbols[$RANDOM % ${#symbols[@]}]}
  slot3=${symbols[$RANDOM % ${#symbols[@]}]}

  echo "Rezultat: | $slot1 | $slot2 | $slot3 |"

  if [[ "$slot1" == "$slot2" && "$slot2" == "$slot3" ]]; then
    echo "Felicitari! Ai castigat!"
  else
    echo "Mai incearca!"
  fi
done
