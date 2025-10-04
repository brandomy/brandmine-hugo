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
