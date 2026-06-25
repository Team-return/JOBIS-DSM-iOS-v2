generate:
	tuist install
	tuist generate --no-open
	open -a /Applications/Xcode-beta.app *.xcworkspace

clean:
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

cache_clean:
	rm -rf ~/Library/Developer/Xcode/DerivedData/*

reset:
	tuist clean
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

ci_generate:
	tuist fetch
	TUIST_CI=1 tuist generate
