#!/bin/bash

git clone git@github.com:natar-io/natar-detections.git
cd natar-detections
git pull
mvn install
cd ..
