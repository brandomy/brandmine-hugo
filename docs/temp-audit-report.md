# /temp/ Directory Audit Report

**Date**: 2025-10-05
**Auditor**: CTO (Claude)
**Scope**: Complete assessment of `/temp/` for migration-worthy content

---

## Executive Summary

The `/temp/` directory contains **235 image files** (all originals, responsive variants deleted), **125 dimension content files**, **42 brand/founder/insight files**, and **extensive Jekyll data structures**. Most content has already been migrated to Hugo in cleaner formats. Key findings:

- **CRITICAL**: 235 original images in temp vs 0 in Hugo static (brand directories exist but are empty)
- **HIGH**: 125 dimension explanation files (EN/RU/ZH) with rich content
- **LOW**: Data files are mostly obsolete (superseded by Hugo taxonomy system)
- **SKIP**: Separators (use Hugo shortcodes), layouts/includes (Jekyll artifacts)

**Cleanup Completed**: Deleted 528 responsive variants (400w/800w/1200w) from temp - Hugo generates these automatically.

---

## 1. Data Files Audit (`/temp/_data/`)

### Core Content Files

| File | Content Summary | Hugo Equivalent | Migration Value |
|------|----------------|-----------------|-----------------|
| `brands.json` | 6 brands with metadata (Serra Verde, Sojourn, Altai Honey, Seven Spices, Taiga Spirits, Teatime) | `/content/brands/` markdown files | **OBSOLETE** - Content migrated to Hugo front matter |
| `founders.json` | 4 founders (Eduardo Santos, Alexei Sokolov, Ivan Petrov, Maria Kuznetsova) | `/content/founders/` markdown files | **OBSOLETE** - Migrated |
| `insights.json` | Insight metadata | `/content/insights/` structure | **OBSOLETE** - Migrated |

### Taxonomy Files

| File | Content Summary | Hugo Equivalent | Migration Value |
|------|----------------|-----------------|-----------------|
| `markets.json` | 147KB - Comprehensive market data with translations | `/data/taxonomies/markets.json` (smaller) | **REVIEW** - Hugo version is streamlined, check for lost translations |
| `sectors.json` | Sector taxonomy with multilingual labels | `/data/taxonomies/sectors.json` | **REVIEW** - Compare translation completeness |
| `attributes.json` | 7KB attribute definitions | `/data/taxonomies/attributes.json` | **REVIEW** - Check parity |
| `signals.json` | Signal taxonomy | `/data/taxonomies/signals.json` | **REVIEW** - Check parity |

### Supporting Data Files

| File | Content Summary | Hugo Equivalent | Migration Value |
|------|----------------|-----------------|-----------------|
| `countries.json` | 41KB - Country data (identical to `/data/countries.json`) | `/data/countries.json` | **OBSOLETE** - Exact duplicate |
| `case_studies.yml` | 21KB - Case study definitions | Not migrated (case studies disabled) | **SKIP** - Case studies not in scope |
| `featured_content.yml` | 16KB - Featured content logic | Hugo uses front matter `featured: true` | **OBSOLETE** - Pattern replaced |
| `component_defaults.yml` | 10KB - Jekyll component defaults | N/A (Hugo uses partials) | **OBSOLETE** - Jekyll artifact |
| `dimensions_config.yml` | Dimension configuration | `/hugo.yaml` params.dimensions | **OBSOLETE** - Migrated to Hugo config |
| `language_map.json` | 14KB - Language mappings | `/i18n/*.yml` files | **OBSOLETE** - Hugo i18n system |
| `market_sector_map.json` | 70KB - Market-sector relationships | Computed from taxonomy at build | **OBSOLETE** - Hugo computes dynamically |
| `image_attributions.yml` | Image credits/attributions | Should move to `/data/image_attributions.yml` | **KEEP** - Legal compliance |

### Subdirectories

| Directory | Content | Hugo Equivalent | Migration Value |
|-----------|---------|-----------------|-----------------|
| `dimensions/` | Dimension category metadata | `/data/dimensions.yaml` | **OBSOLETE** - Migrated |
| `fallback/` | Fallback text patterns | Hugo uses i18n defaults | **OBSOLETE** |
| `footer/` | Footer link structures | Hardcoded in `/layouts/partials/footer.html` | **OBSOLETE** |
| `icons/` | Icon metadata | N/A (icons in `/static/icons/`) | **OBSOLETE** |
| `insights/` | Insight category configs | `/data/insights.yaml` | **OBSOLETE** - Migrated |
| `market-sectors/` | Market-sector mappings | Computed dynamically | **OBSOLETE** |
| `navigation/` | Navigation structures | Hardcoded in templates | **OBSOLETE** |
| `pricing/` | Pricing tiers | `/data/pricing.yaml` | **OBSOLETE** - Migrated |
| `social/` | Social media links | In `/hugo.yaml` or footer | **OBSOLETE** |
| `translations/` | Jekyll i18n files | `/i18n/en.yml`, `/i18n/ru.yml`, `/i18n/zh.yml` | **OBSOLETE** - Migrated |

**Verdict**: Only `image_attributions.yml` worth keeping. All other data obsolete or superseded.

---

## 2. Images Audit (`/temp/assets/images/`)

### Summary Comparison

| Location | Original Images | Notes |
|----------|----------------|-------|
| `/temp/assets/images/` | **235 files** | Responsive variants deleted (528 removed) |
| `/assets/images/` | **~56 files** | Working images (brands, founders, insights) |

**CORRECTION**: Hugo stores images in `/assets/images/`, NOT `/static/images/`.

**Hugo Pattern**: Store originals in `/assets/images/`, Hugo processes them at build time.

**Temp Cleanup**: All responsive variants (400w, 800w, 1200w) deleted. Only original images remain.

### Breakdown by Category

| Category | Original Files in Temp | Hugo /assets/images/ | Status |
|----------|----------------------|---------------------|--------|
| **Brands** | 22 (incl. 3 from brands/) | 22 | ✅ **MIGRATED** (added dragonfly-retreats) |
| **Founders** | 16 | 20 | ✅ **MIGRATED** (added 5 missing founders) |
| **Case Studies** | 8 (from brands/) | 8 | ✅ **MIGRATED** (perfect-diary, sugar-cosmetics, walk-of-shame) |
| **Insights** | 15 | 12 | ⚠️ **PARTIAL** (3 missing) |
| **Dimensions** | 84 | 0 | ❌ **MISSING** |
| **Icons** | 43 | 43 | ✅ Migrated (in /static/icons/) |
| **People** | 12 | 3 | ⚠️ Review (team members?) |
| **Site** | 12 | 2 (logos) | ⚠️ Partial |
| **Categories** | 8 | 3 | ⚠️ Partial |
| **Pages** | 7 | 0 | ⚠️ Review |
| **Placeholders** | 6 | 0 | ❌ **MISSING** |
| **Journal** | 6 | 0 | N/A (journal not migrated) |
| **TOTAL** | **235** | **110** | **125 files remaining in temp**

### Critical Missing Images (Originals Only)

#### Brands (22 original images)
**Location**: `/temp/assets/images/brands/{brand-ref}/originals/`

**Per-brand pattern** (3-4 originals each):
- `hero-{scene}.jpg` - Brand hero/header image
- `logo-color.png` - Brand logo
- `portrait-{context}.jpg` - Founder/team portrait
- `location-{context}.jpg` - Optional location shot

**Example**: `ru-altai-honey/originals/`
```
hero-apiaries.jpg
logo-color.png
portrait-working.jpg
```

**Hugo Status**: ❌ Directories created (`/static/images/brands/altai-honey/`) but **empty**

#### Founders (16 original images)
**Location**: `/temp/assets/images/founders/{founder-ref}/originals/`

**Per-founder pattern** (2-3 originals each):
- `portrait-{style}.jpg` - Professional portrait
- `context-{scene}.jpg` - Optional contextual photo

**Hugo Status**: ❌ NO founder images

#### Insights (Unknown count)
**Location**: `/temp/assets/images/insights/{insight-ref}/`
**Note**: Does NOT use `/originals/` subdirectory pattern consistently

**Hugo Status**: ❌ NO insight images

#### Dimensions (84 original images)
**Location**: `/temp/assets/images/dimensions/{type}/{slug}/originals/`

**Per-dimension pattern** (1 original each):
- `hero-{theme}.jpg` - Visual representing the dimension

**Example**: `sectors/gourmet-foods/originals/`
```
hero-marketplace.jpg
```

**Hugo Status**: ❌ NO dimension images

### Migration Status

**✅ COMPLETED** (50 images migrated):
- ✅ Brands: All 22 originals (including dragonfly-retreats client testimonial)
- ✅ Founders: All 20 originals (added eduardo-santos, isabela-mendez, alexei-sokolov, nikolai-volkov, georgie-yam)
- ✅ Case Studies: All 8 originals (perfect-diary, sugar-cosmetics, walk-of-shame)

**❌ REMAINING** (125 images in temp):
- ❌ Dimensions: 84 originals → `/assets/images/dimensions/{type}/{slug}/`
- ⚠️ Insights: 3 missing → Review and migrate if needed
- ⚠️ Placeholders: 6 → Migrate to `/assets/images/placeholders/`
- ⚠️ People/Site/Categories/Pages: ~32 → Review for relevance

**Next Migration Commands** (dimensions):
```bash
# Migrate dimension images (84 files)
find temp/assets/images/dimensions -path "*/originals/*" -type f -exec sh -c 'TYPE=$(basename $(dirname $(dirname $(dirname "$1")))); SLUG=$(basename $(dirname $(dirname "$1"))); mkdir -p assets/images/dimensions/$TYPE/$SLUG && cp "$1" assets/images/dimensions/$TYPE/$SLUG/$(basename "$1")' _ {} \;

# Verify
find assets/images/dimensions -path "*/originals/*" | wc -l  # Should show 84
```

---

## 3. Separators Review (`/temp/separators/`)

### All 8 Separator Components

| File | Purpose | Parameters | Current Usage |
|------|---------|------------|---------------|
| `bullet-separator.html` | Stylized bullet (✦) for attribute lists | `symbol` (default: ✦) | Metadata grouping |
| `comma-separator.html` | Localized comma separator | Auto-detects `page.lang` | Multi-part names |
| `dot-separator.html` | Dot (•) separator | None | Inline metadata |
| `emoji-separator.html` | Emoji separator | `emoji` parameter | Playful lists |
| `en-dash-separator.html` | En dash (–) separator | None | Date ranges |
| `pipe-separator.html` | Vertical pipe (\|) separator | None | Alternative separator |
| `slash-separator.html` | Forward slash (/) separator | None | Paths, alternatives |
| `spacer.html` | Non-breaking space | None | Spacing control |

### Hugo Implementation Pattern

**Recommended**: Convert to Hugo **shortcodes** in `/layouts/shortcodes/`

#### Example: `bullet-separator` → Hugo Shortcode

**Create**: `/layouts/shortcodes/separator.html`
```go-html-template
{{- $type := .Get 0 | default "dot" -}}
{{- $symbol := .Get "symbol" -}}

{{- if eq $type "bullet" -}}
<span class="separator separator--bullet" aria-hidden="true">{{ $symbol | default "✦" }}</span>
{{- else if eq $type "dot" -}}
<span class="separator separator--dot" aria-hidden="true">•</span>
{{- else if eq $type "comma" -}}
<span class="separator separator--comma" aria-hidden="true">{{ i18n "comma" | default "," }}</span>
{{- else if eq $type "pipe" -}}
<span class="separator separator--pipe" aria-hidden="true">|</span>
{{- end -}}
```

**Usage in Markdown**:
```markdown
Artisanal {{< separator "bullet" >}} Organic {{< separator "bullet" >}} Export-ready

Founded 2015 {{< separator "dot" >}} Russia {{< separator "dot" >}} Honey & Bee Products
```

**CSS Required**: Create `/assets/css/components/separators.css`
```css
.separator {
  display: inline;
  padding: 0 0.5rem;
  color: var(--primary-400);
  user-select: none;
}

.separator--bullet {
  font-size: 0.875em;
  color: var(--secondary-500);
}
```

**Migration Value**: **LOW** - Separators are nice-to-have, not critical. Implement only if needed for content formatting.

---

## 4. Dimensions Content (`/temp/_dimensions/`)

### File Counts

| Language | Files | Hugo Equivalent |
|----------|-------|-----------------|
| EN | 45 | 1 file (`/content/dimensions/markets/russia.en.md`) |
| RU | 40 | 0 files |
| ZH | 40 | 0 files |
| **TOTAL** | **125** | **1** |

### Content Structure

**Temp Dimensions** follow Jekyll pattern:
```
/temp/_dimensions/
  en/
    sectors/gourmet-foods.md
    sectors/honey-bee-products.md
    markets/russia.md
    attributes/founder-led.md
    signals/rapid-growth.md
  ru/
    sectors/gourmet-foods.md (Russian translation)
  zh/
    sectors/gourmet-foods.md (Chinese translation)
```

**Hugo Dimensions** should follow:
```
/content/dimensions/
  sectors/
    gourmet-foods.en.md
    gourmet-foods.ru.md
    gourmet-foods.zh.md
  markets/
    russia.en.md
    russia.ru.md
    russia.zh.md
```

### Sample Content Analysis

**File**: `/temp/_dimensions/en/sectors/gourmet-foods.md`

**Front Matter**:
```yaml
lang: en
ref: sector-gourmet-foods
layout: dimension-profile
title: "Gourmet Foods"
dimension: gourmet-foods
category: sector
permalink: /en/discover/sectors/gourmet-foods/
subtitle: "Premium specialty foods..."
description: "Distinctive gourmet products..."
images:
  hero:
    name: "marketplace"
    alt: "..."
    ext: "jpg"
featured_brands: []
related_insights: []
```

**Body**: ~3 paragraphs of rich sector description, market context, export readiness

**Content Quality**: ⭐⭐⭐⭐⭐ Excellent - Professional, detailed, business-focused

### Migration Impact Analysis

**Risk**: Dimensions are **core taxonomy**. Breaking them breaks site navigation.

**Current Hugo State**:
- Taxonomy system: ✅ Working (`/data/taxonomies/*.json`)
- Taxonomy labels: ✅ Working (`/data/taxonomy-labels.yml`)
- Taxonomy display: ✅ Tags show on cards
- Taxonomy pages: ❌ **NO CONTENT** (only 1 dimension page exists)

**Safe Migration Path**:

1. **Do NOT break existing taxonomy**
   - Keep `/data/taxonomies/*.json` files (taxonomy definitions)
   - Keep `/data/taxonomy-labels.yml` (translations)
   - Keep tag display system (working)

2. **Add dimension content pages** (optional enhancement)
   ```bash
   # Create Hugo-native dimension pages
   /content/dimensions/sectors/gourmet-foods.en.md
   /content/dimensions/sectors/gourmet-foods.ru.md
   /content/dimensions/sectors/gourmet-foods.zh.md
   ```

3. **Migration strategy**:
   - Convert Jekyll front matter to Hugo format
   - Change `layout: dimension-profile` → `type: dimension`
   - Update `permalink` to match Hugo URL structure
   - Preserve `translationKey` for multilingual linking

**Migration Value**: **HIGH** - Adds SEO-friendly dimension landing pages with rich content, but NOT critical for core functionality.

---

## 5. Multilingual Content Audit

### Brands

| Location | EN | RU | ZH | Total |
|----------|----|----|-----|-------|
| `/temp/_brands/` | 6 | 6 | 6 | 18 |
| `/content/brands/` | 6 dirs | ? | ? | 19 files |

**Temp Brands**:
1. `br-serra-verde.md` (EN/RU/ZH)
2. `br-sojourn-hotels.md` (EN/RU/ZH)
3. `ru-altai-honey.md` (EN/RU/ZH)
4. `ru-seven-spices.md` (EN/RU/ZH)
5. `ru-taiga-spirits.md` (EN/RU/ZH)
6. `ru-teatime.md` (EN/RU/ZH)

**Hugo Brands** (directories):
1. `altai-honey/`
2. `serra-verde/`
3. `seven-spices/`
4. `sojourn-hotels/`
5. `taiga-spirits/`
6. `teatime/`

**Analysis**: Same 6 brands, likely already migrated. Need to verify multilingual coverage.

**Action**: Check if Hugo brand files have `.en.md`, `.ru.md`, `.zh.md` variants.

### Founders

| Location | EN | RU | ZH | Total |
|----------|----|----|-----|-------|
| `/temp/_founders/` | 4 | 4 | 4 | 12 |
| `/content/founders/` | 4 dirs | ? | ? | 13 files |

**Temp Founders**:
1. `br-eduardo-santos.md` (EN/RU/ZH)
2. `ru-alexei-sokolov.md` (EN/RU/ZH)
3. `ru-ivan-petrov.md` (EN/RU/ZH)
4. `ru-maria-kuznetsova.md` (EN/RU/ZH)

**Hugo Founders** (directories):
1. `carlos-santos/` (was Eduardo?)
2. `ivan-petrov/`
3. `maria-volkova/` (was Kuznetsova?)
4. `pavel-titov/` (NEW - not in temp!)

**Analysis**: Name changes detected. Pavel Titov is NEW in Hugo (not in temp).

**Action**:
- Verify if Carlos Santos = Eduardo Santos (name change?)
- Verify if Maria Volkova = Maria Kuznetsova (name change?)
- Check multilingual coverage

### Insights

| Location | EN | RU | ZH | Total |
|----------|----|----|-----|-------|
| `/temp/_insights/` | 4 | 4 | 4 | 12 |
| `/content/insights/` | 4 subdirs | ? | ? | 4 files |

**Temp Insights** (all RU-prefixed):
1. `ru-russian-wine-renaissance.md` (EN/RU/ZH)
2. `ru-seven-spices-spotlight.md` (EN/RU/ZH)
3. `ru-siberian-honey-corridor.md` (EN/RU/ZH)
4. `ru-teatime-founder-journey.md` (EN/RU/ZH)

**Hugo Insights** (category-based structure):
```
brand-spotlight/
founders-journey/
location-intelligence/
market-momentum/
```

**Analysis**: Hugo has **different insights** with new 4-category taxonomy (aligned with insight types). Temp insights are legacy.

**Action**: Temp insights are **OBSOLETE**. Hugo insights follow new content strategy.

### Missing Content Summary

**Brands**: ✅ Content migrated (verify multilingual coverage)
**Founders**: ⚠️ Possible name changes, verify identity mapping
**Insights**: ✅ Content replaced with new strategy (temp insights obsolete)
**Dimensions**: ❌ **124 dimension pages NOT migrated** (HIGH value content)

---

## 6. Migration Priority

### CRITICAL (Do Immediately)

1. **Migrate core images** (138 files: brands + founders + dimensions)
   - Site is currently missing critical visual assets
   - **Impact**: Brand/founder cards appear broken without images
   - **Commands**: See Section 2 for detailed migration commands
   - **Verification**:
     ```bash
     find static/images/brands -type f | wc -l  # Should show 22
     find static/images/founders -type f | wc -l  # Should show 16
     find static/images/dimensions -type f | wc -l  # Should show 84
     ```

### HIGH (Plan for Phase 4)

2. **Migrate dimension content pages** (125 files)
   - Rich SEO content for taxonomy landing pages
   - Improves discoverability and educational value
   - Safe to add (doesn't break existing taxonomy)
   - **Steps**:
     - Convert Jekyll front matter to Hugo format
     - Reorganize from `en/sectors/` to `sectors/slug.en.md`
     - Update image paths
     - Test taxonomy linking

3. **Verify multilingual coverage**
   - Check if all brands/founders have EN/RU/ZH variants
   - Fill gaps if needed

### LOW (Nice to Have)

4. **Image attributions**
   - Move `/temp/_data/image_attributions.yml` to `/data/`
   - Ensure legal compliance for stock images

5. **Separator shortcodes**
   - Implement bullet-separator as Hugo shortcode if content needs it
   - Not critical for current site

### SKIP (Obsolete/Irrelevant)

6. **All other data files** - Jekyll artifacts, superseded by Hugo patterns
7. **Case studies** - Not in current scope
8. **Jekyll layouts/includes** - Hugo uses different template system
9. **Temp insights** - Replaced with new content strategy
10. **People images** (39 files) - Check if "people" = team members or founders

---

## Final Recommendations

### Immediate Actions (Week 1)

```bash
# 1. Migrate core images (brands, founders, dimensions)
find temp/assets/images/brands -path "*/originals/*" -type f -exec sh -c 'mkdir -p static/images/brands/$(basename $(dirname $(dirname "$1"))) && cp "$1" static/images/brands/$(basename $(dirname $(dirname "$1")))/$(basename "$1")' _ {} \;

find temp/assets/images/founders -path "*/originals/*" -type f -exec sh -c 'mkdir -p static/images/founders/$(basename $(dirname $(dirname "$1"))) && cp "$1" static/images/founders/$(basename $(dirname $(dirname "$1")))/$(basename "$1")' _ {} \;

find temp/assets/images/dimensions -path "*/originals/*" -type f -exec sh -c 'TYPE=$(basename $(dirname $(dirname $(dirname "$1")))); SLUG=$(basename $(dirname $(dirname "$1"))); mkdir -p static/images/dimensions/$TYPE/$SLUG && cp "$1" static/images/dimensions/$TYPE/$SLUG/$(basename "$1")' _ {} \;

# 2. Migrate insights and placeholders
cp -r temp/assets/images/insights/* static/images/insights/
cp -r temp/assets/images/placeholders/* static/images/placeholders/

# 3. Verify migration
find static/images/brands -type f | wc -l  # Should show 22
find static/images/founders -type f | wc -l  # Should show 16
find static/images/dimensions -type f | wc -l  # Should show 84
find static/images/insights -type f | wc -l  # Should show 15
find static/images/placeholders -type f | wc -l  # Should show 6

# 4. Test Hugo build
hugo server
# Check brand/founder cards display images correctly

# 5. Copy image attributions
cp temp/_data/image_attributions.yml data/

# 6. Commit
git add static/images/ data/image_attributions.yml
git commit -m "feat: migrate original images from temp (163 files: brands, founders, dimensions, insights, placeholders)"
```

### Phase 4 Planning (Dimension Pages)

- Audit 125 dimension files for content quality
- Design Hugo dimension page template
- Convert and migrate systematically (sectors first, then markets, attributes, signals)
- Test multilingual linking

### Archive Strategy

After migration complete:
```bash
# Archive temp/ for reference
tar -czf temp-archive-2025-10-05.tar.gz temp/
mv temp-archive-2025-10-05.tar.gz docs/archive/
rm -rf temp/
```

---

**Audit Complete**: 2025-10-05
**Next Review**: After image migration (verify all images display correctly)
