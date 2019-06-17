#!/bin/bash

CP=$(<apps/classpaths/camera-client.txt)
java -Xmx64m -cp $CP:apps/camera-client.jar  tech.lity.rea.nectar.CameraTest --input camera0
