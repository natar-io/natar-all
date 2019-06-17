#!/bin/bash

git clone git@forge.pole-aquinetic.net:nectar-platform/detections.git
cd detections
mvn install
cd ..
