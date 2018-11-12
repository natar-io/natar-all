#!/bin/bash

git clone git@forge.pole-aquinetic.net:nectar-platform/chilitags-detection-server.git
cd chilitags-detection-server
git checkout master
mkdir build ; cd build
cmake ..
make
