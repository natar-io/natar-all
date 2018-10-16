#!/bin/bash

git clone git@forge.pole-aquinetic.net:nectar-platform/camera-server-test.git

cd camera-server-test
git fetch
git checkout 0.2
mvn package 
