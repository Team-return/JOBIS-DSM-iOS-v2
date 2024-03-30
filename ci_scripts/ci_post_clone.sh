#!/bin/sh
cd ../
git clone https://github.com/Team-return/JOBIS-v2-XCConfig.git
mv JOBIS-v2-XCConfig/XCConfig/ .

cd ./Projects/App/Resources
git clone https://github.com/Team-return/JOBIS-GoogleInfo.git
mv JOBIS-GoogleInfo/FireBase/ .

brew install make
curl -Ls https://install.tuist.io | bash

tuist fetch
TUIST_CI=1 tuist generate
