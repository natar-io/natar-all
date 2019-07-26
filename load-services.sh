#!/bin/sh

# cmd=java -jar
# prog=apps/configuration-loader.jar
# data=$SKETCHBOOK/libraries/PapARt/data/calibration

sudo systemctl enable redis-natar
sudo systemctl start redis-natar

sudo systemctl enable nginx-natar
sudo systemctl start nginx-natar

systemctl --user start eye 
systemctl --user enable eye 
