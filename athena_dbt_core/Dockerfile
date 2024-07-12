# Dockerfile for Dagster and DBT

FROM python:3.10-slim

RUN mkdir -p /opt/dagster/dagster_home /opt/dagster/app

# Copy the requirements.txt file into the image
COPY requirements.txt .

# Install the Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy your Dagster project code and workspace to /opt/dagster/app
COPY . /opt/dagster/app/

# Set Dagster home
ENV DAGSTER_HOME=/opt/dagster/dagster_home/
ENV PYTHONPATH=/opt/dagster/app/orchestration


# Copy Dagster instance YAML to $DAGSTER_HOME
COPY orchestration/dagster.yaml /opt/dagster/dagster_home/

# Create necessary directories for local storage
RUN mkdir -p /opt/dagster/local/artifacts /opt/dagster/local/compute_logs /opt/dagster/local/runs /opt/dagster/local/event_logs /opt/dagster/local/schedules

WORKDIR /opt/dagster/app

EXPOSE 3000

ENTRYPOINT ["dagster-webserver", "-h", "0.0.0.0", "-p", "3000", "-w", "orchestration/workspace.yaml"]
