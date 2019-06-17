#!/bin/bash

git clone git@forge.pole-aquinetic.net:nectar-platform/natar-camera-client.git

cd natar-camera-client
git pull
mvn package 
