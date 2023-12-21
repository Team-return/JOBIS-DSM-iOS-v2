#!/bin/sh
sh ci_install_tuist.sh
cd ../
git clone https://github.com/Team-return/JOBIS-XCConfig.git
mv JOBIS-XCConfig/XCConfig/ .

ci_scripts/tuist/tuist fetch
TUIST_CI=1 ci_scripts/tuist/tuist generate
