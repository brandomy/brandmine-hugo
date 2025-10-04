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
