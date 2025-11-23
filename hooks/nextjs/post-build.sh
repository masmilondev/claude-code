#!/bin/bash
# Next.js Post-Build Hook
# Runs after building Next.js projects

set -e

echo "🧪 Next.js Post-Build Tasks"
echo "============================"

# Run linter
echo "🔍 Running ESLint"
npm run lint

# Run tests
if grep -q "\"test\"" package.json; then
    echo "🧪 Running tests"
    npm test -- --coverage --watchAll=false
fi

# Type check
if [ -f tsconfig.json ]; then
    echo "📝 Type checking"
    npx tsc --noEmit
fi

# Bundle analysis (if next-bundle-analyzer installed)
if grep -q "next-bundle-analyzer" package.json; then
    echo "📊 Bundle size analysis available"
    echo "Run 'ANALYZE=true npm run build' to analyze bundle"
fi

# Check for build warnings
if [ -d .next ]; then
    echo "✅ Build successful - .next directory created"
fi

echo "✅ Post-build tasks complete!"
