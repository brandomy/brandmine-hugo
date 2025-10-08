# Supabase Setup Guide

Step-by-step instructions for setting up Supabase database for Brandmine.

## Prerequisites

- Supabase account ([supabase.com](https://supabase.com))
- Access to Brandmine Hugo project
- Cloudflare Pages account (for production deployment)

## Step 1: Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign in
2. Click "New Project"
3. Fill in project details:
   - **Name**: `brandmine-prod`
   - **Database Password**: Generate strong password (save securely)
   - **Region**: Choose closest to target users (e.g., Singapore for APAC)
4. Click "Create new project"
5. Wait for project provisioning (1-2 minutes)

## Step 2: Get API Credentials

1. Go to Project Settings → API
2. Copy the following values:
   - **Project URL**: `https://[project-ref].supabase.co`
   - **anon/public key**: `eyJ...` (long JWT token)
   - **service_role key**: `eyJ...` (long JWT token - keep secret!)

## Step 3: Configure Local Environment

1. Create `.env.local` in project root (if not exists):
   ```bash
   touch .env.local
   ```

2. Add Supabase credentials:
   ```bash
   SUPABASE_URL=https://[your-project-ref].supabase.co
   SUPABASE_ANON_KEY=eyJ[your-anon-key]...
   SUPABASE_SERVICE_ROLE_KEY=eyJ[your-service-role-key]...
   ```

3. **IMPORTANT**: Add `.env.local` to `.gitignore`:
   ```bash
   echo ".env.local" >> .gitignore
   ```

## Step 4: Run SQL Migrations

Execute SQL files in order from `docs/database/sql/`:

### 1. Create Contacts Table

1. Open Supabase SQL Editor
2. Copy contents of `001-contacts-table.sql`
3. Paste and click "Run"
4. Verify success (should see "Success. No rows returned")
5. Update file header with execution date

### 2. Add Duplicate Prevention (Optional)

1. Copy contents of `002-duplicate-prevention.sql`
2. Paste and run in SQL Editor
3. Update file header with execution date

### 3. Setup Data Retention (Optional)

1. Enable pg_cron extension:
   - Go to Database → Extensions
   - Search for "pg_cron"
   - Click "Enable"

2. Copy contents of `003-data-retention-policy.sql`
3. Uncomment the `cron.schedule` section
4. Paste and run in SQL Editor
5. Update file header with execution date

## Step 5: Verify Database Setup

1. Go to Table Editor
2. Find "contacts" table
3. Check schema matches:
   - ✅ 9 columns (id, name, email, contact_type, company, message, referral_source, country, source, created_at)
   - ✅ 4 indexes
   - ✅ RLS enabled
   - ✅ 2 policies (anonymous insert, authenticated read)

## Step 6: Test Contact Form Locally

1. Load environment variables:
   ```bash
   set -a && source .env.local && set +a
   ```

2. Start Hugo server:
   ```bash
   hugo server
   ```

3. Navigate to `/about/` page
4. Fill out contact form
5. Submit and check:
   - Success message appears
   - Check Supabase Table Editor for new row

## Step 7: Configure Production (Cloudflare Pages)

1. Go to Cloudflare Pages dashboard
2. Select your Brandmine project
3. Go to Settings → Environment Variables
4. Add the following variables:
   - **Name**: `SUPABASE_URL`
   - **Value**: `https://[your-project-ref].supabase.co`
   - **Environment**: Production

5. Add second variable:
   - **Name**: `SUPABASE_ANON_KEY`
   - **Value**: `eyJ[your-anon-key]...`
   - **Environment**: Production

6. Trigger new deployment to apply changes

## Step 8: Setup Email Notifications (Recommended)

### Option A: Zapier (Easiest)

1. Create Zapier account
2. Create new Zap:
   - **Trigger**: Supabase → New Row
   - **Table**: contacts
   - **Action**: Email → Send Email
3. Configure email template with contact details
4. Test and activate

### Option B: Supabase Webhooks

1. Go to Database → Webhooks
2. Create new webhook:
   - **Table**: contacts
   - **Event**: INSERT
   - **URL**: Your notification endpoint
   - **Method**: POST
3. Test webhook
4. Enable webhook

## Troubleshooting

### Contact form not submitting
- Check browser console for errors
- Verify SUPABASE_URL and SUPABASE_ANON_KEY are set
- Check Hugo build logs for getenv errors
- Verify RLS policies are enabled

### Duplicate submission errors
- Check if trigger is enabled: `SELECT * FROM pg_trigger WHERE tgname = 'check_duplicate_contact'`
- Adjust interval in trigger if needed

### Data not appearing in Table Editor
- Verify RLS policies: `SELECT * FROM pg_policies WHERE tablename = 'contacts'`
- Check you're logged in as authenticated user
- Try using SQL Editor instead of Table Editor

## Next Steps

- [ ] Set up email notifications
- [ ] Configure rate limiting in Cloudflare
- [ ] Add spam protection (Turnstile)
- [ ] Create analytics dashboard
- [ ] Document backup/restore procedures

## Support Resources

- [Supabase Docs](https://supabase.com/docs)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)
- [Hugo getenv Function](https://gohugo.io/functions/getenv/)
- Internal: `docs/database-contact-forms.md`
