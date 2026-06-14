#!/bin/bash
set -e

case "$1" in
  build_generator)
    echo "Building generator image..."
    docker build -t generator -f generator/Dockerfile .
    ;;
  run_generator)
    mkdir -p data
    echo "Running generator container..."
    docker run --rm -v "$(pwd)/data:/data" generator
    echo "Created data/data.csv"
    ;;
  create_local_data)
    mkdir -p local_data
    python3 generate.py local_data
    echo "Created local_data/data.csv"
    ;;
  build_reporter)
    echo "Building reporter image..."
    docker build -t reporter -f reporter/Dockerfile .
    ;;
  run_reporter)
    if [ ! -f data/data.csv ]; then
      echo "Error: data/data.csv not found. Run './run.sh run_generator' first."
      exit 1
    fi
    echo "Running reporter container..."
    docker run --rm -v "$(pwd)/data:/data" reporter
    echo "Report generated: data/report.html"
    ;;
  structure)
    echo "Project structure:"
    find . -not -path './.git/*' -not -path './node_modules/*' -not -name '.git' | sort
    ;;
  clear_data)
    rm -f data/*.csv data/*.html
    echo "Cleared *.csv and *.html from data/"
    ;;
  inside_generator)
    echo "Contents of /data inside generator:"
    docker run --rm -v "$(pwd)/data:/data" generator sh -c "ls -la /data"
    ;;
  inside_reporter)
    echo "Contents of /data inside reporter:"
    docker run --rm -v "$(pwd)/data:/data" reporter sh -c "ls -la /data"
    ;;
  report_server)
    if [ ! -f data/report.html ]; then
      echo "Error: data/report.html not found. Run './run.sh run_reporter' first."
      exit 1
    fi
    echo "Starting report server on port 8080..."
    docker run --rm -d -p 8080:80 -v "$(pwd)/data:/usr/share/nginx/html:ro" --name report_server nginx:alpine
    echo "Server running. Open http://localhost:8080/report.html"
    echo "To stop: docker stop report_server"
    ;;
  *)
    echo "Usage: $0 {build_generator|run_generator|create_local_data|build_reporter|run_reporter|structure|clear_data|inside_generator|inside_reporter|report_server}"
    exit 1
esac