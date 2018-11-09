#!/usr/bin/env bash

TRY_LOOP="10"

POSTGRES_HOST="postgres"
POSTGRES_PORT="5432"
POSTGRES_USER="airflow"
POSTGRES_PASSWORD="airflow"
POSTGRES_DB="airflow"


: ${AIRFLOW__CORE__FERNET_KEY:=$(python3 ./fernet_key.py)}
: ${AIRFLOW__CORE__EXECUTOR:=${EXECUTOR:-Sequential}Executor}

# set envrionment variables
export \
  AIRFLOW__CORE__FERNET_KEY \
  AIRFLOW__CORE__SQL_ALCHEMY_CONN \
  AIRFLOW__CORE__EXECUTOR


wait_for_port() {
  local name="$1" host="$2" port="$3"
  local j=0
  while ! nc -z "$host" "$port" >/dev/null 2>&1 < /dev/null; do
    j=$((j+1))
    if [ $j -ge $TRY_LOOP ]; then
      echo >&2 "$(date) - $host:$port still not reachable, giving up"
      exit 1
    fi
    echo "$(date) - waiting for $name... $j/$TRY_LOOP"
    sleep 5
  done
}


if [ ${AIRFLOW__CORE__EXECUTOR} != "SequentialExecutor" ]; then
  AIRFLOW__CORE__SQL_ALCHEMY_CONN="postgresql+psycopg2://$POSTGRES_USER:$POSTGRES_PASSWORD@$POSTGRES_HOST:$POSTGRES_PORT/$POSTGRES_DB"
  wait_for_port "Postgres" "$POSTGRES_HOST" "$POSTGRES_PORT"
fi


case "$1" in
  webserver)
    echo "Initializing database..."
    airflow initdb

    exec airflow webserver
    ;;
  worker|scheduler)
    # Wait for the web browser to run initdb.
    sleep 5
    exec airflow "$@"
    ;;
  version)
    exec airflow "$@"
    ;;
  *)
    # Run non-aiflow commands
    exec "$@"
    ;;
esac