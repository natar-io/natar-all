#!/bin/bash

git clone git@forge.pole-aquinetic.net:nectar-platform/helpers-processing.git
cd helpers-processing
git fetch
git pull
mvn install
cd ..
