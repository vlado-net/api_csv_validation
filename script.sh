#!/bin/bash

# Validate command input
if [[ $# -eq 0 ]] ; then
  echo 'One numeric argument is required.\nExample: "bash script.sh 2"'
  exit 1
elif [[ "$1" -lt 1 ]] ; then
  echo 'The number argument should be greater than "0".\nExample: "bash script.sh 2"'
  exit 1
elif [[ "$1" -gt 10 ]] ; then
  echo 'The number argument should be less than "10".\nExample: "bash script.sh 2"'
  exit 1
fi

# Read the argument
target_id="$1"

# Check jq installed
if ! command -v jq &> /dev/null; then
    echo "Please, install the jq library first (https://jqlang.github.io/jq/)"
    exit 1
fi

validation() {
  # API endpoint call
  target_url="https://jsonplaceholder.typicode.com/comments/$target_id"
  api_response=$(curl -s "$target_url")

  csv_postId=$1
  csv_id=$2
  csv_name=$3
  csv_email=$4
  csv_body=$5

  # Parse the API response into variables to compare
  api_postId=$(printf "%s" "$api_response" | jq -r '.postId')
  api_name=$(printf "%s" "$api_response" | jq -r '.name')
  api_email=$(printf "%s" "$api_response" | jq -r '.email')
  api_body=$(printf "%s" "$api_response" | jq -r '.body')

  # Clean the values from the newline chars (\n)
  comparable_csv_body=$(removeNewLine "${csv_body}")
  comparable_api_body=$(removeNewLine "${api_body}")

  # Validate the API response based on the CSV data
  if [[ "${csv_postId}" != "${api_postId}" ]]; then
    printFail "postId" "$api_postId" "$csv_postId"
  elif [[ "${csv_name}" != "${api_name}" ]]; then
    printFail "name" "$api_name" "$csv_name"
  elif [[ "${csv_email}" != "${api_email}" ]]; then
    printFail "email" "${api_email}" "${csv_email}"
  elif [[ "${comparable_csv_body}" != "${comparable_api_body}" ]]; then
    printFail "body" "$api_body" "$csv_body"
  else
    printGreen "Verification is SUCCESSFUL for the ID=${target_id}."
    printSuccess "postId" "$api_postId" "$csv_postId"
    printSuccess "name" "$api_name" "$csv_name"
    printSuccess "email" "$api_email" "$csv_email"
    printSuccess "body" "$api_body" "$csv_body"
  fi
}

removeNewLine() {
  echo "${$1 //$'\n'/ }"
}

printRed() {
  RED='\033[0;31m'
  NC='\033[0m'
  printf "${RED}$1${NC}\n"
}

printGreen() {
  GREEN='\033[0;32m'
  NC='\033[0m'
  printf "${GREEN}$1${NC}\n"
}

printFail () {
  printRed "Verification FAILED for the ID = ${target_id}."
  echo "The '$1' API response value is: '$2' instead of: '$3' from the CSV source."
}

printSuccess () {
  echo "The '$1' API response value: '$2' equals: '$3' from the CSV source."
}

# Read the CSV file
while IFS=, read -r col1 col2 col3 col4 col5; do
    if [[ "${col2}" == "id" ]]; then
        continue # Skip the header
    fi
    if [[ ${target_id} == "${col2}" ]]; then
      validation "${col1}" "${col2}" "${col3}" "${col4}" "${col5}"
    fi
done < data_source.csv
