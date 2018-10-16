#!/bin/bash

git clone git@forge.pole-aquinetic.net:nectar-platform/chilitags-detection-server.git
cd chilitags-detection-server
git checkout 0.2
mkdir build ; cd build
cmake ..
make
