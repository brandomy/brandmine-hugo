# Supabase SQL Commands

This directory contains all SQL commands used to set up and maintain the Brandmine Supabase database.

## Directory Structure

```
docs/supabase/
├── README.md           # This file
├── sql/
│   ├── 001-initial-setup.sql      # Initial database setup
│   ├── 002-contact-form.sql       # Contact form table
│   └── ...                        # Additional migrations
└── guides/
    └── supabase-setup.md          # Setup instructions
```

## Naming Convention

SQL files should follow this pattern:
- `NNN-description.sql` where NNN is a sequential number (001, 002, etc.)
- Use lowercase with hyphens for descriptions
- Keep names descriptive but concise

## Usage

1. **To apply a new migration:**
   - Go to Supabase Dashboard → SQL Editor
   - Copy contents of the SQL file
   - Execute the query
   - Note the execution date/time in the file's header comment

2. **To track changes:**
   - Each SQL file should include header comments with:
     - Purpose
     - Date created
     - Date applied to production
     - Any prerequisites or dependencies

## Example SQL File Format

```sql
-- Purpose: Create contact form submissions table
-- Created: 2025-10-06
-- Applied to Production: 2025-10-06
-- Prerequisites: None

CREATE TABLE contact_submissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  -- ... rest of schema
);
```

## Current Database Schema

See individual SQL files in the `sql/` directory for current schema definitions.

## Related Documentation

- [Supabase Contact Forms](../supabase-contact-forms.md) - Contact form integration guide
- [Environment Variables](../deployment.md) - Supabase credentials setup
