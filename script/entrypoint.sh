#!/usr/bin/env bash

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