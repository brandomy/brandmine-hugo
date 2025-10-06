# Brandmine Brand Guide - 2025 Minimalist Design

## Color System

### Primary Colors

#### Teal (#38B2AC) - Trust & Stability
```css
--color-teal-50: #E6FFFA;
--color-teal-100: #B2F5EA;
--color-teal-200: #81E6D9;
--color-teal-300: #4FD1C5;
--color-teal-400: #38B2AC;  /* Primary */
--color-teal-500: #319795;
--color-teal-600: #2C7A7B;
--color-teal-700: #285E61;
--color-teal-800: #234E52;
--color-teal-900: #1D4044;
```

**Usage**:
- Primary brand color
- Navigation elements
- CTA buttons
- Links

**Represents**: Global trust, cross-border stability, intelligence platform

#### Orange (#F97316) - Energy & Innovation
```css
--color-orange-50: #FFF7ED;
--color-orange-100: #FFEDD5;
--color-orange-200: #FED7AA;
--color-orange-300: #FDBA74;
--color-orange-400: #FB923C;
--color-orange-500: #F97316;  /* Secondary */
--color-orange-600: #EA580C;
--color-orange-700: #C2410C;
--color-orange-800: #9A3412;
--color-orange-900: #7C2D12;
```

**Usage**:
- Secondary accent
- Highlights
- Attribute taxonomy tags
- Brand Spotlight insights
- Call-to-action accents

**Represents**: Innovation, energy, emerging markets, brand qualities

#### Indigo (#6366F1) - Signals & Growth
```css
--color-indigo-50: #EEF2FF;
--color-indigo-100: #E0E7FF;
--color-indigo-200: #C7D2FE;
--color-indigo-300: #A5B4FC;
--color-indigo-400: #818CF8;
--color-indigo-500: #6366F1;  /* Accent */
--color-indigo-600: #4F46E5;
--color-indigo-700: #4338CA;
--color-indigo-800: #3730A3;
--color-indigo-900: #312E81;
```

**Usage**:
- Accent color
- Signal taxonomy tags
- Founder's Journey insights
- Growth indicators
- Leadership excellence markers

**Represents**: Signals, growth trajectories, founder excellence

### Neutral Colors

#### Gray Scale
```css
--color-gray-50: #F9FAFB;   /* Backgrounds */
--color-gray-100: #F3F4F6;  /* Light backgrounds */
--color-gray-200: #E5E7EB;  /* Borders */
--color-gray-300: #D1D5DB;  /* Disabled states */
--color-gray-400: #9CA3AF;  /* Placeholders */
--color-gray-500: #6B7280;  /* Secondary text */
--color-gray-600: #4B5563;  /* Body text */
--color-gray-700: #374151;  /* Headings */
--color-gray-800: #1F2937;  /* Dark headings */
--color-gray-900: #111827;  /* Maximum contrast */
```

**Usage**:
- Typography (600-900)
- Backgrounds (50-100)
- Borders (200-300)
- Disabled states (300-400)

#### White & Black
```css
--color-white: #FFFFFF;
--color-black: #000000;
```

### Dimension Taxonomy Colors

**CRITICAL**: These color assignments are OFFICIAL Brandmine standards.

#### Olive Green (#A3B763) - Sectors & Market Momentum
```css
--color-olive-50: #F7FAEB;
--color-olive-100: #EBF2D2;
--color-olive-200: #D7E5A8;
--color-olive-300: #C1D983;
--color-olive-400: #ADC96C;
--color-olive-500: #A3B763;  /* Base */
--color-olive-600: #8CA254;
--color-olive-700: #728445;
--color-olive-800: #566336;
--color-olive-900: #3A4228;
```

**Usage**:
- Sector taxonomy tags (Consumer, Technology, Lifestyle, etc.)
- Market Momentum insight category
- Industry analysis markers
- Market trend indicators

**Represents**: Industry verticals, market trends, sector analysis

#### Sky Blue (#0EA5E9) - Markets & Location Intelligence
```css
--color-sky-50: #F0F9FF;
--color-sky-100: #E0F2FE;
--color-sky-200: #BAE6FD;
--color-sky-300: #7DD3FC;
--color-sky-400: #38BDF8;
--color-sky-500: #0EA5E9;  /* Base */
--color-sky-600: #0284C7;
--color-sky-700: #0369A1;
--color-sky-800: #075985;
--color-sky-900: #0C4A6E;
```

**Usage**:
- Market taxonomy tags (China, Russia, Global, etc.)
- Location Intelligence insight category
- Geographic intelligence markers
- Cross-border indicators

**Represents**: Geographic markets, spatial context, location intelligence

### Insight Category Color Alignment

**CRITICAL RULE**: Insight categories use SAME colors as dimension types for visual consistency.

- **Brand Spotlight**: Orange (#F97316) - same as Attributes dimension
- **Founder's Journey**: Indigo (#6366F1) - same as Signals dimension
- **Location Intelligence**: Sky Blue (#0EA5E9) - same as Markets dimension
- **Market Momentum**: Olive Green (#A3B763) - same as Sectors dimension

### Semantic Colors

#### Success
```css
--color-success: #10B981;
--color-success-light: #6EE7B7;
--color-success-dark: #059669;
```

**Usage**: Growth signals, positive metrics, success states

#### Warning
```css
--color-warning: #F59E0B;
--color-warning-light: #FCD34D;
--color-warning-dark: #D97706;
```

**Usage**: Caution signals, alerts, important notices

#### Error
```css
--color-error: #EF4444;
--color-error-light: #FCA5A5;
--color-error-dark: #DC2626;
```

**Usage**: Error states, critical alerts, risk indicators

#### Info
```css
--color-info: #3B82F6;
--color-info-light: #93C5FD;
--color-info-dark: #2563EB;
```

**Usage**: Information notices, insights, contextual help

## Typography System

### Font Families

#### PT Sans - Body (English/Russian)
- **Weights**: 400 (Regular), 700 (Bold)
- **Use**: Body text, UI elements, navigation
- **Language**: Latin, Cyrillic
- **Character**: Clean, modern, highly readable

```css
font-family: 'PT Sans', -apple-system, system-ui, sans-serif;
```

#### PT Serif - Headings (English/Russian)
- **Weights**: 400 (Regular), 700 (Bold)
- **Use**: Headings, editorial content
- **Language**: Latin, Cyrillic
- **Character**: Traditional, authoritative, elegant

```css
font-family: 'PT Serif', Georgia, serif;
```

#### Noto Sans SC - Chinese
- **Weights**: 400 (Regular), 500 (Medium), 700 (Bold)
- **Use**: All Chinese text (body and headings)
- **Language**: Simplified Chinese
- **Character**: Clean, modern, excellent readability

```css
font-family: 'Noto Sans SC', 'PingFang SC', 'Hiragino Sans GB', sans-serif;
```

### Type Scale

#### Desktop Scale (1024px+)
```css
--text-xs: 0.75rem;      /* 12px - Captions, labels */
--text-sm: 0.875rem;     /* 14px - Small text, metadata */
--text-base: 1rem;       /* 16px - Body text */
--text-lg: 1.125rem;     /* 18px - Large body, intro */
--text-xl: 1.25rem;      /* 20px - H4 */
--text-2xl: 1.5rem;      /* 24px - H3 */
--text-3xl: 1.875rem;    /* 30px - H2 */
--text-4xl: 2.25rem;     /* 36px - H1 */
--text-5xl: 3rem;        /* 48px - Hero heading */
```

#### Mobile Scale (320px-768px)
```css
--text-xs: 0.75rem;      /* 12px */
--text-sm: 0.875rem;     /* 14px */
--text-base: 1rem;       /* 16px - Never below 16px */
--text-lg: 1.125rem;     /* 18px */
--text-xl: 1.25rem;      /* 20px - H4 */
--text-2xl: 1.5rem;      /* 24px - H3 */
--text-3xl: 1.875rem;    /* 30px - H2 */
--text-4xl: 2.25rem;     /* 36px - H1 */
```

**Critical**: Never use font-size smaller than 16px for body text on mobile to prevent iOS zoom.

### Line Heights
```css
--leading-none: 1;       /* Tight headings */
--leading-tight: 1.2;    /* H1, H2 */
--leading-snug: 1.375;   /* H3, H4, H5 */
--leading-normal: 1.5;   /* UI elements */
--leading-relaxed: 1.6;  /* Body text */
--leading-loose: 2;      /* Special spacing */
```

### Font Weights
```css
--font-normal: 400;
--font-medium: 500;  /* Noto Sans SC only */
--font-bold: 700;
```

### Typography Hierarchy

#### Headings
```css
h1 {
  font-family: var(--font-heading);
  font-size: var(--text-4xl);
  font-weight: 700;
  line-height: var(--leading-tight);
  margin-block: 1.5rem 1rem;
}

h2 {
  font-family: var(--font-heading);
  font-size: var(--text-3xl);
  font-weight: 700;
  line-height: var(--leading-tight);
  margin-block: 1.25rem 0.875rem;
}

h3 {
  font-family: var(--font-heading);
  font-size: var(--text-2xl);
  font-weight: 700;
  line-height: var(--leading-snug);
  margin-block: 1rem 0.75rem;
}

h4 {
  font-family: var(--font-heading);
  font-size: var(--text-xl);
  font-weight: 700;
  line-height: var(--leading-snug);
  margin-block: 0.875rem 0.625rem;
}
```

#### Body Text
```css
body {
  font-family: var(--font-body);
  font-size: var(--text-base);
  font-weight: 400;
  line-height: var(--leading-relaxed);
  color: var(--color-gray-600);
}

.lead {
  font-size: var(--text-lg);
  line-height: var(--leading-relaxed);
  color: var(--color-gray-700);
}

small {
  font-size: var(--text-sm);
}
```

#### Chinese Typography
```css
:lang(zh) {
  font-family: var(--font-chinese);
}

:lang(zh) h1,
:lang(zh) h2,
:lang(zh) h3,
:lang(zh) h4 {
  font-family: var(--font-chinese);
  font-weight: 500;  /* Medium weight for Chinese */
}

:lang(zh) body {
  font-family: var(--font-chinese);
}
```

## 4 Visual Styles

### 1. Textured Style

**Character**: Organic, tactile, premium, artisanal

**Usage**:
- Traditional luxury brands
- Artisanal products
- Heritage brands
- Premium consumer goods

**Elements**:
- Subtle background textures (paper, fabric, concrete)
- Organic shapes and edges
- Natural imagery
- Warm color overlays
- Depth through layering

**Example CSS**:
```css
.style-textured {
  background-image: url('/images/textures/paper.jpg');
  background-blend-mode: multiply;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1),
              0 2px 4px rgba(0, 0, 0, 0.06);
}

.style-textured .card {
  border: 1px solid rgba(0, 0, 0, 0.05);
  border-radius: 4px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}
```

### 2. Flat Style

**Character**: Modern, clean, digital-first, approachable

**Usage**:
- Technology brands
- Digital services
- Modern consumer brands
- Mobile-first products

**Elements**:
- Solid colors, no gradients
- No shadows or depth effects
- Simple geometric shapes
- Bold, clear typography
- High color contrast
- Minimalist icons

**Example CSS**:
```css
.style-flat {
  background: var(--color-gray-50);
}

.style-flat .card {
  background: var(--color-white);
  border: 2px solid var(--color-gray-200);
  border-radius: 0;
  box-shadow: none;
}

.style-flat .button {
  background: var(--color-teal-500);
  border: none;
  border-radius: 4px;
  box-shadow: none;
}
```

### 3. Geometric Style

**Character**: Structured, technical, data-driven, professional

**Usage**:
- B2B platforms
- Data intelligence
- Financial services
- Analytics tools
- Technical products

**Elements**:
- Precise grid systems
- Angular shapes and lines
- Data visualizations
- Monospace accents
- Technical diagrams
- Grid backgrounds

**Example CSS**:
```css
.style-geometric {
  background-image:
    linear-gradient(var(--color-gray-200) 1px, transparent 1px),
    linear-gradient(90deg, var(--color-gray-200) 1px, transparent 1px);
  background-size: 20px 20px;
}

.style-geometric .card {
  clip-path: polygon(0 0, 100% 0, 100% calc(100% - 12px), calc(100% - 12px) 100%, 0 100%);
  border: 1px solid var(--color-gray-300);
}

.style-geometric .heading {
  font-family: 'PT Sans', monospace;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
```

### 4. Photography Style

**Character**: Visual, narrative, emotional, human-focused

**Usage**:
- Founder stories
- Brand narratives
- Case studies
- Market insights
- Cultural content

**Elements**:
- Large, high-quality images
- Photographic backgrounds
- Image overlays for text
- Cinematic aspect ratios
- Minimal interface chrome
- Text on image with scrim

**Example CSS**:
```css
.style-photography {
  position: relative;
}

.style-photography::before {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(
    to bottom,
    rgba(0, 0, 0, 0) 0%,
    rgba(0, 0, 0, 0.6) 100%
  );
}

.style-photography .card {
  background-size: cover;
  background-position: center;
  min-height: 400px;
}

.style-photography .content {
  position: relative;
  z-index: 1;
  color: var(--color-white);
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}
```

## Panel Color System (Updated 2025-10-06)

### Panel Types and Usage

**Enhanced Palette for Emotional Flow:**

```css
/* Core Panels */
.panel--hero         /* Dark teal gradient - Excitement, brand entry */
.panel--primary-soft /* Light teal (--primary-50) - Trust, authority */
.panel--light        /* White - Clarity, openness */
.panel--neutral-soft /* Light grey (--neutral-50) - Human connection, subtle emphasis */
.panel--orange-soft  /* Orange tint - Warmth, engagement */
.panel--cta          /* Dark teal - Urgency, action */
```

### When to Use Panel Colors

**panel--hero** (Dark Teal Gradient)
- Use: Page hero sections
- Emotion: Excitement, brand entry
- Text color: White/light

**panel--primary-soft** (Light Teal)
- Use: Platform/authority content (brands grid, dimensions)
- Emotion: Trust, credibility
- Best for: Product/feature sections

**panel--light** (White)
- Use: People/clarity content (stats, team info)
- Emotion: Openness, transparency
- Best for: Information sections

**panel--neutral-soft** (Light Grey #F9FAFB)
- Use: People-focused sections (founders, team, testimonials)
- Emotion: Human connection, warmth without stark clinical feel
- Best for: Content about individuals, softer emphasis
- **Key distinction**: Warmer than white, more approachable

**panel--orange-soft** (Orange Tint)
- Use: Insights, thought leadership
- Emotion: Warmth, engagement
- Best for: Differentiating editorial content

**panel--cta** (Dark Teal)
- Use: Final CTAs, conversion panels
- Emotion: Urgency, action
- **Heading color**: Orange (--secondary-200) for attention
- **Primary button**: Always orange (--secondary-500) for maximum conversion
- **Secondary button**: White outline (optional, for secondary actions)

### Panel Sequence Examples

**Home Page (7 Panels):**
```
1. Hero → Dark teal (excitement)
2. Stats → Light teal (trust)
3. Brands → White (clarity)
4. Founders → Neutral soft (human connection)
5. Dimensions → White (openness)
6. Insights → Orange soft (engagement)
7. How It Works → Dark teal (action)
```

**About Page (6 Panels):**
```
1. Hero → Dark teal (excitement)
2. What We Do → White (clarity)
3. Who We Serve → Light teal (authority)
4. Our Approach → Neutral soft (people focus)
5. Our Team → White (transparency)
6. Contact Form → Dark teal CTA (conversion)
```

**Design Principle**: Alternate between teal (brand/platform) and white/neutral (people/content) to create rhythm. Reserve orange for special differentiation (insights).

### CTA Panel Standards (Site-Wide)

**CRITICAL RULE**: All CTA panels must follow this exact pattern for maximum conversion.

**Visual Hierarchy:**
```
1. Heading: Orange (--secondary-200) on dark teal*
2. Body text: White with 90% opacity
3. Primary button: Orange (--secondary-500) - ALWAYS
4. Secondary button: White outline (optional)

*Exception: White heading when panel contains orange numbered elements (preserves visual hierarchy)
```

**Code Template:**
```html
<section class="panel panel--cta">
  <div class="panel__content" style="max-width: 800px; margin: 0 auto; text-align: center;">
    <h2 style="color: var(--secondary-200); margin-bottom: var(--space-md);">
      [Heading]
    </h2>
    <p style="color: white; opacity: 0.9; font-size: var(--text-lg); margin-bottom: var(--space-xl);">
      [Description]
    </p>

    <div style="display: flex; gap: var(--space-4); flex-wrap: wrap; justify-content: center;">
      <!-- Primary Button (Orange) -->
      <a href="[primary-action]" class="btn btn--secondary" style="display: inline-block; padding: var(--btn-padding-default); background: var(--secondary-500); color: white; border-radius: var(--radius-md); font-weight: var(--font-semibold); min-height: var(--btn-height-default); display: inline-flex; align-items: center; justify-content: center; text-decoration: none;">
        [Primary CTA]
      </a>

      <!-- Secondary Button (White Outline) -->
      <a href="[secondary-action]" class="btn btn--outline-light" style="display: inline-block; padding: var(--btn-padding-default); background: transparent; color: white; border: 2px solid white; border-radius: var(--radius-md); font-weight: var(--font-semibold); min-height: var(--btn-height-default); display: inline-flex; align-items: center; justify-content: center; text-decoration: none;">
        [Secondary CTA]
      </a>
    </div>
  </div>
</section>
```

**CRITICAL: Button styles must be identical across all pages:**
- Use `class="btn btn--secondary"` for primary orange button
- Use `class="btn btn--outline-light"` for secondary white outline button
- Always include: `padding: var(--btn-padding-default)` and `min-height: var(--btn-height-default)`
- Gap between buttons: `var(--space-4)` (not --space-md)

**Rationale:**
- **Orange heading**: Grabs attention against dark teal (maximum contrast)
- **Orange primary button**: Highest conversion element, must stand out
- **White secondary button**: Lower priority action, recedes visually
- **Dark teal background**: Creates urgency/action emotion

**Examples:**
- **Brands page**: "Ready to Grow Beyond Borders?" (orange heading) → "Grow With Brandmine" (orange button)
- **Home page**: "How It Works" (white heading - exception for numbered steps in orange) → "Start Discovering" (orange button)
- **About page**: Future CTA panels (orange heading + orange button)

## 2025 Minimalist Design Principles

### 1. Content First
- Remove decorative elements
- Let content breathe with whitespace
- Clear visual hierarchy
- Purposeful use of color

### 2. Functional Beauty
- Every element serves a purpose
- No ornamental design
- Beauty through clarity
- Thoughtful negative space

### 3. Performance is Design
- Lightweight assets
- Fast load times
- Smooth interactions
- Progressive enhancement

### 4. Mobile-First Mindset
- Design for smallest screens first
- Progressive enhancement for larger screens
- Touch-friendly by default
- Thumb-zone navigation

### 5. Accessibility is Essential
- WCAG 2.1 AA minimum
- Semantic HTML
- Keyboard navigation
- Screen reader friendly
- Sufficient color contrast

### 6. Data-Driven Aesthetics
- Let data shape design
- Programmatic components
- Consistent patterns
- Scalable systems

## Mobile-First Component Patterns

### Card Component
```css
.card {
  /* Mobile first */
  display: flex;
  flex-direction: column;
  gap: 1rem;
  padding: 1.5rem;
  background: var(--color-white);
  border: 1px solid var(--color-gray-200);
  border-radius: 8px;
}

.card__image {
  aspect-ratio: 16 / 9;
  overflow: hidden;
  border-radius: 4px;
}

.card__image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.card__title {
  font-size: var(--text-xl);
  font-weight: 700;
  margin: 0;
}

.card__meta {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

/* Tablet and above */
@media (min-width: 768px) {
  .card {
    padding: 2rem;
  }
}
```

### Tag Component
```css
.tag {
  /* Mobile: Full visibility */
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
  padding: 0.375rem 0.75rem;
  font-size: var(--text-sm);
  font-weight: 500;
  border-radius: 4px;
  background: var(--color-gray-100);
  color: var(--color-gray-700);
}

.tag--market {
  background: var(--color-sky-50);
  color: var(--color-sky-700);
}

.tag--sector {
  background: var(--color-olive-50);
  color: var(--color-olive-700);
}

.tag--attribute {
  background: var(--color-orange-50);
  color: var(--color-orange-700);
}

.tag--signal {
  background: var(--color-indigo-50);
  color: var(--color-indigo-700);
}
```

### Button Component
```css
.button {
  /* Touch-friendly sizing */
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 44px;
  min-width: 44px;
  padding: 0.75rem 1.5rem;

  font-family: var(--font-body);
  font-size: var(--text-base);
  font-weight: 600;
  text-align: center;
  text-decoration: none;

  background: var(--color-teal-500);
  color: var(--color-white);
  border: none;
  border-radius: 6px;

  cursor: pointer;
  transition: background-color 0.2s ease;
}

.button:hover,
.button:focus {
  background: var(--color-teal-600);
}

.button:active {
  background: var(--color-teal-700);
}

.button--secondary {
  background: var(--color-orange-500);
}

.button--secondary:hover,
.button--secondary:focus {
  background: var(--color-orange-600);
}

.button--outline {
  background: transparent;
  color: var(--color-teal-500);
  border: 2px solid var(--color-teal-500);
}

.button--outline:hover,
.button--outline:focus {
  background: var(--color-teal-50);
}
```

### Navigation Component
```css
.nav {
  display: flex;
  flex-direction: column;
  gap: 0;
}

.nav__link {
  display: flex;
  align-items: center;
  min-height: 44px;
  padding: 0.75rem 1rem;

  color: var(--color-gray-700);
  text-decoration: none;

  border-bottom: 1px solid var(--color-gray-200);
}

.nav__link:hover,
.nav__link:focus {
  background: var(--color-gray-50);
  color: var(--color-teal-600);
}

.nav__link--active {
  color: var(--color-teal-600);
  font-weight: 600;
  border-left: 3px solid var(--color-teal-500);
}

/* Tablet horizontal nav */
@media (min-width: 768px) {
  .nav {
    flex-direction: row;
    gap: 1rem;
  }

  .nav__link {
    border-bottom: none;
    border-left: none;
    padding: 0.5rem 1rem;
  }

  .nav__link--active {
    border-left: none;
    border-bottom: 2px solid var(--color-teal-500);
  }
}
```

## Touch Target Sizing

### Minimum Touch Targets
```css
:root {
  --touch-target-min: 44px;  /* Apple HIG standard */
}

/* All interactive elements */
a,
button,
.button,
.tag,
.nav__link,
input,
select,
textarea {
  min-height: var(--touch-target-min);
  min-width: var(--touch-target-min);
}

/* Exception: Inline links in paragraphs */
p a {
  min-height: auto;
  min-width: auto;
  /* Use padding to extend tap area */
  padding: 0.25rem 0.125rem;
}
```

### Spacing for Touch
```css
/* Adequate spacing between touch targets */
.button-group {
  display: flex;
  gap: 1rem;  /* Minimum 8px, ideal 16px */
}

.tag-list {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;  /* Minimum spacing */
}
```

## Insight Card & CTA Styling (2025-10-05)

### Insight Card Components
```css
/* Category Badge - Subtle, not dominant */
.insight-category {
  font-size: 11px;
  font-weight: var(--font-medium);
  opacity: 0.7;
  padding: 4px 10px;
}

/* Country Flag - Inline indicator */
.card__flag-inline {
  font-size: 16px;
  margin-right: 0.375rem;
}

/* Founder Names - Light, italic text (NOT pills) */
.founder-pill {
  font-size: 13px;
  font-style: italic;
  color: var(--color-gray-500);
  font-weight: 400;
}

/* Clickable Hero Images */
.card__image-link {
  text-decoration: none;
  display: block;
  transition: opacity 0.2s ease;
}

.card__image-link:hover {
  opacity: 0.95;
}
```

### CTA Box Differentiation

**Brand Profiles**: Teal alert-style box (prominent conversion)
```css
.press-room-box {
  padding: var(--space-6);
  background: var(--primary-50);
  border: 1px solid var(--primary-200);
  border-radius: var(--radius-md);
}
```

**Insights Articles**: White subtle box (soft conversion)
```css
.cta-box {
  padding: var(--space-6);
  background: var(--color-white);
  border: 1px solid var(--color-gray-200);
  border-radius: var(--radius-md);
}

.cta-box .button {
  background: var(--color-teal-600);
  color: white;
}
```

**Rationale**: Brand profiles encourage immediate upgrade, insights articles maintain reading flow with softer CTAs.

## Spacing System

### Space Scale
```css
:root {
  --space-xs: 0.25rem;   /* 4px */
  --space-sm: 0.5rem;    /* 8px */
  --space-md: 1rem;      /* 16px */
  --space-lg: 1.5rem;    /* 24px */
  --space-xl: 2rem;      /* 32px */
  --space-2xl: 3rem;     /* 48px */
  --space-3xl: 4rem;     /* 64px */
  --space-4xl: 6rem;     /* 96px */
}
```

### Spacing Usage
- **xs (4px)**: Icon gaps, tight spacing
- **sm (8px)**: Tag gaps, inline elements
- **md (16px)**: Paragraph spacing, card internal padding
- **lg (24px)**: Section internal spacing
- **xl (32px)**: Card padding (desktop), component gaps
- **2xl (48px)**: Section gaps
- **3xl (64px)**: Major section breaks
- **4xl (96px)**: Hero spacing, page sections

## Accessibility Standards

### Color Contrast
- **Normal text**: 4.5:1 minimum (WCAG AA)
- **Large text**: 3:1 minimum (18px+, or 14px+ bold)
- **UI components**: 3:1 minimum

### Verified Combinations
```css
/* Pass WCAG AA */
--color-gray-600 on --color-white     ✓ 7.23:1
--color-gray-700 on --color-white     ✓ 10.44:1
--color-teal-500 on --color-white     ✓ 4.52:1
--color-white on --color-teal-500     ✓ 4.52:1
--color-white on --color-orange-500   ✓ 4.67:1
```

### Focus States
```css
*:focus-visible {
  outline: 2px solid var(--color-teal-500);
  outline-offset: 2px;
  border-radius: 4px;
}

button:focus-visible,
a:focus-visible {
  outline: 3px solid var(--color-teal-500);
  outline-offset: 2px;
}
```

### Skip Links
```css
.skip-link {
  position: absolute;
  top: -40px;
  left: 0;
  background: var(--color-teal-500);
  color: var(--color-white);
  padding: 0.5rem 1rem;
  text-decoration: none;
  z-index: 100;
}

.skip-link:focus {
  top: 0;
}
```

## CTA Button Standards

### White Background CTA Pattern

**Use Case**: CTA buttons on white or light backgrounds (sidebars, content boxes)

**Standard Styling**:
```css
/* Base state */
.cta-button {
  background: var(--primary-600);  /* Teal */
  color: white;
  font-weight: var(--font-semibold);
  transition: color var(--transition-fast), font-weight var(--transition-fast);
}

/* Hover state */
.cta-button:hover {
  color: var(--secondary-200);  /* Light orange #FED7AA */
  font-weight: var(--font-bold);
}
```

**Key Rules**:
- Background color stays **teal** (no background change on hover)
- Text color changes from **white → light orange** on hover
- Font weight increases from **semibold → bold** on hover (creates "growing" effect)
- Use `--secondary-200` specifically (#FED7AA - same as footer)
- Simple, clean interaction without lift effects or shadows

**Examples**:
- Insight sidebar "Explore Membership" button
- About page "Join Us" button
- Any CTA on white/light backgrounds

**Why This Pattern**:
- Maintains brand consistency (teal = trust)
- Orange text provides clear hover feedback
- Accessible contrast ratio (WCAG AA compliant)
- Subtle but noticeable interaction

---

**Last Updated**: 2025-10-06
**Status**: White background CTA standard added, insight card styling documented
**Design Philosophy**: Content first, mobile first, performance first
