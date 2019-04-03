#!/bin/bash

git clone git@forge.pole-aquinetic.net:nectar-platform/natar-tracker-artoolkitplus.git
cd natar-tracker-artoolkitplus
if [ $? -eq 0 ]; then
	git checkout master
	mkdir build ; cd build
	cmake ..
	make
else
	echo -e "Exiting ..."
fi
