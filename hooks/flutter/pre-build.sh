#!/bin/bash
# Flutter Pre-Build Hook
# Runs before building Flutter projects

set -e

echo "🔍 Flutter Pre-Build Checks"
echo "==========================="

# Check Flutter version
echo "📱 Flutter version:"
flutter --version | head -1

# Get dependencies
echo "📦 Getting dependencies"
flutter pub get

# Check for outdated packages
echo "📊 Checking for outdated packages"
flutter pub outdated

# Run code generation if needed
if grep -q "build_runner" pubspec.yaml; then
    echo "🔧 Running code generation"
    flutter pub run build_runner build --delete-conflicting-outputs
fi

# Format check
echo "✨ Checking code format"
dart format --set-exit-if-changed lib/ || echo "⚠️  Code needs formatting"

echo "✅ Pre-build checks complete!"
