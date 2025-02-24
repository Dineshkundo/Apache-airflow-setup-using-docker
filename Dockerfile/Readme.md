# Airflow in Docker

This repository provides a setup for running Apache Airflow inside a Docker container.

## Prerequisites

- Docker installed on your system
- Docker Desktop configured for file sharing (for Windows users)

## Setup Instructions

### 1. Build the Docker Image
Run the following command to build the Docker image:
```sh
 docker build -t airflow-docker .
```

### 2. Run the Docker Container
Run the following command to start the Airflow container:
```sh
docker run -it -p 8888:8080 -v C:\Users\dkundo\Desktop\Airflow\dags:/opt/airflow/dags airflow-docker
```

### 3. Access Airflow UI
Once the container is running, you can access the Airflow web UI at:
```
http://localhost:8888
```

### 4. Default User Credentials
The default admin user is created automatically:
- **Username:** dinesh
- **Password:** dinesh

## Folder Structure
```
/
│── airflow_commands.sh    # Script to initialize and start Airflow
│── Dockerfile             # Docker configuration file
│── dags/                  # Directory for DAGs (mounted from host)
```

## Troubleshooting

### DAGs Not Showing in UI?
1. Ensure DAGs are mounted correctly:
   ```sh
   docker exec -it <container_id> ls /opt/airflow/dags
   ```
   If the DAGs are missing, verify your volume mount path.

2. Check for import errors:
   ```sh
   docker exec -it <container_id> airflow dags list-import-errors
   ```
   Ensure DAG IDs are unique.

### Restart Airflow Services
If changes are not reflected, restart Airflow:
```sh
docker restart <container_id>
```

## License
This project is licensed under the MIT License.

---

For any issues, feel free to open an issue in the repository!

