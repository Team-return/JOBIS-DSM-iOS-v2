#!/bin/sh
cd ..

git clone https://github.com/Team-return/JOBIS-v2-XCConfig.git
mv JOBIS-v2-XCConfig/XCConfig/ .

brew install make
curl -Ls https://install.tuist.io | bash

TUIST_CI=1
make ci_generate
