#!/bin/sh

# cmd=java -jar
# prog=apps/configuration-loader.jar
# data=$SKETCHBOOK/libraries/PapARt/data/calibration

SKETCHBOOK=/usr/share/processing/modes/java

cmd=natar-app
prog=tech.lity.rea.nectar.apps.ConfigurationLoader
data=$SKETCHBOOK/libraries/PapARt/data/calibration
markers=$SKETCHBOOK/libraries/PapARt/data/markers

echo "Copy the calibrations to Natar (Redis)." 

# color
$cmd $prog -p / -f ~/calibrations/calibration-AstraS-rgb.yaml -pd -o camera0:calibration

# depth
$cmd $prog -p / -f ~/calibrations/calibration-AstraS-depth.yaml -o camera0:depth:calibration -pd
$cmd $prog -p / -f ~/calibrations/calibration-AstraS-stereo.xml -o camera0:depth:extrinsics -m 

#Projector
$cmd $prog -p / -f ~/calibrations/projector.yaml -o projector0:calibration -pd -pr

echo "Copy the calibrations to PapARt." 
cp ~/calibrations/* /usr/share/processing/modes/java/libraries/PapARt/data/calibration/
