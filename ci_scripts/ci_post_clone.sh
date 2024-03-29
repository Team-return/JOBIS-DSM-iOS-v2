#!/bin/sh
cd ../
git clone https://github.com/Team-return/JOBIS-v2-XCConfig.git
mv JOBIS-v2-XCConfig/XCConfig/ .

brew install make
curl -Ls https://install.tuist.io | bash

tuist fetch
TUIST_CI=1 tuist generate
