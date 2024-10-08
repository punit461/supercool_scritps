#!/bin/bash

# create.sh - to create a given set of docker containers running llama3.1


CONFIG_FILE="config.yml"
VOLUME_NAME="/usr/share/ollama/.ollama"
MODEL="llama3.1"

echo "model_list:" > $CONFIG_FILE

# Define function to create and manage ollama containers
create_ollama_container() {
    local container_name="ollama$1"
    local port=$2

    # Check if the container with the same name exists, if yes, remove it
    if docker ps -a --format '{{.Names}}' | grep -q "^$container_name$"; then
        echo "Removing existing container: $container_name"
        docker rm -f $container_name
    fi

    # Check if the container on the specified port exists, if yes, remove it
    if docker ps -a --format '{{.Ports}}' | grep -q "0.0.0.0:$port->"; then
        echo "Removing existing container on port $port"
        docker rm -f $(docker ps -a --format '{{if (index (split .Ports "/") 0) | (index (split . "->") 0) | (eq "'"0.0.0.0:$port"'")}}{{.Names}}{{end}}')
    fi

        # Create and run the new container
    docker run -d --gpus=all \
        -v $VOLUME_NAME:/root/.ollama \
        -p $port:11434 \
        --name $container_name \
        ollama/ollama

    echo "Created container: $container_name on port $port"


    # Add entry to the config file
    echo "  - model_name: $MODEL" >> $CONFIG_FILE
    echo "    litellm_params:" >> $CONFIG_FILE
    echo "        model: ollama/$MODEL" >> $CONFIG_FILE
    echo "        api_base: http://localhost:$port" >> $CONFIG_FILE

}

# Create n different ollama containers with unique names and ports
for i in {1..4}; do
    port=$((11434 + i))
    create_ollama_container $i $port
done
