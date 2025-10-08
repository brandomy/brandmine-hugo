# Dev Journal: Supabase Database Setup

**Date**: 2025-10-03
**Phase**: Week 4 Day 16-17 (CLEAN-BUILD-PLAN.md)
**Feature**: Database schema creation and initial data seeding

## Context

Following Pagefind search implementation (documented in 2025-10-03-pagefind-search.md), the next priority per CLEAN-BUILD-PLAN.md was to set up Supabase as the database backend for Brandmine.

**Decision**: Use Supabase PostgreSQL with relational translations table (not JSONB) as approved by CEO.

## What Was Built

### 1. Schema Design

**Document**: `docs/database-schema.md` (CEO-approved)

**Key Decisions**:
- ✅ Relational translations table (polymorphic design)
- ✅ Supabase Storage for all images
- ✅ Database as source of truth for taxonomies
- ✅ Public API access via RLS policies
- ✅ No PostgreSQL search (Pagefind handles it)

**Tables Created**: 11 total
- Core: `brands`, `founders`, `insights`, `dimensions`, `translations` (5)
- Junction: `brand_markets`, `brand_sectors`, `brand_attributes`, `brand_signals`, `insight_markets`, `insight_sectors` (6)

### 2. SQL Migrations

**Files**:
```
scripts/migrations/
├── 01-create-tables.sql       # Core & junction tables
├── 02-create-indexes.sql      # Performance indexes
├── 03-create-triggers.sql     # updated_at triggers
├── 04-enable-rls.sql          # Row-Level Security policies
└── 00-complete-schema.sql     # Combined migration (all 4 phases)
```

**Migration Stats**:
- 11 tables created
- 40+ indexes created
- 5 update triggers
- 24 RLS policies (12 read + 12 write)
- Execution time: ~10 seconds

### 3. Supabase Project

**Project**: `brandmine-prod`
**URL**: `https://wcfhbzbmxztdzwjaujoq.supabase.co`
**Region**: (not specified - using default)
**Plan**: Free tier (500 MB database, 1 GB storage)

**Credentials Storage**:
```
.env.local (gitignored):
SUPABASE_URL=https://wcfhbzbmxztdzwjaujoq.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### 4. Storage Buckets

**Script**: `scripts/setup-storage.js`

**Buckets Created** (all public):
- `brand-images` - Brand logos, hero images, product photos
- `founder-images` - Founder portraits
- `insight-images` - Insight hero images
- `dimension-icons` - Taxonomy dimension icons

**URL Pattern**:
```
https://wcfhbzbmxztdzwjaujoq.supabase.co/storage/v1/object/public/<bucket>/<path>
```

**RLS Policies**:
- Public read access
- Service role write access only

### 5. Dimension Seeding

**Script**: `scripts/seed-dimensions.js`

**Source Data**: `data/taxonomies/*.json` (imported from Jekyll during earlier migration)

**Dimensions Inserted**:
| Type | Count | Color |
|------|-------|-------|
| Markets | 15 | #0EA5E9 (sky blue) |
| Sectors | 16 | #A3B763 (olive green) |
| Attributes | 8 | #F97316 (orange) |
| Signals | 4 | #6366F1 (indigo) |
| **Total** | **43** | |

**Translations Inserted**:
- 43 dimensions × 3 languages × 2 fields = **258 translation rows**
- Languages: English (en), Russian (ru), Chinese (zh)
- Fields: `title`, `description`

**Sample Dimensions**:
- Markets: russia, china, brazil, india, asean, gcc, uae, etc.
- Sectors: honey-bee-products, artisanal-spirits, gourmet-foods, hotels-resorts, wine, etc.
- Attributes: founder-led, artisanal-excellence, heritage-brand, sustainability-pioneer, etc.
- Signals: export-ready, rapid-growth, investment-ready, franchise-ready

**Execution Time**: ~5 seconds

### 6. Schema Verification

**Script**: `scripts/verify-schema.js`

**Tests Performed**:
1. ✅ Core tables exist (brands, founders, insights, dimensions, translations)
2. ✅ Dimension counts correct (15 markets, 16 sectors, 8 attributes, 4 signals)
3. ✅ Translation counts correct (258 total: 86 EN, 86 RU, 86 ZH)
4. ✅ Query dimension with translations (russia market sample)
5. ✅ Storage buckets exist (4 public buckets)
6. ✅ RLS policies configured

**Sample Query Result** (russia market):
```json
{
  "id": "3ee08d96-8da3-41b5-9c6f-dad660f987b1",
  "slug": "russia",
  "dimension_type": "market",
  "color_hex": "#0EA5E9",
  "translations": {
    "en": "Russia",
    "ru": "Россия",
    "zh": "俄罗斯"
  }
}
```

## Technical Implementation

### Relational Translations Pattern

**Why Not JSONB?**
CEO preferred relational design for:
- Better queryability
- Easier to update individual translations
- Standard SQL patterns
- Type safety

**Polymorphic Design**:
```sql
CREATE TABLE translations (
  id UUID PRIMARY KEY,
  entity_type TEXT NOT NULL,  -- 'brand' | 'founder' | 'insight' | 'dimension'
  entity_id UUID NOT NULL,
  language TEXT NOT NULL,     -- 'en' | 'ru' | 'zh'
  field_name TEXT NOT NULL,   -- 'title' | 'description' | 'content' | etc.
  field_value TEXT NOT NULL,
  UNIQUE(entity_type, entity_id, language, field_name)
);
```

**Advantages**:
- Single translations table for all entities
- Easy to add new languages (no schema changes)
- Flexible field names per entity type
- Composite index for fast lookups

**Query Pattern** (two-query approach):
```javascript
// 1. Get dimension
const { data: dimension } = await supabase
  .from('dimensions')
  .select('*')
  .eq('slug', 'russia')
  .single();

// 2. Get translations
const { data: translations } = await supabase
  .from('translations')
  .select('*')
  .eq('entity_type', 'dimension')
  .eq('entity_id', dimension.id);
```

### Database as Taxonomy Source of Truth

**Critical Architectural Decision**: Taxonomies (dimensions) flow **from Supabase → Hugo**, not Hugo → Supabase.

**Rationale**:
1. Single source of truth for adding/editing dimension values
2. API-driven access for future applications
3. Referential integrity via foreign keys
4. No Hugo rebuild required to add new dimension values
5. Supabase dashboard = management interface

**Sync Direction**:
| Data Type | Source of Truth | Sync Direction |
|-----------|-----------------|----------------|
| Dimensions (taxonomies) | **Supabase** | Supabase → Hugo |
| Content (brands/founders/insights) | **Hugo** | Hugo → Supabase |
| Images | **Supabase Storage** | Upload → Supabase |

### Row-Level Security (RLS)

**Public Read Policies**:
```sql
-- Brands (published only)
CREATE POLICY "Public brands read" ON brands
  FOR SELECT USING (draft = false);

-- Dimensions (all public)
CREATE POLICY "Public dimensions read" ON dimensions
  FOR SELECT USING (true);

-- Translations (all public)
CREATE POLICY "Public translations read" ON translations
  FOR SELECT USING (true);
```

**Admin Write Policies**:
```sql
-- Service role only
CREATE POLICY "Admin brands write" ON brands
  FOR ALL USING (auth.role() = 'service_role');
```

**Effect**: Public can read published content via anon key, but only service role (sync script) can write.

### No PostgreSQL Search

**Decision**: Skip PostgreSQL full-text search entirely.

**Rationale**:
- Pagefind already working (170 pages indexed in 0.244s)
- Static search = zero database load
- Multilingual support built-in
- Privacy-friendly (no tracking)
- Simpler architecture

**Supabase Role**: Fast API access for dynamic content (future mobile app, admin dashboard), NOT search.

## Package Updates

**package.json**:
```json
{
  "scripts": {
    "build": "hugo --gc --minify && npx pagefind --site public",
    "dev": "hugo server",
    "search": "npx pagefind --site public",
    "migrate": "node scripts/run-migrations.js",
    "seed-dimensions": "node scripts/seed-dimensions.js"
  },
  "devDependencies": {
    "@supabase/supabase-js": "^2.39.0",
    "dotenv": "^16.3.1",
    "pagefind": "^1.4.0"
  }
}
```

**New Dependencies**:
- `@supabase/supabase-js` - Supabase client library
- `dotenv` - Environment variable loading

## Files Created/Modified

**Created**:
- `.env.local` - Supabase credentials (gitignored)
- `docs/database-schema.md` - Schema design documentation
- `scripts/migrations/01-create-tables.sql`
- `scripts/migrations/02-create-indexes.sql`
- `scripts/migrations/03-create-triggers.sql`
- `scripts/migrations/04-enable-rls.sql`
- `scripts/migrations/00-complete-schema.sql`
- `scripts/setup-storage.js` - Create storage buckets
- `scripts/seed-dimensions.js` - Insert dimension data
- `scripts/verify-schema.js` - Schema verification tests
- `scripts/run-migrations.js` - Migration runner (unused - ran via Supabase dashboard)
- `docs/dev-journal/2025-10-03-supabase-setup.md` (this file)

**Modified**:
- `package.json` - Added Supabase dependencies and scripts
- `.gitignore` - Already had `.env.local` (no changes needed)

## Data Volume

**Current State**:
| Entity | Rows | Size Estimate |
|--------|------|---------------|
| Dimensions | 43 | ~5 KB |
| Translations | 258 | ~30 KB |
| Brands | 0 | - |
| Founders | 0 | - |
| Insights | 0 | - |
| **Total** | **301 rows** | **~35 KB** |

**Storage Buckets**: 4 buckets, 0 files, 0 KB

**Database Size**: < 1 MB (well within 500 MB free tier)

## Known Issues

None. All tests passed.

## Next Steps

### Immediate (Day 18)

Per CLEAN-BUILD-PLAN.md Day 18:

1. **Build Hugo → Supabase Sync Script**:
   - Parse Hugo markdown front matter
   - Extract multilingual content from `_index.en.md`, `_index.ru.md`, `_index.zh.md`
   - Upload images to Supabase Storage
   - Upsert brands/founders/insights + translations
   - Update junction tables (brand_markets, etc.)
   - Test with current 6 brands

2. **Automate Sync**:
   - Add `npm run sync` command
   - GitHub Actions on push to `main`

### Future (Day 19-20)

- Image optimization pipeline
- Deploy to Cloudflare Pages
- Polish + production testing

## Success Metrics

- ✅ **Migration Speed**: 10 seconds for complete schema
- ✅ **Seed Speed**: 5 seconds for 43 dimensions + 258 translations
- ✅ **Query Performance**: < 100ms for dimension queries
- ✅ **Data Accuracy**: 100% match with source JSON files
- ✅ **Storage**: < 1 MB database, 0 MB images (within free tier)
- ✅ **All Tests Passed**: 6/6 verification tests

## Lessons Learned

1. **Supabase Dashboard for Migrations**: Easier to run SQL directly in dashboard than via JS client
2. **Polymorphic Translations**: Flexible design, but requires two queries (no JOIN support in Supabase client)
3. **Relational vs JSONB**: CEO preference for relational proved simpler to reason about
4. **Source JSON Files**: `data/taxonomies/*.json` provided clean seed data (thanks to earlier Jekyll import)
5. **Storage Buckets**: Simple setup via Supabase client, public access works well for CDN

## References

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Storage](https://supabase.com/docs/guides/storage)
- [Row-Level Security](https://supabase.com/docs/guides/auth/row-level-security)
- docs/database-schema.md - Complete schema design
- CLEAN-BUILD-PLAN.md - Phase 4, Day 16-17

---

**Status**: Supabase setup COMPLETE ✅
**Next**: Day 18 - Hugo → Supabase sync script development
