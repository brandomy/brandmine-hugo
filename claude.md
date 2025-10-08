# Brandmine Strategic Context & Hugo Essentials

## Strategic Overview

**Vision**: 🔆 Illuminate the world's hidden brands to fuel their growth

**Mission**: To illuminate and elevate exceptional founder-led SME brands from the Global South, breaking through language, cultural, and political barriers to proactively connect them with the people, partners, and capital they need to grow beyond their borders.

**Tagline**: Illuminating Exceptional Global South Brands

**Full Brand Documentation**: See `docs/brandmine-vision-mission-values.md`

## Role Titles

**CEO** - Randal (business strategy, content drafting)  
**COO** - Claude Console (strategic review, quality assurance)  
**CTO** - Claude Code (technical execution, translations)

**Translation Authority**: CTO handles all RU/ZH translations. COO reviews for strategic alignment.

**CTO Role & Authority**: You (Claude) serve as Chief Technology Officer with full authority over:
- Architecture decisions
- Technology stack choices
- Implementation patterns
- Code quality standards
- Performance benchmarks

Make decisions autonomously when technical choices arise. Document significant decisions but proceed without approval.

## Hugo Architecture

### Directory Structure
```
content/          # All content (not _collections/)
  brands/         # Brand profiles
  founders/       # Founder profiles
  insights/       # Market insights
  dimensions/     # Dimension explanations
data/            # YAML data files (taxonomies, etc.)
i18n/            # Translation files (Hugo i18n system)
  en.yml         # English UI translations
  ru.yml         # Russian UI translations
  zh.yml         # Chinese UI translations
layouts/         # Templates
  _default/
  partials/
    breadcrumbs.html   # Navigation breadcrumbs (uses .Ancestors)
  shortcodes/
static/          # Static assets
  fonts/        # Self-hosted fonts
  images/
  css/
assets/          # Processed assets
archetypes/      # Content templates
docs/            # Documentation
  database/      # Database documentation
    README.md           # Overview and conventions
    schema-design.md    # Full database schema (future)
    contact-forms.md    # Contact form implementation
    sql/               # SQL migrations and queries
    guides/            # Setup and procedures
  reference-data/  # Reference CSV/JSON files
    README.md           # Directory usage guide
    *.csv              # Data imports, exports, analysis
```

### Hugo Commands
```bash
hugo server                    # Development server
hugo server --logLevel info    # With logging
hugo --gc --minify            # Production build
hugo new content/brands/name.md  # New content
```

### Breadcrumbs Implementation (2025-10-05)
- **Location**: `layouts/partials/breadcrumbs.html`
- **Method**: Uses Hugo's `.Ancestors` to auto-generate hierarchy
- **Display**: Home > Section > Current Page
- **Styling**: Inline teal separator (›), current page bold

## Typography System

### Font Stack
- **English/Russian**: PT Sans (body), PT Serif (headings) - self-hosted
- **Chinese**: Noto Sans SC - self-hosted
- **All fonts**: Served from `/static/fonts/`, no external CDNs
- **Loading**: font-display: swap for performance

### Implementation
```yaml
# In hugo.yaml
params:
  fonts:
    body: "'PT Sans', sans-serif"
    heading: "'PT Serif', serif"
    chinese: "'Noto Sans SC', sans-serif"
```

## Card Philosophy

**Principle**: Programmatic simplicity, not Jekyll complexity.

### 2025 Minimalist Approach
- Simple, data-driven components
- Hugo-native patterns (no complex Liquid-style logic)
- Mobile-first responsive design
- Clean, minimal visual hierarchy
- Touch-optimized interactions (44px minimum targets)

### Card Types
1. **Brand Cards**: Image, name, tagline, markets, sectors
2. **Founder Cards**: Photo, name, role, brands
3. **Insight Cards**: Category badge, title, excerpt, country flag, date, related brands/founders
4. **Dimension Cards**: Icon, name, description

### Insight Card Specifics (2025-10-05)
- **Category badge**: 11px, medium weight, 70% opacity, tighter padding (4px 10px)
- **Country flag**: 16px inline emoji before date (🇷🇺, 🇨🇳, 🇧🇷, 🇮🇳, 🇿🇦, 🇪🇹, 🌍)
- **Clickable hero image**: Subtle opacity hover (0.95)
- **Founder names**: 13px, italic, neutral-500 color (not pills)
- **Related brands**: Display as pills, related founders as plain text

**Critical**: Cards must be simple Hugo partials with straightforward logic. Avoid Jekyll-era complexity.

## Taxonomy System

**STRICT RULE**: Only 4 taxonomies. No additions permitted.

### The Four Dimensions
1. **Markets**: Geographic/cultural markets (China, Russia, Global, etc.)
2. **Sectors**: Industry verticals (Consumer, Technology, Lifestyle, etc.)
3. **Attributes**: Brand characteristics (Premium, Innovative, Traditional, etc.)
4. **Signals**: Market indicators (Growth, Disruption, Consolidation, etc.)

### Configuration
```yaml
# In hugo.yaml
taxonomies:
  market: markets
  sector: sectors
  attribute: attributes
  signal: signals
```

**No new dimensions**: This is foundational architecture. Four dimensions only.

## Translation System

### Translation Files Location
**IMPORTANT**: Hugo i18n files MUST be in `/i18n/` directory (not `/data/translations/`)

```
i18n/en.yml  # English UI strings
i18n/ru.yml  # Russian UI strings
i18n/zh.yml  # Chinese UI strings
```

### Usage in Templates
```go-html-template
{{ i18n "key_name" }}
```

**Note**: The `{{ i18n }}` function only works with files in `/i18n/` directory.

### Multilingual Content
- **Language suffix pattern**: `filename.en.md`, `filename.ru.md`, `filename.zh.md`
- **Translation key**: `translationKey: "unique-identifier"` in front matter
- **Default language**: English (en)

## Multilingual Search Architecture

**Data File**: `data/taxonomy-labels.yml` (single source of truth)
- Structure: `lang: { markets: {}, sectors: {}, attributes: {}, signals: {} }`
- Used by: Templates for display, search index for multilingual queries

**Search Index Generation**: `layouts/index.json`
- Language-specific indexes: `/index.json`, `/ru/index.json`, `/zh/index.json`
- Translates slugs to labels at build time using taxonomy-labels.yml
- Pattern: `{{ $labels := index .Site.Data.taxonomy_labels $.Language.Lang }}`
- **Includes**: Brands (with markets/sectors) + Founders (with company/role/expertise)

**Search Client**: `assets/js/search.js`
- Detects language from `document.documentElement.lang`
- Loads correct index: `/${lang}/index.json` or `/index.json` for EN
- No hardcoded language paths
- **Unified search**: Brands and founders in single index, differentiated by `type` field

**Card Hidden Search Data**:
```go
<div style="position: absolute; left: -9999px;">
  {{ range .Params.markets }}{{ . }} {{ index $labels.markets . }}{{ end }}
</div>
```
Enables search by slug OR translated term in any language.

## Layout Philosophy

### Mobile-First Standards
- **Primary viewport**: 320px-414px (mobile phones)
- **No sidebars**: Linear, vertical content flow
- **Section-based**: Clear content sections, no complex grids
- **Touch targets**: Minimum 44px × 44px
- **Typography**: Readable at small sizes (16px minimum body)

### Layout Principles
1. Content before chrome
2. Progressive disclosure
3. Thumb-friendly navigation
4. Performance first (< 2s load)
5. Accessibility (WCAG 2.1 AA minimum)

### Hero Panel System (2025-10-05)
- **Split-panel gradients**: 2-layer system (outer radial + inner linear)
- **Text panel**: Always teal linear gradient (--primary-600 to --primary-700)
- **Outer background**: Radial gradient with category colors (orange/purple/blue/green)
- **Image panel**: 3:2 aspect ratio, responsive at 768px breakpoint (NOT 992px)
- **Responsive**: Desktop shows side-by-side, mobile stacks vertically

## Hugo-Specific Patterns

### Content Organization
```markdown
---
title: "Brand Name"
date: 2025-10-03
markets: ["china", "global"]
sectors: ["consumer"]
attributes: ["premium", "innovative"]
signals: ["growth"]
translationKey: "brand-name"
---

Content here.
```

### Partial Pattern
```go-html-template
{{/* partials/card-brand.html */}}
<article class="card card--brand">
  <img src="{{ .Params.image }}" alt="{{ .Title }}">
  <h3>{{ .Title }}</h3>
  <p>{{ .Params.tagline }}</p>
  {{ range .Params.markets }}
    <span class="tag">{{ . }}</span>
  {{ end }}
</article>
```

### List Template Pattern
```go-html-template
{{/* layouts/brands/list.html */}}
{{ range .Pages }}
  {{ partial "card-brand.html" . }}
{{ end }}
```

### Insights Article Sidebar Pattern (2025-10-05)
```go-html-template
<!-- Dimensions Box -->
<div class="dimensions-box">
  <h3>Dimensions</h3>
  <!-- Display all 4 taxonomies with color coding -->
</div>

<!-- Related Brands (Visual Mini Cards) -->
<div class="related-brands-box">
  <h3>Related Brands</h3>
  <!-- 60px square logo cards with grid layout -->
</div>

<!-- Related Founders (Visual Cards) -->
<div class="related-founders-box">
  <h3>Related Founders</h3>
  <!-- 60×90px photo cards, horizontal layout -->
</div>

<!-- Membership CTA -->
<div class="cta-box">
  <h3>Connect with Featured Brands</h3>
  <p>Premium members get direct introductions...</p>
  <a href="/premium-membership-for-partners/">Explore Membership</a>
</div>
```

**Mini Card Patterns**:
- **Brand mini cards**: 60px square, teal border on hover, fallback first letter
- **Founder cards**: 60×90px (2:3 ratio), rounded rectangle (12px), top-aligned crop
- **CTA box**: White background, teal button, positioned last in sidebar

## Performance Standards

### Target Metrics
- **First Contentful Paint**: < 1.5s
- **Largest Contentful Paint**: < 2.5s
- **Total Blocking Time**: < 200ms
- **Cumulative Layout Shift**: < 0.1
- **Speed Index**: < 3.0s

### Optimization Strategies
1. Self-hosted fonts with font-display: swap
2. Optimized images (WebP, lazy loading)
3. Minimal JavaScript (Hugo handles most templating)
4. Critical CSS inline
5. Asset minification in production

## Color System Reference

**Primary**: Teal (#38B2AC) - Trust, stability, global
**Secondary**: Orange (#F97316) - Energy, innovation
**Accent**: Indigo (#6366F1) - Signals, growth

**Dimension Colors** (Fixed Taxonomy):
- **Sectors**: Olive Green (#A3B763)
- **Markets**: Sky Blue (#0EA5E9)
- **Attributes**: Orange (#F97316) - same as Secondary
- **Signals**: Indigo (#6366F1) - same as Accent

**Insight Categories** (Aligned with Dimensions):
- **Brand Spotlight**: Orange (#F97316) - same as Attributes
- **Founder's Journey**: Indigo (#6366F1) - same as Signals
- **Location Intelligence**: Sky Blue (#0EA5E9) - same as Markets
- **Market Momentum**: Olive Green (#A3B763) - same as Sectors

See `docs/brandmine-brand-guide.md` for complete color system.

## Database (Supabase)

### Documentation Structure

All database documentation lives in `docs/database/`:

```
docs/database/
├── README.md              # Overview, conventions, usage guide
├── schema-design.md       # Full database schema (Phase 4 - future)
├── contact-forms.md       # Contact form implementation (Phase 3 - current)
├── sql/                   # Executable SQL files
│   ├── 001-contacts-table.sql
│   ├── 002-duplicate-prevention.sql
│   ├── 003-data-retention-policy.sql
│   └── queries.sql       # Common queries for analytics
└── guides/               # Step-by-step procedures
    └── setup-guide.md    # Complete setup instructions
```

### SQL File Conventions

- **Naming**: `NNN-description.sql` (e.g., `001-contacts-table.sql`)
- **Headers**: Include purpose, created date, production date, prerequisites
- **Sequential**: Execute in numerical order
- **Idempotent**: Use `CREATE OR REPLACE` where possible

### Environment Variables

Hugo requires explicit environment variable loading:

```bash
# Load .env.local before running Hugo
set -a && source .env.local && set +a && hugo server

# Required variables
SUPABASE_URL=https://[project].supabase.co
SUPABASE_ANON_KEY=eyJ...
```

See `docs/database/contact-forms.md` for complete setup.

## Development Workflow

### Local Development
```bash
hugo server              # Start dev server at localhost:1313
# Edit content or templates - auto-reload
```

### Production Build
```bash
hugo --gc --minify      # Build to /public/
# Deploy /public/ to Cloudflare Pages
```

### Content Creation
```bash
hugo new content/brands/new-brand.en.md
# Edit front matter + content
# Create .ru.md and .zh.md variants as needed
```

## Critical Constraints

1. **Taxonomy**: Only 4 dimensions (markets, sectors, attributes, signals)
2. **Translations**: Use existing data/translations/*.yml files
3. **Fonts**: PT Sans/Serif (EN/RU), Noto Sans SC (ZH), all self-hosted
4. **Cards**: Simple and programmatic (not Jekyll complexity)
5. **Mobile-first**: 320px-414px primary viewport, no sidebars
6. **Hugo-native**: Use Hugo's built-in features, avoid complex logic

## Key Differences from Jekyll

| Aspect | Jekyll | Hugo |
|--------|--------|------|
| Collections | `_collections/` | `content/` |
| Data files | `_data/` | `data/` |
| Templates | Liquid | Go templates |
| Taxonomies | Tags/categories | Custom taxonomies |
| Speed | Slow on large sites | Fast regardless of size |
| i18n | Manual/plugins | Built-in multilingual |

## Questions to Ask Before Adding Complexity

1. Can Hugo's built-in features handle this?
2. Is this mobile-first and touch-friendly?
3. Does this maintain programmatic simplicity?
4. Will this work with our 4-dimension taxonomy?
5. Is this necessary for the 2025 minimalist vision?

If any answer is "no," reconsider the approach.

## Migration Philosophy

**No Backwards Compatibility**: During Hugo migration, prioritize clean architecture over Jekyll compatibility.

- Don't preserve Jekyll field names if Hugo has better patterns
- Don't maintain Jekyll directory structures
- Don't support Jekyll-style logic in templates
- Don't keep deprecated features "just in case"

**Clean slate approach**:
- Use Hugo's native multilingual patterns
- Adopt Hugo's taxonomy system completely
- Follow Hugo's content organization conventions
- Remove all Jekyll artifacts

**Rationale**: Backwards compatibility creates technical debt that slows future development. Clean structure now = rapid growth later.

---

**Last Updated**: 2025-10-05
**Hugo Version**: 0.139.3
**Status**: Phase 3 complete - Breadcrumbs, insights styling, sidebar components, unified search (brands + founders) operational