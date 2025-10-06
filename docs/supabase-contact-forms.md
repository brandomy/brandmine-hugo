# Supabase Contact Forms Schema

## Overview

Separate database tables for managing contact inquiries from the About page and future brand/partner signup pages.

**Last Updated**: 2025-10-06

## Database Tables

### 1. Contacts Table

**Purpose**: Store all general contact form submissions from the About page

**Schema**:

```sql
-- Create contacts table
CREATE TABLE contacts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  contact_type TEXT NOT NULL, -- 'brand', 'partner', 'job_seeker', 'other'
  company TEXT,
  message TEXT NOT NULL,
  referral_source TEXT, -- 'search', 'linkedin', 'referral', 'other'
  country TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add indexes for common queries
CREATE INDEX idx_contacts_email ON contacts(email);
CREATE INDEX idx_contacts_type ON contacts(contact_type);
CREATE INDEX idx_contacts_created ON contacts(created_at DESC);

-- Enable Row Level Security (RLS)
ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;

-- Create policy for anonymous inserts (form submissions)
CREATE POLICY "Allow anonymous inserts" ON contacts
  FOR INSERT
  WITH CHECK (true);

-- Create policy for authenticated reads (admin access)
CREATE POLICY "Allow authenticated reads" ON contacts
  FOR SELECT
  USING (auth.role() = 'authenticated');
```

## Setup Instructions

### 1. Create Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Create a new project (or use existing `brandmine-prod`)
3. Save your project URL and anon key

### 2. Run SQL Schema

1. Open Supabase SQL Editor
2. Copy and paste the schema above
3. Run the SQL to create table and policies

### 3. Configure Environment Variables

**✅ Already Configured**: Credentials exist in `.env.local` (project root)

```bash
# File: .env.local (already exists - DO NOT COMMIT)
SUPABASE_URL=https://wcfhbzbmxztdzwjaujoq.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**IMPORTANT**: Hugo does NOT automatically load `.env.local` files. You must export the variables to your shell environment.

**For Local Development**:

Option 1: Export variables manually before running Hugo:
```bash
export SUPABASE_URL=https://wcfhbzbmxztdzwjaujoq.supabase.co
export SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
hugo server
```

Option 2: Load from .env.local using source (recommended):
```bash
set -a && source .env.local && set +a && hugo server
```

Option 3: Use direnv (if installed):
```bash
# Create .envrc file
echo "dotenv .env.local" > .envrc
direnv allow
hugo server
```

**For Production (Cloudflare Pages)**:
Add environment variables in Cloudflare Pages dashboard:
- `SUPABASE_URL=https://wcfhbzbmxztdzwjaujoq.supabase.co`
- `SUPABASE_ANON_KEY=[copy from .env.local]`

### 4. Update Contact Form Credentials

**Current Implementation**: Hardcoded placeholder in `layouts/partials/contact-form.html`

```javascript
// TODO: Replace with actual credentials
const SUPABASE_URL = 'YOUR_SUPABASE_URL';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
```

**Update to use environment variables**:

```javascript
const SUPABASE_URL = '{{ getenv "SUPABASE_URL" }}';
const SUPABASE_ANON_KEY = '{{ getenv "SUPABASE_ANON_KEY" }}';
```

**Note**: Hugo's `getenv` function will read from `.env.local` during local development and from Cloudflare Pages environment variables in production.

## Data Access

### Admin Dashboard

Access contact submissions through Supabase Dashboard:
- **Table Editor**: `https://app.supabase.com/project/<project-id>/editor/contacts`
- **SQL Editor**: Run custom queries
- **API**: Auto-generated REST endpoints

### Common Queries

**Get all contacts from last 7 days:**
```sql
SELECT * FROM contacts
WHERE created_at >= NOW() - INTERVAL '7 days'
ORDER BY created_at DESC;
```

**Get contacts by type:**
```sql
SELECT contact_type, COUNT(*) as count
FROM contacts
GROUP BY contact_type
ORDER BY count DESC;
```

**Get contacts by country:**
```sql
SELECT country, COUNT(*) as count
FROM contacts
WHERE country IS NOT NULL
GROUP BY country
ORDER BY count DESC;
```

**Search contacts by email:**
```sql
SELECT * FROM contacts
WHERE email ILIKE '%example.com%'
ORDER BY created_at DESC;
```

## Email Notifications (Recommended)

### Option 1: Supabase Database Webhooks

Configure Supabase to send POST requests when new contacts are created:

1. Go to Supabase Dashboard → Database → Webhooks
2. Add new webhook:
   - **Table**: `contacts`
   - **Events**: `INSERT`
   - **Type**: `HTTP Request`
   - **URL**: Your notification service (Zapier, Make.com, custom endpoint)
   - **Method**: `POST`

**Webhook Payload**:
```json
{
  "type": "INSERT",
  "table": "contacts",
  "record": {
    "id": "uuid",
    "name": "John Doe",
    "email": "john@example.com",
    "contact_type": "brand",
    "message": "..."
  },
  "old_record": null
}
```

### Option 2: Email Service Integration (Zapier)

1. Create Zapier workflow:
   - **Trigger**: Supabase Row Added (contacts table)
   - **Action**: Send Email (Gmail/SendGrid/Mailgun)

2. Email Template:
```
New Contact: {contact_type}

Name: {name}
Email: {email}
Company: {company}
Country: {country}

Message:
{message}

Referral Source: {referral_source}
Submitted: {created_at}

View in Supabase: https://app.supabase.com/project/PROJECT_ID/editor/contacts
```

### Option 3: Supabase Edge Function

Create a serverless function to send emails:

```javascript
// supabase/functions/notify-contact/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

serve(async (req) => {
  const { record } = await req.json()

  // Send email via SendGrid
  const response = await fetch('https://api.sendgrid.com/v3/mail/send', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${Deno.env.get('SENDGRID_API_KEY')}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      personalizations: [{
        to: [{ email: 'admin@brandmine.com' }],
        subject: `New ${record.contact_type} contact: ${record.name}`
      }],
      from: { email: 'noreply@brandmine.com' },
      content: [{
        type: 'text/plain',
        value: `
          Name: ${record.name}
          Email: ${record.email}
          Type: ${record.contact_type}
          Company: ${record.company || 'N/A'}
          Country: ${record.country || 'N/A'}

          Message:
          ${record.message}

          Referral Source: ${record.referral_source || 'Not specified'}
        `
      }]
    })
  })

  return new Response(JSON.stringify({ success: true }), {
    headers: { "Content-Type": "application/json" }
  })
})
```

**Database Trigger**:
```sql
CREATE OR REPLACE FUNCTION notify_new_contact()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM net.http_post(
    url := 'https://your-project.supabase.co/functions/v1/notify-contact',
    headers := '{"Content-Type": "application/json", "Authorization": "Bearer YOUR_SERVICE_KEY"}'::jsonb,
    body := json_build_object('record', row_to_json(NEW))::jsonb
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_contact_created
  AFTER INSERT ON contacts
  FOR EACH ROW
  EXECUTE FUNCTION notify_new_contact();
```

## Data Privacy & GDPR Compliance

### Data Retention Policy

**Auto-delete contacts older than 2 years:**

```sql
-- Function to delete old contacts
CREATE OR REPLACE FUNCTION delete_old_contacts()
RETURNS void AS $$
BEGIN
  DELETE FROM contacts
  WHERE created_at < NOW() - INTERVAL '2 years';
END;
$$ LANGUAGE plpgsql;

-- Schedule via pg_cron (if extension enabled)
SELECT cron.schedule(
  'delete-old-contacts',
  '0 0 1 * *', -- First day of each month at midnight
  'SELECT delete_old_contacts();'
);
```

### User Data Export (GDPR Request)

```sql
-- Export all data for a specific email
SELECT
  id,
  name,
  email,
  contact_type,
  company,
  message,
  referral_source,
  country,
  created_at
FROM contacts
WHERE email = 'user@example.com'
ORDER BY created_at DESC;
```

### User Data Deletion (GDPR Request)

```sql
-- Delete all data for a specific email
DELETE FROM contacts WHERE email = 'user@example.com';
```

## Security Best Practices

### Implemented ✅

- [x] Row Level Security (RLS) enabled
- [x] Anonymous users can only INSERT (not read)
- [x] Only authenticated admins can read data
- [x] Anon key used in client (not service key)
- [x] Email validation on client side (HTML5 required attribute)

### Recommended Enhancements

- [ ] **Rate Limiting**: Implement Cloudflare rate limiting (5 requests/minute per IP)
- [ ] **Spam Protection**: Add Turnstile or reCAPTCHA to form
- [ ] **Email Validation**: Server-side email format validation via database trigger
- [ ] **Duplicate Prevention**: Check for duplicate submissions (same email + 5 min window)
- [ ] **Honeypot Field**: Add hidden field to catch bots

### Example: Duplicate Prevention Trigger

```sql
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
```

## Future Tables (Optional)

### 2. Brand Inquiries Table

For dedicated `/brand-signup/` page:

```sql
CREATE TABLE brand_inquiries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  brand_name TEXT NOT NULL,
  founder_name TEXT NOT NULL,
  email TEXT NOT NULL,
  website TEXT,
  current_markets TEXT[], -- Array of current markets
  target_markets TEXT[], -- Array of target expansion markets
  revenue_range TEXT, -- '<$100K', '$100K-$500K', '$500K-$1M', '$1M+'
  employee_count TEXT, -- '1-10', '11-50', '51-200', '200+'
  message TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_brand_inquiries_email ON brand_inquiries(email);
CREATE INDEX idx_brand_inquiries_created ON brand_inquiries(created_at DESC);

ALTER TABLE brand_inquiries ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow anonymous inserts" ON brand_inquiries
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow authenticated reads" ON brand_inquiries
  FOR SELECT USING (auth.role() = 'authenticated');
```

### 3. Partner Inquiries Table

For dedicated `/partner-signup/` page:

```sql
CREATE TABLE partner_inquiries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  company TEXT NOT NULL,
  email TEXT NOT NULL,
  role TEXT, -- 'investor', 'distributor', 'retailer', 'franchisor'
  markets_of_interest TEXT[], -- Array of target markets
  sectors_of_interest TEXT[], -- Array of target sectors
  investment_range TEXT, -- '<$100K', '$100K-$500K', '$500K-$1M', '$1M+'
  message TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_partner_inquiries_email ON partner_inquiries(email);
CREATE INDEX idx_partner_inquiries_role ON partner_inquiries(role);
CREATE INDEX idx_partner_inquiries_created ON partner_inquiries(created_at DESC);

ALTER TABLE partner_inquiries ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow anonymous inserts" ON partner_inquiries
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow authenticated reads" ON partner_inquiries
  FOR SELECT USING (auth.role() = 'authenticated');
```

## Analytics & Reporting

### Contact Conversion Metrics

```sql
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
```

### Top Referral Sources

```sql
SELECT
  referral_source,
  COUNT(*) as count,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) as percentage
FROM contacts
WHERE referral_source IS NOT NULL
GROUP BY referral_source
ORDER BY count DESC;
```

### Geographic Distribution

```sql
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
```

## Next Steps

1. **Create Supabase Project** (if not using existing `brandmine-prod`)
2. **Run contacts table schema** in SQL Editor
3. **Update contact form** with actual Supabase credentials
4. **Set up email notifications** (Zapier recommended for simplicity)
5. **Configure rate limiting** in Cloudflare Pages
6. **Add spam protection** (Turnstile) to form

---

**Status**: Schema defined, awaiting Supabase credentials
**Owner**: CTO
**Implementation File**: `layouts/partials/contact-form.html`
