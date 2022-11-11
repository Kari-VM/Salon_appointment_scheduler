#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ KARISHMA'S SALON ~~~~~\n"

SERVICE_MENU() {
  if [[ $1 ]]
  then
   echo -e "\n$1"
  fi 

  echo -e "\nWelcome to Karishma's Salon. What would you like today?"
  
  # get available service from database
  AVAILABLE_SERVICE=$($PSQL "SELECT * FROM services")

  echo "$AVAILABLE_SERVICE" | while read SERVICE_ID BAR NAME
  do
   echo "$SERVICE_ID) $NAME"
  done 

  read SERVICE_ID_SELECTED

  # if service_id doesn't exist
  if [[ $SERVICE_ID_SELECTED != [0-6] ]]
  then
   # send to service_menu
   SERVICE_MENU "That service does not exist. Please enter a valid option."
   else
    # if service_id exists, ask phone number
    echo -e "\nWhat is your phone number?"
    read CUSTOMER_PHONE
    
    # get customer name from database
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

    # if customer doesn't exist
     if [[ -z $CUSTOMER_NAME ]]
     then
      
      # get new customer name
      echo -e "\nThere is no record for that phone number, what is your name?"
      read CUSTOMER_NAME

      # insert new customer to database
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
      
      # get service_name from database
      SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

      # ask service time
      echo -e "\nWhat time would you like to have your$SERVICE_NAME, $CUSTOMER_NAME?"
      read SERVICE_TIME

      # get customer_id from database
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

      # insert appointment result
      INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
      
      # output message
      echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

      else
      # get service_name from database
      SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

      # ask service time
      echo -e "\nWhat time would you like to have your$SERVICE_NAME, $CUSTOMER_NAME?"
      read SERVICE_TIME

      # get customer_id from database
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

      # insert appointment result
      INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
      
      # output message
      echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
     fi
  fi 
}

SERVICE_MENU

