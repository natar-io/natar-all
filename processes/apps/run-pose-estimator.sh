#!/bin/bash

CP=$(<apps/classpaths/pose.txt)
java -Xmx64m -cp $CP:apps/apps.jar tech.lity.rea.nectar.apps.MultiPoseEstimator --input camera0
