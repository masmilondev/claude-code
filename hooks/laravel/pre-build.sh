#!/bin/bash
# Laravel Pre-Build Hook
# Runs before building Laravel projects

set -e

echo "🔍 Laravel Pre-Build Checks"
echo "============================"

# Check if .env exists
if [ ! -f .env ]; then
    echo "⚠️  No .env file found"
    if [ -f .env.example ]; then
        echo "📝 Creating .env from .env.example"
        cp .env.example .env
        php artisan key:generate
    else
        echo "❌ Error: No .env or .env.example found"
        exit 1
    fi
fi

# Check if vendor exists
if [ ! -d vendor ]; then
    echo "📦 Installing Composer dependencies"
    composer install --no-interaction
fi

# Check database connection
echo "🔌 Checking database connection"
php artisan db:show 2>/dev/null || echo "⚠️  Database connection failed (continuing anyway)"

# Clear caches
echo "🧹 Clearing caches"
php artisan config:clear
php artisan cache:clear
php artisan view:clear

echo "✅ Pre-build checks complete!"
