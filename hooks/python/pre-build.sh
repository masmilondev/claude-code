#!/bin/bash
# Python Pre-Build Hook
# Runs before building Python projects

set -e

echo "🔍 Python Pre-Build Checks"
echo "==========================="

# Check Python version
echo "🐍 Python version:"
python --version

# Create virtual environment if needed
if [ ! -d venv ] && [ ! -d .venv ]; then
    echo "📦 Creating virtual environment"
    python -m venv venv
fi

# Activate virtual environment
if [ -d venv ]; then
    source venv/bin/activate
elif [ -d .venv ]; then
    source .venv/bin/activate
fi

# Install dependencies
if [ -f requirements.txt ]; then
    echo "📦 Installing requirements"
    pip install -r requirements.txt
elif [ -f pyproject.toml ]; then
    echo "📦 Installing with poetry/pip"
    pip install -e .
fi

# Type checking with mypy (if installed)
if command -v mypy &> /dev/null; then
    echo "🔍 Running mypy type checking"
    mypy . || echo "⚠️  Type check warnings found"
fi

echo "✅ Pre-build checks complete!"
