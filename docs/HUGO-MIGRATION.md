# ⚠️ STRATEGIC PIVOT - 2025-10-03

**Original Plan**: Import 575 Jekyll HTML files + 35 helpers (8-10 weeks)
**New Plan**: Build clean Hugo-native site, import content only (4 weeks)

## Rationale for Pivot

After comprehensive temp folder inspection (see `temp-folder-comprehensive-inventory.md` and `temp-folder-detailed-assessment.md`), discovered:

- **575 HTML template files** (25 layouts, 352 includes, 198 page sections)
- **35+ helper functions** with complex Jekyll Liquid logic
- **108+ components** with interdependencies
- **Jekyll-specific patterns** that don't translate cleanly to Hugo

**Technical debt vs. business value**:
- Converting Jekyll complexity = 8-10 weeks of template conversion work
- Building clean Hugo-native = 4 weeks with better architecture
- **Primary goal**: Fast data ingestion (Supabase → Hugo)
- **Secondary goal**: Elegant search (Pagefind integration)
- **Need**: Scalable architecture for 100s of brands, not complex component library

## Strategic Decision

**Import content, rebuild templates**:
- ✅ Import 166 markdown files (brands, founders, insights, dimensions)
- ✅ Import data layer (75+ JSON/YAML files)
- ✅ Copy 771 images (optimize later)
- ❌ Skip 575 Jekyll HTML templates (rebuild as needed)
- ❌ Skip 35+ Jekyll helpers (use Hugo native patterns)
- ❌ Skip complex component library (build minimal card system)

## What We Keep from Jekyll

**Content (166 files)**:
- 18 brand files (6 × 3 languages)
- 12 founder files (4 × 3 languages)
- 12 insight files (4 × 3 languages)
- 124 dimension files (44 × 3 languages)

**Data Layer (75+ files)**:
- Taxonomy data (markets, sectors, attributes, signals)
- Translation files (UI strings, dimension names, navigation)
- Content JSON (brands.json, founders.json, insights.json)
- Configuration (featured_content.yml, page_sections.yml)

**Images (771 files, 97 MB)**:
- Brand/founder/insight/dimension images
- Copy as-is initially, optimize with Hugo image processing later

**Text/Copy**:
- Page section content (extract from Jekyll partials)
- Home/About page copy
- Dimension explanations

## What We Rebuild Hugo-Native

**Templates**:
- Base layout (baseof.html) - Clean Hugo pattern
- Content type layouts (brand, founder, insight) - Simple Hugo templates
- List layouts - Hugo's built-in list patterns
- Taxonomy templates - Hugo's built-in taxonomy system

**Components**:
- Card system (brand-card, founder-card, insight-card) - Minimal, Hugo partials
- Navigation - Hugo menu system + language switcher
- Header/footer - Clean Hugo partials

**Features**:
- Search - Pagefind (Hugo-native static search)
- Multilingual - Hugo's built-in i18n
- Taxonomies - Hugo's native taxonomy system

**Data Ingestion**:
- Supabase integration - Custom Hugo data template
- Build script to fetch from Supabase API → Hugo content files

## New Approach Benefits

1. **Faster to production** - 4 weeks vs 8-10 weeks
2. **Clean architecture** - Hugo patterns, not Jekyll conversions
3. **Easier to maintain** - Less code, standard patterns
4. **Better performance** - No Jekyll legacy overhead
5. **Pagefind search** - Static search, no backend needed
6. **Supabase-ready** - Clean data layer for API integration
7. **Scalable** - Architecture for 100s of brands, not just 6

## Reference Documentation

**Kept for reference** (archived but valuable):
- `temp-folder-comprehensive-inventory.md` - Full Jekyll structure analysis
- `temp-folder-detailed-assessment.md` - Detailed component inventory
- `temp/` folder - Complete Jekyll site archive

**New strategic plan**:
- See `CLEAN-BUILD-PLAN.md` for detailed 4-week implementation plan

---

# Original Migration Plan (ARCHIVED)

*The following represents the original Jekyll-to-Hugo conversion plan. Kept for reference but not being executed.*

## Original Content Inventory

### Jekyll Site Structure

**Content Files** (198 markdown):
- Brands: 6 files × 3 languages = 18 files
- Founders: 4 files × 3 languages = 12 files
- Insights: 4 files × 3 languages = 12 files
- Dimensions: 44 files × 3 languages = 124 files
- Case Studies: Disabled (8 files)
- Dummy Data: Test content (not production)

**Template Files** (575 HTML):
- Layouts: 25 Jekyll templates
- Includes: 352 component/helper files
  - Components: 108 files (cards, navigation, forms, etc.)
  - Helpers: 35+ data lookup/formatting functions
  - Page sections: 21 page types with multiple sections each
- Page Sections: 198 standalone section files

**Data Files** (75+ YAML/JSON):
- Taxonomy data: markets.json, sectors.json, attributes.json, signals.json
- Content data: brands.json, founders.json, insights.json
- Translations: 3 language files with UI strings
- Configuration: featured_content.yml, page_sections.yml, etc.

**Images** (771 files, 97 MB):
- Brand images (10 brand sets)
- Founder images (7 founder sets)
- Insight images (4 insight sets)
- Dimension images (markets, sectors, attributes, signals)
- Site assets (logos, icons, favicons)

### Original Migration Phases

**Phase 1: Foundation** (Week 1)
- Import content (brands, founders, insights, dimensions)
- Convert separators to Hugo shortcodes
- Setup basic layouts

**Phase 2: Core Templates** (Week 2)
- Convert content type layouts (brand, founder, insight)
- Convert list layouts
- Test taxonomy pages

**Phase 3: Components** (Week 3)
- Convert card components (brand-card, founder-card, insight-card)
- Convert navigation components
- Convert essential UI components

**Phase 4: Pages** (Week 4)
- Convert home page layout + 15 sections
- Convert about page layout + 9 sections
- Convert dimension pages

**Phase 5: Images** (Week 5)
- Generate WebP versions
- Create responsive sizes (320w, 768w, 1024w, 1920w)
- Update image references

**Phase 6: Polish** (Week 6)
- Convert remaining 95 components as needed
- Quality assurance
- Performance audit

### Original Risk Assessment

**High Risk**:
- Component library complexity (108 files with interdependencies)
- Helper conversion (35+ functions with Liquid logic)
- Card data lookups (Jekyll patterns ≠ Hugo patterns)
- Image pipeline (771 files, time-consuming)

**Medium Risk**:
- Template logic conversion (Liquid → Go templates)
- Taxonomy integration (Hugo's system differs from Jekyll)
- Multilingual content (translation key linking)

**Low Risk**:
- Content migration (straightforward, well-structured)
- Data files (already Hugo-compatible formats)
- Separators (simple, isolated)

### Why This Plan Was Abandoned

1. **Complexity vs. value** - 575 template files to convert for 6 brands
2. **Technical debt** - Jekyll patterns don't fit Hugo's philosophy
3. **Timeline** - 6 weeks for templates vs. 4 weeks for complete rebuild
4. **Scalability** - Complex component library not needed for growth
5. **Business goals** - Need fast data ingestion (Supabase), not Jekyll preservation
6. **Search requirements** - Pagefind integration easier with clean build
7. **Maintenance burden** - Simpler to maintain Hugo-native code

---

**Status**: Plan pivoted to clean Hugo build (see `CLEAN-BUILD-PLAN.md`)
**Date**: 2025-10-03
**Decision**: CTO autonomous decision based on technical assessment
