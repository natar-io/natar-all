#!/bin/bash

git clone git@forge.pole-aquinetic.net:nectar-platform/natar-apps.git
cd natar-apps
git pull
mvn install
cd ..
