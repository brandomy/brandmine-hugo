#!/usr/bin/env node

/**
 * Brandmine Supabase Storage Setup
 * Creates storage buckets for images
 * Date: 2025-10-03
 */

const { createClient } = require('@supabase/supabase-js');
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '..', '.env.local') });

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
  console.error('❌ Missing Supabase credentials in .env.local');
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
});

const buckets = [
  { id: 'brand-images', name: 'brand-images', public: true },
  { id: 'founder-images', name: 'founder-images', public: true },
  { id: 'insight-images', name: 'insight-images', public: true },
  { id: 'dimension-icons', name: 'dimension-icons', public: true }
];

async function setupStorage() {
  console.log('🗄️  Brandmine Supabase Storage Setup');
  console.log('====================================\n');

  try {
    // List existing buckets
    const { data: existing, error: listError } = await supabase.storage.listBuckets();

    if (listError) {
      console.error('❌ Failed to list buckets:', listError.message);
      process.exit(1);
    }

    console.log(`📦 Found ${existing.length} existing bucket(s)\n`);

    // Create each bucket
    for (const bucket of buckets) {
      const exists = existing.find(b => b.id === bucket.id);

      if (exists) {
        console.log(`✓  ${bucket.name} already exists`);
        continue;
      }

      console.log(`📤 Creating ${bucket.name}...`);

      const { data, error } = await supabase.storage.createBucket(bucket.id, {
        public: bucket.public,
        fileSizeLimit: 52428800, // 50MB
        allowedMimeTypes: ['image/png', 'image/jpeg', 'image/jpg', 'image/webp', 'image/svg+xml']
      });

      if (error) {
        console.error(`   ❌ Failed: ${error.message}`);
      } else {
        console.log(`   ✅ Created successfully`);
      }
    }

    console.log('\n====================================');
    console.log('✅ Storage setup complete!');
    console.log('====================================\n');

    // Verify buckets
    const { data: final } = await supabase.storage.listBuckets();
    console.log('📦 Available buckets:');
    final.forEach(b => {
      console.log(`   - ${b.name} (${b.public ? 'public' : 'private'})`);
    });

    process.exit(0);
  } catch (error) {
    console.error('\n❌ Storage setup failed:', error.message);
    process.exit(1);
  }
}

setupStorage();
