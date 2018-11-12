#!/bin/bash

git clone git@forge.pole-aquinetic.net:nectar-platform/artoolkitplus-detection-server.git
cd artoolkitplus-detection-server
git checkout master
mkdir build ; cd build
cmake ..
make
