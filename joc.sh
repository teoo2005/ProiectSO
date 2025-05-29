
#!/bin/bash

simboluri=("PRUNE" "LAMAI" "7" "BAR" "STAR")

echo "Apasa ENTER pentru a roti "

while true; do
  read -r tasta
  if [[ -n "$tasta" ]]; then
    echo "Mai mult noroc data viitoare"
    break
  fi

  slot1=${simboluri[$RANDOM % ${#simboluri[@]}]}
  slot2=${simboluri[$RANDOM % ${#simboluri[@]}]}
  slot3=${simboluri[$RANDOM % ${#simboluri[@]}]}

  echo "--- | $slot1 | $slot2 | $slot3 | ---"

  if [[ "$slot1" == "$slot2" && "$slot2" == "$slot3" ]]; then
    echo "Bravo sefule ! Ai castigat!"
  else
    echo "Mai incearca !"
  fi
done
