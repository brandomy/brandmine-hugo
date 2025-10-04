# CEO Workflow: Adding New Brands to Brandmine

**Purpose**: Step-by-step guide for CEO to add new brands to the Brandmine platform.

**Status**: Production-ready workflow (Day 19-20 implementation complete)

---

## Overview

Adding a new brand to Brandmine involves:
1. Creating multilingual markdown files (EN/RU/ZH)
2. Adding brand images to assets folder
3. Running sync script to push to Supabase
4. Building site with updated search index

**Time required**: ~15-30 minutes per brand

---

## Prerequisites

### Required Information
Before starting, gather:
- [ ] Brand name (in English, Russian, Chinese)
- [ ] Business details (founded year, employees, revenue, website, headquarters)
- [ ] Taxonomy classifications (markets, sectors, attributes, signals)
- [ ] Brand description/story (2-3 paragraphs in each language)
- [ ] Images (logo PNG + hero image JPG)

### Taxonomy Reference
**Markets**: russia, china, brazil, india, asean, gcc, uae, central-asia, latin-america, east-africa, global, etc. (15 total)

**Sectors**: honey-bee-products, artisanal-spirits, gourmet-foods, hotels-resorts, wine, tea-coffee, chocolate-confections, craft-beer, etc. (16 total)

**Attributes**: founder-led, artisanal-excellence, heritage-brand, sustainability-pioneer, innovation-leader, export-champion, family-business, certified-organic (8 total)

**Signals**: export-ready, rapid-growth, investment-ready, franchise-ready (4 total)

**📋 Full taxonomy list**: See `data/taxonomies/*.json` files

---

## Step 1: Create Brand Directory

```bash
# Create brand directory (use lowercase-with-hyphens slug)
mkdir -p content/brands/your-brand-slug
```

**Slug naming rules**:
- All lowercase
- Use hyphens (not underscores or spaces)
- Keep it short and memorable
- Examples: `altai-honey`, `serra-verde`, `taiga-spirits`

---

## Step 2: Create Markdown Files

Create 3 files: `_index.en.md`, `_index.ru.md`, `_index.zh.md`

### English File (`_index.en.md`)

```markdown
---
title: "Brand Name in English"
translationKey: "your-brand-slug"
date: 2025-10-03
draft: false

# Taxonomies (4 dimensions)
markets: ["russia", "china"]
sectors: ["gourmet-foods"]
attributes: ["founder-led", "artisanal-excellence"]
signals: ["export-ready"]

# Founder relationship (optional, if founder profile exists)
founder: "founder-slug"

# Business details
founded: 2020
employees: 50
revenue: "$5M-10M"
website: "https://yourbrand.com"
headquarters:
  city: "City Name"
  country: "ru"  # ISO 2-letter code: ru, cn, br, in, etc.
  region: "Region/State Name"
  coordinates: [55.7558, 37.6173]  # [latitude, longitude]

# Assets (filenames only, not full paths)
logo: "logo-color.png"
heroImage: "hero-image.jpg"

# SEO
description: "One-sentence brand description for meta tags and search results"
---

# Brand story content starts here

Write 2-4 paragraphs about the brand in English. Use markdown formatting:

## Subheadings

Use H2 (##) for major sections.

**Bold text** for emphasis.

*Italic text* for subtle emphasis.

- Bullet points
- For lists
- Of features or benefits
```

### Russian File (`_index.ru.md`)

Same structure, translate:
- `title`: Brand name in Russian
- `headquarters.city`, `headquarters.region`: Translated city/region
- `description`: Russian SEO description
- Content body: Translated story (2-4 paragraphs)

**Keep unchanged**:
- `translationKey`, `date`, `draft`
- Taxonomy arrays (markets, sectors, attributes, signals)
- `founder`, `founded`, `employees`, `revenue`, `website`
- `headquarters.country`, `headquarters.coordinates`
- `logo`, `heroImage` filenames

### Chinese File (`_index.zh.md`)

Same structure, translate:
- `title`: Brand name in Chinese
- `headquarters.city`, `headquarters.region`: Translated city/region
- `description`: Chinese SEO description
- Content body: Translated story (2-4 paragraphs)

**Keep unchanged**: Same as Russian file

---

## Step 3: Add Brand Images

### Image Requirements
- **Logo**: PNG format, transparent background, square aspect ratio (500x500px recommended)
- **Hero**: JPG format, landscape aspect ratio (1200x630px recommended)
- **Size**: < 500 KB per image (optimize before upload)

### File Locations
```bash
# Create image directory
mkdir -p assets/images/brands/your-brand-slug/originals

# Add images (exact filenames must match front matter)
# Example:
assets/images/brands/your-brand-slug/originals/logo-color.png
assets/images/brands/your-brand-slug/originals/hero-image.jpg
```

**⚠️ Critical**:
- Image filenames in markdown MUST exactly match actual filenames
- Use lowercase filenames
- PNG for logos, JPG for photos
- Store in `assets/images/brands/{slug}/originals/` directory

---

## Step 4: Sync to Supabase

After creating markdown files and adding images:

```bash
# Run sync script
npm run sync
```

**Expected output**:
```
📦 Processing brand: your-brand-slug
   📤 Uploading images...
      ✓ Uploaded: logo-color.png
      ✓ Uploaded: hero-image.jpg
   💾 Upserting brand record...
      ✓ Brand record upserted: [uuid]
   🌐 Inserting translations...
      ✓ Inserted 9 translations
   🔗 Updating taxonomy relationships...
      ✓ Taxonomy relationships updated
   ✅ Brand your-brand-slug synced successfully

==================================
✅ Sync complete!
   - Success: X brand(s)
   - Errors: 0 brand(s)
==================================
```

**Troubleshooting**:
- **"Image not found"**: Check image path matches `assets/images/brands/{slug}/originals/{filename}`
- **"Dimension not found"**: Check taxonomy slug exists in `data/taxonomies/*.json`
- **"Failed to parse front matter"**: Check YAML syntax (indentation, quotes, colons)

---

## Step 5: Build Site

```bash
# Build Hugo site + Pagefind search index
npm run build
```

**Expected output**:
```
Indexed 3 languages
Indexed 173 pages
Indexed 3003 words
Finished in 0.221 seconds
```

**Verify**:
- Check `public/brands/your-brand-slug/index.html` exists
- Search for brand name in Pagefind index

---

## Step 6: Preview Locally (Optional)

```bash
# Start Hugo development server
npm run dev

# Open in browser
open http://localhost:1313
```

**Test checklist**:
- [ ] Brand appears in brands list page
- [ ] Individual brand page renders correctly
- [ ] Images load properly (logo + hero)
- [ ] Taxonomy pills display (markets, sectors, attributes, signals)
- [ ] Language switcher works (EN → RU → ZH)
- [ ] Search finds brand by name
- [ ] Mobile view looks good (320px-414px width)

---

## Step 7: Deploy to Production

### Option A: Push to GitHub (Auto-Deploy)
```bash
# Commit changes
git add .
git commit -m "feat: add [brand-name] brand profile"
git push origin main

# Cloudflare Pages auto-deploys within 1-2 minutes
```

### Option B: Manual Deploy via Cloudflare Pages
1. Go to Cloudflare Pages dashboard
2. Click **Create deployment**
3. Select **Production** branch
4. Wait for build to complete (~30 seconds)

---

## Quick Reference: File Checklist

For each new brand, create:

```
content/brands/your-brand-slug/
├── _index.en.md    ✅ English content
├── _index.ru.md    ✅ Russian translation
└── _index.zh.md    ✅ Chinese translation

assets/images/brands/your-brand-slug/originals/
├── logo-color.png  ✅ Brand logo (PNG, square, transparent)
└── hero-image.jpg  ✅ Hero image (JPG, landscape, 1200x630)
```

---

## Common Workflows

### Add Brand + Sync + Build + Deploy
```bash
# Complete workflow (3 commands)
npm run sync       # Sync to Supabase
npm run build      # Build site + search
git add . && git commit -m "feat: add new brand" && git push  # Deploy
```

### Update Existing Brand
1. Edit markdown files in `content/brands/[slug]/`
2. Run `npm run sync` to update Supabase
3. Run `npm run build` to rebuild site
4. Push to GitHub to deploy

### Replace Brand Images
1. Update images in `assets/images/brands/[slug]/originals/`
2. Run `npm run sync` (script detects and re-uploads changed images)
3. Run `npm run build`
4. Deploy

---

## Taxonomy Management

### View Available Taxonomies
```bash
# Markets (15 options)
cat data/taxonomies/markets.json

# Sectors (16 options)
cat data/taxonomies/sectors.json

# Attributes (8 options)
cat data/taxonomies/attributes.json

# Signals (4 options)
cat data/taxonomies/signals.json
```

### Add New Taxonomy Values
**⚠️ Requires CTO intervention** - Contact CTO to:
1. Add to JSON files in `data/taxonomies/`
2. Seed to Supabase dimensions table
3. Update translation files

---

## Batch Operations

### Add Multiple Brands
```bash
# Create all brand directories first
mkdir -p content/brands/brand-one content/brands/brand-two content/brands/brand-three

# Create markdown files for each
# Add images for each
# Then sync all at once

npm run sync  # Syncs all brands in one operation
```

### Export Brand Data from Supabase
```bash
# View brand data in Supabase dashboard
# Or use Supabase CLI to export CSV
```

---

## Troubleshooting

### Issue: Sync fails with "Invalid YAML"
**Solution**:
- Check front matter indentation (use 2 spaces, not tabs)
- Ensure colons have space after them (`key: value` not `key:value`)
- Quote values with special characters (`title: "Brand & Co."`)
- Arrays use square brackets (`markets: ["russia", "china"]`)

### Issue: Images don't appear on site
**Solution**:
- Verify image path: `assets/images/brands/{slug}/originals/{filename}`
- Check filename exactly matches front matter (case-sensitive)
- Ensure images are PNG (logo) or JPG (hero), not other formats
- Run `npm run sync` again to re-upload

### Issue: Brand doesn't appear in search
**Solution**:
- Run `npm run build` to regenerate Pagefind index
- Check `draft: false` in front matter (draft brands aren't indexed)
- Verify brand page exists in `public/brands/{slug}/`

### Issue: Taxonomy pills don't show
**Solution**:
- Check taxonomy slugs match exactly (lowercase, hyphens)
- Verify taxonomy exists in `data/taxonomies/*.json`
- Ensure array syntax is correct (`markets: ["russia"]` not `markets: russia`)

---

## Performance Tips

### Optimize Images Before Upload
```bash
# Recommended tools:
# - TinyPNG (https://tinypng.com) for PNG logos
# - ImageOptim (macOS) for JPG/PNG
# - Squoosh (https://squoosh.app) for WebP conversion

# Target sizes:
# Logo: < 100 KB
# Hero: < 300 KB
```

### Content Writing Tips
- **Concise**: 2-4 paragraphs per language (300-600 words)
- **SEO-friendly**: Include brand name, sector, and market keywords
- **Storytelling**: Focus on founder journey, unique value prop, growth story
- **Call-to-action**: End with export readiness or partnership opportunity

---

## Support

### Questions?
- **Technical issues**: Ask CTO (Claude)
- **Content strategy**: CEO decision
- **Taxonomy additions**: CTO approval required
- **Deployment issues**: Check Cloudflare Pages logs

### Useful Commands
```bash
npm run dev          # Local development server
npm run sync         # Sync to Supabase
npm run build        # Build site + search
npm run search       # Rebuild search index only
hugo server          # Hugo dev server only
```

### Key Files Reference
- **Taxonomies**: `data/taxonomies/*.json`
- **Translations**: `data/translations/*.yml`
- **Sync script**: `scripts/sync-to-supabase.js`
- **Build config**: `package.json`, `hugo.yaml`
- **Deployment**: `docs/deployment-checklist.md`

---

**Last Updated**: 2025-10-03
**Workflow Version**: 1.0 (Production-ready)
**Next Steps**: Add brands, build content library, deploy to production
