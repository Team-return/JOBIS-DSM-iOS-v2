#!/bin/sh
sh ci_install_tuist.sh
cd ../
git clone https://github.com/Team-return/JOBIS-v2-XCConfig.git
mv JOBIS-v2-XCConfig/XCConfig/ .

ci_scripts/tuist/tuist fetch
TUIST_CI=1 ci_scripts/tuist/tuist generate
