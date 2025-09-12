#!/bin/bash

# TabBarComponent UI Tests Runner
# This script helps run UI tests for the TabBarComponent project

echo "🚀 TabBarComponent UI Tests Runner"
echo "=================================="

# Check if Xcode is available
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: xcodebuild not found. Please ensure Xcode is installed and command line tools are set up."
    echo "   Run: sudo xcode-select --install"
    exit 1
fi

# Check if project exists
if [ ! -f "TabBarComponent.xcodeproj/project.pbxproj" ]; then
    echo "❌ Error: TabBarComponent.xcodeproj not found in current directory"
    exit 1
fi

echo "📱 Available simulators:"
xcrun simctl list devices available | grep "iPhone\|iPad" | head -10

echo ""
echo "🧪 Running UI Tests..."

# Run UI tests on the first available iPhone simulator
SIMULATOR_ID=$(xcrun simctl list devices available | grep "iPhone" | head -1 | grep -o '([^)]*' | tr -d '(' | tr -d ')')

if [ -z "$SIMULATOR_ID" ]; then
    echo "❌ Error: No iPhone simulator found"
    exit 1
fi

echo "📱 Using simulator: $SIMULATOR_ID"

# Build and run UI tests
xcodebuild test \
    -project TabBarComponent.xcodeproj \
    -scheme TabBarComponent \
    -destination "platform=iOS Simulator,id=$SIMULATOR_ID" \
    -only-testing:TabBarComponentUITests

echo ""
echo "✅ UI Tests completed!"
echo "📊 Check the output above for test results"
