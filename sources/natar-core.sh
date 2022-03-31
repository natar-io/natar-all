#!/bin/bash
# OK
git clone git@github.com:natar-io/natar-core.git
cd natar-core
git pull
mvn install
cd ..
