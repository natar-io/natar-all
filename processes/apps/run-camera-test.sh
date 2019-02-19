#!/bin/bash

CP=$(<apps/camera-server-test.txt)
java -Xmx64m -cp $CP:apps/camera-server-test.jar  tech.lity.rea.nectar.CameraTest --input camera0
