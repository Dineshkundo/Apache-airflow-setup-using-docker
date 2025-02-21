#!/bin/bash

set -e  # Exit on any error

echo "🚀 Running Airflow Code Quality & Setup Checks..."

# 1️⃣ System Dependencies Check
echo "✅ Checking System Dependencies..."
REQUIRED_PACKAGES=("wget" "curl" "git" "libffi-dev" "libpq-dev" "gcc" "build-essential")
for pkg in "${REQUIRED_PACKAGES[@]}"; do
    if ! dpkg -l | grep -q "$pkg"; then
        echo "❌ Missing: $pkg - Please install it!"
        exit 1
    fi
done
echo "✔ All system dependencies are installed."

# 2️⃣ Python & Virtual Environment Check
echo "✅ Checking Python Version..."
PYTHON_VERSION_REQUIRED="3.8"
PYTHON_VERSION_INSTALLED=$(python3 --version 2>&1 | awk '{print $2}')
if [[ "$PYTHON_VERSION_INSTALLED" != "$PYTHON_VERSION_REQUIRED"* ]]; then
    echo "❌ Python version mismatch! Required: $PYTHON_VERSION_REQUIRED, Found: $PYTHON_VERSION_INSTALLED"
    exit 1
fi
echo "✔ Python version is correct: $PYTHON_VERSION_INSTALLED"

echo "✅ Checking Virtual Environment..."
if [[ -z "$VIRTUAL_ENV" ]]; then
    echo "❌ Virtual environment not activated!"
    exit 1
fi
echo "✔ Virtual environment is active."

# 3️⃣ Airflow Installation Check
echo "✅ Checking Airflow Installation..."
if ! airflow version &> /dev/null; then
    echo "❌ Airflow is not installed correctly!"
    exit 1
fi
echo "✔ Airflow is installed: $(airflow version)"

echo "✅ Checking Required Airflow Packages..."
REQUIRED_AIRFLOW_PACKAGES=("apache-airflow" "flask-session")
for pkg in "${REQUIRED_AIRFLOW_PACKAGES[@]}"; do
    if ! pip list | grep -q "$pkg"; then
        echo "❌ Missing: $pkg - Please install it!"
        exit 1
    fi
done
echo "✔ All Airflow dependencies are installed."

# 4️⃣ Airflow Setup Check
echo "✅ Checking Airflow Database Initialization..."
if [[ ! -f "$AIRFLOW_HOME/airflow.db" ]]; then
    echo "❌ Airflow DB not initialized!"
    exit 1
fi
echo "✔ Airflow database is initialized."

echo "✅ Checking Airflow Webserver & Scheduler..."
if ! pgrep -f "airflow webserver" > /dev/null; then
    echo "❌ Airflow Webserver is NOT running!"
    exit 1
fi
if ! pgrep -f "airflow scheduler" > /dev/null; then
    echo "❌ Airflow Scheduler is NOT running!"
    exit 1
fi
echo "✔ Airflow Webserver & Scheduler are running."

# 5️⃣ DAG Validation Check
echo "✅ Checking Airflow DAGs..."
if ! airflow dags list &> /dev/null; then
    echo "❌ DAGs are not loading properly!"
    exit 1
fi
echo "✔ DAGs loaded successfully."

# 6️⃣ Code Quality Check (Linting)
echo "✅ Running PEP8 (Flake8) Linter..."
if ! pip show flake8 > /dev/null; then
    pip install flake8
fi
flake8 --ignore=E501 --exclude=.venv,.airflowvirtualenv || { echo "❌ Linting failed!"; exit 1; }
echo "✔ Code is PEP8 compliant."

# 7️⃣ Security Check
echo "✅ Running Security Scan (Bandit)..."
if ! pip show bandit > /dev/null; then
    pip install bandit
fi
bandit -r $AIRFLOW_HOME || { echo "❌ Security issues found!"; exit 1; }
echo "✔ No major security issues found."

echo "🎉 All Airflow Quality Checks Passed Successfully!"
