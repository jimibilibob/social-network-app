#!/bin/bash
echo “Running pre-commit hook”
xcodebuild -quiet -project YourProject.xcodeproj -scheme “YourTestScheme” -destination 'platform=iOS Simulator,name=iPhone XR,OS=12.1' test
if [ $? -ne 0 ]; then
 echo “Tests must pass before commit!”
 exit 1
fi