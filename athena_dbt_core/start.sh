#!/bin/bash

# Start the Dagster Webserver
dagster-webserver -h 0.0.0.0 -p 3000 &

# Start the Dagster Daemon
dagster-daemon run
