#!/bin/sh

# cmd=java -jar
# prog=apps/configuration-loader.jar
# data=$SKETCHBOOK/libraries/PapARt/data/calibration

SKETCHBOOK=/usr/share/processing/modes/java

cmd=natar-app
prog=tech.lity.rea.nectar.apps.ConfigurationLoader
data=$SKETCHBOOK/libraries/PapARt/data/calibration
markers=$SKETCHBOOK/libraries/PapARt/data/markers

#Projector
$cmd $prog -p / -f $data/camProjExtrinsics.xml -o projector0:extrinsics -m -i

#Table
$cmd $prog -p / -f $data/tablePosition.xml -m -o camera0:table

#Markerboards
$cmd $prog -p / -f $markers/calib1.svg -mb -o calib1
$cmd $prog -p / -f $markers/A4-default.svg -mb -o a4-default
