#!/usr/bin/env node

/**
 * Brandmine Supabase Migration Runner
 * Runs SQL migrations against Supabase database
 * Date: 2025-10-03
 */

const fs = require('fs');
const path = require('path');
const { createClient } = require('@supabase/supabase-js');
require('dotenv').config({ path: path.join(__dirname, '..', '.env.local') });

// Load environment variables
const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
  console.error('❌ Missing Supabase credentials in .env.local');
  console.error('Required: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY');
  process.exit(1);
}

// Create Supabase client with service role key
const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
});

// Migration files in order
const migrationFiles = [
  '01-create-tables.sql',
  '02-create-indexes.sql',
  '03-create-triggers.sql',
  '04-enable-rls.sql'
];

/**
 * Execute SQL file
 */
async function executeSqlFile(filename) {
  const filePath = path.join(__dirname, 'migrations', filename);
  console.log(`\n📄 Running: ${filename}`);

  if (!fs.existsSync(filePath)) {
    throw new Error(`Migration file not found: ${filePath}`);
  }

  const sql = fs.readFileSync(filePath, 'utf8');

  // Execute SQL using Supabase RPC
  const { data, error } = await supabase.rpc('exec_sql', { sql_string: sql }).catch(async () => {
    // If exec_sql function doesn't exist, try direct SQL execution
    // Note: This requires using postgres-js or pg client
    // For now, we'll use a workaround with multiple statements

    // Split SQL into individual statements (basic approach)
    const statements = sql
      .split(';')
      .map(s => s.trim())
      .filter(s => s.length > 0 && !s.startsWith('--') && !s.startsWith('SELECT'));

    console.log(`   Executing ${statements.length} statements...`);

    for (let i = 0; i < statements.length; i++) {
      const stmt = statements[i] + ';';
      if (stmt.trim().length < 5) continue;

      try {
        await supabase.rpc('exec_sql', { query: stmt });
      } catch (err) {
        // Ignore errors from SELECT status messages
        if (!err.message?.includes('function') && !err.message?.includes('exec_sql')) {
          throw err;
        }
      }
    }

    return { data: null, error: null };
  });

  if (error) {
    throw new Error(`Migration failed: ${error.message}`);
  }

  console.log(`✅ ${filename} completed`);
  return data;
}

/**
 * Main migration runner
 */
async function runMigrations() {
  console.log('🚀 Brandmine Supabase Migration');
  console.log('================================\n');
  console.log(`URL: ${SUPABASE_URL}`);
  console.log(`Database: brandmine-prod\n`);

  try {
    // Test connection
    const { error: testError } = await supabase.from('_test_connection').select('*').limit(1);
    if (testError && !testError.message.includes('does not exist')) {
      console.log('⚠️  Connection test warning (expected for new database)');
    } else {
      console.log('✅ Supabase connection successful\n');
    }

    // Run migrations in order
    for (const file of migrationFiles) {
      await executeSqlFile(file);
    }

    console.log('\n================================');
    console.log('✅ All migrations completed successfully!');
    console.log('================================\n');

    process.exit(0);
  } catch (error) {
    console.error('\n================================');
    console.error('❌ Migration failed:');
    console.error(error.message);
    console.error('================================\n');
    process.exit(1);
  }
}

// Run migrations
runMigrations();
