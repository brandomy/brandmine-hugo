# Brandmine Hugo Architecture: Final Implementation Plan

## Executive Summary

**Project**: Migration from Jekyll to Hugo for Brandmine platform  
**Timeline**: 5 days to functional MVP with demo content  
**Objective**: Launch empty shell ready for real content fill post-launch  
**Status**: Architecture fully specified, ready for Claude Code implementation

---

## Strategic Context

### Business Model
Brandmine is the first comprehensive consumer brand database capturing Russia's geopolitical pivot from West to East. We illuminate founder-led brands from BRICS+ markets, connecting them with international partners and capital.

### Target Audiences
1. Russian brand founders seeking Eastern/Global South expansion
2. Diaspora investors seeking heritage country opportunities
3. International partners seeking authentic emerging market brands

### Geographic Strategy
- **Home Base**: Malaysia (ASEAN gateway, neutral ground for all BRICS)
- **Primary Focus**: Russia (succession-planning founders, geopolitical timing)
- **Cultural Bridge**: China (20-year founder experience, natural expansion path)

---

## Technical Foundation

### Core Architecture Decisions

**1. Content Organization: Hybrid Language Suffix Pattern**

```
content/
├── brands/
│   ├── _index.en.md
│   ├── _index.ru.md
│   ├── _index.zh.md
│   └── teatime/
│       ├── _index.en.md
│       ├── _index.ru.md
│       └── _index.zh.md
├── founders/
│   └── pavel-titov/
│       ├── _index.en.md
│       └── _index.ru.md
├── insights/
│   ├── brand-spotlight/
│   ├── founders-journey/
│   ├── location-intelligence/
│   └── market-momentum/
└── dimensions/
    ├── markets/
    │   └── russia.en.md
    ├── sectors/
    ├── attributes/
    └── signals/
```

**Rationale**: Hugo's built-in translation linking via `translationKey`, content types stay logically grouped, language versions discoverable via file suffix.

---

**2. Taxonomy Implementation: Hybrid Hugo + Client-Side**

```yaml
# hugo.yaml
taxonomies:
  market: markets
  sector: sectors
  attribute: attributes
  signal: signals
```

**Hugo Handles**: SEO-friendly single taxonomy pages (`/markets/russia/`)  
**JavaScript Handles**: Multi-taxonomy intersection filtering (Russia + Wine brands)

**Rationale**: Best of both worlds—SEO benefits for individual dimensions, dynamic UX for complex queries, avoids combinatorial URL explosion.

---

**3. Founder-Brand Linking: Manual References**

```yaml
# Brand front matter
founder: "pavel-titov"  # Single slug reference

# Founder front matter
# No explicit brand list - computed from brands referencing this founder
```

**Template Pattern**: Bidirectional lookup via Hugo's `.Site.RegularPages` filtering

**Rationale**: Explicit, unambiguous, supports 1:1 and 1:many relationships, easy validation.

---

**4. Insights Organization: Subdirectories Only**

```
content/insights/
├── brand-spotlight/
├── founders-journey/
├── location-intelligence/
└── market-momentum/
```

**Front Matter**:
```yaml
insightType: "founders-journey"  # Single value, matches directory name
```

**No Hugo Categories**: Explicit field only, simpler and faster.

**Rationale**: File location = category assignment (physical enforcement), one source of truth, no redundancy.

---

**5. Dimension Description Pages: Optional Rich Content**

**Pattern**: Taxonomy auto-lists always work, optional markdown adds rich content when desired.

```go-html-template
{{ $content := .Site.GetPage (printf "dimensions/markets/%s" .Data.Term) }}
{{ if $content }}
  {{ $content.Content }}  <!-- Rich content if exists -->
{{ end }}
<!-- Brand list always renders regardless -->
```

**Launch Strategy**: Auto-lists only, add Russia overview post-launch, scale progressively.

---

**6. Search/Filter: Client-Side JSON**

**Data Generation**: Hugo outputs JSON during build  
**Search**: Vanilla JavaScript with inverted index  
**Filtering**: Multi-taxonomy intersection logic  
**Performance**: Lazy-load on first search input focus

**Rationale**: China-accessible, zero ongoing costs, static hosting compatible, fast for 500 brands.

---

**7. Asset Organization**

```
assets/              # Processed by Hugo Pipes
├── scss/
│   ├── tokens/      # Design system (from Jekyll)
│   └── components/
└── js/
    ├── search.js
    └── filter.js

static/              # Served directly
├── fonts/           # Self-hosted PT Sans/Serif, Noto SC
├── images/
│   ├── dimensions/
│   └── insights/
└── icons/
    └── sprite.svg
```

---

## Complete Color System (CORRECTED)

### Brand Identity

| Element | Color | CSS Variable | Hex |
|---------|-------|--------------|-----|
| Primary | Teal | `--primary-500` | #38B2AC |
| Secondary | Orange | `--secondary-500` | #F97316 |
| Accent | Indigo | `--accent-500` | #6366F1 |

### Dimension Taxonomy

| Type | Color | CSS Variable | Hex |
|------|-------|--------------|-----|
| **Markets** | Sky Blue | `--sky-500` | #0EA5E9 |
| **Sectors** | Olive Green | `--olive-500` | #A3B763 |
| **Attributes** | Orange | `--secondary-500` | #F97316 |
| **Signals** | Indigo | `--accent-500` | #6366F1 |

### Insight Categories (Aligned with Dimensions)

| Category | Color | CSS Variable | Aligned With |
|----------|-------|--------------|--------------|
| Brand Spotlight | Orange | `--secondary-500` | Attributes |
| Founder's Journey | Indigo | `--accent-500` | Signals |
| Location Intelligence | Sky Blue | `--sky-500` | Markets |
| Market Momentum | Olive Green | `--olive-500` | Sectors |

**Critical Rule**: Insight colors MUST match dimension colors for visual consistency.

---

## Complete Hugo Configuration

```yaml
# hugo.yaml
baseURL: "https://brandmine.io"
languageCode: "en"
title: "Brandmine"

# Build settings
buildDrafts: false
buildFuture: false
enableRobotsTXT: true
enableGitInfo: true

# Multilingual
defaultContentLanguage: "en"
defaultContentLanguageInSubdir: false

languages:
  en:
    languageName: "English"
    weight: 1
    params:
      description: "Discover exceptional founder-led brands from BRICS+ markets"
  ru:
    languageName: "Русский"
    weight: 2
    params:
      description: "Откройте для себя исключительные бренды основателей из стран БРИКС+"
  zh:
    languageName: "中文"
    weight: 3
    params:
      description: "发现来自金砖国家的杰出创始人品牌"

# Taxonomies (4 dimensions)
taxonomies:
  market: "markets"
  sector: "sectors"
  attribute: "attributes"
  signal: "signals"

# Pagination
paginate: 24

# Permalinks
permalinks:
  brands: "/:section/:slug/"
  founders: "/:section/:slug/"
  insights: "/:section/:slug/"

# Image processing
imaging:
  resampleFilter: "Lanczos"
  quality: 85
  anchor: "Smart"

# Minification
minify:
  disableXML: true
  minifyOutput: true

# Markup
markup:
  goldmark:
    renderer:
      unsafe: true
  highlight:
    style: "monokai"
    lineNos: false
    noClasses: false

# Output formats
outputs:
  home: ["HTML", "RSS", "JSON"]
  section: ["HTML", "RSS"]
  taxonomy: ["HTML", "RSS"]

# Custom parameters
params:
  designSystem:
    primaryColor: "#38B2AC"
    fontHeading: "PT Serif"
    fontBody: "PT Sans"
  
  dimensions:
    markets:
      color: "sky"
      colorVar: "--sky-500"
      colorHex: "#0EA5E9"
    sectors:
      color: "olive"
      colorVar: "--olive-500"
      colorHex: "#A3B763"
    attributes:
      color: "secondary"
      colorVar: "--secondary-500"
      colorHex: "#F97316"
    signals:
      color: "accent"
      colorVar: "--accent-500"
      colorHex: "#6366F1"
  
  company:
    name: "Brandmine"
    tagline: "Illuminate exceptional brands from emerging markets"
    email: "hello@brandmine.io"
    location: "George Town, Penang, Malaysia"
  
  features:
    search: true
    multiFilter: true
    maps: true
  
  chinaOptimized: true
```

---

## Sample Content Files

### 1. Brand Profile

```yaml
# content/brands/teatime/_index.en.md
---
title: "TeaTime Premium Russian Tea"
translationKey: "teatime-brand"
date: 2024-10-15
draft: false
lang: en

# Taxonomies (4 dimensions)
markets: ["russia", "central-asia"]
sectors: ["food-beverage", "specialty-tea"]
attributes: ["heritage-brand", "family-owned", "export-ready"]
signals: ["revenue-growth", "international-distribution"]

# Founder relationship
founder: "pavel-titov"

# Business details
founded: 2018
employees: 45
revenue: "$5M-10M"
website: "https://teatime.ru"
headquarters:
  city: "Moscow"
  region: "Central Russia"
  coordinates: [55.7558, 37.6173]

# Assets
logo: "/images/brands/teatime/logo.svg"
heroImage: "/images/brands/teatime/hero.jpg"

# SEO
description: "Premium Russian tea combining traditional culture with modern quality standards"
---

TeaTime revolutionizes the Russian specialty tea market by combining traditional tea culture with modern quality standards...
```

---

### 2. Founder Profile

```yaml
# content/founders/pavel-titov/_index.en.md
---
title: "Pavel Titov"
translationKey: "pavel-titov-founder"
date: 2024-10-15
draft: false
lang: en

# Professional
role: "Founder & CEO"
industry: "Food & Beverage"
expertise: ["Hospitality Management", "Premium Tea Sourcing", "Export Development"]

# Personal
location: "Moscow, Russia"
languages: ["Russian", "English", "German"]
education: "Moscow State Institute of International Relations (MGIMO)"

# Social
linkedin: "https://linkedin.com/in/pavel-titov-tea"
email: "pavel@teatime.ru"

# Assets
photo: "/images/founders/pavel-titov/portrait.jpg"
heroImage: "/images/founders/pavel-titov/hero.jpg"

# SEO
description: "Founder of TeaTime, bringing 15 years of luxury hospitality expertise to Russia's specialty tea renaissance"
---

Pavel Titov brings 15 years of luxury hospitality expertise to Russia's specialty tea renaissance...
```

---

### 3. Insight Article

```yaml
# content/insights/founders-journey/pavel-titov-from-moscow-to-global.en.md
---
title: "From Five-Star Hotels to Heritage Tea: Pavel Titov's Journey"
translationKey: "pavel-titov-journey-insight"
date: 2024-10-18
draft: false
lang: en

# Single category
insightType: "founders-journey"

# Related entities
relatedBrands: ["teatime"]
relatedFounders: ["pavel-titov"]
markets: ["russia"]
sectors: ["food-beverage"]

# Metadata
author: "Brandmine Research Team"
readTime: 8
heroImage: "/images/insights/pavel-titov-journey/hero.jpg"

# SEO
description: "How a luxury hospitality executive built a $5M tea business by rediscovering Russian tea heritage"
summary: "Pavel Titov's journey from managing Moscow's finest hotels to building TeaTime"
---

Pavel Titov didn't set out to revolutionize Russia's tea market...
```

---

### 4. Dimension Description Page

```yaml
# content/dimensions/markets/russia.en.md
---
title: "Russia Market"
translationKey: "russia-market-dimension"
date: 2024-10-15
draft: false
lang: en

# Metadata
dimensionType: "market"
population: 144000000
gdp: "$2.24T"

# Assets
heroImage: "/images/dimensions/markets/russia-hero.jpg"

# SEO
description: "Discover exceptional Russian founder-led brands navigating international expansion"
---

Russia represents one of BRICS' most complex and dynamic markets for founder-led brands...
```

---

## 5-Day Implementation Roadmap

### Day 1: Foundation Setup

**Deliverables**:
- Initialize Hugo project with complete hugo.yaml
- Port Jekyll design tokens (colors, typography, spacing)
- Set up trilingual structure (EN/RU/ZH)
- Configure Cloudflare Pages deployment

**Validation**:
- `hugo server` runs without errors
- Three language versions accessible
- Design tokens compile to CSS
- Deployment pipeline functional

**Files Created**:
```
hugo.yaml
archetypes/brands.md, founders.md, insights.md
assets/scss/tokens/_colors.scss, _typography.scss, _spacing.scss
layouts/_default/baseof.html
```

---

### Day 2: Core Templates & Content

**Deliverables**:
- Master template with header/footer
- Brand list and single templates
- Founder templates
- Taxonomy term templates (4 dimensions)
- 3 sample brands with complete front matter

**Validation**:
- Brand pages render correctly
- Founder pages show linked brands
- Taxonomy pages auto-generate
- Language switcher works

**Files Created**:
```
layouts/_default/list.html, single.html
layouts/brands/list.html, single.html
layouts/founders/single.html
layouts/taxonomy/markets.html, sectors.html, attributes.html, signals.html
layouts/partials/header.html, footer.html, brand-card.html, language-switcher.html
content/brands/teatime/_index.en.md, _index.ru.md
content/founders/pavel-titov/_index.en.md
```

---

### Day 3: Search & Filtering

**Deliverables**:
- Generate search index JSON
- Build client-side search with type-ahead
- Implement multi-taxonomy filter UI
- Test filtering across 4 dimensions

**Validation**:
- Search returns results after 2+ characters
- Type-ahead shows grouped results
- Multi-taxonomy filtering works
- Mobile-responsive

**Files Created**:
```
layouts/_default/search-index.json
assets/js/search.js, filter.js
layouts/partials/search-bar.html, filter-panel.html
data/dimensions.yaml
```

---

### Day 4: Insights System & Dimensions

**Deliverables**:
- Create insight category subdirectories
- Build insight templates with correct color mappings
- Add optional dimension description pages
- Create 2 sample insights

**Validation**:
- Insights display with correct colors:
  - Brand Spotlight: Orange
  - Founder's Journey: Indigo
  - Location Intelligence: Sky Blue
  - Market Momentum: Olive Green
- Dimension pages show content + brand list
- RSS feeds generate

**Files Created**:
```
layouts/insights/list.html, single.html
content/insights/brand-spotlight/_index.en.md
content/insights/founders-journey/pavel-titov-journey.en.md
content/dimensions/markets/russia.en.md
data/insights.yaml
```

---

### Day 5: Polish & Deployment

**Deliverables**:
- Mobile responsiveness testing
- Cross-browser testing
- Performance optimization
- Multilingual verification
- Production deployment

**Validation**:
- Lighthouse mobile score >90
- All pages render in 3 languages
- Search/filtering work on mobile
- Self-hosted fonts load properly
- Site live at brandmine.io

**Final Checklist**:
```
Technical:
- [ ] Hugo build completes without errors
- [ ] All internal links functional
- [ ] 404 page implemented
- [ ] Sitemap and robots.txt generated

Content:
- [ ] 5-10 demo brands with complete data
- [ ] 3-5 founder profiles
- [ ] 2-3 insights across categories
- [ ] 2-3 dimension description pages

Performance:
- [ ] Images optimized
- [ ] CSS/JS minified
- [ ] Fonts preloaded
- [ ] Lazy loading implemented

Deployment:
- [ ] Cloudflare Pages connected
- [ ] Build command: hugo --gc --minify
- [ ] Custom domain connected
- [ ] SSL active
```

---

## Critical Implementation Rules

### NEVER DO
- Change dimension colors from specification
- Change insight category colors from specification
- Use Google services or external CDNs
- Use non-self-hosted fonts
- Create new dimension types beyond 4
- Use max-width media queries

### ALWAYS DO
- Use Jekyll 3.9.5 compatible patterns (for reference)
- Mobile-first responsive design
- BEM-compliant CSS
- Maintain trilingual excellence
- Ensure China/Russia accessibility
- Validate color mappings against this document

---

## Data File Specifications

### data/dimensions.yaml

```yaml
dimensions:
  markets:
    title: "Markets"
    color: "sky"
    colorVar: "--sky-500"
    colorHex: "#0EA5E9"
    icon: "map-pin"
  
  sectors:
    title: "Sectors"
    color: "olive"
    colorVar: "--olive-500"
    colorHex: "#A3B763"
    icon: "tag"
  
  attributes:
    title: "Attributes"
    color: "secondary"
    colorVar: "--secondary-500"
    colorHex: "#F97316"
    icon: "star"
  
  signals:
    title: "Signals"
    color: "accent"
    colorVar: "--accent-500"
    colorHex: "#6366F1"
    icon: "trending-up"
```

---

### data/insights.yaml

```yaml
types:
  brand-spotlight:
    title: "Brand Spotlight"
    description: "Featured brand stories and analysis"
    color: "secondary"
    colorVar: "--secondary-500"
    colorHex: "#F97316"
    icon: "spotlight"
    alignedWith: "attributes"
  
  founders-journey:
    title: "Founder's Journey"
    description: "Personal stories of founder-led brands"
    color: "accent"
    colorVar: "--accent-500"
    colorHex: "#6366F1"
    icon: "person"
    alignedWith: "signals"
  
  location-intelligence:
    title: "Location Intelligence"
    description: "Geographic and market context"
    color: "sky"
    colorVar: "--sky-500"
    colorHex: "#0EA5E9"
    icon: "map"
    alignedWith: "markets"
  
  market-momentum:
    title: "Market Momentum"
    description: "Sector trends and opportunities"
    color: "olive"
    colorVar: "--olive-500"
    colorHex: "#A3B763"
    icon: "trending"
    alignedWith: "sectors"
```

---

## Success Criteria

### MVP Launch (5-Day Target)

- Hugo site deployed to Cloudflare Pages
- 4 taxonomies working with auto-generated lists
- Trilingual structure (EN/RU/ZH) functional
- 5-10 demo brands with complete data
- Design system from Jekyll fully ported
- Mobile-responsive across all devices
- Ready to fill with real content post-launch

### Post-Launch Phase

- Replace demo brands with real Russian founders
- Add rich dimension descriptions (Russia first)
- Expand insight content across all categories
- Implement maps (Phase 2 with Supabase)
- Add analytics and conversion tracking

---

## Team Coordination

### For Claude Code (CTO)

**Implementation Authority**: You own all technical decisions and delivery  
**Question Types**: Ask about business requirements, confirm feature priorities  
**Documentation**: Provide working code with inline comments  
**Quality Bar**: Functional over perfect—iterate post-launch

### For Research Director

**Demo Content**: Identify 5-10 Russian brands for demo data  
**Sector Balance**: Mix of hotels, spirits, food/beverage  
**Privacy**: Verify all information is publicly available  
**Validation**: Review brand profiles for accuracy

### For CEO (Me)

**Strategic Decisions**: Approve demo brand list, feature priorities  
**Quality Bar**: Define "good enough" for 5-day launch  
**Post-Launch**: Plan real content fill strategy and timeline

---

## Risk Mitigation

### Technical Risks
- **Hugo learning curve**: Mitigate with complete template examples
- **Multilingual complexity**: Use Hugo's built-in `translationKey` system
- **Search performance**: Lazy-load data, implement pagination fallback

### Content Risks
- **Demo brand privacy**: Use only public information, or create realistic fiction
- **Translation quality**: Human review for demo content, launch English-only if needed

### Timeline Risks
- **5-day deadline**: Daily check-ins, reduce feature set if needed (defer search to post-launch)

---

## Next Steps

1. **Save this document** as `hugo-implementation-plan.md`
2. **Review with Claude Code** tomorrow for technical questions
3. **Approve demo brand list** from Research Director
4. **Begin Day 1 implementation** with foundation setup

---

**Document Status**: Final specification, ready for implementation  
**Last Updated**: 2024-10-02  
**Version**: 1.0 (corrected colors, clarified insights structure)