#!/bin/bash
# Flutter Post-Build Hook
# Runs after building Flutter projects

set -e

echo "🧪 Flutter Post-Build Tasks"
echo "============================"

# Run analyzer
echo "🔍 Running Flutter analyze"
flutter analyze

# Run tests
echo "🧪 Running tests"
flutter test --coverage

# Check test coverage
if [ -f coverage/lcov.info ]; then
    echo "📊 Test coverage generated"
    # You can integrate with coverage tools here
fi

# Run widget tests
echo "🎨 Widget tests completed"

echo "✅ Post-build tasks complete!"
