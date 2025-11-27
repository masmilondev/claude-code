#!/bin/bash
# Hook: Extract database schema from phpMyAdmin URL or table name
# Usage: ./db-schema.sh "database_name" "table_name"

DATABASE="${1:-cloudpos}"
TABLE="$2"

# MySQL connection settings (MAMP configuration)
MYSQL_USER="${MYSQL_USER:-root}"
MYSQL_PASS="${MYSQL_PASS:-L0c@ldb}"
MYSQL_HOST="${MYSQL_HOST:-127.0.0.1}"
MYSQL_PORT="${MYSQL_PORT:-3390}"

# Try different MySQL paths
MYSQL_CMD=""
for cmd in "/Applications/MAMP/Library/bin/mysql" "/usr/local/mysql/bin/mysql" "mysql"; do
    if command -v "$cmd" &> /dev/null || [ -f "$cmd" ]; then
        MYSQL_CMD="$cmd"
        break
    fi
done

if [ -z "$MYSQL_CMD" ]; then
    echo "Error: MySQL client not found"
    exit 1
fi

if [ -z "$TABLE" ]; then
    echo "Error: Table name required"
    echo "Usage: $0 database_name table_name"
    exit 1
fi

echo "=== Schema for $DATABASE.$TABLE ==="
echo ""

# Get table structure
echo "### Columns:"
$MYSQL_CMD -u "$MYSQL_USER" -p"$MYSQL_PASS" -h "$MYSQL_HOST" -P "$MYSQL_PORT" -e "DESCRIBE $TABLE" "$DATABASE" 2>/dev/null

echo ""
echo "### Indexes:"
$MYSQL_CMD -u "$MYSQL_USER" -p"$MYSQL_PASS" -h "$MYSQL_HOST" -P "$MYSQL_PORT" -e "SHOW INDEX FROM $TABLE" "$DATABASE" 2>/dev/null

echo ""
echo "### Sample Data (5 rows):"
$MYSQL_CMD -u "$MYSQL_USER" -p"$MYSQL_PASS" -h "$MYSQL_HOST" -P "$MYSQL_PORT" -e "SELECT * FROM $TABLE LIMIT 5" "$DATABASE" 2>/dev/null

echo ""
echo "### Row Count:"
$MYSQL_CMD -u "$MYSQL_USER" -p"$MYSQL_PASS" -h "$MYSQL_HOST" -P "$MYSQL_PORT" -e "SELECT COUNT(*) as total FROM $TABLE" "$DATABASE" 2>/dev/null
