#!/bin/bash

git clone git@forge.pole-aquinetic.net:nectar-platform/camera-server.git

cd camera-server
git fetch
mvn package 

