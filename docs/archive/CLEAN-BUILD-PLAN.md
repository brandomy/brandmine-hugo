# Clean Hugo Build Plan
**Strategic Decision**: Build Hugo-native site, import Jekyll content only
**Timeline**: 4 weeks
**Date**: 2025-10-03

## Overview

Build a clean, Hugo-native Brandmine site optimized for:
1. **Fast data ingestion** - Supabase → Hugo content pipeline
2. **Elegant search** - Pagefind static search integration
3. **Scalability** - Architecture for 100s of brands
4. **Simplicity** - Minimal components, standard Hugo patterns
5. **Performance** - < 2s load times, optimal Core Web Vitals

## Import from Jekyll

**Content** (166 markdown files):
- ✅ 18 brand files (6 brands × 3 languages)
- ✅ 12 founder files (4 founders × 3 languages)
- ✅ 12 insight files (4 insights × 3 languages)
- ✅ 124 dimension files (44 dimensions × 3 languages)

**Data** (75+ files):
- ✅ Taxonomy data (markets, sectors, attributes, signals)
- ✅ Translation files (UI strings, dimension names)
- ✅ Content JSON (brands, founders, insights)
- ✅ Configuration YAML

**Images** (771 files, 97 MB):
- ✅ Copy originals as-is
- ⏳ Optimize with Hugo image processing (later phase)

**Text/Copy**:
- ✅ Extract page section content from Jekyll partials
- ✅ Home/About page copy

## Build Hugo-Native

**Templates** (build from scratch):
- Base layout (baseof.html)
- Content type layouts (brand, founder, insight, dimension)
- List layouts (brands, founders, insights)
- Taxonomy term templates
- Home/About page layouts

**Components** (minimal set):
- Brand card partial
- Founder card partial
- Insight card partial
- Navigation partial
- Language selector partial
- Header/footer partials

**Features**:
- Pagefind search integration
- Hugo multilingual (en, ru, zh)
- Hugo taxonomies (markets, sectors, attributes, signals)
- Responsive images (Hugo image processing)

---

## Phase 1: Foundation (Week 1)

### Day 1-2: Hugo Setup + Content Import

**Tasks**:
1. Configure Hugo multilingual
2. Configure taxonomies
3. Import content files (brands, founders, insights, dimensions)
4. Import data layer
**Deliverable**: Content accessible, Hugo builds without errors

### Day 3-4: Base Layout + Typography

**Tasks**:
1. Create layouts/_default/baseof.html
2. Set up typography system (PT Sans, PT Serif, Noto Sans SC)
3. Copy fonts to static/fonts/
4. Create minimal CSS (reset, typography, colors, mobile-first)
**Deliverable**: Clean base template, typography working

### Day 5: Navigation + Header/Footer

**Tasks**:
1. Create layouts/partials/header.html
2. Create layouts/partials/footer.html
3. Create layouts/partials/nav.html
4. Create layouts/partials/language-selector.html
**Deliverable**: Working navigation, language switching

---

## Phase 2: Content Types + Search (Week 2)

### Day 6-7: Brand Layout + Cards

**Tasks**:
1. Create layouts/brands/single.html
2. Create layouts/brands/list.html
3. Create layouts/partials/brand-card.html
4. Test with imported brands (6 brands)
**Deliverable**: Brand pages rendering, brand list working

### Day 8: Founder Layout + Cards

**Tasks**:
1. Create layouts/founders/single.html
2. Create layouts/founders/list.html
3. Create layouts/partials/founder-card.html
4. Test with imported founders (4 founders)
**Deliverable**: Founder pages rendering, founder list working

### Day 9: Insight Layout + Cards

**Tasks**:
1. Create layouts/insights/single.html
2. Create layouts/insights/list.html
3. Create layouts/partials/insight-card.html
4. Test with imported insights (4 insights)
**Deliverable**: Insight pages rendering, insight list working

### Day 10: Pagefind Search Integration

**Tasks**:
1. Install Pagefind
2. Add Pagefind to build process
3. Create search page
4. Create layouts/search/list.html
5. Add search to navigation
6. Test search functionality
**Deliverable**: Working static search across all content

---

## Phase 3: Taxonomies + Dimensions (Week 3)

### Day 11-12: Taxonomy Templates

**Tasks**:
1. Create layouts/_default/terms.html
2. Create layouts/_default/taxonomy.html
3. Create layouts/partials/taxonomy-pill.html
4. Test all 4 taxonomies (markets, sectors, attributes, signals)
**Deliverable**: All taxonomy pages rendering correctly

### Day 13: Dimension Content Pages

**Tasks**:
1. Review imported dimension content (124 files)
2. Create layouts/dimensions/single.html (if needed)
3. Test dimension pages
**Deliverable**: Dimension content pages working

### Day 14-15: Home + About Pages

**Tasks**:
1. Create layouts/index.html (home page)
2. Create content/about/_index.md
3. Create layouts/about/list.html (about page)
4. Extract copy from Jekyll partials
**Deliverable**: Home and About pages complete

---

## Phase 4: Supabase Integration (Week 4)

### Day 16-17: Supabase Schema Design

**Tasks**:
1. Design Supabase tables (brands, founders, insights)
2. Set up Supabase project
3. Create tables
4. Seed with current content
**Deliverable**: Supabase schema ready

### Day 18: Data Sync Script

**Tasks**:
1. Create scripts/sync-from-supabase.js
2. Add sync to package.json
**Deliverable**: Working Supabase → Hugo sync script

### Day 19: Image Optimization

**Tasks**:
1. Set up Hugo image processing
2. Copy images from temp
3. Update card partials to use responsive-image partial
4. Generate WebP versions
5. Create responsive sizes (320w, 768w, 1024w, 1920w)
**Deliverable**: Optimized images, responsive loading

### Day 20: Polish + Deploy

**Tasks**:
1. Performance audit (Lighthouse)
2. Cross-browser testing
3. Multilingual testing
4. Search testing
5. Deploy to Cloudflare Pages
**Deliverable**: Production-ready site deployed

---

## Technical Decisions

### Why Pagefind?

**Static search benefits**:
- No backend required
- Fast client-side search
- Works offline
- Privacy-friendly
- Multilingual support
- Automatically indexes Hugo content

**Decision**: Pagefind best fits static site philosophy

### Why Supabase?

**Advantages**:
- PostgreSQL (robust, JSONB support)
- Real-time capabilities
- Auto-generated API
- Free tier
- Open source

**Use case**:
- Editorial team enters brands in Supabase UI
- CI/CD runs sync script
- Hugo rebuilds with latest data
- Cloudflare Pages deploys

**Decision**: Supabase provides best balance of ease + power

### What to Skip from Jekyll

**Not importing**:
- 575 Jekyll HTML templates (rebuild Hugo-native)
- 35+ Jekyll helpers (use Hugo functions)
- Complex component library (build minimal cards)
- Carousel/slider components
- Complex filtering UI
- Map components (defer to future)
- Case study content (disabled)

**Rationale**: Simpler = easier to maintain, Hugo-native = better performance

---

## Success Criteria

**Week 1**: Content imported, base layout working, navigation functional
**Week 2**: All content types rendering, Pagefind search operational
**Week 3**: Taxonomies working, Home/About complete
**Week 4**: Supabase sync working, site deployed, Lighthouse > 90

## Performance Targets

- First Contentful Paint: < 1.5s
- Largest Contentful Paint: < 2.5s
- Total Blocking Time: < 200ms
- Cumulative Layout Shift: < 0.1
- Speed Index: < 3.0s
- Lighthouse Score: > 90

---

**Status**: Ready to execute
**Start Date**: 2025-10-03
**Target Completion**: 2025-10-31
**Responsible**: CTO (autonomous)
