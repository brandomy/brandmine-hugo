#!/usr/bin/env node

/**
 * Brandmine Hugo → Supabase Sync Script
 * Syncs brands/founders/insights from Hugo content to Supabase database
 * Date: 2025-10-03
 * Phase: Week 4 Day 18 (CLEAN-BUILD-PLAN.md)
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

/**
 * Parse front matter from markdown file
 */
function parseFrontMatter(filePath) {
  const content = fs.readFileSync(filePath, 'utf8');
  const match = content.match(/^---\n([\s\S]*?)\n---\n([\s\S]*)$/);

  if (!match) {
    throw new Error(`Invalid front matter in ${filePath}`);
  }

  const frontMatter = {};
  const yaml = match[1];
  const body = match[2].trim();

  // Simple YAML parser (handles basic key: value, arrays, nested objects)
  const lines = yaml.split('\n');
  let currentKey = null;
  let arrayMode = false;
  let nestedMode = false;
  let nestedKey = null;

  for (let line of lines) {
    line = line.trim();
    if (!line || line.startsWith('#')) continue;

    // Array items
    if (line.startsWith('- ')) {
      if (arrayMode && currentKey) {
        const value = line.substring(2).replace(/['"]/g, '');
        frontMatter[currentKey].push(value);
      }
      continue;
    }

    // Key: value pairs
    if (line.includes(':')) {
      const colonIndex = line.indexOf(':');
      const key = line.substring(0, colonIndex).trim();
      let value = line.substring(colonIndex + 1).trim();

      // Check if it's a nested object start
      if (!value) {
        nestedMode = true;
        nestedKey = key;
        frontMatter[key] = {};
        arrayMode = false;
        continue;
      }

      // Handle nested object properties
      if (nestedMode && nestedKey && line.startsWith(' ')) {
        const nestedPropKey = key;
        // Remove quotes and parse value
        value = value.replace(/^['"]|['"]$/g, '');

        // Check if value is an array
        if (value.startsWith('[') && value.endsWith(']')) {
          const arrayValue = value.slice(1, -1).split(',').map(v => {
            v = v.trim().replace(/^['"]|['"]$/g, '');
            return isNaN(v) ? v : parseFloat(v);
          });
          frontMatter[nestedKey][nestedPropKey] = arrayValue;
        } else if (!isNaN(value)) {
          frontMatter[nestedKey][nestedPropKey] = parseFloat(value);
        } else {
          frontMatter[nestedKey][nestedPropKey] = value;
        }
        continue;
      }

      // Exit nested mode if we're back to root level
      if (nestedMode && !line.startsWith(' ')) {
        nestedMode = false;
        nestedKey = null;
      }

      // Remove quotes
      value = value.replace(/^['"]|['"]$/g, '');

      // Check if next non-empty line is an array
      arrayMode = !value;
      currentKey = key;

      if (arrayMode) {
        frontMatter[key] = [];
      } else if (value.startsWith('[') && value.endsWith(']')) {
        // Inline array
        frontMatter[key] = value.slice(1, -1).split(',').map(v =>
          v.trim().replace(/^['"]|['"]$/g, '')
        );
        arrayMode = false;
      } else if (!isNaN(value)) {
        frontMatter[key] = parseFloat(value);
      } else if (value === 'true' || value === 'false') {
        frontMatter[key] = value === 'true';
      } else {
        frontMatter[key] = value;
      }
    }
  }

  return { frontMatter, body };
}

/**
 * Get all brand directories
 */
function getBrandDirectories() {
  const brandsPath = path.join(__dirname, '..', 'content', 'brands');
  const entries = fs.readdirSync(brandsPath, { withFileTypes: true });

  return entries
    .filter(entry => entry.isDirectory())
    .map(entry => ({
      slug: entry.name,
      path: path.join(brandsPath, entry.name)
    }));
}

/**
 * Parse brand from Hugo content directory
 */
function parseBrand(brandDir) {
  const { slug, path: brandPath } = brandDir;

  const brand = {
    slug,
    languages: {}
  };

  // Parse each language file
  const languages = ['en', 'ru', 'zh'];

  for (const lang of languages) {
    const filePath = path.join(brandPath, `_index.${lang}.md`);

    if (!fs.existsSync(filePath)) {
      console.warn(`   ⚠️  Missing ${lang} file for ${slug}`);
      continue;
    }

    try {
      const { frontMatter, body } = parseFrontMatter(filePath);
      brand.languages[lang] = {
        frontMatter,
        body
      };
    } catch (error) {
      console.error(`   ❌ Failed to parse ${filePath}:`, error.message);
    }
  }

  // Use English front matter as source of truth for metadata
  if (!brand.languages.en) {
    throw new Error(`Missing English content for ${slug}`);
  }

  const enFrontMatter = brand.languages.en.frontMatter;

  // Extract core brand data
  brand.data = {
    slug,
    translationKey: enFrontMatter.translationKey || slug,
    draft: enFrontMatter.draft || false,
    hugoDate: enFrontMatter.date,
    founded: enFrontMatter.founded,
    employees: enFrontMatter.employees?.toString(),
    revenue: enFrontMatter.revenue,
    website: enFrontMatter.website,
    founderSlug: enFrontMatter.founder,
    logo: enFrontMatter.logo,
    heroImage: enFrontMatter.heroImage,

    // Headquarters
    headquartersCity: enFrontMatter.headquarters?.city,
    headquartersCountry: enFrontMatter.headquarters?.country,
    headquartersRegion: enFrontMatter.headquarters?.region,
    headquartersLatitude: enFrontMatter.headquarters?.coordinates?.[0],
    headquartersLongitude: enFrontMatter.headquarters?.coordinates?.[1],

    // Taxonomies
    markets: enFrontMatter.markets || [],
    sectors: enFrontMatter.sectors || [],
    attributes: enFrontMatter.attributes || [],
    signals: enFrontMatter.signals || []
  };

  return brand;
}

/**
 * Upload image to Supabase Storage
 */
async function uploadImage(brandSlug, fileName, bucketName = 'brand-images') {
  const localPath = path.join(__dirname, '..', 'assets', 'images', 'brands', brandSlug, 'originals', fileName);

  if (!fs.existsSync(localPath)) {
    console.warn(`   ⚠️  Image not found: ${localPath}`);
    return null;
  }

  const fileBuffer = fs.readFileSync(localPath);
  const storagePath = `${brandSlug}/${fileName}`;

  // Check if file already exists
  const { data: existing } = await supabase.storage
    .from(bucketName)
    .list(brandSlug);

  const fileExists = existing?.some(f => f.name === fileName);

  if (fileExists) {
    console.log(`      ↻ Image already exists: ${storagePath}`);
    return `${SUPABASE_URL}/storage/v1/object/public/${bucketName}/${storagePath}`;
  }

  // Upload file
  const { data, error } = await supabase.storage
    .from(bucketName)
    .upload(storagePath, fileBuffer, {
      contentType: `image/${path.extname(fileName).substring(1)}`,
      upsert: false
    });

  if (error) {
    console.error(`   ❌ Failed to upload ${fileName}:`, error.message);
    return null;
  }

  const publicUrl = `${SUPABASE_URL}/storage/v1/object/public/${bucketName}/${storagePath}`;
  console.log(`      ✓ Uploaded: ${fileName}`);
  return publicUrl;
}

/**
 * Get dimension ID by slug and type
 */
async function getDimensionId(slug, dimensionType) {
  const { data, error } = await supabase
    .from('dimensions')
    .select('id')
    .eq('slug', slug)
    .eq('dimension_type', dimensionType)
    .single();

  if (error || !data) {
    console.warn(`   ⚠️  Dimension not found: ${dimensionType}/${slug}`);
    return null;
  }

  return data.id;
}

/**
 * Upsert brand to Supabase
 */
async function upsertBrand(brand) {
  console.log(`\n📦 Processing brand: ${brand.slug}`);

  // Upload images (if they exist)
  let logoUrl = null;
  let heroImageUrl = null;

  if (brand.data.logo) {
    console.log('   📤 Uploading images...');
    logoUrl = await uploadImage(brand.slug, brand.data.logo);
    if (brand.data.heroImage) {
      heroImageUrl = await uploadImage(brand.slug, brand.data.heroImage);
    }
  }

  // Upsert brand record
  console.log('   💾 Upserting brand record...');

  const brandRecord = {
    slug: brand.data.slug,
    translation_key: brand.data.translationKey,
    draft: brand.data.draft,
    hugo_date: brand.data.hugoDate,
    founded: brand.data.founded,
    employees: brand.data.employees,
    revenue: brand.data.revenue,
    website: brand.data.website,
    headquarters_city: brand.data.headquartersCity,
    headquarters_country: brand.data.headquartersCountry,
    headquarters_region: brand.data.headquartersRegion,
    headquarters_latitude: brand.data.headquartersLatitude,
    headquarters_longitude: brand.data.headquartersLongitude,
    logo_url: logoUrl,
    hero_image_url: heroImageUrl,
    published_at: brand.data.draft ? null : new Date().toISOString()
  };

  const { data: upsertedBrand, error: brandError } = await supabase
    .from('brands')
    .upsert(brandRecord, { onConflict: 'slug' })
    .select()
    .single();

  if (brandError) {
    console.error(`   ❌ Failed to upsert brand:`, brandError.message);
    return;
  }

  console.log(`      ✓ Brand record upserted: ${upsertedBrand.id}`);

  // Insert translations
  console.log('   🌐 Inserting translations...');

  const translations = [];

  for (const [lang, content] of Object.entries(brand.languages)) {
    const fm = content.frontMatter;
    const body = content.body;

    // Title
    if (fm.title) {
      translations.push({
        entity_type: 'brand',
        entity_id: upsertedBrand.id,
        language: lang,
        field_name: 'title',
        field_value: fm.title
      });
    }

    // Description (SEO)
    if (fm.description) {
      translations.push({
        entity_type: 'brand',
        entity_id: upsertedBrand.id,
        language: lang,
        field_name: 'description',
        field_value: fm.description
      });
    }

    // Body content
    if (body) {
      translations.push({
        entity_type: 'brand',
        entity_id: upsertedBrand.id,
        language: lang,
        field_name: 'content',
        field_value: body
      });
    }
  }

  // Delete existing translations for this brand
  await supabase
    .from('translations')
    .delete()
    .eq('entity_type', 'brand')
    .eq('entity_id', upsertedBrand.id);

  // Insert new translations
  const { error: transError } = await supabase
    .from('translations')
    .insert(translations);

  if (transError) {
    console.error(`   ❌ Failed to insert translations:`, transError.message);
  } else {
    console.log(`      ✓ Inserted ${translations.length} translations`);
  }

  // Update junction tables (taxonomies)
  console.log('   🔗 Updating taxonomy relationships...');

  // Delete existing relationships
  await supabase.from('brand_markets').delete().eq('brand_id', upsertedBrand.id);
  await supabase.from('brand_sectors').delete().eq('brand_id', upsertedBrand.id);
  await supabase.from('brand_attributes').delete().eq('brand_id', upsertedBrand.id);
  await supabase.from('brand_signals').delete().eq('brand_id', upsertedBrand.id);

  // Insert markets
  for (const marketSlug of brand.data.markets) {
    const dimId = await getDimensionId(marketSlug, 'market');
    if (dimId) {
      await supabase.from('brand_markets').insert({
        brand_id: upsertedBrand.id,
        dimension_id: dimId
      });
    }
  }

  // Insert sectors
  for (const sectorSlug of brand.data.sectors) {
    const dimId = await getDimensionId(sectorSlug, 'sector');
    if (dimId) {
      await supabase.from('brand_sectors').insert({
        brand_id: upsertedBrand.id,
        dimension_id: dimId
      });
    }
  }

  // Insert attributes
  for (const attrSlug of brand.data.attributes) {
    const dimId = await getDimensionId(attrSlug, 'attribute');
    if (dimId) {
      await supabase.from('brand_attributes').insert({
        brand_id: upsertedBrand.id,
        dimension_id: dimId
      });
    }
  }

  // Insert signals
  for (const signalSlug of brand.data.signals) {
    const dimId = await getDimensionId(signalSlug, 'signal');
    if (dimId) {
      await supabase.from('brand_signals').insert({
        brand_id: upsertedBrand.id,
        dimension_id: dimId
      });
    }
  }

  console.log(`      ✓ Taxonomy relationships updated`);
  console.log(`   ✅ Brand ${brand.slug} synced successfully\n`);
}

/**
 * Main sync function
 */
async function syncToSupabase() {
  console.log('🔄 Brandmine Hugo → Supabase Sync');
  console.log('==================================\n');

  try {
    const brandDirs = getBrandDirectories();
    console.log(`📂 Found ${brandDirs.length} brand(s) to sync\n`);

    let successCount = 0;
    let errorCount = 0;

    for (const brandDir of brandDirs) {
      try {
        const brand = parseBrand(brandDir);
        await upsertBrand(brand);
        successCount++;
      } catch (error) {
        console.error(`\n❌ Failed to sync ${brandDir.slug}:`, error.message);
        console.error(error.stack);
        errorCount++;
      }
    }

    console.log('==================================');
    console.log(`✅ Sync complete!`);
    console.log(`   - Success: ${successCount} brand(s)`);
    console.log(`   - Errors: ${errorCount} brand(s)`);
    console.log('==================================\n');

    process.exit(errorCount > 0 ? 1 : 0);
  } catch (error) {
    console.error('\n❌ Sync failed:', error.message);
    console.error(error.stack);
    process.exit(1);
  }
}

syncToSupabase();
