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

mise install tuist@3.23.1

tuist version

tuist fetch
TUIST_CI=1 tuist generate
