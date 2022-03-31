#!/bin/bash
## NOT OK
git clone git@github.com:natar-io/sticker-detection-server.git
cd sticker-detection-server
# git checkout 0.2
mkdir build ; cd build
cmake ..
make
