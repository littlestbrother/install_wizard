#!/bin/bash
# v1.0.0

# colors
red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'

runScript() {
  # "i" is equal to the current iterated directory. "elements" is an array filled with all of the directories selected
  for i in $elements; do
    cd $i
    printf "${cyn}$PWD${end}/%s\n"
    # |--------------COMMANDS GO HERE!------------------|

    touch testFile

    # |-------------------------------------------------|
    printf "${grn}success!${end}\n"
    cd ..
  done
}

# --------------------------------------------------------------------------------------------------------------------

requestResponse() {
  # helpful variables
  declare -i numOfItems=-1
  declare -a currentDirecoryList

  # get hidden files also
  # shopt -s dotglob

  for i in *; do
    currentDirecoryList+=($i)
    # get number of items
    ((numOfItems++))
  done

  # loop through currentDirecoryList and print their respective response
  printf "\t${PWD}\n\n"
  printf "\tFILES AND FOLDERS:\n"
  for i in ${!currentDirecoryList[@]}; do
    printf "\t[${i}] ${currentDirecoryList[${i}]}\n"
  done
  printf "\n\tOTHER:\n\t[q] quit\n\t[a] all\n\n"

  # ask user for directories
  printf "\tExample response: 0 2 4 5\n"
  read -p $'\tEnter desired directories: ' response

  # check if user would like to quit
  if [[ " ${response[*]} " == *"q"* ]]; then
    # kill the program
    echo "bye 👋"
    exit
  # ...or check if they would like to select all
  elif [[ " ${response[*]} " == *"a"* ]]; then
    # create an array of numbers 0 - however long
    for i in ${!currentDirecoryList[@]}; do
      userSelectedIndexes+=($i)
    done
  fi

  # check if response only contains numbers, numbers within the expected range, and no negatives!
  if [[ " ${response[*]} " =~ [0-9] ]] && [[ " ${response[*]} " != *"-"* ]]; then
    # convert prompt result (string) into an array [0, 1, 2, 3]
    IFS=' ' read -r -a userSelectedIndexes <<<"$response"
  fi

  clear
  clear

  ## check if list of indexes has anything empty
  if [ -z "$userSelectedIndexes" ]; then
    printf "\tInvalid response! 😬\n\n"
    requestResponse
  fi

  printf "\tSELECTED:\n"
  # loop through user prompt array to show user what they've selected
  for i in "${userSelectedIndexes[@]}"; do
    printf "\t[$i] ${currentDirecoryList[i]}\n"
  done

  declare -a userSelectedDirNames

  # prompt user if their selection is okay
  read -r -p $'\n\tIs this correct? [y/N] ' response
  if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then

    # add to userSelectedDirNames list
    for i in "${userSelectedIndexes[@]}"; do
      userSelectedDirNames+=(${currentDirecoryList[i]})
    done
  else
    clear
    requestResponse
  fi
  clear
  clear

  # rename userSelectedDirNames to element for ease of use when adding custom commands
  elements="${userSelectedDirNames[@]}"
  runScript $elements
}

# start the program off with requestResponse
requestResponse
