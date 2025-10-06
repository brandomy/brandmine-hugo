-- Purpose: Auto-delete contacts older than 2 years (GDPR compliance)
-- Created: 2025-10-06
-- Applied to Production: [PENDING]
-- Prerequisites: 001-contacts-table.sql
-- Note: Requires pg_cron extension to be enabled in Supabase

-- Function to delete old contacts
CREATE OR REPLACE FUNCTION delete_old_contacts()
RETURNS void AS $$
BEGIN
  DELETE FROM contacts
  WHERE created_at < NOW() - INTERVAL '2 years';
END;
$$ LANGUAGE plpgsql;

-- Schedule via pg_cron (run on first day of each month at midnight)
-- Note: Uncomment and run separately after enabling pg_cron extension
-- SELECT cron.schedule(
--   'delete-old-contacts',
--   '0 0 1 * *',
--   'SELECT delete_old_contacts();'
-- );
