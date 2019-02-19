#!/bin/bash

CP=$(<apps/camera-server.txt)
java  -Xmx128m -cp $CP:apps/camera-server.jar tech.lity.rea.nectar.camera.CameraServerImpl --driver OPENNI2 --device-id 0 --format rgb --output camera0 --stream --depth-camera -v
