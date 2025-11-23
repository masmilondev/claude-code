#!/bin/bash
# Next.js Pre-Build Hook
# Runs before building Next.js projects

set -e

echo "🔍 Next.js Pre-Build Checks"
echo "==========================="

# Check Node version
REQUIRED_NODE="18.0.0"
CURRENT_NODE=$(node -v | cut -d'v' -f2)

echo "📦 Node version: $CURRENT_NODE"

# Check if .env.local exists
if [ ! -f .env.local ] && [ ! -f .env ]; then
    echo "⚠️  No .env.local or .env file found"
    if [ -f .env.example ]; then
        echo "📝 Creating .env.local from .env.example"
        cp .env.example .env.local
    fi
fi

# Install dependencies if needed
if [ ! -d node_modules ]; then
    echo "📦 Installing dependencies"
    npm ci
fi

# Type check
if [ -f tsconfig.json ]; then
    echo "🔍 Type checking"
    npm run type-check || npx tsc --noEmit
fi

echo "✅ Pre-build checks complete!"
