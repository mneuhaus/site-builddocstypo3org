#!/bin/bash

# Initialize environment
log="/var/log/app"

if [ ! -d $log ];
then
    mkdir $log
fi

codeStatus=`curl -s -o /dev/null -w "%{http_code}" http://<%= @server_name %>/`

if [ $codeStatus != 200 ];
then
    echo "Something weird happened to the Flow application. Flushing cache the hard way..."
    rm -rf <%= @release_to %>/Data/Temporary/

    # Log incident
    echo $i > $log/incident-not-200-status-page-`date +"%m-%d-%y-%T"`
fi
