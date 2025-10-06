-- Purpose: Prevent duplicate contact submissions from same email within 5 minutes
-- Created: 2025-10-06
-- Applied to Production: [PENDING]
-- Prerequisites: 001-contacts-table.sql

CREATE OR REPLACE FUNCTION prevent_duplicate_contacts()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM contacts
    WHERE email = NEW.email
      AND created_at > NOW() - INTERVAL '5 minutes'
  ) THEN
    RAISE EXCEPTION 'Duplicate submission. Please wait 5 minutes before resubmitting.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_duplicate_contact
  BEFORE INSERT ON contacts
  FOR EACH ROW
  EXECUTE FUNCTION prevent_duplicate_contacts();
