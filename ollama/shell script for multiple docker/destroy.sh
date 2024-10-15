#!/bin/bash
# Script to destroy running docker containers

docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
