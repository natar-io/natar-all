#!/bin/bash

git clone git@github.com:natar-io/natar-tracker-aruco.git
cd natar-tracker-aruco
if [ $? -eq 0 ]; then
	git checkout master
	mkdir build ; cd build
	cmake ..
	make
else
	echo -e "Exiting ..."
fi
