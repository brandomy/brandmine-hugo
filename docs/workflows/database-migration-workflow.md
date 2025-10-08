# Database Migration Workflow for Brandmine

**Purpose**: Standard process for creating and deploying database schema changes to Brandmine's Supabase instance.

**Participants**: CTO (SQL development), CEO (Supabase execution), COO (quality review)

**Key Constraint**: Only CEO has Supabase dashboard access. CTO writes SQL, CEO executes it.

---

## Process Overview

1. **Requirements Gathering** - Understand business need
2. **SQL Development** - CTO writes migration file
3. **CEO Execution** - CEO runs SQL in Supabase SQL Editor
4. **Verification** - CTO tests in application
5. **Documentation** - CTO updates docs and commits to git

---

## Step-by-Step Process

### 1. Requirements Gathering

**CEO provides business requirement:**
```
"We need to track contact form submissions from different pages"
"Add brand inquiry form with revenue/market fields"
"Create partner signup with investment range tracking"
```

**CTO clarifies:**
- Required fields and data types
- Business rules and constraints
- Impact on existing features
- UI/UX implications
- Multilingual considerations (EN/RU/ZH)

---

### 2. SQL Development

**CTO creates new migration file:**

```bash
# Determine next sequential number
cd docs/database/sql
ls -1 *.sql | grep "^[0-9]" | tail -1
# If last is 002-*, create 003-*

# Create new migration file
touch 003-brand-inquiries-table.sql
```

**Add file header:**

```sql
-- Migration: Add brand_inquiries table for brand signup form
-- Created: 2025-10-08
-- Production Deploy: Not deployed
-- Prerequisites: Supabase project initialized
-- Purpose: Track brand signup inquiries with market/revenue metadata
```

**Write idempotent SQL:**

```sql
-- Create brand_inquiries table if it doesn't exist
CREATE TABLE IF NOT EXISTS brand_inquiries (
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
  source TEXT, -- Page source: 'brands', 'home', 'direct'
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add indexes for common queries
CREATE INDEX IF NOT EXISTS idx_brand_inquiries_email
  ON brand_inquiries(email);
CREATE INDEX IF NOT EXISTS idx_brand_inquiries_created
  ON brand_inquiries(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_brand_inquiries_target_markets
  ON brand_inquiries USING GIN(target_markets);

-- Enable Row Level Security (RLS)
ALTER TABLE brand_inquiries ENABLE ROW LEVEL SECURITY;

-- Create policy for anonymous inserts (form submissions)
DROP POLICY IF EXISTS "Allow anonymous inserts" ON brand_inquiries;
CREATE POLICY "Allow anonymous inserts" ON brand_inquiries
  FOR INSERT
  WITH CHECK (true);

-- Create policy for authenticated reads (admin access)
DROP POLICY IF EXISTS "Allow authenticated reads" ON brand_inquiries;
CREATE POLICY "Allow authenticated reads" ON brand_inquiries
  FOR SELECT
  USING (auth.role() = 'authenticated');
```

---

### 3. CEO Execution in Supabase

**CTO provides migration to CEO:**

```markdown
**Ready for deployment**: docs/database/sql/003-brand-inquiries-table.sql

Please execute this SQL in Supabase SQL Editor:
1. Navigate to https://supabase.com/dashboard
2. Select Brandmine project (wcfhbzbmxztdzwjaujoq)
3. Click "SQL Editor" in left sidebar
4. Click "New query"
5. Copy SQL from docs/database/sql/003-brand-inquiries-table.sql
6. Paste into SQL Editor
7. Click "Run" button
8. Confirm success message
```

**CEO executes SQL:**
1. Opens Supabase dashboard
2. Navigates to SQL Editor
3. Runs the migration SQL
4. Verifies success message
5. Confirms to CTO: "Migration deployed successfully"

**CEO verification queries** (optional):

```sql
-- Check table exists
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_name = 'brand_inquiries';

-- Check columns
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'brand_inquiries'
ORDER BY ordinal_position;

-- Check indexes
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'brand_inquiries';

-- Check RLS policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual
FROM pg_policies
WHERE tablename = 'brand_inquiries';
```

---

### 4. CTO Verification

**After CEO confirms deployment, CTO tests in application:**

```bash
# Load environment variables and run development server
set -a && source .env.local && set +a && hugo server

# Test the new feature:
# - Check that form appears on intended page
# - Verify all fields render correctly
# - Test form submission end-to-end
# - Confirm data appears in Supabase Table Editor
# - Test validation rules
# - Verify mobile responsiveness
# - Test on EN/RU/ZH language versions
```

**CTO updates migration file header:**

```sql
-- Migration: Add brand_inquiries table for brand signup form
-- Created: 2025-10-08
-- Production Deploy: 2025-10-08  ← Update with CEO's deployment date
-- Prerequisites: Supabase project initialized
-- Purpose: Track brand signup inquiries with market/revenue metadata
```

---

### 5. Documentation

**Update docs/database/README.md:**

Add entry to migration history table:

```markdown
| File | Purpose | Status | Deploy Date |
|------|---------|--------|-------------|
| `003-brand-inquiries-table.sql` | Brand signup form tracking | ✅ Production | 2025-10-08 |
```

**Update docs/database/contact-forms.md if needed:**
- Document new table schema
- Add business rules for field usage
- Note any UI/UX implications
- Add example queries for analytics

**Commit to git:**

```bash
git add docs/database/sql/003-brand-inquiries-table.sql
git add docs/database/README.md
git add docs/database/contact-forms.md
git commit -m "feat(db): add brand_inquiries table for brand signup form

Enables tracking brand signup inquiries with market/revenue metadata.
Migration tested and deployed to production.

- Table: brand_inquiries
- Fields: brand_name, founder_name, email, markets, revenue, etc.
- RLS: Anonymous insert, authenticated read
- Indexes: email, created_at, target_markets

See docs/database/sql/003-brand-inquiries-table.sql"
```

---

## Quality Checklist

Before marking migration complete, verify:

- ✅ **CTO**: SQL uses idempotent patterns (IF NOT EXISTS, CREATE OR REPLACE)
- ✅ **CTO**: File header includes all metadata (created, deployed, prerequisites, purpose)
- ✅ **CTO**: Migration file created in docs/database/sql/ with sequential numbering
- ✅ **CTO**: Provides clear deployment instructions to CEO
- ✅ **CEO**: Executes SQL in Supabase SQL Editor
- ✅ **CEO**: Confirms successful deployment to CTO
- ✅ **CTO**: Verifies functionality in application (hugo server)
- ✅ **CTO**: Tests form submission end-to-end
- ✅ **CTO**: Confirms data appears in Supabase Table Editor
- ✅ **CTO**: Updates production deploy date in file header
- ✅ **CTO**: Updates migration history in docs/database/README.md
- ✅ **CTO**: Updates related documentation (contact-forms.md, etc.)
- ✅ **CTO**: Commits changes to git with descriptive message
- ✅ **COO**: Reviews security (RLS policies, validation, spam prevention)
- ✅ **COO**: Confirms business alignment and data structure

---

## Brandmine-Specific Patterns

### Hugo Environment Variables

**Critical**: Hugo requires explicit environment variable loading before build.

```bash
# Load .env.local before running Hugo
set -a && source .env.local && set +a && hugo server

# Required variables in .env.local
SUPABASE_URL=https://wcfhbzbmxztdzwjaujoq.supabase.co
SUPABASE_ANON_KEY=eyJ...
```

**In templates:**

```javascript
const SUPABASE_URL = '{{ getenv "SUPABASE_URL" }}';
const SUPABASE_ANON_KEY = '{{ getenv "SUPABASE_ANON_KEY" }}';
```

### Multilingual Considerations

**Forms must work in EN/RU/ZH:**

```html
<!-- Use i18n keys for all labels -->
<label for="name">{{ i18n "form_name" }}</label>
<input type="text" id="name" name="name" required>

<!-- Error messages -->
<span class="error">{{ i18n "form_error_required" }}</span>
```

**Database stores EN values, UI displays translations:**

```sql
-- Database column stores English
contact_type TEXT NOT NULL -- 'brand', 'partner', 'job_seeker', 'other'

-- Template translates for display
{{ i18n (printf "contact_type_%s" .contact_type) }}
```

### Source Tracking

**Track which page user submitted from:**

```html
<!-- Contact form partial accepts source parameter -->
{{ partial "contact-form.html" (dict "context" . "source" "about") }}
{{ partial "contact-form.html" (dict "context" . "source" "build-with-us") }}

<!-- Hidden field in form -->
<input type="hidden" name="source" value="{{ .source }}">
```

---

## Special Cases

### Adding RLS Policies

```sql
-- Always drop existing policy first to avoid conflicts
DROP POLICY IF EXISTS "speakers_select_policy" ON speakers;

-- Create new policy
CREATE POLICY "speakers_select_policy"
ON speakers FOR SELECT
TO authenticated
USING (true);
```

### Spam Prevention Triggers

```sql
-- Prevent duplicate submissions within 5-minute window
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

DROP TRIGGER IF EXISTS check_duplicate_contact ON contacts;
CREATE TRIGGER check_duplicate_contact
  BEFORE INSERT ON contacts
  FOR EACH ROW
  EXECUTE FUNCTION prevent_duplicate_contacts();
```

### Data Retention Policies

```sql
-- Auto-delete contacts older than 2 years (GDPR compliance)
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

### Array Columns for Taxonomies

```sql
-- Markets and sectors as PostgreSQL arrays
current_markets TEXT[], -- ['russia', 'china', 'global']
sectors_of_interest TEXT[], -- ['gourmet-foods', 'natural-beauty']

-- GIN index for array queries
CREATE INDEX IF NOT EXISTS idx_brand_inquiries_target_markets
  ON brand_inquiries USING GIN(target_markets);

-- Query brands interested in specific market
SELECT * FROM brand_inquiries
WHERE 'russia' = ANY(target_markets);
```

---

## Rollback Procedures

**If migration causes issues:**

1. **Write rollback SQL:**
   ```sql
   -- Rollback for 003-brand-inquiries-table.sql
   DROP TRIGGER IF EXISTS check_duplicate_brand_inquiry ON brand_inquiries;
   DROP FUNCTION IF EXISTS prevent_duplicate_brand_inquiries();
   DROP POLICY IF EXISTS "Allow authenticated reads" ON brand_inquiries;
   DROP POLICY IF EXISTS "Allow anonymous inserts" ON brand_inquiries;
   DROP INDEX IF EXISTS idx_brand_inquiries_target_markets;
   DROP INDEX IF EXISTS idx_brand_inquiries_created;
   DROP INDEX IF EXISTS idx_brand_inquiries_email;
   DROP TABLE IF EXISTS brand_inquiries;
   ```

2. **Provide to CEO for execution in Supabase**

3. **Document rollback in migration file:**
   ```sql
   -- Production Deploy: 2025-10-08
   -- Rolled Back: 2025-10-09 (reason: conflicted with existing feature)
   ```

---

## Common Issues

**"Column already exists"**
- Use idempotent SQL with existence checks
- Verify migration hasn't already been run
- Check Supabase Table Editor for existing schema

**"Permission denied"**
- Check RLS policies are correctly configured
- Verify using anon key for form submissions
- Ensure authenticated role for admin queries

**"Foreign key constraint violation"**
- Ensure referenced tables/columns exist
- Check data integrity before adding constraints
- Use `ON DELETE CASCADE` or `ON DELETE SET NULL` appropriately

**"Type mismatch"**
- Verify data types match business requirements
- Use explicit type casts when needed
- PostgreSQL arrays require TEXT[] not just TEXT

**"Hugo template not finding environment variables"**
- Must load `.env.local` before running Hugo
- Use `set -a && source .env.local && set +a && hugo server`
- Verify variables are exported: `echo $SUPABASE_URL`

---

## Best Practices

✅ **DO**:
- Always test in SQL Editor before considering deployed
- Use sequential numbering for clear migration order
- Write idempotent SQL (safe to run multiple times)
- Document business purpose in file header
- Update migration history immediately after deploy
- Commit SQL and docs together
- Load `.env.local` before running Hugo
- Test forms on all language versions (EN/RU/ZH)
- Add source tracking to all forms
- Implement spam prevention triggers

❌ **DON'T**:
- Modify migration files after production deployment
- Skip sequential numbers in file naming
- Deploy without testing
- Forget to update production deploy date
- Mix multiple unrelated changes in one migration
- Commit without descriptive message
- Run Hugo without loading environment variables
- Forget to test multilingual form functionality
- Skip RLS policies (security risk)
- Ignore spam prevention (data quality risk)

---

## Example: Complete Migration Lifecycle

**1. CEO Request:**
```
"We need brand signup form on Brands page to capture inquiries from potential brands"
```

**2. CTO Clarifies:**
```
"Brand signup form will capture:
- Brand name, founder name, email
- Current markets, target markets (arrays)
- Revenue range, employee count
- Message field
- Source tracking

Table: brand_inquiries
RLS: Anonymous insert, authenticated read
Spam prevention: 5-minute duplicate check
Proceed?"
```

**3. CEO Approves:**
```
"Approved - build it"
```

**4. CTO Creates Migration:**
- Writes `003-brand-inquiries-table.sql`
- Includes table, indexes, RLS policies, spam prevention trigger
- Documents in file header

**5. CTO Provides SQL to CEO:**
```
"Ready for deployment: docs/database/sql/003-brand-inquiries-table.sql

Please execute in Supabase SQL Editor and confirm."
```

**6. CEO Executes:**
```
"Migration deployed successfully"
```

**7. CTO Verifies:**
- Tests form submission on Brands page
- Confirms data in Supabase Table Editor
- Tests EN/RU/ZH versions
- Verifies spam prevention works

**8. CTO Documents:**
- Updates migration file header with deploy date
- Updates docs/database/README.md
- Updates docs/database/contact-forms.md
- Commits to git

**9. COO Reviews:**
```
"Quality confirmed:
- Security: RLS policies correct, spam prevention working
- Functionality: Form submissions successful across all languages
- Data structure: Aligns with business requirements
Status: Approved"
```

**10. CEO Validates:**
```
"Perfect - brands can now reach us easily. Form works great on mobile too."
```

---

## Analytics Queries

**Track brand inquiries by market:**

```sql
SELECT
  unnest(target_markets) as market,
  COUNT(*) as inquiries
FROM brand_inquiries
GROUP BY market
ORDER BY inquiries DESC;
```

**Inquiries by revenue range:**

```sql
SELECT
  revenue_range,
  COUNT(*) as count,
  ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) as percentage
FROM brand_inquiries
WHERE revenue_range IS NOT NULL
GROUP BY revenue_range
ORDER BY count DESC;
```

**Recent inquiries with key metrics:**

```sql
SELECT
  brand_name,
  founder_name,
  email,
  target_markets,
  revenue_range,
  created_at
FROM brand_inquiries
WHERE created_at >= NOW() - INTERVAL '30 days'
ORDER BY created_at DESC;
```

**GDPR data export for specific email:**

```sql
-- Export all data for user request
SELECT *
FROM brand_inquiries
WHERE email = 'user@example.com'
ORDER BY created_at DESC;
```

**GDPR data deletion:**

```sql
-- Delete all data for user request
DELETE FROM brand_inquiries WHERE email = 'user@example.com';
```

---

**Workflow Owner**: CTO
**Review Frequency**: Update as process evolves
**Last Updated**: 2025-10-08
**Status**: Active workflow for Brandmine Supabase migrations
