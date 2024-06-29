#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
  CHECK_ELEMENT=$($PSQL "SELECT * FROM elements WHERE symbol = '$1' or name = '$1'")
  else
  CHECK_ELEMENT=$($PSQL "SELECT * FROM elements WHERE atomic_number = $1")
  fi
  if [[ -z $CHECK_ELEMENT ]]
  then
    echo "I could not find that element in the database."
      else
      echo "$CHECK_ELEMENT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME
        do
        RESULT=$($PSQL "SELECT type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties FULL JOIN types USING (type_id) WHERE atomic_number = $ATOMIC_NUMBER")
        echo "$RESULT" | while read TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
        do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        done
      done
    fi
  
else
echo -e "Please provide an element as an argument."
fi
