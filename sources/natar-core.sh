#!/bin/bash

git clone git@forge.pole-aquinetic.net:nectar-platform/natar-core.git
cd natar-core
git pull
mvn install
cd ..
