# Taxonomy Standards

## Overview

Brandmine uses exactly **4 taxonomy dimensions** to classify brands and content. All taxonomy terms MUST come from the official registry files in `data/taxonomies/*.json`.

## The 4 Dimensions

1. **Markets** - Geographic/cultural markets
2. **Sectors** - Industry verticals
3. **Attributes** - Brand characteristics
4. **Signals** - Market indicators

## Registry Files

All authorized taxonomy terms are defined in:

```
data/taxonomies/
├── markets.json     (15 authorized markets)
├── sectors.json     (16 authorized sectors)
├── attributes.json  (8 authorized attributes)
└── signals.json     (4 authorized signals)
```

## Authorized Terms

### Markets (15 terms)
- abkhazia
- asean
- brazil
- china
- egypt
- ethiopia
- gcc
- india
- indonesia
- iran
- malaysia
- mongolia
- russia
- south-africa
- uae

**DO NOT USE**: Country codes (de, fr, gb, jp, sg, eu), regional groups not in registry (eastern-europe, south-america), or individual countries not listed above.

### Sectors (16 terms)
- artisan-ceramics
- artisan-confectionery
- artisanal-spirits
- cured-meats
- fashion-accessories
- fermented-dairy
- gourmet-foods
- halal-foods
- honey-bee-products
- hotels-resorts
- jewelry-watches
- mineral-waters
- natural-beauty
- natural-supplements
- specialty-cheeses
- wine

**DO NOT USE**: Generic terms (food-beverage, hospitality, luxury-services, specialty-coffee, specialty-foods) or terms not in the registry.

### Attributes (8 terms)
- artisanal-excellence
- cultural-bridge
- founder-led
- heritage-brand
- innovation-leader
- premium-positioning
- regional-icon
- sustainability-pioneer

### Signals (4 terms)
- export-ready
- franchise-ready
- investment-ready
- rapid-growth

## Usage in Front Matter

```yaml
---
title: "Brand Name"
markets: ["russia", "china"]           # Only from markets.json
sectors: ["gourmet-foods"]             # Only from sectors.json
attributes: ["founder-led", "regional-icon"]  # Only from attributes.json
signals: ["export-ready"]              # Only from signals.json
---
```

## Validation Rules

1. **ONLY use terms from registry files** - Do NOT invent new terms
2. **Use exact slugs** - Match the "id" field in JSON files exactly
3. **No country codes** - Use market names (e.g., "russia" not "ru")
4. **Markets ≠ Countries** - Markets are strategic groupings, not all countries
5. **Check all languages** - EN, RU, and ZH files must use identical taxonomy terms

## Adding New Terms

To add a new taxonomy term:

1. Add to appropriate registry file (`data/taxonomies/*.json`)
2. Include all 3 language translations (en, ru, zh)
3. Provide icon and hero_image paths
4. Update this documentation
5. **DO NOT** use terms before adding to registry

## Common Violations

❌ **WRONG**:
```yaml
markets: ["de", "fr", "gb"]  # Country codes not allowed
sectors: ["food-beverage"]   # Not in registry
```

✅ **CORRECT**:
```yaml
markets: ["russia", "china"]  # Authorized market names
sectors: ["gourmet-foods"]    # From sectors.json
```

## Enforcement

- Run `hugo build` to generate taxonomy pages
- Only authorized terms should create pages in `public/markets/`, `public/sectors/`, etc.
- Unauthorized terms will create orphan pages - this indicates a violation

## Last Updated

2025-10-04 - Initial taxonomy standards documentation
