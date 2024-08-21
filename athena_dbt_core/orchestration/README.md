# Dagster Orchestration

This directory contains the Dagster project used to orchestrate the dbt pipeline.

## Directory Structure
```
└── 📁orchestration
    └── README.md
    └── 📁source
        └── assets.py
        └── constants.py
        └── definitions.py
        └── schedules.py
    └── dagster.yaml
    └── workspace.yaml
    └── Dockerfile_dagster
    └── Dockerfile_code
    └── docker-compose.yaml
```


### Explanation of Files

- `source/`: Contains Python scripts for the Dagster project.
  - `__init__.py`: Initializes the module.
  - `assets.py`: Defines the dbt models as Dagster assets.
  - `constants.py`: Stores constants such as paths and configuration values.
  - `definitions.py`: Defines the Dagster job, including assets and schedules.
  - `schedules.py`: Defines schedules for running Dagster jobs.
- `workspace.yaml`: Configures the Dagster workspace to include the orchestration code.
- `dagster.yaml`: Configures the Dagster multi-container project


## Local Deployment with Docker Compose

This guide will walk you through deploying the Dagster project locally using Docker Compose. Before you begin, make sure you have AWS credentials configured and the necessary Docker images built.

### Prerequisites

1. **AWS CLI Configuration**: Ensure that you have AWS CLI installed and configured with the correct credentials. Run the following command:
```bash
aws configure
```
Enter your AWS Access Key ID, Secret Access Key, and region as prompted.

2. **Build Docker Images**: Make sure that the Docker images for the Dagster webserver, daemon, and user code have been built. If not, follow the instructions in the `ecs_infra` folder to build and push the images.

### Update Configuration Files

1. **Update `dagster.yaml`**: By default, the project is configured to use the ECS Run Launcher. For local deployment, you need to switch to the Docker Run Launcher. To do this:

   - Open the `dagster.yaml` file.
   - Comment out the ECS Run Launcher configuration.
   - Uncomment the Docker Run Launcher configuration:
```yaml
run_launcher:
  module: dagster_docker
  class: DockerRunLauncher
  config:
    env_vars:
      - DB_USERNAME
      - DB_PASSWORD
      - DB_NAME
      - DB_PORT
      - DB_HOST
    network: docker_network
    container_kwargs:
      volumes: # Make docker client accessible to any launched containers as well
        - /var/run/docker.sock:/var/run/docker.sock
        - /tmp/io_manager_storage:/tmp/io_manager_storage
        - /root/.aws:/root/.aws
```
2. **Update `workspace.yaml`**: By default, the project is configured to use ECS service discovery. For local deployment, you need to update the host configuration for the user code:
```yaml
load_from:
  - grpc_server:
      host: "dagster_user_code"
      port: 4000
      location_name: "user_code_location"
```

### Running the Project Locally

1. **Start Docker Compose** : With the configuration files updated, you can now start the project locally using Docker Compose. Navigate to the `orchestration` directory and run the following command:
```bash
docker-compose up
```
This will start all the necessary services, including the Dagster webserver, daemon, and user code containers.

2. **Access Dagster Webserver** : Once the containers are running, you can access the Dagster webserver in your browser at:
```
http://localhost:3000
```

### Stopping the Project

To stop the Docker Compose services, run:
```bash
docker-compose down
```

This will stop and remove all the containers.