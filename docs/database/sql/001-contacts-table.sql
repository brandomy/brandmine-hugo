-- Purpose: Create contacts table for general contact form submissions
-- Created: 2025-10-06
-- Applied to Production: [PENDING]
-- Prerequisites: None

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
  source TEXT, -- Track which page the form was submitted from ('about', 'build-with-us', etc.)
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add indexes for common queries
CREATE INDEX idx_contacts_email ON contacts(email);
CREATE INDEX idx_contacts_type ON contacts(contact_type);
CREATE INDEX idx_contacts_created ON contacts(created_at DESC);
CREATE INDEX idx_contacts_source ON contacts(source);

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
