#!/bin/bash

CP=$(<apps/classpaths/apps.txt)
java -Xmx64m -cp $CP:apps/apps.jar tech.lity.rea.nectar.apps.ConfigurationLoader -f data/calib1.svg -o calib1 -mb
