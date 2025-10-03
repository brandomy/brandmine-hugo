#!/bin/bash

# Validate brand content files against taxonomy JSON files
# Ensures all taxonomy terms used in brand files exist in the official taxonomy data

set -e

TAXONOMY_DIR="data/taxonomies"
CONTENT_DIR="content/brands"
ERRORS=0
WARNINGS=0

echo "🔍 Validating brand taxonomy usage..."
echo ""

# Load valid terms from each taxonomy
VALID_MARKETS=$(jq -r '.[].id' "$TAXONOMY_DIR/markets.json" | sort)
VALID_SECTORS=$(jq -r '.[].id' "$TAXONOMY_DIR/sectors.json" | sort)
VALID_ATTRIBUTES=$(jq -r '.[].id' "$TAXONOMY_DIR/attributes.json" | sort)
VALID_SIGNALS=$(jq -r '.[].id' "$TAXONOMY_DIR/signals.json" | sort)

echo "📋 Loaded taxonomy definitions:"
echo "  Markets: $(echo "$VALID_MARKETS" | wc -l | tr -d ' ') terms"
echo "  Sectors: $(echo "$VALID_SECTORS" | wc -l | tr -d ' ') terms"
echo "  Attributes: $(echo "$VALID_ATTRIBUTES" | wc -l | tr -d ' ') terms"
echo "  Signals: $(echo "$VALID_SIGNALS" | wc -l | tr -d ' ') terms"
echo ""

# Function to check if a term exists in valid list
term_exists() {
  local term="$1"
  local valid_list="$2"
  echo "$valid_list" | grep -q "^${term}$"
}

# Function to extract array values from front matter
extract_taxonomy_terms() {
  local file="$1"
  local field="$2"

  # Extract the array from YAML front matter
  awk -v field="$field" '
    /^---$/ { if (++count == 2) exit }
    count == 1 && $0 ~ "^" field ":" {
      # Handle inline array format
      if ($0 ~ /\[.*\]/) {
        match($0, /\[.*\]/)
        arr = substr($0, RSTART, RLENGTH)
        gsub(/[\[\]"]/, "", arr)
        gsub(/, /, "\n", arr)
        print arr
        next
      }
      # Handle multi-line array format
      in_array = 1
      next
    }
    count == 1 && in_array {
      if ($0 ~ /^[a-z_]+:/ || $0 ~ /^---$/) {
        in_array = 0
        next
      }
      if ($0 ~ /^ *- /) {
        gsub(/^ *- *["'\'']*/, "")
        gsub(/["'\'',]*$/, "")
        print $0
      }
    }
  ' "$file"
}

# Check all brand files
BRAND_FILES=$(find "$CONTENT_DIR" -name "_index.*.md" | sort)
FILE_COUNT=$(echo "$BRAND_FILES" | wc -l | tr -d ' ')

echo "🔎 Checking $FILE_COUNT brand files..."
echo ""

for file in $BRAND_FILES; do
  filename=$(basename "$file")
  brand_dir=$(basename "$(dirname "$file")")

  echo "Checking $brand_dir/$filename..."

  # Check markets
  USED_MARKETS=$(extract_taxonomy_terms "$file" "markets")
  if [ -n "$USED_MARKETS" ]; then
    while IFS= read -r term; do
      if [ -n "$term" ] && ! term_exists "$term" "$VALID_MARKETS"; then
        echo "  ❌ Invalid market: '$term'"
        ((ERRORS++))
      fi
    done <<< "$USED_MARKETS"
  fi

  # Check sectors
  USED_SECTORS=$(extract_taxonomy_terms "$file" "sectors")
  if [ -n "$USED_SECTORS" ]; then
    while IFS= read -r term; do
      if [ -n "$term" ] && ! term_exists "$term" "$VALID_SECTORS"; then
        echo "  ❌ Invalid sector: '$term'"
        ((ERRORS++))
      fi
    done <<< "$USED_SECTORS"
  fi

  # Check attributes
  USED_ATTRIBUTES=$(extract_taxonomy_terms "$file" "attributes")
  if [ -n "$USED_ATTRIBUTES" ]; then
    while IFS= read -r term; do
      if [ -n "$term" ] && ! term_exists "$term" "$VALID_ATTRIBUTES"; then
        echo "  ❌ Invalid attribute: '$term'"
        ((ERRORS++))
      fi
    done <<< "$USED_ATTRIBUTES"
  fi

  # Check signals
  USED_SIGNALS=$(extract_taxonomy_terms "$file" "signals")
  if [ -n "$USED_SIGNALS" ]; then
    while IFS= read -r term; do
      if [ -n "$term" ] && ! term_exists "$term" "$VALID_SIGNALS"; then
        echo "  ❌ Invalid signal: '$term'"
        ((ERRORS++))
      fi
    done <<< "$USED_SIGNALS"
  fi

  # Check if file has any taxonomy terms
  if [ -z "$USED_MARKETS" ] && [ -z "$USED_SECTORS" ] && [ -z "$USED_ATTRIBUTES" ] && [ -z "$USED_SIGNALS" ]; then
    echo "  ⚠️  Warning: No taxonomy terms found"
    ((WARNINGS++))
  else
    if [ $ERRORS -eq 0 ]; then
      echo "  ✅ All terms valid"
    fi
  fi

  echo ""
done

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Validation Summary:"
echo "  Files checked: $FILE_COUNT"
echo "  Errors: $ERRORS"
echo "  Warnings: $WARNINGS"
echo ""

if [ $ERRORS -eq 0 ]; then
  echo "✅ All brand files use valid taxonomy terms"
  exit 0
else
  echo "❌ Validation failed with $ERRORS unauthorized term(s)"
  exit 1
fi
