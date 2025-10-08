# Reference Data

**Purpose**: Store structured reference data files (CSV, JSON, YAML) used for analysis, imports, and data management.

## Contents

This directory contains data files that are:
- **Reference materials** for business analysis or content creation
- **Import sources** for bulk operations (CSV imports to Supabase, etc.)
- **Lookup tables** for validation or enrichment
- **Export snapshots** for reporting or archival purposes

## File Types

### CSV Files (.csv)
- Brand lists with metadata
- Taxonomy mappings
- Contact lists or leads
- Export snapshots from database

### JSON Files (.json)
- Structured data exports
- API response samples
- Complex data structures

### YAML Files (.yml)
- Configuration data
- Structured content templates
- Multilingual data sets

## Naming Conventions

**Date-prefixed exports**:
```
YYYY-MM-DD-description.csv
2025-10-08-brand-list-export.csv
```

**Descriptive reference files**:
```
kebab-case-description.csv
taxonomy-term-mappings.csv
brics-country-codes.json
```

## Usage Examples

### Brand Import CSV
```csv
name,slug,tagline,market,sector,headquarters_city,headquarters_country
Altai Gold Honey,altai-honey,Pure Siberian honey from pristine Altai Mountains,russia,honey-bee-products,Barnaul,Russia
```

### Taxonomy Mapping CSV
```csv
taxonomy,slug,label_en,label_ru,label_zh
markets,russia,Russia,Россия,俄罗斯
markets,china,China,Китай,中国
sectors,gourmet-foods,Gourmet Foods,Изысканные Продукты Питания,美食
```

### Data Export Snapshot
```csv
entity_type,entity_count,last_updated
brands,12,2025-10-08
founders,8,2025-10-08
insights,4,2025-10-08
```

## Directory vs Data Directory

**`docs/reference-data/`** (this directory):
- Human-readable reference files
- Import/export operations
- Ad-hoc analysis data
- Not processed by Hugo build

**`data/`** (Hugo data directory):
- Structured data used by templates at build time
- Taxonomy definitions, translations, configuration
- Processed by Hugo during site generation
- Production data used by the site

## Gitignore Considerations

**Commit to git**:
- Reference taxonomy mappings
- Template CSV structures
- Small reference datasets (< 100 rows)
- Documentation examples

**Add to .gitignore**:
- Large exports (> 1000 rows)
- PII or sensitive data
- Temporary analysis files
- Database dumps

## Common Operations

### Importing CSVs to Supabase
```bash
# Example: Import brands from CSV
node scripts/import-brands-from-csv.js docs/reference-data/brands-import.csv
```

### Exporting Data for Analysis
```bash
# Example: Export current brand data
node scripts/export-brands-to-csv.js > docs/reference-data/$(date +%Y-%m-%d)-brands-export.csv
```

### Validating Taxonomy Terms
```bash
# Example: Check all content uses authorized taxonomy terms
node scripts/validate-taxonomies.js docs/reference-data/taxonomy-mappings.csv
```

## Best Practices

1. **Add README per major dataset**: If you upload a significant CSV with 10+ columns, add a `filename-README.md` explaining the schema
2. **Date exports**: Prefix export snapshots with dates for chronological tracking
3. **Document sources**: Note where data came from (web scraping, manual research, database export)
4. **Clean headers**: Use lowercase, snake_case column names in CSVs
5. **UTF-8 encoding**: Ensure all files use UTF-8 for multilingual support (RU/ZH characters)

## File Organization

```
docs/reference-data/
├── README.md                           # This file
├── taxonomy-mappings.csv               # Reference taxonomy data
├── 2025-10-08-brand-export.csv        # Dated export snapshot
├── import-templates/                   # CSV templates for imports
│   ├── brand-import-template.csv
│   └── founder-import-template.csv
└── analysis/                           # Ad-hoc analysis files
    └── market-coverage-analysis.csv
```

---

**Created**: 2025-10-08
**Purpose**: Centralized location for reference data files
**Usage**: Import/export, analysis, validation, documentation
