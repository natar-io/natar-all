#!/bin/bash
## PB with assembly, to update
git clone git@github.com:natar-io/natar-multi-camera-server.git

cd natar-multi-camera-server
git pull
mvn install

