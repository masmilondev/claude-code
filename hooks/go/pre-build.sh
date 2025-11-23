#!/bin/bash
# Go Pre-Build Hook
# Runs before building Go projects

set -e

echo "🔍 Go Pre-Build Checks"
echo "======================"

# Check Go version
echo "🔧 Go version:"
go version

# Download dependencies
echo "📦 Downloading dependencies"
go mod download

# Verify dependencies
echo "🔍 Verifying dependencies"
go mod verify

# Format check
echo "✨ Checking code format"
if [ -n "$(gofmt -l .)" ]; then
    echo "⚠️  Code needs formatting:"
    gofmt -l .
    echo "Run: gofmt -w ."
fi

# Vet code
echo "🔍 Running go vet"
go vet ./...

echo "✅ Pre-build checks complete!"
