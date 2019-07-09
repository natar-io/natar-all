#!/bin/sh

# cmd=java -jar
# prog=apps/configuration-loader.jar
# data=$SKETCHBOOK/libraries/PapARt/data/calibration

cmd=natar-app
prog=tech.lity.rea.nectar.apps.ConfigurationLoader
data=$SKETCHBOOK/libraries/PapARt/data/calibration
markers=$SKETCHBOOK/libraries/PapARt/data/markers

#RGB Camera
$cmd $prog -p / -f $data/calibration-AstraS-rgb.yaml -pd -o camera0:calibration

#Depth Camera
$cmd $prog -p / -f $data/calibration-AstraS-depth.yaml -o camera0:depth:calibration -pd 
$cmd $prog -p / -f $data/calibration-AstraS-stereo.xml -o camera0:depth:extrinsics -m 

#Projector
$cmd $prog -p / -f $data/projector.yaml -o projector0:calibration -pd -pr
$cmd $prog -p / -f $data/camProjExtrinsics.xml -o projector0:extrinsics -m -i

#Table
$cmd $prog -p / -f $data/tablePosition.xml -m -o table:extrinsics

#Markerboards
$cmd $prog -p / -f $markers/calib1.svg -mb -o calib1
$cmd $prog -p / -f $markers/calib-aruco2-v.svg -mb -o calib2
$cmd $prog -p / -f $markers/A4-default.svg -mb -o a4-default
