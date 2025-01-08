#!/bin/bash

# Load the dictionary of 5-letter words
if [[ ! -f /usr/share/dict/words ]]; then
  echo "Error: 'words' file required."
  exit 1
fi

# Convert all words to lowercase
WORD_FILE="/usr/share/dict/words"
possible_words=($(awk 'length($0) == 5 && /[a-zA-Z]*/ { print tolower($0) }' $WORD_FILE | grep -v "'"))

# Initialize known constraints
known_correct=("_" "_" "_" "_" "_") # Correctly placed letters
known_present=()                   # Letters present but misplaced
excluded_letters=()                # Letters not in the word

# Function to filter possible words based on rules
filter_words() {
  local filtered=()
  for word in "${possible_words[@]}"; do
    local valid=true
    
    # Check for correctly placed letters
    for i in {0..4}; do
      if [[ "${known_correct[$i]}" != "_" && "${word:$i:1}" != "${known_correct[$i]}" ]]; then
        valid=false
        break
      fi
    done

    # Check for misplaced letters
    for entry in "${known_present[@]}"; do
      letter="${entry:0:1}"
      position="${entry:1:1}"
      if [[ "${word:$position:1}" == "$letter" || "$word" != *"$letter"* ]]; then
        valid=false
        break
      fi
    done

    # Check for excluded letters
    for (( i=0; i<${#excluded_letters}; i++ )); do
      letter="${excluded_letters:i:1}"
      if [[ "$word" == *"$letter"* ]]; then
        valid=false
        break
      fi
    done

    # If valid, add to the filtered list
    if $valid; then
      filtered+=("$word")
    fi
  done
  possible_words=("${filtered[@]}")
}

# Main loop
while true; do
  if [[ ${#possible_words[@]} -eq 0 ]]; then
    echo "No possible words remain. Please check your feedback."
    exit 1
  fi

  # Suggest a random word
  suggestion="${possible_words[RANDOM % ${#possible_words[@]}]}"
  echo "Suggestion: $suggestion"

  # Get feedback
  read -p "Feedback (*=correct, +=present, -=absent, #=new suggestion): " feedback

  if [[ "$feedback" == "#" ]]; then
    continue
  fi

  if [[ "${#feedback}" -ne 5 ]]; then
    echo "Invalid feedback. Please provide exactly 5 characters."
    continue
  fi

  # Process feedback
  candidates_to_exclude=()
  for i in {0..4}; do
    letter="${suggestion:$i:1}"
    case "${feedback:$i:1}" in
      "*")
        known_correct[$i]="$letter"
        ;;
      "+")
        known_present+=("$letter$i")
        ;;
      "-")
        candidates_to_exclude="$candidates_to_exclude$letter"
        ;;
      *)
        echo "Invalid feedback character: ${feedback:$i:1}"
        ;;
    esac
  done

  for (( i=0; i<${#candidates_to_exclude}; i++ )); do
    char="${candidates_to_exclude:i:1}"
    if [[ "${known_correct[@]}" != *"$char"* && "$known_present" != *"$char"* ]]; then
      excluded_letters+="$char"
    fi
  done
  # Filter the list of possible words
  filter_words
done

