-- Common Queries for Contacts Table
-- Use these in Supabase SQL Editor for data analysis and reporting

-- ============================================================================
-- BASIC QUERIES
-- ============================================================================

-- Get all contacts from last 7 days
SELECT * FROM contacts
WHERE created_at >= NOW() - INTERVAL '7 days'
ORDER BY created_at DESC;

-- Get contacts by type
SELECT contact_type, COUNT(*) as count
FROM contacts
GROUP BY contact_type
ORDER BY count DESC;

-- Get contacts by country
SELECT country, COUNT(*) as count
FROM contacts
WHERE country IS NOT NULL
GROUP BY country
ORDER BY count DESC;

-- Search contacts by email
SELECT * FROM contacts
WHERE email ILIKE '%example.com%'
ORDER BY created_at DESC;

-- Get contacts by source page
SELECT source, COUNT(*) as count
FROM contacts
WHERE source IS NOT NULL
GROUP BY source
ORDER BY count DESC;

-- ============================================================================
-- ANALYTICS & REPORTING
-- ============================================================================

-- Contacts by month
SELECT
  DATE_TRUNC('month', created_at) AS month,
  COUNT(*) as total,
  COUNT(*) FILTER (WHERE contact_type = 'brand') as brands,
  COUNT(*) FILTER (WHERE contact_type = 'partner') as partners,
  COUNT(*) FILTER (WHERE contact_type = 'job_seeker') as job_seekers
FROM contacts
WHERE created_at >= NOW() - INTERVAL '6 months'
GROUP BY month
ORDER BY month DESC;

-- Top referral sources
SELECT
  referral_source,
  COUNT(*) as count,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) as percentage
FROM contacts
WHERE referral_source IS NOT NULL
GROUP BY referral_source
ORDER BY count DESC;

-- Geographic distribution
SELECT
  country,
  COUNT(*) as count,
  COUNT(*) FILTER (WHERE contact_type = 'brand') as brand_inquiries,
  COUNT(*) FILTER (WHERE contact_type = 'partner') as partner_inquiries
FROM contacts
WHERE country IS NOT NULL
GROUP BY country
ORDER BY count DESC
LIMIT 10;

-- Contacts by source page and type
SELECT
  source,
  contact_type,
  COUNT(*) as count
FROM contacts
GROUP BY source, contact_type
ORDER BY source, count DESC;

-- ============================================================================
-- GDPR COMPLIANCE
-- ============================================================================

-- Export all data for a specific email (GDPR request)
SELECT
  id,
  name,
  email,
  contact_type,
  company,
  message,
  referral_source,
  country,
  source,
  created_at
FROM contacts
WHERE email = 'user@example.com'
ORDER BY created_at DESC;

-- Delete all data for a specific email (GDPR request)
DELETE FROM contacts WHERE email = 'user@example.com';

-- ============================================================================
-- MAINTENANCE
-- ============================================================================

-- Check for duplicate submissions in last hour
SELECT email, COUNT(*) as submissions
FROM contacts
WHERE created_at > NOW() - INTERVAL '1 hour'
GROUP BY email
HAVING COUNT(*) > 1
ORDER BY submissions DESC;

-- Recent contacts with full details
SELECT
  name,
  email,
  contact_type,
  company,
  country,
  source,
  LEFT(message, 100) as message_preview,
  created_at
FROM contacts
ORDER BY created_at DESC
LIMIT 20;
