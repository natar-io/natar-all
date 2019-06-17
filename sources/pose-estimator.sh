#!/bin/bash

## Download pose estimator 
git clone git@forge.pole-aquinetic.net:nectar-platform/pose-estimator-papart.git

cd pose-estimator-papart
git fetch
git checkout 0.2
mvn package

# end pose estimator
