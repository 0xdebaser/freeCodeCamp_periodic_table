#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align -t -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # if argument is an integer
  RE='^[0-9]+$'
  if [[ $1 =~ $RE ]]
  then
    # check for atomic number
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  fi
  # if no atomic number
  if [[ -z $ATOMIC_NUMBER ]]
  # check for symbol
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number from elements WHERE symbol = '$1'")
  fi
  # if still no atomic number
  if [[ -z $ATOMIC_NUMBER ]]
  # check for name
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number from elements WHERE name = '$1'")
  fi
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi