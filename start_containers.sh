#!/bin/bash
clear
echo "Stopping Containers --->>"
docker start cd-mysql
docker start cd-dev
