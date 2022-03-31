#!/bin/bash
#OK for all
git clone https://github.com/Rea-lity-Tech/SimplePointCloud.git
cd SimplePointCloud
mvn install
cd ..

git clone https://github.com/Rea-lity-Tech/SVGExtended.git
cd SVGExtended
mvn install
cd ..

git clone https://github.com/Rea-lity-Tech/ColorConverter.git
cd ColorConverter
mvn install
cd ..

git clone https://github.com/poqudrof/ProcessingTUIO.git
cd ProcessingTUIO
mvn install
cd ..

git clone https://github.com/Rea-lity-Tech/Skatolo.git
cd Skatolo
mvn install
cd ..

## What was this ?
# git clone git@forge.pole-aquinetic.net:RealityTechPublic/javacv-processing.git
# cd javacv-processing
# mvn install
# cd ..
