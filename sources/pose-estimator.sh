#!/bin/bash

## Download pose estimator 
git clone git@github.com:natar-io/pose-estimator-papart.git

cd pose-estimator-papart
git fetch
git checkout 0.2
mvn package

# end pose estimator
