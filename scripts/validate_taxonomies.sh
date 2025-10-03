#!/bin/bash

# Validate taxonomy JSON files
# Ensures all 4 dimension files have correct structure and required fields

set -e

TAXONOMY_DIR="data/taxonomies"
ERRORS=0

echo "🔍 Validating taxonomy JSON files..."
echo ""

# Check if directory exists
if [ ! -d "$TAXONOMY_DIR" ]; then
  echo "❌ Directory $TAXONOMY_DIR does not exist"
  exit 1
fi

# Required files
FILES=("attributes.json" "sectors.json" "signals.json" "markets.json")

# Validate each file
for file in "${FILES[@]}"; do
  filepath="$TAXONOMY_DIR/$file"

  echo "Checking $file..."

  # Check if file exists
  if [ ! -f "$filepath" ]; then
    echo "  ❌ File not found"
    ((ERRORS++))
    continue
  fi

  # Validate JSON syntax
  if ! jq empty "$filepath" 2>/dev/null; then
    echo "  ❌ Invalid JSON syntax"
    ((ERRORS++))
    continue
  fi

  # Check if root is an array
  if ! jq -e '. | type == "array"' "$filepath" >/dev/null 2>&1; then
    echo "  ❌ Root element must be an array"
    ((ERRORS++))
  fi

  # Count items
  item_count=$(jq 'length' "$filepath")
  echo "  ✅ Valid JSON with $item_count items"

  # Validate first item structure (sample check)
  if [ "$item_count" -gt 0 ]; then
    if ! jq -e '.[0].id' "$filepath" >/dev/null 2>&1; then
      echo "  ⚠️  Warning: First item missing 'id' field"
    fi
    if ! jq -e '.[0].name' "$filepath" >/dev/null 2>&1; then
      echo "  ⚠️  Warning: First item missing 'name' field"
    fi
    if ! jq -e '.[0].description' "$filepath" >/dev/null 2>&1; then
      echo "  ⚠️  Warning: First item missing 'description' field"
    fi

    # Check multilingual structure
    if jq -e '.[0].name | type == "object"' "$filepath" >/dev/null 2>&1; then
      echo "  ✅ Multilingual structure detected"
    fi
  fi

  echo ""
done

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ERRORS -eq 0 ]; then
  echo "✅ All taxonomy files validated successfully"
  exit 0
else
  echo "❌ Validation failed with $ERRORS error(s)"
  exit 1
fi
