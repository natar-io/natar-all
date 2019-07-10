#!/bin/sh

# cmd=java -jar
# prog=apps/configuration-loader.jar
# data=$SKETCHBOOK/libraries/PapARt/data/calibration

SKETCHBOOK=/usr/share/processing/modes/java

cmd=natar-app
prog=tech.lity.rea.nectar.apps.ConfigurationLoader
data=$SKETCHBOOK/libraries/PapARt/data/calibration
markers=$SKETCHBOOK/libraries/PapARt/data/markers

local_name=$1

# color
$cmd $prog -p / -f ~/calibrations/calibration-AstraS-$local_name-rgb.yaml -pd -o camera0:calibration

# depth
$cmd $prog -p / -f ~/calibrations/calibration-AstraS-$local_name-depth.yaml -o camera0:depth:calibration -pd
$cmd $prog -p / -f ~/calibrations/calibration-AstraS-$local_name-stereo.xml -o camera0:depth:extrinsics -m 

#Projector
$cmd $prog -p / -f ~/calibrations/projector-$local_name.yaml -o projector0:calibration -pd -pr

