#!/bin/bash
echo “Running pre-commit hook”
xcodebuild -project social-network-app.xcodeproj -scheme "social-network-app" -destination 'platform=iOS Simulator,name=iPhone 13 Pro,OS=15.5' test
if [ $? -ne 0 ]; then
 echo “Tests must pass before commit!”
 exit 1
fi
