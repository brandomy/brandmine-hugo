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
