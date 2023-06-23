#!/bin/bash

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Please provide an element as an argument."
    exit 0
fi

# Get the input argument
element=$1

# Check if the input is numeric or a string
re='^[0-9]+$'
if [[ $element =~ $re ]]; then
  # Numeric input
  query="SELECT e.atomic_number, e.name, e.symbol, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type
        FROM elements e
        JOIN properties p ON e.atomic_number = p.atomic_number
        JOIN types t ON p.type_id = t.type_id
        WHERE e.atomic_number = $element;"
else
  # String input
  query="SELECT e.atomic_number, e.name, e.symbol, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius, t.type
        FROM elements e
        JOIN properties p ON e.atomic_number = p.atomic_number
        JOIN types t ON p.type_id = t.type_id
        WHERE e.name = '$element' OR e.symbol = '$element';"
fi

# Connect to the database and execute the SQL query
result=$(psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c "$query")

# Run the argument through the database
if [ -z "$result" ]; then
  echo "I could not find that element in the database."
else
  IFS='|' read -r atomic_number name symbol atomic_mass melting_point_celsius boiling_point_celsius type <<< "$result"
  echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
fi
