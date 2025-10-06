# Supabase Schema Design for Brandmine

**Date**: 2025-10-03
**Phase**: Week 4 (CLEAN-BUILD-PLAN.md Day 16-17)
**Status**: CEO Approved - Ready for Implementation

## Executive Summary

This document defines the PostgreSQL schema for Brandmine's Supabase database using **relational translations tables** for multilingual content (EN/RU/ZH). The database serves as the **source of truth for taxonomy dimensions**, with **Supabase Storage** handling all images. Search functionality is delegated to **Pagefind** (static site search), while Supabase provides fast API access for dynamic content and future applications.

## Design Principles

1. **Relational Translations**: Separate `translations` table with foreign keys (not JSONB)
2. **Database as Taxonomy Source**: Dimensions managed in Supabase, synced to Hugo
3. **Supabase Storage**: All images stored in Supabase buckets (not Hugo static/)
4. **Public API Access**: RLS policies enable public read access for frontend applications
5. **Pagefind for Search**: No PostgreSQL full-text search (static Pagefind handles it)
6. **Scalability**: Designed for 100s of brands, not just current 6

## Schema Architecture

### Core Tables

```
brands          # Brand profiles (language-agnostic data)
founders        # Founder profiles (language-agnostic data)
insights        # Market insights (language-agnostic data)
dimensions      # Taxonomy terms (4 types) - SOURCE OF TRUTH
translations    # Multilingual content for all entities (EN/RU/ZH)
```

### Junction Tables (Many-to-Many)

```
brand_markets      # brands ↔ markets
brand_sectors      # brands ↔ sectors
brand_attributes   # brands ↔ attributes
brand_signals      # brands ↔ signals
insight_markets    # insights ↔ markets
insight_sectors    # insights ↔ sectors
```

### Supabase Storage Buckets

```
brand-images      # Brand logos, hero images, product photos
founder-images    # Founder portraits and photos
insight-images    # Insight hero images and graphics
dimension-icons   # Icons for taxonomy dimensions (if applicable)
```

---

## Table Definitions

### 1. `brands`

**Purpose**: Core brand profiles (language-agnostic data only)

```sql
CREATE TABLE brands (
  -- Identity
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT UNIQUE NOT NULL,  -- e.g., "altai-honey"

  -- Relationships
  founder_id UUID REFERENCES founders(id) ON DELETE SET NULL,

  -- Business Details
  founded INTEGER,  -- Year, e.g., 2010
  employees TEXT,  -- Range, e.g., "25" or "20-50"
  revenue TEXT,  -- Range, e.g., "$2M-5M"
  website TEXT,

  -- Location
  headquarters_city TEXT,
  headquarters_country TEXT,  -- ISO 3166-1 alpha-2, e.g., "ru"
  headquarters_region TEXT,
  headquarters_latitude DECIMAL(10, 7),
  headquarters_longitude DECIMAL(10, 7),

  -- Assets (Supabase Storage URLs)
  logo_url TEXT,
  hero_image_url TEXT,

  -- Metadata
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  published_at TIMESTAMPTZ,
  draft BOOLEAN NOT NULL DEFAULT false,

  -- Hugo sync
  translation_key TEXT UNIQUE NOT NULL,
  hugo_date DATE NOT NULL,

  -- Constraints
  CONSTRAINT brands_slug_format CHECK (slug ~ '^[a-z0-9-]+$')
);

-- Indexes
CREATE INDEX idx_brands_founder ON brands(founder_id);
CREATE INDEX idx_brands_country ON brands(headquarters_country);
CREATE INDEX idx_brands_published ON brands(published_at) WHERE draft = false;
CREATE INDEX idx_brands_slug ON brands(slug);
CREATE INDEX idx_brands_translation_key ON brands(translation_key);

-- Trigger for updated_at
CREATE TRIGGER brands_updated_at
  BEFORE UPDATE ON brands
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();
```

**Multilingual Content**: See `translations` table (entity_type = 'brand', entity_id = brand.id)

---

### 2. `founders`

**Purpose**: Founder profiles (language-agnostic data only)

```sql
CREATE TABLE founders (
  -- Identity
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT UNIQUE NOT NULL,  -- e.g., "pavel-titov"

  -- Professional
  industry TEXT,  -- e.g., "Food & Beverage"
  years_experience INTEGER,
  expertise TEXT[],  -- Array: ["tea blending", "beverage innovation"]

  -- Personal
  city TEXT,
  country TEXT,  -- ISO 3166-1 alpha-2
  languages TEXT[],  -- ["Russian", "English", "German"]
  education TEXT,

  -- Social
  linkedin TEXT,
  email TEXT,

  -- Assets (Supabase Storage URL)
  photo_url TEXT,

  -- Metadata
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  published_at TIMESTAMPTZ,
  draft BOOLEAN NOT NULL DEFAULT false,

  -- Hugo sync
  translation_key TEXT UNIQUE NOT NULL,
  hugo_date DATE NOT NULL,

  -- Constraints
  CONSTRAINT founders_slug_format CHECK (slug ~ '^[a-z0-9-]+$')
);

-- Indexes
CREATE INDEX idx_founders_country ON founders(country);
CREATE INDEX idx_founders_industry ON founders(industry);
CREATE INDEX idx_founders_published ON founders(published_at) WHERE draft = false;
CREATE INDEX idx_founders_slug ON founders(slug);
CREATE INDEX idx_founders_translation_key ON founders(translation_key);

-- Trigger for updated_at
CREATE TRIGGER founders_updated_at
  BEFORE UPDATE ON founders
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();
```

**Multilingual Content**: See `translations` table (entity_type = 'founder', entity_id = founder.id)

---

### 3. `insights`

**Purpose**: Market insights (language-agnostic data only)

```sql
CREATE TABLE insights (
  -- Identity
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT UNIQUE NOT NULL,  -- e.g., "seven-spices-spotlight"

  -- Insight Category
  insight_type TEXT NOT NULL,  -- "brand-spotlight" | "founders-journey" | "location-intelligence" | "market-momentum"

  -- Related Entities
  related_brand_ids UUID[],  -- Array of brand IDs
  related_founder_ids UUID[],  -- Array of founder IDs

  -- Metadata
  author TEXT,
  read_time INTEGER,  -- Minutes

  -- Assets (Supabase Storage URL)
  hero_image_url TEXT,

  -- Dates
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  published_at TIMESTAMPTZ,
  draft BOOLEAN NOT NULL DEFAULT false,

  -- Hugo sync
  translation_key TEXT UNIQUE NOT NULL,
  hugo_date DATE NOT NULL,

  -- Constraints
  CONSTRAINT insights_slug_format CHECK (slug ~ '^[a-z0-9-]+$'),
  CONSTRAINT insights_type_valid CHECK (insight_type IN (
    'brand-spotlight',
    'founders-journey',
    'location-intelligence',
    'market-momentum'
  ))
);

-- Indexes
CREATE INDEX idx_insights_type ON insights(insight_type);
CREATE INDEX idx_insights_published ON insights(published_at) WHERE draft = false;
CREATE INDEX idx_insights_slug ON insights(slug);
CREATE INDEX idx_insights_translation_key ON insights(translation_key);
CREATE INDEX idx_insights_related_brands ON insights USING GIN (related_brand_ids);
CREATE INDEX idx_insights_related_founders ON insights USING GIN (related_founder_ids);

-- Trigger for updated_at
CREATE TRIGGER insights_updated_at
  BEFORE UPDATE ON insights
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();
```

**Multilingual Content**: See `translations` table (entity_type = 'insight', entity_id = insight.id)

---

### 4. `dimensions`

**Purpose**: Taxonomy terms (SOURCE OF TRUTH) - 4 types: markets, sectors, attributes, signals

```sql
CREATE TABLE dimensions (
  -- Identity
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT NOT NULL,  -- e.g., "russia", "honey-bee-products"
  dimension_type TEXT NOT NULL,  -- "market" | "sector" | "attribute" | "signal"

  -- Display
  color_hex TEXT,  -- e.g., "#0EA5E9" for markets
  icon TEXT,  -- Icon identifier (if applicable)
  sort_order INTEGER DEFAULT 0,

  -- Metadata
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- Constraints
  UNIQUE(slug, dimension_type),
  CONSTRAINT dimensions_type_valid CHECK (dimension_type IN (
    'market',
    'sector',
    'attribute',
    'signal'
  ))
);

-- Indexes
CREATE INDEX idx_dimensions_type ON dimensions(dimension_type);
CREATE INDEX idx_dimensions_slug ON dimensions(slug);
CREATE INDEX idx_dimensions_sort ON dimensions(sort_order);

-- Trigger for updated_at
CREATE TRIGGER dimensions_updated_at
  BEFORE UPDATE ON dimensions
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();
```

**Multilingual Content**: See `translations` table (entity_type = 'dimension', entity_id = dimension.id)

**Critical**: This table is the **source of truth** for taxonomies. Hugo syncs FROM this table, not to it.

---

### 5. `translations`

**Purpose**: Multilingual content for all entities (brands, founders, insights, dimensions)

```sql
CREATE TABLE translations (
  -- Identity
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Entity Reference (polymorphic)
  entity_type TEXT NOT NULL,  -- "brand" | "founder" | "insight" | "dimension"
  entity_id UUID NOT NULL,  -- Foreign key to respective table

  -- Language
  language TEXT NOT NULL,  -- ISO 639-1: "en" | "ru" | "zh"

  -- Field Reference
  field_name TEXT NOT NULL,  -- "title" | "description" | "content" | "bio" | "role" | "summary" | "key_achievement"

  -- Content
  field_value TEXT NOT NULL,  -- The actual translated content

  -- Metadata
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- Constraints
  UNIQUE(entity_type, entity_id, language, field_name),
  CONSTRAINT translations_entity_type_valid CHECK (entity_type IN (
    'brand',
    'founder',
    'insight',
    'dimension'
  )),
  CONSTRAINT translations_language_valid CHECK (language IN ('en', 'ru', 'zh'))
);

-- Indexes
CREATE INDEX idx_translations_entity ON translations(entity_type, entity_id);
CREATE INDEX idx_translations_language ON translations(language);
CREATE INDEX idx_translations_field ON translations(field_name);

-- Composite index for fast lookups
CREATE INDEX idx_translations_lookup ON translations(entity_type, entity_id, language, field_name);

-- Trigger for updated_at
CREATE TRIGGER translations_updated_at
  BEFORE UPDATE ON translations
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();
```

**Sample Rows** (for Altai Honey brand):
```json
[
  {
    "entity_type": "brand",
    "entity_id": "uuid-of-altai-honey",
    "language": "en",
    "field_name": "title",
    "field_value": "Altai Gold Honey"
  },
  {
    "entity_type": "brand",
    "entity_id": "uuid-of-altai-honey",
    "language": "ru",
    "field_name": "title",
    "field_value": "Алтайский золотой мёд"
  },
  {
    "entity_type": "brand",
    "entity_id": "uuid-of-altai-honey",
    "language": "zh",
    "field_name": "title",
    "field_value": "阿尔泰金蜂蜜"
  },
  {
    "entity_type": "brand",
    "entity_id": "uuid-of-altai-honey",
    "language": "en",
    "field_name": "description",
    "field_value": "Premium wild honey from the pristine Altai Mountains..."
  },
  {
    "entity_type": "brand",
    "entity_id": "uuid-of-altai-honey",
    "language": "en",
    "field_name": "content",
    "field_value": "Altai Gold Honey sources the world's finest wild honey..."
  }
]
```

**Field Names by Entity Type**:

| Entity Type | Field Names |
|-------------|-------------|
| `brand` | `title`, `description`, `content` |
| `founder` | `title`, `bio`, `content`, `role`, `key_achievement` |
| `insight` | `title`, `summary`, `content` |
| `dimension` | `title`, `description` |

---

### 6. Junction Tables

#### `brand_markets`

```sql
CREATE TABLE brand_markets (
  brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
  dimension_id UUID NOT NULL REFERENCES dimensions(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  PRIMARY KEY (brand_id, dimension_id),
  CONSTRAINT fk_dimension_type CHECK (
    dimension_id IN (SELECT id FROM dimensions WHERE dimension_type = 'market')
  )
);

CREATE INDEX idx_brand_markets_brand ON brand_markets(brand_id);
CREATE INDEX idx_brand_markets_dimension ON brand_markets(dimension_id);
```

#### `brand_sectors`

```sql
CREATE TABLE brand_sectors (
  brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
  dimension_id UUID NOT NULL REFERENCES dimensions(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  PRIMARY KEY (brand_id, dimension_id),
  CONSTRAINT fk_dimension_type CHECK (
    dimension_id IN (SELECT id FROM dimensions WHERE dimension_type = 'sector')
  )
);

CREATE INDEX idx_brand_sectors_brand ON brand_sectors(brand_id);
CREATE INDEX idx_brand_sectors_dimension ON brand_sectors(dimension_id);
```

#### `brand_attributes`

```sql
CREATE TABLE brand_attributes (
  brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
  dimension_id UUID NOT NULL REFERENCES dimensions(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  PRIMARY KEY (brand_id, dimension_id),
  CONSTRAINT fk_dimension_type CHECK (
    dimension_id IN (SELECT id FROM dimensions WHERE dimension_type = 'attribute')
  )
);

CREATE INDEX idx_brand_attributes_brand ON brand_attributes(brand_id);
CREATE INDEX idx_brand_attributes_dimension ON brand_attributes(dimension_id);
```

#### `brand_signals`

```sql
CREATE TABLE brand_signals (
  brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
  dimension_id UUID NOT NULL REFERENCES dimensions(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  PRIMARY KEY (brand_id, dimension_id),
  CONSTRAINT fk_dimension_type CHECK (
    dimension_id IN (SELECT id FROM dimensions WHERE dimension_type = 'signal')
  )
);

CREATE INDEX idx_brand_signals_brand ON brand_signals(brand_id);
CREATE INDEX idx_brand_signals_dimension ON brand_signals(dimension_id);
```

#### `insight_markets`

```sql
CREATE TABLE insight_markets (
  insight_id UUID NOT NULL REFERENCES insights(id) ON DELETE CASCADE,
  dimension_id UUID NOT NULL REFERENCES dimensions(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  PRIMARY KEY (insight_id, dimension_id),
  CONSTRAINT fk_dimension_type CHECK (
    dimension_id IN (SELECT id FROM dimensions WHERE dimension_type = 'market')
  )
);

CREATE INDEX idx_insight_markets_insight ON insight_markets(insight_id);
CREATE INDEX idx_insight_markets_dimension ON insight_markets(dimension_id);
```

#### `insight_sectors`

```sql
CREATE TABLE insight_sectors (
  insight_id UUID NOT NULL REFERENCES insights(id) ON DELETE CASCADE,
  dimension_id UUID NOT NULL REFERENCES dimensions(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

  PRIMARY KEY (insight_id, dimension_id),
  CONSTRAINT fk_dimension_type CHECK (
    dimension_id IN (SELECT id FROM dimensions WHERE dimension_type = 'sector')
  )
);

CREATE INDEX idx_insight_sectors_insight ON insight_sectors(insight_id);
CREATE INDEX idx_insight_sectors_dimension ON insight_sectors(dimension_id);
```

---

## Supporting Functions

### Update Timestamp Trigger

```sql
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

---

## Supabase Storage Configuration

### Bucket Setup

```sql
-- Create storage buckets
INSERT INTO storage.buckets (id, name, public)
VALUES
  ('brand-images', 'brand-images', true),
  ('founder-images', 'founder-images', true),
  ('insight-images', 'insight-images', true),
  ('dimension-icons', 'dimension-icons', true);
```

### Storage Policies (RLS)

```sql
-- Public read access for all image buckets
CREATE POLICY "Public read brand images"
ON storage.objects FOR SELECT
USING (bucket_id = 'brand-images');

CREATE POLICY "Public read founder images"
ON storage.objects FOR SELECT
USING (bucket_id = 'founder-images');

CREATE POLICY "Public read insight images"
ON storage.objects FOR SELECT
USING (bucket_id = 'insight-images');

CREATE POLICY "Public read dimension icons"
ON storage.objects FOR SELECT
USING (bucket_id = 'dimension-icons');

-- Service role write access (sync script only)
CREATE POLICY "Service role write brand images"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'brand-images' AND auth.role() = 'service_role');

CREATE POLICY "Service role write founder images"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'founder-images' AND auth.role() = 'service_role');

CREATE POLICY "Service role write insight images"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'insight-images' AND auth.role() = 'service_role');

CREATE POLICY "Service role write dimension icons"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'dimension-icons' AND auth.role() = 'service_role');
```

### Image URL Pattern

```
https://<project-ref>.supabase.co/storage/v1/object/public/<bucket>/<path>

Examples:
https://abc123xyz.supabase.co/storage/v1/object/public/brand-images/altai-honey/logo-color.png
https://abc123xyz.supabase.co/storage/v1/object/public/founder-images/pavel-titov/portrait-formal.jpg
https://abc123xyz.supabase.co/storage/v1/object/public/insight-images/seven-spices-spotlight/hero-market.jpg
```

---

## Query Performance Patterns

### Get Brand with Translations (Single Language)

```sql
SELECT
  b.*,
  -- English translations
  (SELECT field_value FROM translations WHERE entity_type = 'brand' AND entity_id = b.id AND language = 'en' AND field_name = 'title') AS title,
  (SELECT field_value FROM translations WHERE entity_type = 'brand' AND entity_id = b.id AND language = 'en' AND field_name = 'description') AS description,
  (SELECT field_value FROM translations WHERE entity_type = 'brand' AND entity_id = b.id AND language = 'en' AND field_name = 'content') AS content,
  -- Founder
  f.slug AS founder_slug,
  (SELECT field_value FROM translations WHERE entity_type = 'founder' AND entity_id = f.id AND language = 'en' AND field_name = 'title') AS founder_name
FROM brands b
LEFT JOIN founders f ON b.founder_id = f.id
WHERE b.slug = 'altai-honey'
  AND b.draft = false;
```

### Get All Brands with Taxonomies (Optimized)

```sql
SELECT
  b.id,
  b.slug,
  t_title.field_value AS title,
  t_desc.field_value AS description,
  b.logo_url,
  b.founded,
  -- Markets
  ARRAY_AGG(DISTINCT dt_market.field_value) FILTER (WHERE d_market.dimension_type = 'market') AS markets,
  -- Sectors
  ARRAY_AGG(DISTINCT dt_sector.field_value) FILTER (WHERE d_sector.dimension_type = 'sector') AS sectors
FROM brands b
-- Translations for brand
LEFT JOIN translations t_title ON t_title.entity_type = 'brand' AND t_title.entity_id = b.id AND t_title.language = 'en' AND t_title.field_name = 'title'
LEFT JOIN translations t_desc ON t_desc.entity_type = 'brand' AND t_desc.entity_id = b.id AND t_desc.language = 'en' AND t_desc.field_name = 'description'
-- Markets
LEFT JOIN brand_markets bm ON b.id = bm.brand_id
LEFT JOIN dimensions d_market ON bm.dimension_id = d_market.id
LEFT JOIN translations dt_market ON dt_market.entity_type = 'dimension' AND dt_market.entity_id = d_market.id AND dt_market.language = 'en' AND dt_market.field_name = 'title'
-- Sectors
LEFT JOIN brand_sectors bs ON b.id = bs.brand_id
LEFT JOIN dimensions d_sector ON bs.dimension_id = d_sector.id
LEFT JOIN translations dt_sector ON dt_sector.entity_type = 'dimension' AND dt_sector.entity_id = d_sector.id AND dt_sector.language = 'en' AND dt_sector.field_name = 'title'
WHERE b.draft = false
GROUP BY b.id, t_title.field_value, t_desc.field_value
ORDER BY b.published_at DESC;
```

### Filter Brands by Market

```sql
SELECT DISTINCT b.*
FROM brands b
JOIN brand_markets bm ON b.id = bm.brand_id
JOIN dimensions d ON bm.dimension_id = d.id
WHERE d.slug = 'russia'
  AND b.draft = false
ORDER BY b.published_at DESC;
```

---

## Database as Taxonomy Source of Truth

### Workflow

```
Supabase (dimensions table) → Sync Script → Hugo (content/dimensions/)
```

**Critical**: Taxonomy changes are made in Supabase first, then synced to Hugo.

### Why Database is Source of Truth

1. **Single Management Interface**: Edit taxonomies in Supabase dashboard
2. **API-Driven**: Future applications can query taxonomies via API
3. **Referential Integrity**: Foreign key constraints prevent orphaned taxonomy references
4. **Versioning**: `updated_at` timestamps track taxonomy changes
5. **Scalability**: Adding new dimension values doesn't require Hugo rebuild

### Sync Direction

| Data Type | Source of Truth | Sync Direction |
|-----------|-----------------|----------------|
| Taxonomies (dimensions) | **Supabase** | Supabase → Hugo |
| Content (brands/founders/insights) | **Hugo** | Hugo → Supabase |
| Images | **Supabase Storage** | Upload → Supabase, reference in Hugo |

---

## Row-Level Security (RLS) Policies

### Enable RLS

```sql
ALTER TABLE brands ENABLE ROW LEVEL SECURITY;
ALTER TABLE founders ENABLE ROW LEVEL SECURITY;
ALTER TABLE insights ENABLE ROW LEVEL SECURITY;
ALTER TABLE dimensions ENABLE ROW LEVEL SECURITY;
ALTER TABLE translations ENABLE ROW LEVEL SECURITY;
```

### Public Read Policies

```sql
-- Public read access (published content only)
CREATE POLICY "Public brands read" ON brands
  FOR SELECT USING (draft = false);

CREATE POLICY "Public founders read" ON founders
  FOR SELECT USING (draft = false);

CREATE POLICY "Public insights read" ON insights
  FOR SELECT USING (draft = false);

CREATE POLICY "Public dimensions read" ON dimensions
  FOR SELECT USING (true);

CREATE POLICY "Public translations read" ON translations
  FOR SELECT USING (true);
```

### Admin Write Policies

```sql
-- Admin write access (service role only)
CREATE POLICY "Admin brands write" ON brands
  FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Admin founders write" ON founders
  FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Admin insights write" ON insights
  FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Admin dimensions write" ON dimensions
  FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Admin translations write" ON translations
  FOR ALL USING (auth.role() = 'service_role');
```

### Junction Table Policies

```sql
-- Public read, service role write
CREATE POLICY "Public read brand_markets" ON brand_markets
  FOR SELECT USING (true);

CREATE POLICY "Admin write brand_markets" ON brand_markets
  FOR ALL USING (auth.role() = 'service_role');

-- Repeat for: brand_sectors, brand_attributes, brand_signals, insight_markets, insight_sectors
```

---

## Search Strategy: Pagefind Only

**Decision**: No PostgreSQL full-text search. Pagefind handles all search.

**Rationale**:
- ✅ Pagefind already implemented and working (170 pages indexed)
- ✅ Static search = no database load, instant results
- ✅ Multilingual support built-in
- ✅ Taxonomy filtering via data attributes
- ✅ Privacy-friendly (no tracking)
- ❌ PostgreSQL full-text search = additional complexity, maintenance burden
- ❌ Duplicate functionality (Pagefind already does this better)

**Supabase Role**: Fast API access for dynamic content (future mobile app, admin dashboard), NOT search.

---

## Data Volume Projections

### Current State (October 2025)

| Entity | Count | Translations | Total Rows |
|--------|-------|--------------|------------|
| Brands | 6 | 6 × 3 langs × 3 fields = 54 | 60 |
| Founders | 4 | 4 × 3 langs × 5 fields = 60 | 64 |
| Insights | 4 | 4 × 3 langs × 3 fields = 36 | 40 |
| Dimensions | 44 | 44 × 3 langs × 2 fields = 264 | 308 |
| **Total** | **58** | **414** | **472 rows** |

**Database Size**: ~500 KB (well within Supabase free tier: 500 MB)

### Scale Projections (Year 1)

| Entity | Year 1 Target | Translations | Total Rows |
|--------|---------------|--------------|------------|
| Brands | 100 | 100 × 3 × 3 = 900 | 1,000 |
| Founders | 50 | 50 × 3 × 5 = 750 | 800 |
| Insights | 100 | 100 × 3 × 3 = 900 | 1,000 |
| Dimensions | 60 | 60 × 3 × 2 = 360 | 420 |
| **Total** | **310** | **2,910** | **3,220 rows** |

**Database Size**: ~5 MB (well within free tier)

---

## Hugo Sync Strategy

### Sync Flow

```
Content Creation:
  Hugo (markdown) → Sync Script → Supabase (brands/founders/insights + translations)

Taxonomy Management:
  Supabase (dimensions) → Sync Script → Hugo (content/dimensions/)

Image Management:
  Local Files → Upload Script → Supabase Storage → URLs stored in database
```

### Sync Script Responsibilities

1. **Parse Hugo front matter** (YAML)
2. **Extract multilingual content** (read `_index.en.md`, `_index.ru.md`, `_index.zh.md`)
3. **Upload images to Supabase Storage** (if not already uploaded)
4. **Upsert entity rows** (brands/founders/insights)
5. **Upsert translation rows** (for each language + field)
6. **Resolve relationships** (founder slugs → UUIDs, taxonomy slugs → dimension UUIDs)
7. **Update junction tables** (brand_markets, etc.)
8. **Pull dimensions** (sync Supabase dimensions → Hugo)
9. **Log sync results**

### Sync Frequency

- **Development**: On-demand via `npm run sync`
- **Production**: GitHub Actions on push to `main` branch
- **Taxonomy Updates**: Manual in Supabase, then run sync script to update Hugo

---

## API Usage Examples

### JavaScript (Supabase Client)

```javascript
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_ANON_KEY
)

// Get all brands (English) with translations
const { data: brands } = await supabase
  .from('brands')
  .select(`
    id,
    slug,
    founded,
    logo_url,
    translations!inner(field_name, field_value)
  `)
  .eq('translations.language', 'en')
  .eq('draft', false)

// Parse translations into object
const brandsWithTranslations = brands.map(brand => ({
  ...brand,
  title: brand.translations.find(t => t.field_name === 'title')?.field_value,
  description: brand.translations.find(t => t.field_name === 'description')?.field_value,
  content: brand.translations.find(t => t.field_name === 'content')?.field_value
}))

// Get brand with taxonomies
const { data: brand } = await supabase
  .from('brands')
  .select(`
    *,
    translations!inner(language, field_name, field_value),
    brand_markets(dimension:dimension_id(
      slug,
      translations!inner(language, field_name, field_value)
    ))
  `)
  .eq('slug', 'altai-honey')
  .eq('translations.language', 'en')
  .single()
```

---

## Migration Plan

### Phase 1: Schema Creation (Day 16)

1. Create Supabase project (`brandmine-prod`)
2. Run schema SQL (all CREATE TABLE statements)
3. Run trigger functions
4. Enable RLS policies
5. Create storage buckets
6. Verify schema in Supabase dashboard

### Phase 2: Initial Data Load (Day 17)

1. Manually insert dimension data (44 dimensions × 3 langs = 132 translation rows)
2. Verify dimension data
3. Test dimension queries

### Phase 3: Sync Script Development (Day 18)

1. Create `scripts/sync-to-supabase.js`
2. Parse Hugo markdown
3. Upload images to Supabase Storage
4. Build entity + translation inserts
5. Resolve relationships
6. Test with current 6 brands

### Phase 4: Production Deployment (Day 20)

1. Full sync of all content
2. Add GitHub Actions workflow
3. Configure secrets
4. Monitor sync logs
5. Verify data in Supabase

---

## Success Metrics

- **Sync Speed**: < 10 seconds for full sync (6 brands + 4 founders + 4 insights)
- **Query Performance**: < 200ms for brand list with translations
- **Data Accuracy**: 100% parity between Hugo and Supabase
- **Uptime**: 99.9% (Supabase SLA)
- **Storage**: < 10 MB database + < 50 MB images (well within free tier)

---

## Summary of CEO-Approved Changes

1. ✅ **Relational Translations**: Separate `translations` table (not JSONB)
2. ✅ **Supabase Storage**: All images in Supabase buckets
3. ✅ **Public API Access**: RLS policies enable public read
4. ✅ **No PostgreSQL Search**: Pagefind handles all search
5. ✅ **Database as Taxonomy Source**: Dimensions managed in Supabase first

---

**Status**: CEO Approved - Ready for Implementation
**Next**: Create Supabase project and run migrations (Day 16)
**Timeline**: Day 16 (Schema) → Day 17 (Dimensions) → Day 18 (Sync Script) → Day 20 (Deploy)
