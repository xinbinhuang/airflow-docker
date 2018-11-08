#!/usr/bin/env bash

POSTGRES_HOST="postgres"
POSTGRES_PORT="5432"
POSTGRES_USER="airflow"
POSTGRES_PASSWORD="airflow"
POSTGRES_DB="airflow"

AIRFLOW__CORE__SQL_ALCHEMY_CONNECTION="postgresql+psycopg2://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}"

# Generate Fernet key
if [ -z $FERNET_KEY ]; then
    FERNET_KEY=$(python3 -c "from cryptography.fernet import Fernet; FERNET_KEY = Fernet.generate_key().decode(); print(FERNET_KEY)")
fi

sed -i "s/{{ FERNET_KEY }}/${FERNET_KEY}/" ${AIRFLOW_HOME}/airflow.cfg

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