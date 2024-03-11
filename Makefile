generate:
	tuist fetch
	tuist generate

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
