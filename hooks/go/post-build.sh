#!/bin/bash
# Go Post-Build Hook
# Runs after building Go projects

set -e

echo "🧪 Go Post-Build Tasks"
echo "======================"

# Run tests
echo "🧪 Running tests"
go test ./... -v -race -coverprofile=coverage.out

# Show coverage
echo "📊 Test coverage:"
go tool cover -func=coverage.out | tail -1

# Run golangci-lint if available
if command -v golangci-lint &> /dev/null; then
    echo "🔍 Running golangci-lint"
    golangci-lint run
fi

# Check for common issues
echo "🔍 Running go vet"
go vet ./...

# Build to verify
echo "🔨 Test build"
go build ./...

echo "✅ Post-build tasks complete!"
