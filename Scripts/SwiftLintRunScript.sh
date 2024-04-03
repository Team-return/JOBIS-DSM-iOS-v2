if test -d "/opt/homebrew/bin/"; then
    PATH="/opt/homebrew/bin/:${PATH}"
fi

export PATH
YML="$(dirname "$0")/.swiftlint.yml"

if which swiftlint > /dev/null; then
    swiftlint --config "${YML}"
else
    echo "warning: SwiftLint not installed, please run 'brew install swiftlint'"
fi
