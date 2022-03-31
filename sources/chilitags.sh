#!/bin/bash

## OpenCV binding out of date

git clone git@github.com:natar-io/natar-tracker-chilitags.git
cd natar-tracker-chilitags
if [ $? -eq 0 ]; then
	git checkout master
	mkdir build ; cd build
	cmake ..
	make
else
	echo -e "Exiting ..."
fi
