#!/bin/bash

git clone git@forge.pole-aquinetic.net:nectar-platform/redis-image-helper.git
cd redis-image-helper
git checkout master
mkdir build ; cd build
cmake ..
make
echo "Installing..."
sudo make install
