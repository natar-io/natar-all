#!/bin/bash

git clone git@forge.pole-aquinetic.net:nectar-platform/sticker-detection-server.git
cd sticker-detection-server
# git checkout 0.2
mkdir build ; cd build
cmake ..
make
