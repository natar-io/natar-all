#!/bin/bash

git clone git@forge.pole-aquinetic.net:nectar-platform/aruco-detection-server.git
cd aruco-detection-server
git checkout 0.2
mkdir build ; cd build
cmake ..
make
