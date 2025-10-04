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
