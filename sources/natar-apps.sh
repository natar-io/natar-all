#!/bin/bash
# OK
git clone git@github.com:natar-io/natar-apps.git
cd natar-apps
git pull
mvn install
cd ..
