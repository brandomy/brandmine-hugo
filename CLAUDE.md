# Brandmine Strategic Context & Hugo Essentials

## Quick Links

- **Brand Strategy**: [docs/brand/brand-strategy.md](docs/brand/brand-strategy.md)
- **Technical Reference**: [docs/technical/README.md](docs/technical/README.md)
- **Brand Guide**: [docs/brand/brand-guide.md](docs/brand/brand-guide.md)
- **Workflows**: [docs/workflows/README.md](docs/workflows/README.md)
- **Database**: [docs/database/README.md](docs/database/README.md)
- **Documentation Index**: [docs/README.md](docs/README.md)

---

## Strategic Overview

**Vision**: 🔆 Illuminate the world's hidden brands to fuel their growth

**Mission**: To illuminate and elevate exceptional founder-led SME brands from the Global South, breaking through language, cultural, and political barriers to proactively connect them with the people, partners, and capital they need to grow beyond their borders.

**Tagline**: Illuminating Exceptional Global South Brands

**Core Values**:
1. **Bridge Cultures** - We turn barriers into bridges
2. **Champion Founders** - Exceptional founders shouldn't stay hidden
3. **Create Connections** - Strategic matches, not random meetings

**Full Brand Strategy**: See [docs/brand/brand-strategy.md](docs/brand/brand-strategy.md)

---

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

---

## Backlog System

**Purpose**: Capture future ideas without CEO needing to track them.

**Command**: CEO can say either:
- **"Code, backlog this: [idea/task]"** OR
- **"CTO, backlog this: [idea/task]"**

Both commands are **equivalent** and work exactly the same way.

**File**: [docs/BACKLOG.md](docs/BACKLOG.md)

**CTO Response**:
1. Create backlog entry with unique ID, scope, acceptance criteria
2. Confirm: "Added to backlog as #XXX"

**CTO Ownership**:
- ✅ All backlog maintenance and status tracking
- ✅ Implementation planning when item is prioritized
- ❌ CEO does NOT maintain todo lists or track backlog status

See [docs/workflows/ceo-coo-cto-workflow.md](docs/workflows/ceo-coo-cto-workflow.md) for complete workflow documentation.

---

## Critical Constraints

### The Non-Negotiables

1. **Taxonomy**: Only 4 dimensions (markets, sectors, attributes, signals). No additions permitted.
2. **Images**: ALL content images go in `assets/images/` (Hugo processes them). NEVER use `static/images/`.
3. **Translations**: Hugo i18n files MUST be in `i18n/` directory (not `data/translations/`).
4. **Fonts**: PT Sans/Serif (EN/RU), Noto Sans SC (ZH), all self-hosted from `static/fonts/`.
5. **Mobile-first**: 320px-414px primary viewport, no sidebars.
6. **Hugo-native**: Use Hugo's built-in features, avoid complex logic.

**Rationale**: These constraints are foundational architecture. Violating them creates technical debt.

---

## Hugo Quick Reference

### Essential Commands
```bash
# Development
hugo server                      # Start dev server (localhost:1313)
hugo server --logLevel info      # With detailed logging

# Production
set -a && source .env.local && set +a && hugo --gc --minify

# Content Creation
hugo new content/brands/brand-name.en.md
```

### Directory Structure
```
content/          # All content (brands, founders, insights, dimensions)
data/            # YAML/JSON data (taxonomies, labels)
i18n/            # Translation files (en.yml, ru.yml, zh.yml)
layouts/         # Templates (partials, shortcodes, pages)
static/          # Static assets (fonts, favicon only)
assets/          # Processed assets (CSS, JS, images)
docs/            # Documentation
```

**Details**: See [docs/technical/hugo-essentials.md](docs/technical/hugo-essentials.md)

---

## Taxonomy System

**STRICT RULE**: Only 4 taxonomies. No additions permitted.

### The Four Dimensions
1. **Markets**: Geographic/cultural markets (Russia, China, Brazil, etc.)
2. **Sectors**: Industry verticals (Gourmet Foods, Natural Beauty, etc.)
3. **Attributes**: Brand characteristics (Founder-Led, Premium Positioning, etc.)
4. **Signals**: Market indicators (Export Ready, Rapid Growth, etc.)

### Configuration
```yaml
# In hugo.yaml
taxonomies:
  market: markets
  sector: sectors
  attribute: attributes
  signal: signals
```

**Authorized Terms**: All terms defined in `data/taxonomies/*.json` files.

**Details**: See [docs/technical/taxonomy-guide.md](docs/technical/taxonomy-guide.md)

---

## Translation System

### Files Location
**CRITICAL**: Hugo i18n files MUST be in `/i18n/` directory (not `/data/translations/`)

```
i18n/en.yml  # English UI strings
i18n/ru.yml  # Russian UI strings
i18n/zh.yml  # Chinese UI strings
```

### Usage in Templates
```go-html-template
{{ i18n "key_name" }}
```

### Multilingual Content
- **Language suffix**: `filename.en.md`, `filename.ru.md`, `filename.zh.md`
- **Translation key**: `translationKey: "unique-identifier"` in front matter
- **Default language**: English (en)

**Details**: See [docs/workflows/translation-workflow.md](docs/workflows/translation-workflow.md)

---

## Color System Reference

**Primary**: Teal (#38B2AC) - Trust, stability, global
**Secondary**: Orange (#F97316) - Energy, innovation
**Accent**: Indigo (#6366F1) - Signals, growth

**Dimension Colors**:
- **Sectors**: Olive Green (#A3B763)
- **Markets**: Sky Blue (#0EA5E9)
- **Attributes**: Orange (#F97316)
- **Signals**: Indigo (#6366F1)

**Details**: See [docs/brand/brand-guide.md](docs/brand/brand-guide.md)

---

## Database (Supabase)

### Documentation Structure
All database documentation lives in `docs/database/`:

```
docs/database/
├── README.md              # Overview, conventions, usage guide
├── contact-forms.md       # Contact form implementation
├── schema-design.md       # Full database schema (future)
├── sql/                   # Executable SQL migration files
└── guides/                # Step-by-step procedures
```

### Environment Variables
Hugo requires explicit environment variable loading:

```bash
# Load .env.local before running Hugo
set -a && source .env.local && set +a && hugo server

# Required variables
SUPABASE_URL=https://[project].supabase.co
SUPABASE_ANON_KEY=eyJ...
```

**Details**: See [docs/database/contact-forms.md](docs/database/contact-forms.md)

---

## Development Philosophy

### Questions to Ask Before Adding Complexity

1. Can Hugo's built-in features handle this?
2. Is this mobile-first and touch-friendly?
3. Does this maintain programmatic simplicity?
4. Will this work with our 4-dimension taxonomy?
5. Is this necessary for the 2025 minimalist vision?

If any answer is "no," reconsider the approach.

### Card Philosophy

**Principle**: Programmatic simplicity, not Jekyll complexity.

- Simple, data-driven components
- Hugo-native patterns (no complex Liquid-style logic)
- Mobile-first responsive design
- Clean, minimal visual hierarchy
- Touch-optimized interactions (44px minimum targets)

**Card Types**: Brand, Founder, Insight, Dimension

**Details**: See [docs/technical/hugo-essentials.md](docs/technical/hugo-essentials.md)

---

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

---

**Last Updated**: 2025-10-23
**Hugo Version**: 0.139.3
**Status**: Production - CSS extraction complete, docs reorganized
