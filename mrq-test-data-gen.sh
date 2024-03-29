#!/bin/bash

source ./env.sh
if [ -z "$API_KEY" ]; then
  echo 'Must provide an API key'
fi

type=""
env=""
qty="1"
uuid=$(uuidgen)

print_help() {
  echo "Usage: $0 [-t type] [-e env] [-q qty] [-k api_key] [-a] [-h]"
  echo
  echo "Options:"
  echo "  -t    Set the type"
  echo "  -a    Run for all types"
  echo "  -e    Set the environment (expr, stg1, prod)"
  echo "  -q    Set the quantity (defaults to 1 if not set)"
  echo "  -k    Set the API key for the customer (must be provided on first run at least)"
  echo "  -h    Print this help message"
  exit 1
}

while getopts "t:e:q:k:ah" opt; do
  case ${opt} in
    a)
      type="all"
      ;;
    t )
      type=$OPTARG
      ;;
    e )
      env=$OPTARG
      ;;
    q )
      echo "Setting quantity to $OPTARG"
      qty=$OPTARG
      ;;
    k)
      echo "Setting API key to $OPTARG"
      echo "export API_KEY=$OPTARG" > env.sh
      ;;
    h )
      print_help
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      exit 1
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      exit 1
      ;;
  esac
done

# shift processed operators
shift $((OPTIND -1))

if [ -z "$type" ]; then
  echo "Type argument was not included. Please include a type (content, session, user, order)."
  exit 1
fi
if [ -z "$env" ]; then
  echo "Environment argument was not included. Please include an environment (expr, stg1, prod)."
  exit 1
fi

# define valid arguments
valid_environments=("expr" "stg1" "prod")
valid_types=("content" "user" "session" "order" "all")

# Function to check if a value is in an array
contains() {
  local value=$1
  shift
  for item; do
    [[ $item == $value ]] && return 0
  done
  return 1
}

# environment argument validation
if ! contains "$env" "${valid_environments[@]}"; then
  echo "Invalid environment: $env. Valid environments are: ${valid_environments[*]}"
  exit 1
fi

# type argument validation
if ! contains "$type" "${valid_types[@]}"; then
  echo "Invalid type: $type. Valid types are: ${valid_types[*]}"
  exit 1
fi

execute_request() {
  local type="$1"

  for (( id=1; id<=qty; id++ ))
  do
    echo "creating $type with id $id"
    sh ./make-request.sh "$env" "$type" "$uuid-$id"
    if [ $? -ne 0 ]; then
      echo "Error: request failed on iteration $id"
      exit 1
    fi
  done

  echo "Successfully created $qty items."
}

# if type is all, run for all types
if [ "$type" == "all" ]; then
  for t in "${valid_types[@]}"; do
    execute_request "$t"
  done
  echo "Successfully created $qty events for all types."
  exit 0
fi

# otherwise, run for the specified type
execute_request "$type"
exit 0