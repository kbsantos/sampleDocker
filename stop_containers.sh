#!/bin/bash
clear
echo "Stopping Containers --->>"
docker stop $(docker ps -a -q)
