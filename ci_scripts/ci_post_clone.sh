#!/bin/sh
cd ../
git clone https://github.com/Team-return/JOBIS-v2-XCConfig.git
mv JOBIS-v2-XCConfig/XCConfig/ .

git clone https://github.com/Team-return/JOBIS-GoogleInfo.git
mv JOBIS-GoogleInfo/FireBase/ Projects/App/Resources/

brew install make

curl https://mise.jdx.dev/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate bash --shims)"

mise install tuist@3.40.0

tuist version

make reset

tuist fetch
TUIST_CI=1 tuist generate
