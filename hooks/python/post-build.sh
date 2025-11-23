#!/bin/bash
# Python Post-Build Hook
# Runs after building Python projects

set -e

echo "🧪 Python Post-Build Tasks"
echo "============================"

# Activate virtual environment
if [ -d venv ]; then
    source venv/bin/activate
elif [ -d .venv ]; then
    source .venv/bin/activate
fi

# Run tests with pytest
if command -v pytest &> /dev/null; then
    echo "🧪 Running pytest"
    pytest -v --cov=. --cov-report=term-missing
fi

# Run linter (black)
if command -v black &> /dev/null; then
    echo "✨ Running black formatter check"
    black --check .
fi

# Run flake8
if command -v flake8 &> /dev/null; then
    echo "🔍 Running flake8"
    flake8 .
fi

echo "✅ Post-build tasks complete!"
