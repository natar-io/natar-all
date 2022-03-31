#!/bin/bash

## NOT OK, pom to update
git clone git@github.com:natar-io/natar-camera-client.git

cd natar-camera-client
git pull
mvn package 
