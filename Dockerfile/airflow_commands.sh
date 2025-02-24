
#!/usr/bin/env bash

# Initiliase the metastore
airflow db init

# Run the scheduler in background
airflow scheduler &> /dev/null &

# Create user
airflow users create -u dinesh -p dinesh -r Admin -e admin@dinesh.com -f Dinesh -l Kundo

# Run the web server in foreground (for docker logs)
exec airflow webserver
