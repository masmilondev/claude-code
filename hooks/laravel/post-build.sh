#!/bin/bash
# Laravel Post-Build Hook
# Runs after building Laravel projects

set -e

echo "🧪 Laravel Post-Build Tasks"
echo "==========================="

# Run tests
echo "🧪 Running PHPUnit tests"
if [ -f vendor/bin/phpunit ]; then
    vendor/bin/phpunit --testdox
else
    php artisan test --parallel
fi

# Run static analysis (if installed)
if [ -f vendor/bin/phpstan ]; then
    echo "🔍 Running PHPStan"
    vendor/bin/phpstan analyze
fi

# Run code style check (if installed)
if [ -f vendor/bin/pint ]; then
    echo "✨ Running Laravel Pint"
    vendor/bin/pint --test
fi

# Check for N+1 queries (if telescope installed)
if php artisan | grep -q "telescope"; then
    echo "📊 Telescope is installed - check for N+1 queries"
fi

echo "✅ Post-build tasks complete!"
