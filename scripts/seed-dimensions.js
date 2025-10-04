#!/usr/bin/env node

/**
 * Brandmine Supabase Dimension Seeder
 * Reads taxonomy JSON files and inserts dimensions + translations into Supabase
 * Date: 2025-10-03
 */

const fs = require('fs');
const path = require('path');
const { createClient } = require('@supabase/supabase-js');
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

// Dimension type color mapping (from data/dimensions.yaml)
const COLOR_MAP = {
  market: '#0EA5E9',   // Sky blue
  sector: '#A3B763',   // Olive green
  attribute: '#F97316', // Orange
  signal: '#6366F1'    // Indigo
};

/**
 * Load taxonomy JSON files
 */
function loadTaxonomies() {
  const dataPath = path.join(__dirname, '..', 'data', 'taxonomies');

  const markets = JSON.parse(fs.readFileSync(path.join(dataPath, 'markets.json'), 'utf8'));
  const sectors = JSON.parse(fs.readFileSync(path.join(dataPath, 'sectors.json'), 'utf8'));
  const attributes = JSON.parse(fs.readFileSync(path.join(dataPath, 'attributes.json'), 'utf8'));
  const signals = JSON.parse(fs.readFileSync(path.join(dataPath, 'signals.json'), 'utf8'));

  return { markets, sectors, attributes, signals };
}

/**
 * Insert dimension and its translations
 */
async function insertDimension(dimensionData, dimensionType, sortOrder) {
  const slug = dimensionData.id;
  const colorHex = COLOR_MAP[dimensionType];

  // 1. Insert dimension
  const { data: dimension, error: dimError } = await supabase
    .from('dimensions')
    .insert({
      slug,
      dimension_type: dimensionType,
      color_hex: colorHex,
      sort_order: sortOrder
    })
    .select()
    .single();

  if (dimError) {
    console.error(`   ❌ Failed to insert dimension ${slug}:`, dimError.message);
    return null;
  }

  console.log(`   ✓  Inserted dimension: ${slug} (${dimensionType})`);

  // 2. Insert translations
  const translations = [];
  const languages = ['en', 'ru', 'zh'];

  for (const lang of languages) {
    // Title translation
    if (dimensionData.name && dimensionData.name[lang]) {
      translations.push({
        entity_type: 'dimension',
        entity_id: dimension.id,
        language: lang,
        field_name: 'title',
        field_value: dimensionData.name[lang]
      });
    }

    // Description translation
    if (dimensionData.description && dimensionData.description[lang]) {
      translations.push({
        entity_type: 'dimension',
        entity_id: dimension.id,
        language: lang,
        field_name: 'description',
        field_value: dimensionData.description[lang]
      });
    } else if (dimensionData.short_description && dimensionData.short_description[lang]) {
      // Markets use short_description
      translations.push({
        entity_type: 'dimension',
        entity_id: dimension.id,
        language: lang,
        field_name: 'description',
        field_value: dimensionData.short_description[lang]
      });
    }
  }

  if (translations.length > 0) {
    const { error: transError } = await supabase
      .from('translations')
      .insert(translations);

    if (transError) {
      console.error(`   ❌ Failed to insert translations for ${slug}:`, transError.message);
    } else {
      console.log(`      + ${translations.length} translations`);
    }
  }

  return dimension;
}

/**
 * Main seeder
 */
async function seedDimensions() {
  console.log('🌱 Brandmine Dimension Seeder');
  console.log('=============================\n');

  try {
    const { markets, sectors, attributes, signals } = loadTaxonomies();

    console.log(`📊 Loaded taxonomies:`);
    console.log(`   - Markets: ${markets.length}`);
    console.log(`   - Sectors: ${sectors.length}`);
    console.log(`   - Attributes: ${attributes.length}`);
    console.log(`   - Signals: ${signals.length}`);
    console.log(`   - Total: ${markets.length + sectors.length + attributes.length + signals.length} dimensions\n`);

    let totalInserted = 0;
    let sortOrder = 0;

    // Insert Markets
    console.log('📍 Inserting markets...');
    for (const market of markets) {
      await insertDimension(market, 'market', sortOrder++);
      totalInserted++;
    }

    // Insert Sectors
    console.log('\n🏷️  Inserting sectors...');
    for (const sector of sectors) {
      await insertDimension(sector, 'sector', sortOrder++);
      totalInserted++;
    }

    // Insert Attributes
    console.log('\n⭐ Inserting attributes...');
    for (const attribute of attributes) {
      await insertDimension(attribute, 'attribute', sortOrder++);
      totalInserted++;
    }

    // Insert Signals
    console.log('\n📈 Inserting signals...');
    for (const signal of signals) {
      await insertDimension(signal, 'signal', sortOrder++);
      totalInserted++;
    }

    console.log('\n=============================');
    console.log(`✅ Seeding complete!`);
    console.log(`   - ${totalInserted} dimensions inserted`);
    console.log(`   - ${totalInserted * 6} translations inserted (3 langs × 2 fields each)`);
    console.log('=============================\n');

    // Verify counts
    const { count: dimCount } = await supabase
      .from('dimensions')
      .select('*', { count: 'exact', head: true });

    const { count: transCount } = await supabase
      .from('translations')
      .select('*', { count: 'exact', head: true })
      .eq('entity_type', 'dimension');

    console.log('📊 Verification:');
    console.log(`   - Dimensions in database: ${dimCount}`);
    console.log(`   - Translations in database: ${transCount}\n`);

    process.exit(0);
  } catch (error) {
    console.error('\n❌ Seeding failed:', error.message);
    console.error(error.stack);
    process.exit(1);
  }
}

seedDimensions();
