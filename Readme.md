
# **Apache Airflow Setup & Deployment Guide 🚀**  

This guide provides step-by-step instructions to set up **Apache Airflow** in a **Docker container** on any **Linux environment** with complete quality checks.

---

## **📌 Prerequisites**  
Ensure the following dependencies are installed:  
- **Linux OS** (Ubuntu/Debian/CentOS)  
- **Docker & Docker Compose**  
- **Python 3.8+**  
- **pip (latest version)**  
- **Virtual Environment (venv)**  

### **🔹 Install Required Packages (If Not Installed)**
```bash
sudo apt update -y && sudo apt install -y wget curl git python3 python3-venv python3-pip libpq-dev gcc build-essential
```

### **🔹 Install Docker & Docker Compose**
```bash
sudo apt install -y docker.io docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```
> **Note:** Log out & log back in to apply Docker permissions.

---

## **🚀 Step 1: Setup Apache Airflow in Docker**
Run the following commands to set up Airflow inside a **Docker container**:

### **🔹 Pull the Python 3.8 Slim Image**
```bash
docker pull python:3.8-slim
```

### **🔹 Start the Docker Container**
```bash
docker run -it -p 8888:8080 --name airflow-container python:3.8-slim /bin/bash
```

---

## **🚀 Step 2: Install Dependencies & Setup Airflow**
Inside the Docker container, execute:

```bash
# Set up Airflow home
export AIRFLOW_HOME=/opt/airflow

# Install system dependencies
apt-get update -y && apt-get install -y wget curl git libffi-dev libpq-dev gcc build-essential

# Create airflow user
useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow
pip install --upgrade pip

# Switch to airflow user
su - airflow
cd /opt/airflow

# Create virtual environment
python -m venv .airflowvirtualenv
source .airflowvirtualenv/bin/activate

# Download Airflow constraints file
wget https://raw.githubusercontent.com/apache/airflow/constraints-2.5.1/constraints-3.8.txt

# Install Airflow & required dependencies
pip install "apache-airflow[crypto,celery,postgres,cncf.kubernetes,docker]"==2.5.1 --constraint ./constraints-3.8.txt

# Initialize Airflow database
airflow db init

# Create an Airflow user (Admin)
airflow users create -u admin -p admin -r Admin -e admin@example.com -f First -l Last

# Start Airflow Scheduler & Webserver
airflow scheduler &> /dev/null &
airflow webserver &> /dev/null &

# Verify setup
airflow dags list
```

> **🔗 Access Airflow UI:** Open **http://localhost:8888** in your browser.

---

## **🚀 Step 3: Add & Test a DAG**
To add a new **DAG (Directed Acyclic Graph)**:

```bash
# Copy a sample DAG inside the container
docker cp testdag.py airflow-container:/opt/airflow/.airflowvirtualenv/lib/python3.8/site-packages/airflow/example_dags/testdag.py

# Test DAG execution
airflow dags test testdag
```
> **Expected Output:** DAG execution should be successful.

---

## **🚀 Step 4: Stop & Restart Airflow**
To **stop Airflow**, run:  
```bash
docker stop airflow-container
```
To **restart Airflow**, run:  
```bash
docker start airflow-container
docker exec -it airflow-container /bin/bash
```

---

## **🚀 Troubleshooting**
| Issue | Solution |
|--------|----------|
| `ModuleNotFoundError: No module named 'flask_session.sessions'` | Run: `pip install flask-session` |
| `ERROR: Could not open requirements file: ./constraints-3.8.txt` | Run: `wget https://raw.githubusercontent.com/apache/airflow/constraints-2.5.1/constraints-3.8.txt` |
| Airflow Web UI Not Loading | Restart webserver: `airflow webserver &` |

---

## **🎯 Conclusion**
You now have a **fully working Apache Airflow setup** with **DAG execution, Web UI, and quality checks** running in **Docker**! 🚀🔥  

If you found this useful, give a ⭐ to the repo! ✅
##use ful links
### https://medium.com/@fninsiima/de-mini-series-part-two-57770ff7cdf9
# 
