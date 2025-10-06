# Hugo Technical Standards - Brandmine

## Image Placement Standards

**CRITICAL RULE**: All content images MUST go in `/assets/images/` (Hugo processes them). NEVER use `/static/images/` for content images.

### Directory Structure
```
assets/images/          # ALL content images here (Hugo processes)
├── brands/
│   ├── brandname/
│   │   └── originals/
│   │       ├── hero-*.jpg
│   │       └── logo-*.png
├── founders/
│   ├── foundername/
│   │   └── originals/
│   │       └── photo-*.jpg
├── insights/
│   └── article-name/
│       └── originals/
│           └── hero-*.jpg
└── dimensions/
    └── category/
        └── originals/
            └── icon-*.svg

static/                 # ONLY non-content assets
├── fonts/             # Self-hosted fonts only
└── favicon.ico        # Site favicon only
```

### Why This Matters
- **Hugo Image Processing**: Only `/assets/images/` files get processed (resize, WebP, optimization)
- **Performance**: Processed images = faster load times
- **Responsive Images**: Hugo generates srcset variants automatically
- **Cache Busting**: Hugo adds content hashes to processed images

### Content Front Matter Pattern
```yaml
# Brand profile
heroImage: "hero-storefront.jpg"  # Lives in assets/images/brands/{slug}/originals/

# Founder profile
photo: "photo-headshot.jpg"  # Lives in assets/images/founders/{slug}/originals/

# Insight
heroImage: "hero-graph.jpg"  # Lives in assets/images/insights/{slug}/originals/
```

### Template Usage
```go-html-template
{{/* Hugo processes from assets/images/ */}}
{{ $brandSlug := path.Base .File.Dir }}
{{ $heroPath := printf "images/brands/%s/originals/%s" $brandSlug .Params.heroImage }}
{{ $hero := resources.Get $heroPath }}
{{ if $hero }}
  {{ $resized := $hero.Resize "800x600 q85" }}
  <img src="{{ $resized.RelPermalink }}" alt="{{ .Title }}">
{{ end }}
```

**Never manually reference `/static/images/` in templates or front matter for content images.**

### When Adding New Images
1. **Identify image type**: Brand hero? Founder photo? Insight illustration?
2. **Create directory**: `assets/images/{type}/{name}/originals/`
3. **Place file**: Move image to the originals directory
4. **Update front matter**: Reference just the filename (template builds full path)
5. **Clear cache if needed**: `hugo --gc --cleanDestinationDir`

## Site Directory Structure

### Complete Site Structure
```
brandmine-hugo/
├── archetypes/           # Content templates
│   ├── default.md
│   ├── brand.md
│   ├── founder.md
│   ├── insight.md
│   └── dimension.md
├── assets/              # Source assets (processed)
│   ├── css/
│   ├── js/
│   └── images/
├── content/             # All content (Markdown)
│   ├── brands/
│   │   ├── _index.en.md
│   │   ├── _index.ru.md
│   │   ├── _index.zh.md
│   │   ├── brand-name.en.md
│   │   ├── brand-name.ru.md
│   │   └── brand-name.zh.md
│   ├── founders/
│   ├── insights/
│   ├── dimensions/
│   └── _index.md
├── data/                # YAML/JSON data
│   └── translations/
│       ├── en.yml
│       ├── ru.yml
│       └── zh.yml
├── docs/                # Documentation
│   ├── supabase/        # Database documentation
│   │   ├── README.md
│   │   ├── schema-design.md
│   │   ├── contact-forms.md
│   │   ├── sql/
│   │   │   ├── 001-contacts-table.sql
│   │   │   ├── 002-duplicate-prevention.sql
│   │   │   ├── 003-data-retention-policy.sql
│   │   │   └── queries.sql
│   │   └── guides/
│   │       └── setup-guide.md
│   ├── brandmine-brand-guide.md
│   ├── hugo-technical-standards.md
│   └── ...
├── layouts/             # Templates
│   ├── _default/
│   │   ├── baseof.html
│   │   ├── single.html
│   │   └── list.html
│   ├── partials/
│   │   ├── head.html
│   │   ├── header.html
│   │   ├── footer.html
│   │   ├── breadcrumbs.html  # Navigation breadcrumbs (uses .Ancestors)
│   │   ├── card-brand.html
│   │   ├── card-founder.html
│   │   ├── card-insight.html
│   │   └── card-dimension.html
│   ├── shortcodes/
│   ├── brands/
│   ├── founders/
│   ├── insights/
│   └── index.html
├── static/              # Static assets (copied as-is)
│   ├── fonts/
│   │   ├── PTSans/
│   │   ├── PTSerif/
│   │   └── NotoSansSC/
│   ├── images/
│   └── favicon.ico
├── hugo.yaml           # Site configuration
└── README.md
```

## Content Types & Archetypes

### Brand Archetype
**File**: `archetypes/brand.md`
```yaml
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
translationKey: "{{ .Name }}"

# Taxonomy (4 dimensions only)
markets: []      # e.g., ["china", "global", "russia"]
sectors: []      # e.g., ["consumer", "technology"]
attributes: []   # e.g., ["premium", "innovative"]
signals: []      # e.g., ["growth", "disruption"]

# Brand Details
tagline: ""
founded: ""
headquarters: ""
website: ""

# Media
image: ""        # Featured image path
logo: ""         # Logo path

# SEO
description: ""  # Meta description
keywords: []     # SEO keywords
---

Brand story and description here.
```

### Founder Archetype
**File**: `archetypes/founder.md`
```yaml
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
translationKey: "{{ .Name }}"

# Founder Details
role: ""         # e.g., "Founder & CEO"
brands: []       # Associated brand keys
nationality: ""
education: ""

# Media
photo: ""        # Headshot path

# Social
linkedin: ""
twitter: ""
weibo: ""

# SEO
description: ""
keywords: []
---

Founder biography here.
```

### Insight Archetype
**File**: `archetypes/insight.md`
```yaml
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
translationKey: "{{ .Name }}"

# Taxonomy
markets: []
sectors: []
signals: []      # Insights focus on signals

# Insight Type
type: "insight"  # market-report, trend-analysis, case-study

# Reading Time
readingTime: 5   # minutes

# SEO
description: ""
keywords: []
---

Insight content here.
```

### Dimension Archetype
**File**: `archetypes/dimension.md`
```yaml
---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
translationKey: "{{ .Name }}"

# Dimension Type
dimensionType: "" # market, sector, attribute, or signal

# Visual
icon: ""          # Icon identifier
color: ""         # Hex color (sectors: #A3B763, markets: #0EA5E9, attributes: #F97316, signals: #6366F1)

# SEO
description: ""
---

Dimension explanation here.
```

## 4-Dimension Taxonomy Implementation

### Configuration
**File**: `hugo.yaml`
```yaml
taxonomies:
  market: markets
  sector: sectors
  attribute: attributes
  signal: signals

# Default settings
params:
  taxonomyCloud:
    - markets
    - sectors
    - attributes
    - signals
```

### Usage in Content
```yaml
---
title: "Tea Time London"
markets: ["china", "global"]
sectors: ["consumer", "lifestyle"]
attributes: ["premium", "traditional", "quality"]
signals: ["growth", "cross-border"]
---
```

### Accessing in Templates
```go-html-template
{{/* List all markets for a brand */}}
{{ range .Params.markets }}
  <span class="tag tag--market">{{ . }}</span>
{{ end }}

{{/* Get all brands in a market */}}
{{ $market := .Site.GetPage (printf "/markets/%s" "china") }}
{{ range $market.Pages }}
  {{/* Each brand page in China market */}}
{{ end }}

{{/* Count items in taxonomy */}}
{{ len .Site.Taxonomies.markets }}

{{/* List all terms in taxonomy */}}
{{ range $key, $value := .Site.Taxonomies.markets }}
  <a href="{{ "/markets/" | relLangURL }}{{ $key }}">
    {{ $key }} ({{ len $value }})
  </a>
{{ end }}
```

### Taxonomy Template Structure
```
layouts/
├── markets/
│   ├── list.html        # /markets/ - all markets
│   └── term.html        # /markets/china/ - single market
├── sectors/
│   ├── list.html
│   └── term.html
├── attributes/
│   ├── list.html
│   └── term.html
└── signals/
    ├── list.html
    └── term.html
```

## Multilingual Implementation

### Language Configuration
**File**: `hugo.yaml`
```yaml
defaultContentLanguage: en
defaultContentLanguageInSubdir: false

languages:
  en:
    languageName: English
    languageCode: en-US
    weight: 1
    params:
      lang: en
  ru:
    languageName: Русский
    languageCode: ru-RU
    weight: 2
    params:
      lang: ru
  zh:
    languageName: 中文
    languageCode: zh-CN
    weight: 3
    params:
      lang: zh
```

### Language Suffix Pattern
```
content/
└── brands/
    ├── tea-time.en.md    # English version
    ├── tea-time.ru.md    # Russian version
    └── tea-time.zh.md    # Chinese version
```

### TranslationKey
**Critical**: Use `translationKey` to link translations
```yaml
# tea-time.en.md
---
title: "Tea Time London"
translationKey: "tea-time"
---

# tea-time.ru.md
---
title: "Чайное Время Лондон"
translationKey: "tea-time"
---

# tea-time.zh.md
---
title: "伦敦茶时间"
translationKey: "tea-time"
---
```

### Translation File Pattern
**File**: `data/translations/en.yml`
```yaml
# Navigation
nav_home: "Home"
nav_brands: "Brands"
nav_founders: "Founders"
nav_insights: "Insights"

# Common
read_more: "Read more"
view_all: "View all"
filter_by: "Filter by"

# Taxonomies
markets: "Markets"
sectors: "Sectors"
attributes: "Attributes"
signals: "Signals"
```

**Usage in templates**:
```go-html-template
<nav>
  <a href="{{ "/" | relLangURL }}">{{ i18n "nav_home" }}</a>
  <a href="{{ "/brands/" | relLangURL }}">{{ i18n "nav_brands" }}</a>
</nav>
```

## Insight Article Sidebar Components (2025-10-05)

### Sidebar Structure
```go-html-template
<!-- Dimensions Box -->
<div class="dimensions-box">
  <h3>Dimensions</h3>
  <!-- Display all 4 taxonomies with color coding -->
</div>

<!-- Related Brands (Visual Mini Cards) -->
<div class="related-brands-box">
  <h3>Related Brands</h3>
  <div class="related-brands-grid">
    {{ range .Params.relatedBrands }}
      <a href="{{ (site.GetPage (printf "brands/%s" .)).RelPermalink }}" class="brand-mini-card">
        <!-- 60px square logo with fallback -->
      </a>
    {{ end }}
  </div>
</div>

<!-- Related Founders (Visual Cards) -->
<div class="related-founders-box">
  <h3>Related Founders</h3>
  {{ range .Params.relatedFounders }}
    <a href="{{ (site.GetPage (printf "founders/%s" .)).RelPermalink }}" class="founder-card">
      <!-- 60×90px photo, horizontal layout -->
    </a>
  {{ end }}
</div>

<!-- Membership CTA -->
<div class="cta-box">
  <h3>Connect with Featured Brands</h3>
  <p>Premium members get direct introductions...</p>
  <a href="/premium-membership-for-partners/" class="button">Explore Membership</a>
</div>
```

### Mini Card Specifications

**Brand Mini Cards**:
- Size: 60px square
- Grid layout: `auto-fill, minmax(100px, 1fr)`
- Teal border on hover (`--primary-600`)
- Fallback: First letter if no logo
- White background, subtle lift animation

**Founder Cards**:
- Photo: 60×90px (2:3 aspect ratio)
- Border-radius: 12px (rounded rectangle)
- Image crop: `object-position: top center` (top-aligned)
- Layout: Horizontal (photo left, name/role right)
- Teal accent on hover (`--primary-600`)

**CTA Box**:
- Background: White (`--color-white`)
- Border: 1px solid `--color-gray-200`
- Button: Teal (`--color-teal-600`)
- Position: Last in sidebar
- Soft conversion (not alert-style)

## Card System: Simple & Programmatic

### Brand Card Pattern
**File**: `layouts/partials/card-brand.html`
```go-html-template
<article class="card card--brand">
  {{ if .Params.image }}
    <div class="card__image">
      <img src="{{ .Params.image | relURL }}"
           alt="{{ .Title }}"
           loading="lazy">
    </div>
  {{ end }}

  <div class="card__content">
    <h3 class="card__title">
      <a href="{{ .RelPermalink }}">{{ .Title }}</a>
    </h3>

    {{ if .Params.tagline }}
      <p class="card__tagline">{{ .Params.tagline }}</p>
    {{ end }}

    <div class="card__meta">
      {{ if .Params.markets }}
        <div class="card__tags card__tags--markets">
          {{ range .Params.markets }}
            <span class="tag tag--market">{{ . }}</span>
          {{ end }}
        </div>
      {{ end }}

      {{ if .Params.sectors }}
        <div class="card__tags card__tags--sectors">
          {{ range .Params.sectors }}
            <span class="tag tag--sector">{{ . }}</span>
          {{ end }}
        </div>
      {{ end }}
    </div>
  </div>
</article>
```

### Founder Card Pattern
**File**: `layouts/partials/card-founder.html`
```go-html-template
<article class="card card--founder">
  {{ if .Params.photo }}
    <div class="card__photo">
      <img src="{{ .Params.photo | relURL }}"
           alt="{{ .Title }}"
           loading="lazy">
    </div>
  {{ end }}

  <div class="card__content">
    <h3 class="card__name">{{ .Title }}</h3>
    {{ if .Params.role }}
      <p class="card__role">{{ .Params.role }}</p>
    {{ end }}

    {{ if .Params.brands }}
      <div class="card__brands">
        {{ range .Params.brands }}
          {{ $brandPage := $.Site.GetPage (printf "/brands/%s" .) }}
          {{ if $brandPage }}
            <a href="{{ $brandPage.RelPermalink }}" class="card__brand-link">
              {{ $brandPage.Title }}
            </a>
          {{ end }}
        {{ end }}
      </div>
    {{ end }}
  </div>
</article>
```

### Insight Card Pattern
**File**: `layouts/partials/card-insight.html`
```go-html-template
<article class="card card--insight">
  <div class="card__content">
    <div class="card__meta">
      <time datetime="{{ .Date.Format "2006-01-02" }}">
        {{ .Date.Format "January 2, 2006" }}
      </time>
      {{ if .Params.readingTime }}
        <span class="card__reading-time">
          {{ .Params.readingTime }} {{ i18n "min_read" }}
        </span>
      {{ end }}
    </div>

    <h3 class="card__title">
      <a href="{{ .RelPermalink }}">{{ .Title }}</a>
    </h3>

    {{ if .Params.description }}
      <p class="card__excerpt">{{ .Params.description }}</p>
    {{ else }}
      <p class="card__excerpt">{{ .Summary }}</p>
    {{ end }}

    {{ if .Params.signals }}
      <div class="card__tags">
        {{ range .Params.signals }}
          <span class="tag tag--signal">{{ . }}</span>
        {{ end }}
      </div>
    {{ end }}
  </div>
</article>
```

### Dimension Card Pattern
**File**: `layouts/partials/card-dimension.html`
```go-html-template
<article class="card card--dimension"
         data-dimension-type="{{ .Params.dimensionType }}">
  <div class="card__content">
    {{ if .Params.icon }}
      <div class="card__icon" style="color: {{ .Params.color }}">
        <svg class="icon icon--{{ .Params.icon }}">
          <use href="#icon-{{ .Params.icon }}"></use>
        </svg>
      </div>
    {{ end }}

    <h3 class="card__title">{{ .Title }}</h3>

    {{ if .Params.description }}
      <p class="card__description">{{ .Params.description }}</p>
    {{ end }}

    <a href="{{ .RelPermalink }}" class="card__link">
      {{ i18n "learn_more" }}
    </a>
  </div>
</article>
```

## Font Loading: Self-Hosted Typography

### Font Files Structure
```
static/fonts/
├── PTSans/
│   ├── PTSans-Regular.woff2
│   ├── PTSans-Bold.woff2
│   ├── PTSans-Italic.woff2
│   └── PTSans-BoldItalic.woff2
├── PTSerif/
│   ├── PTSerif-Regular.woff2
│   ├── PTSerif-Bold.woff2
│   ├── PTSerif-Italic.woff2
│   └── PTSerif-BoldItalic.woff2
└── NotoSansSC/
    ├── NotoSansSC-Regular.woff2
    ├── NotoSansSC-Bold.woff2
    └── NotoSansSC-Medium.woff2
```

### Font Face Declarations
**File**: `assets/css/fonts.css`
```css
/* PT Sans - Latin/Cyrillic */
@font-face {
  font-family: 'PT Sans';
  src: url('/fonts/PTSans/PTSans-Regular.woff2') format('woff2');
  font-weight: 400;
  font-style: normal;
  font-display: swap;
  unicode-range: U+0000-00FF, U+0100-024F, U+0400-04FF;
}

@font-face {
  font-family: 'PT Sans';
  src: url('/fonts/PTSans/PTSans-Bold.woff2') format('woff2');
  font-weight: 700;
  font-style: normal;
  font-display: swap;
  unicode-range: U+0000-00FF, U+0100-024F, U+0400-04FF;
}

/* PT Serif - Latin/Cyrillic */
@font-face {
  font-family: 'PT Serif';
  src: url('/fonts/PTSerif/PTSerif-Regular.woff2') format('woff2');
  font-weight: 400;
  font-style: normal;
  font-display: swap;
  unicode-range: U+0000-00FF, U+0100-024F, U+0400-04FF;
}

@font-face {
  font-family: 'PT Serif';
  src: url('/fonts/PTSerif/PTSerif-Bold.woff2') format('woff2');
  font-weight: 700;
  font-style: normal;
  font-display: swap;
  unicode-range: U+0000-00FF, U+0100-024F, U+0400-04FF;
}

/* Noto Sans SC - Simplified Chinese */
@font-face {
  font-family: 'Noto Sans SC';
  src: url('/fonts/NotoSansSC/NotoSansSC-Regular.woff2') format('woff2');
  font-weight: 400;
  font-style: normal;
  font-display: swap;
  unicode-range: U+4E00-9FFF, U+3400-4DBF;
}

@font-face {
  font-family: 'Noto Sans SC';
  src: url('/fonts/NotoSansSC/NotoSansSC-Bold.woff2') format('woff2');
  font-weight: 700;
  font-style: normal;
  font-display: swap;
  unicode-range: U+4E00-9FFF, U+3400-4DBF;
}
```

### CSS Variables
```css
:root {
  /* Font families */
  --font-body: 'PT Sans', -apple-system, system-ui, sans-serif;
  --font-heading: 'PT Serif', Georgia, serif;
  --font-chinese: 'Noto Sans SC', 'PingFang SC', 'Hiragino Sans GB', sans-serif;

  /* Font sizes - fluid typography */
  --text-xs: clamp(0.75rem, 0.7rem + 0.25vw, 0.875rem);
  --text-sm: clamp(0.875rem, 0.8rem + 0.375vw, 1rem);
  --text-base: clamp(1rem, 0.9rem + 0.5vw, 1.125rem);
  --text-lg: clamp(1.125rem, 1rem + 0.625vw, 1.25rem);
  --text-xl: clamp(1.25rem, 1.1rem + 0.75vw, 1.5rem);
  --text-2xl: clamp(1.5rem, 1.3rem + 1vw, 2rem);
  --text-3xl: clamp(1.875rem, 1.6rem + 1.375vw, 2.5rem);
}

body {
  font-family: var(--font-body);
  font-size: var(--text-base);
  line-height: 1.6;
}

:lang(zh) body {
  font-family: var(--font-chinese);
}

h1, h2, h3, h4, h5, h6 {
  font-family: var(--font-heading);
  line-height: 1.2;
}

:lang(zh) h1,
:lang(zh) h2,
:lang(zh) h3,
:lang(zh) h4,
:lang(zh) h5,
:lang(zh) h6 {
  font-family: var(--font-chinese);
}
```

## Mobile-First Standards

### Viewport Breakpoints
```css
/* Mobile-first: Design for 320px-414px first */
:root {
  --bp-xs: 320px;   /* Small phones */
  --bp-sm: 375px;   /* Standard phones */
  --bp-md: 414px;   /* Large phones */
  --bp-lg: 768px;   /* Tablets */
  --bp-xl: 1024px;  /* Laptops */
  --bp-2xl: 1440px; /* Desktops */
}

/* Mobile-first media queries */
@media (min-width: 768px) {
  /* Tablet and above */
}

@media (min-width: 1024px) {
  /* Laptop and above */
}
```

### Touch Targets
```css
/* Minimum 44px × 44px touch targets */
.button,
.card a,
nav a,
.tag {
  min-height: 44px;
  min-width: 44px;
  padding: 0.75rem 1rem;

  /* Increase tap area without visual change */
  position: relative;
}

.button::before {
  content: '';
  position: absolute;
  top: -8px;
  right: -8px;
  bottom: -8px;
  left: -8px;
}
```

### Layout Patterns
```css
/* No sidebars - linear vertical flow */
.layout {
  display: flex;
  flex-direction: column;
  gap: var(--space-lg);
}

/* Card grid - mobile first */
.card-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
}

@media (min-width: 768px) {
  .card-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (min-width: 1024px) {
  .card-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

/* Content max-width for readability */
.content {
  max-width: 65ch; /* ~65 characters per line */
  margin-inline: auto;
  padding-inline: 1rem;
}

@media (min-width: 768px) {
  .content {
    padding-inline: 2rem;
  }
}
```

### Typography Scaling
```css
/* Mobile: 16px minimum */
body {
  font-size: clamp(1rem, 0.9rem + 0.5vw, 1.125rem);
}

/* Headings scale appropriately */
h1 {
  font-size: clamp(1.875rem, 1.6rem + 1.375vw, 2.5rem);
  margin-block: 1.5rem 1rem;
}

h2 {
  font-size: clamp(1.5rem, 1.3rem + 1vw, 2rem);
  margin-block: 1.25rem 0.875rem;
}

h3 {
  font-size: clamp(1.25rem, 1.1rem + 0.75vw, 1.5rem);
  margin-block: 1rem 0.75rem;
}
```

## Breadcrumbs Implementation (2025-10-05)

**Location**: `layouts/partials/breadcrumbs.html`

**Implementation**:
```go-html-template
<nav aria-label="Breadcrumb">
  <ol class="breadcrumbs">
    <li><a href="{{ "/" | relLangURL }}">{{ i18n "home" | default "Home" }}</a></li>
    {{ range .Ancestors.Reverse }}
      <li><a href="{{ .RelPermalink }}">{{ .Title }}</a></li>
    {{ end }}
    <li aria-current="page">{{ .Title }}</li>
  </ol>
</nav>
```

**Hugo Method**: Uses `.Ancestors` to auto-generate hierarchy
**Display**: Home > Section > Current Page
**Styling**: Inline teal separator (›), current page bold

## Hero Panel System (2025-10-05)

### Split-Panel Gradient Architecture
**2-layer gradient system** for soothing color transitions:

**Layer 1 - Outer Section Background**:
```css
.panel--hero-split {
  background: radial-gradient(
    circle at 30% 40%,
    var(--primary-400) 0%,
    var(--primary-700) 100%
  );
}
```

**Layer 2 - Text Panel (Always Teal)**:
```css
.split-hero__content {
  background: linear-gradient(
    90deg,
    var(--primary-600) 0%,
    var(--primary-700) 100%
  );
}
```

**Color Variants** (outer background only):
- Orange (Brand Spotlight): `--secondary-400` → `--secondary-700`
- Purple (Founder's Journey): `#A78BFA` → `#7E22CE`
- Blue (Location Intelligence): `--sky-400` → `--sky-700`
- Green (Market Momentum): `--olive-400` → `--olive-700`

**Image Panel**:
- Aspect ratio: 3:2 (horizontal)
- Responsive breakpoint: **768px** (NOT 992px)
- Desktop: Side-by-side layout
- Mobile: Stacked vertically

## Home Page Panel Sequence (OFFICIAL STANDARD)

**Emotional Journey Pattern:**
1. **Hero** → panel--hero (excitement, visual impact)
2. **Discovery** → panel--primary (trust, brand reliability)
3. **Featured Brands** → panel--light (clarity, clean showcase)
4. **Insights** → panel--orange-soft (warmth, engagement)
5. **Discovery Tools** → panel--accent-soft (intelligence, capability)
6. **CTA** → panel--cta (urgency, action)

**Mobile Behavior:**
- Full-width panels
- Vertical rhythm: --space-2xl (3rem) between sections
- No horizontal scrolling

**Typography:**
- Consistent h2 for section headings
- Color varies by panel background (maintain WCAG AA contrast)

## Performance Benchmarks

### Target Metrics (Lighthouse)
```yaml
performance: 95+
accessibility: 100
best_practices: 100
seo: 100

# Core Web Vitals
LCP: < 2.5s    # Largest Contentful Paint
FID: < 100ms   # First Input Delay
CLS: < 0.1     # Cumulative Layout Shift

# Additional
FCP: < 1.5s    # First Contentful Paint
SI: < 3.0s     # Speed Index
TBT: < 200ms   # Total Blocking Time
TTI: < 3.5s    # Time to Interactive
```

### Optimization Checklist
- [ ] Self-hosted fonts with font-display: swap
- [ ] Images optimized (WebP with fallback)
- [ ] Images lazy-loaded (loading="lazy")
- [ ] Critical CSS inlined
- [ ] CSS minified (hugo --minify)
- [ ] HTML minified (hugo --minify)
- [ ] No render-blocking resources
- [ ] Proper cache headers
- [ ] Resource hints (preconnect, dns-prefetch)
- [ ] No console errors
- [ ] Semantic HTML
- [ ] ARIA labels where needed
- [ ] Keyboard navigation support

### Build Commands
```bash
# Development (fast, unoptimized)
hugo server

# Production (optimized)
hugo --gc --minify

# With performance analysis
hugo --gc --minify --templateMetrics --templateMetricsHints
```

## Hugo-Native Patterns

### Conditional Rendering
```go-html-template
{{ if .Params.featured }}
  <mark class="badge badge--featured">{{ i18n "featured" }}</mark>
{{ end }}

{{ with .Params.tagline }}
  <p class="tagline">{{ . }}</p>
{{ end }}
```

### Loops and Ranges
```go-html-template
{{/* All brands */}}
{{ range where .Site.RegularPages "Section" "brands" }}
  {{ partial "card-brand.html" . }}
{{ end }}

{{/* Filtered by market */}}
{{ range where .Site.RegularPages ".Params.markets" "intersect" (slice "china") }}
  {{ partial "card-brand.html" . }}
{{ end }}

{{/* Limited number */}}
{{ range first 6 (where .Site.RegularPages "Section" "insights") }}
  {{ partial "card-insight.html" . }}
{{ end }}
```

### Data Access
```go-html-template
{{/* Translation data */}}
{{ $translations := index .Site.Data.translations .Site.Language.Lang }}
{{ $nav := $translations.nav_brands }}

{{/* Custom data file */}}
{{ $brands := .Site.Data.brands }}
{{ range $brands }}
  <li>{{ .name }}</li>
{{ end }}
```

### URL Generation
```go-html-template
{{/* Relative to current language */}}
<a href="{{ "/brands/" | relLangURL }}">{{ i18n "nav_brands" }}</a>

{{/* Absolute URL */}}
<a href="{{ "/brands/" | absLangURL }}">{{ i18n "nav_brands" }}</a>

{{/* Permalink */}}
<a href="{{ .Permalink }}">{{ .Title }}</a>
<a href="{{ .RelPermalink }}">{{ .Title }}</a>
```

### Content Summaries
```go-html-template
{{/* Auto summary (first 70 words) */}}
{{ .Summary }}

{{/* Manual summary (<!--more--> in content) */}}
{{ .Summary }}

{{/* Truncated content */}}
{{ .Content | truncate 200 }}

{{/* Plain text version */}}
{{ .Plain }}
```

## Supabase Database Standards

### Documentation Location
All Supabase documentation is centralized in `docs/supabase/`:

```
docs/supabase/
├── README.md              # Overview and conventions
├── schema-design.md       # Full database schema (Phase 4)
├── contact-forms.md       # Contact form implementation (Phase 3)
├── sql/                   # SQL migrations
│   ├── 001-contacts-table.sql
│   ├── 002-duplicate-prevention.sql
│   ├── 003-data-retention-policy.sql
│   └── queries.sql       # Common queries
└── guides/               # Procedures
    └── setup-guide.md
```

### SQL Migration Standards

**Naming Convention**: `NNN-description.sql`
- Use sequential numbers (001, 002, 003...)
- Lowercase with hyphens for descriptions
- Descriptive but concise

**File Headers**: Every SQL file must include:
```sql
-- Purpose: [What this migration does]
-- Created: [YYYY-MM-DD]
-- Applied to Production: [YYYY-MM-DD or PENDING]
-- Prerequisites: [None or list of files]
```

**Execution Rules**:
- Execute files in numerical order
- Track execution dates in file headers
- Use `CREATE OR REPLACE` for idempotency where possible
- Test in development before production

### Environment Variables

Hugo does NOT auto-load `.env.local` files. Must export manually:

```bash
# Load environment variables before Hugo
set -a && source .env.local && set +a && hugo server

# Required variables
SUPABASE_URL=https://[project].supabase.co
SUPABASE_ANON_KEY=eyJ[token]...
```

**Template Usage**:
```go-html-template
const SUPABASE_URL = '{{ getenv "SUPABASE_URL" }}';
const SUPABASE_ANON_KEY = '{{ getenv "SUPABASE_ANON_KEY" }}';
```

**Production (Cloudflare Pages)**:
- Add environment variables in Cloudflare dashboard
- Variables auto-injected during build
- No `.env.local` needed in production

### Query Organization

**queries.sql** contains reference queries organized by purpose:
- Basic queries (recent contacts, by type, by country)
- Analytics (monthly trends, referral sources, geographic distribution)
- GDPR compliance (data export, deletion)
- Maintenance (duplicate detection, recent activity)

Copy queries directly from `queries.sql` into Supabase SQL Editor.

## Critical Constraints

### Taxonomy Limit
**ONLY 4 TAXONOMIES**:
1. markets
2. sectors
3. attributes
4. signals

**No additions permitted**. This is architectural foundation.

### Translation System
**Use existing files**:
- `data/translations/en.yml`
- `data/translations/ru.yml`
- `data/translations/zh.yml`

**Do not create new translation mechanisms**.

### Font Stack
**Only these fonts**:
- PT Sans (body, EN/RU)
- PT Serif (headings, EN/RU)
- Noto Sans SC (body/headings, ZH)

**All self-hosted from `/static/fonts/`**. No external CDNs.

### Card Complexity
**Keep cards simple**:
- Hugo partials, not complex components
- Data-driven from front matter
- No JavaScript required for basic cards
- Progressive enhancement only

### Mobile-First
**Primary viewport**: 320px-414px
- No sidebars
- Linear content flow
- 44px minimum touch targets
- Readable typography at mobile sizes

## Migration Standards

**Critical Rule**: No backwards compatibility with Jekyll.

**Examples**:
- ❌ `collection` field → ✅ Use Hugo sections
- ❌ Jekyll-style `_data/` → ✅ Hugo `data/`
- ❌ Liquid template patterns → ✅ Go template patterns
- ❌ Jekyll front matter → ✅ Clean Hugo front matter

**When migrating content**:
1. Convert to clean Hugo structure first
2. Don't preserve Jekyll fields
3. Don't create compatibility shims
4. Document breaking changes

---

**Last Updated**: 2025-10-05
**Hugo Version**: 0.139.3
**Status**: Breadcrumbs, hero panel gradients, insight sidebar components, and mini card patterns documented
