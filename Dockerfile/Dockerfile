# Base image
FROM python:3.8-slim

LABEL maintainer="Dinesh"

# Define build arguments
ARG AIRFLOW_VERSION=2.5.1
ARG PYTHON_VERSION=3.8
ARG AIRFLOW_HOME=/opt/airflow 

# Set environment variables
ENV AIRFLOW_HOME=${AIRFLOW_HOME}
ENV PATH="${AIRFLOW_HOME}/.local/bin:${PATH}"

# Install dependencies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    wget \
    curl \
    git \
    libssl-dev \
    libffi-dev \
    libpq-dev \
    freetds-bin \
    freetds-dev \
    libkrb5-dev \
    libsasl2-dev \
    build-essential \
    default-libmysqlclient-dev \
    locales \
    rsync \
    zip \
    unzip \
    gcc \
    vim \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Download Airflow constraints file
RUN wget -O /constraints.txt https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt

# Upgrade pip and install Airflow
RUN pip install --upgrade pip && \
    useradd -ms /bin/bash -d ${AIRFLOW_HOME} dinesh && \
    pip install apache-airflow[postgres]==${AIRFLOW_VERSION} --constraint /constraints.txt

# Copy the Airflow commands script
COPY ./airflow_commands.sh ${AIRFLOW_HOME}/airflow_commands.sh

# Set script permissions
RUN chmod +x ${AIRFLOW_HOME}/airflow_commands.sh && \
    chown -R dinesh:dinesh ${AIRFLOW_HOME}

# Switch to dinesh user
USER dinesh

# Set working directory
WORKDIR ${AIRFLOW_HOME}

# Create dags directory
RUN mkdir -p dags

# Expose the Airflow webserver port
EXPOSE 8080

# Execute the airflow_commands.sh
ENTRYPOINT ["/opt/airflow/airflow_commands.sh"]
