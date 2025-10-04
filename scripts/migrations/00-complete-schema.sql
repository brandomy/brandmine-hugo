-- Brandmine Supabase Schema Migration
-- Phase 1: Create Tables
-- Date: 2025-10-03

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================================
-- SUPPORTING FUNCTIONS
-- ============================================================================

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================================
-- CORE TABLES
-- ============================================================================

-- 1. BRANDS TABLE
CREATE TABLE brands (
  -- Identity
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT UNIQUE NOT NULL,

  -- Relationships
  founder_id UUID,  -- Foreign key added later

  -- Business Details
  founded INTEGER,
  employees TEXT,
  revenue TEXT,
  website TEXT,

  -- Location
  headquarters_city TEXT,
  headquarters_country TEXT,
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

-- 2. FOUNDERS TABLE
CREATE TABLE founders (
  -- Identity
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT UNIQUE NOT NULL,

  -- Professional
  industry TEXT,
  years_experience INTEGER,
  expertise TEXT[],

  -- Personal
  city TEXT,
  country TEXT,
  languages TEXT[],
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

-- Add foreign key from brands to founders (now that founders table exists)
ALTER TABLE brands
ADD CONSTRAINT brands_founder_fkey
FOREIGN KEY (founder_id) REFERENCES founders(id) ON DELETE SET NULL;

-- 3. INSIGHTS TABLE
CREATE TABLE insights (
  -- Identity
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT UNIQUE NOT NULL,

  -- Insight Category
  insight_type TEXT NOT NULL,

  -- Related Entities
  related_brand_ids UUID[],
  related_founder_ids UUID[],

  -- Metadata
  author TEXT,
  read_time INTEGER,

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

-- 4. DIMENSIONS TABLE (SOURCE OF TRUTH for taxonomies)
CREATE TABLE dimensions (
  -- Identity
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug TEXT NOT NULL,
  dimension_type TEXT NOT NULL,

  -- Display
  color_hex TEXT,
  icon TEXT,
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

-- 5. TRANSLATIONS TABLE
CREATE TABLE translations (
  -- Identity
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Entity Reference (polymorphic)
  entity_type TEXT NOT NULL,
  entity_id UUID NOT NULL,

  -- Language
  language TEXT NOT NULL,

  -- Field Reference
  field_name TEXT NOT NULL,

  -- Content
  field_value TEXT NOT NULL,

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

-- ============================================================================
-- JUNCTION TABLES (Many-to-Many)
-- ============================================================================

-- Brand Taxonomies
CREATE TABLE brand_markets (
  brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
  dimension_id UUID NOT NULL REFERENCES dimensions(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (brand_id, dimension_id)
);

CREATE TABLE brand_sectors (
  brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
  dimension_id UUID NOT NULL REFERENCES dimensions(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (brand_id, dimension_id)
);

CREATE TABLE brand_attributes (
  brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
  dimension_id UUID NOT NULL REFERENCES dimensions(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (brand_id, dimension_id)
);

CREATE TABLE brand_signals (
  brand_id UUID NOT NULL REFERENCES brands(id) ON DELETE CASCADE,
  dimension_id UUID NOT NULL REFERENCES dimensions(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (brand_id, dimension_id)
);

-- Insight Taxonomies
CREATE TABLE insight_markets (
  insight_id UUID NOT NULL REFERENCES insights(id) ON DELETE CASCADE,
  dimension_id UUID NOT NULL REFERENCES dimensions(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (insight_id, dimension_id)
);

CREATE TABLE insight_sectors (
  insight_id UUID NOT NULL REFERENCES insights(id) ON DELETE CASCADE,
  dimension_id UUID NOT NULL REFERENCES dimensions(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (insight_id, dimension_id)
);

-- Migration complete
SELECT 'Phase 1: Tables created successfully' AS status;
-- Brandmine Supabase Schema Migration
-- Phase 2: Create Indexes
-- Date: 2025-10-03

-- ============================================================================
-- BRANDS INDEXES
-- ============================================================================

CREATE INDEX idx_brands_founder ON brands(founder_id);
CREATE INDEX idx_brands_country ON brands(headquarters_country);
CREATE INDEX idx_brands_published ON brands(published_at) WHERE draft = false;
CREATE INDEX idx_brands_slug ON brands(slug);
CREATE INDEX idx_brands_translation_key ON brands(translation_key);

-- ============================================================================
-- FOUNDERS INDEXES
-- ============================================================================

CREATE INDEX idx_founders_country ON founders(country);
CREATE INDEX idx_founders_industry ON founders(industry);
CREATE INDEX idx_founders_published ON founders(published_at) WHERE draft = false;
CREATE INDEX idx_founders_slug ON founders(slug);
CREATE INDEX idx_founders_translation_key ON founders(translation_key);

-- ============================================================================
-- INSIGHTS INDEXES
-- ============================================================================

CREATE INDEX idx_insights_type ON insights(insight_type);
CREATE INDEX idx_insights_published ON insights(published_at) WHERE draft = false;
CREATE INDEX idx_insights_slug ON insights(slug);
CREATE INDEX idx_insights_translation_key ON insights(translation_key);
CREATE INDEX idx_insights_related_brands ON insights USING GIN (related_brand_ids);
CREATE INDEX idx_insights_related_founders ON insights USING GIN (related_founder_ids);

-- ============================================================================
-- DIMENSIONS INDEXES
-- ============================================================================

CREATE INDEX idx_dimensions_type ON dimensions(dimension_type);
CREATE INDEX idx_dimensions_slug ON dimensions(slug);
CREATE INDEX idx_dimensions_sort ON dimensions(sort_order);

-- ============================================================================
-- TRANSLATIONS INDEXES
-- ============================================================================

CREATE INDEX idx_translations_entity ON translations(entity_type, entity_id);
CREATE INDEX idx_translations_language ON translations(language);
CREATE INDEX idx_translations_field ON translations(field_name);

-- Composite index for fast lookups
CREATE INDEX idx_translations_lookup ON translations(entity_type, entity_id, language, field_name);

-- ============================================================================
-- JUNCTION TABLE INDEXES
-- ============================================================================

-- Brand taxonomies
CREATE INDEX idx_brand_markets_brand ON brand_markets(brand_id);
CREATE INDEX idx_brand_markets_dimension ON brand_markets(dimension_id);

CREATE INDEX idx_brand_sectors_brand ON brand_sectors(brand_id);
CREATE INDEX idx_brand_sectors_dimension ON brand_sectors(dimension_id);

CREATE INDEX idx_brand_attributes_brand ON brand_attributes(brand_id);
CREATE INDEX idx_brand_attributes_dimension ON brand_attributes(dimension_id);

CREATE INDEX idx_brand_signals_brand ON brand_signals(brand_id);
CREATE INDEX idx_brand_signals_dimension ON brand_signals(dimension_id);

-- Insight taxonomies
CREATE INDEX idx_insight_markets_insight ON insight_markets(insight_id);
CREATE INDEX idx_insight_markets_dimension ON insight_markets(dimension_id);

CREATE INDEX idx_insight_sectors_insight ON insight_sectors(insight_id);
CREATE INDEX idx_insight_sectors_dimension ON insight_sectors(dimension_id);

-- Migration complete
SELECT 'Phase 2: Indexes created successfully' AS status;
-- Brandmine Supabase Schema Migration
-- Phase 3: Create Triggers
-- Date: 2025-10-03

-- ============================================================================
-- UPDATE TIMESTAMP TRIGGERS
-- ============================================================================

-- Brands
CREATE TRIGGER brands_updated_at
  BEFORE UPDATE ON brands
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- Founders
CREATE TRIGGER founders_updated_at
  BEFORE UPDATE ON founders
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- Insights
CREATE TRIGGER insights_updated_at
  BEFORE UPDATE ON insights
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- Dimensions
CREATE TRIGGER dimensions_updated_at
  BEFORE UPDATE ON dimensions
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- Translations
CREATE TRIGGER translations_updated_at
  BEFORE UPDATE ON translations
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- Migration complete
SELECT 'Phase 3: Triggers created successfully' AS status;
-- Brandmine Supabase Schema Migration
-- Phase 4: Enable Row-Level Security (RLS)
-- Date: 2025-10-03

-- ============================================================================
-- ENABLE RLS ON ALL TABLES
-- ============================================================================

ALTER TABLE brands ENABLE ROW LEVEL SECURITY;
ALTER TABLE founders ENABLE ROW LEVEL SECURITY;
ALTER TABLE insights ENABLE ROW LEVEL SECURITY;
ALTER TABLE dimensions ENABLE ROW LEVEL SECURITY;
ALTER TABLE translations ENABLE ROW LEVEL SECURITY;
ALTER TABLE brand_markets ENABLE ROW LEVEL SECURITY;
ALTER TABLE brand_sectors ENABLE ROW LEVEL SECURITY;
ALTER TABLE brand_attributes ENABLE ROW LEVEL SECURITY;
ALTER TABLE brand_signals ENABLE ROW LEVEL SECURITY;
ALTER TABLE insight_markets ENABLE ROW LEVEL SECURITY;
ALTER TABLE insight_sectors ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- PUBLIC READ POLICIES (Published content only)
-- ============================================================================

-- Brands
CREATE POLICY "Public brands read" ON brands
  FOR SELECT USING (draft = false);

-- Founders
CREATE POLICY "Public founders read" ON founders
  FOR SELECT USING (draft = false);

-- Insights
CREATE POLICY "Public insights read" ON insights
  FOR SELECT USING (draft = false);

-- Dimensions (always public)
CREATE POLICY "Public dimensions read" ON dimensions
  FOR SELECT USING (true);

-- Translations (always public)
CREATE POLICY "Public translations read" ON translations
  FOR SELECT USING (true);

-- Junction tables (always public)
CREATE POLICY "Public read brand_markets" ON brand_markets
  FOR SELECT USING (true);

CREATE POLICY "Public read brand_sectors" ON brand_sectors
  FOR SELECT USING (true);

CREATE POLICY "Public read brand_attributes" ON brand_attributes
  FOR SELECT USING (true);

CREATE POLICY "Public read brand_signals" ON brand_signals
  FOR SELECT USING (true);

CREATE POLICY "Public read insight_markets" ON insight_markets
  FOR SELECT USING (true);

CREATE POLICY "Public read insight_sectors" ON insight_sectors
  FOR SELECT USING (true);

-- ============================================================================
-- ADMIN WRITE POLICIES (Service role only)
-- ============================================================================

-- Brands
CREATE POLICY "Admin brands write" ON brands
  FOR ALL USING (auth.role() = 'service_role');

-- Founders
CREATE POLICY "Admin founders write" ON founders
  FOR ALL USING (auth.role() = 'service_role');

-- Insights
CREATE POLICY "Admin insights write" ON insights
  FOR ALL USING (auth.role() = 'service_role');

-- Dimensions
CREATE POLICY "Admin dimensions write" ON dimensions
  FOR ALL USING (auth.role() = 'service_role');

-- Translations
CREATE POLICY "Admin translations write" ON translations
  FOR ALL USING (auth.role() = 'service_role');

-- Junction tables
CREATE POLICY "Admin write brand_markets" ON brand_markets
  FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Admin write brand_sectors" ON brand_sectors
  FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Admin write brand_attributes" ON brand_attributes
  FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Admin write brand_signals" ON brand_signals
  FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Admin write insight_markets" ON insight_markets
  FOR ALL USING (auth.role() = 'service_role');

CREATE POLICY "Admin write insight_sectors" ON insight_sectors
  FOR ALL USING (auth.role() = 'service_role');

-- Migration complete
SELECT 'Phase 4: RLS policies created successfully' AS status;
