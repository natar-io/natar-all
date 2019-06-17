#!/bin/bash

git clone git@forge.pole-aquinetic.net:nectar-platform/natar-detections.git
cd natar-detections
git pull
mvn install
cd ..
