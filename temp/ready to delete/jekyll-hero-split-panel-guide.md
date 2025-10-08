# Split-Style Hero Panel Guide

**Creating Attractive Side-by-Side Heroes for Central Navigation Sections**

---

## Overview

The `.panel--hero-split` is a Tier 4 hero panel that creates visually striking side-by-side layouts with content on one side and an image on the other. This is used for our main navigation sections: **Brands**, **Founders**, and **Insights**.

**File Location**: [assets/css/layout/panels/_panel-types.scss:307-547](assets/css/layout/panels/_panel-types.scss#L307-L547)

---

## Visual Design

### Layout Structure

```
┌─────────────────────────────────────┐
│  Content Side    │   Image Side     │  ← Desktop (≥768px)
│  - Title         │   [Hero Image]   │
│  - Subtitle      │   3:2 ratio      │
│  - Metadata      │                  │
└─────────────────────────────────────┘

Mobile (<768px):
┌─────────────────────┐
│     Content         │
│     - Title         │
│     - Subtitle      │
│     - Metadata      │
├─────────────────────┤
│   [Hero Image]      │
│   3:2 ratio         │
└─────────────────────┘
```

### Default Styling

- **Background**: Radial gradient (teal)
  - Light center: `var(--primary-400)` (#38B2AC lighter)
  - Dark edges: `var(--primary-600)` (#38B2AC darker)
- **Text Color**: White
- **Padding**: `var(--space-8)` (32px) top/bottom

---

## Responsive Behavior

### Mobile-First Design (Mobile < 768px)

- **Layout**: Stacked vertically
- **Text Alignment**: Center
- **Grid**: Single column, two rows (content → image)
- **Content Padding**: `var(--space-8)` `var(--space-6)` (32px 24px)

### Tablet/Desktop (≥ 768px)

- **Layout**: Side-by-side (50/50 split)
- **Text Alignment**: Left
- **Grid**: Two columns, vertically centered
- **Content Padding**: `var(--space-12)` `var(--space-10)` (48px 40px)
- **Min Height**: `var(--hero-height-md)`

### Large Desktop (≥ 992px)

- **Content Padding**: `var(--space-16)` `var(--space-12)` (64px 48px)
- **Min Height**: `var(--hero-height-lg)`

---

## Typography System

### Title (`.split-hero__title`)

| Screen Size | Font Size | CSS Variable |
|-------------|-----------|--------------|
| Mobile      | 3xl       | `var(--text-3xl)` |
| Tablet      | 4xl       | `var(--text-4xl)` |
| Desktop     | 5xl       | `var(--text-5xl)` |

- **Font Weight**: Bold (`var(--font-bold)`)
- **Line Height**: Tight (`var(--leading-tight)`)
- **Color**: White
- **Margin**: 0 0 `var(--space-4)` 0

### Subtitle (`.split-hero__subtitle`)

| Screen Size | Font Size | CSS Variable |
|-------------|-----------|--------------|
| Mobile      | lg        | `var(--text-lg)` |
| Tablet+     | xl        | `var(--text-xl)` |

- **Font Weight**: Normal (`var(--font-normal)`)
- **Line Height**: Relaxed (`var(--leading-relaxed)`)
- **Color**: `var(--surface-alpha-90)` (semi-transparent white)
- **Max Width**: 50 characters
- **Margin**: Auto-centered on mobile

---

## Image Specifications

### `.split-hero__image`

- **Aspect Ratio**: 3:2 (consistent across all screen sizes)
- **Object Fit**: Cover (fills container, crops to fit)
- **Object Position**: Center
- **Overflow**: Hidden

**Recommended Image Dimensions**:
- Minimum: 1200 × 800px
- Optimal: 1800 × 1200px
- Format: JPG (optimized), WebP preferred

---

## Color Palette Variants

The split hero supports 8 color schemes for different content types:

| Modifier Class | Color Scheme | Gradient Colors | Use Case |
|----------------|--------------|-----------------|----------|
| `.split-hero--teal` | Teal (default) | `--primary-400` → `--primary-600` | Primary sections |
| `.split-hero--blue` | Journal Blue | `--journal-blue-light` → `--journal-blue-dark` | Insights/Editorial |
| `.split-hero--orange` | Secondary Orange | `--secondary-400` → `--secondary-600` | Brands/Features |
| `.split-hero--purple` | Journal Purple | `--journal-purple-light` → `--journal-purple-dark` | Founder stories |
| `.split-hero--green` | Journal Green | `--journal-green-light` → `--journal-green-dark` | Markets/Growth |
| `.split-hero--slate` | Journal Slate | `--journal-slate-light` → `--journal-slate-dark` | Analysis |
| `.split-hero--coral` | Journal Coral | `--journal-coral-light` → `--journal-coral-dark` | Special features |
| `.split-hero--sage` | Journal Sage | `--journal-sage-light` → `--journal-sage-dark` | Resources |

**Implementation**: Add modifier class to `.split-hero` container element

---

## BEM Architecture

### Block-Element Structure

```html
<section class="panel panel--hero-split">
  <div class="panel__content">
    <div class="split-hero [split-hero--{color}]">

      <!-- Content Side -->
      <div class="split-hero__content">
        <h1 class="split-hero__title">Page Title</h1>
        <p class="split-hero__subtitle">Engaging subtitle text</p>
        <!-- Optional metadata -->
      </div>

      <!-- Image Side -->
      <div class="split-hero__image">
        <img src="path/to/hero-image.jpg" alt="Descriptive alt text">
      </div>

    </div>
  </div>
</section>
```

### Key Classes

- **Block**: `.panel--hero-split`
- **Container**: `.split-hero`
- **Elements**:
  - `.split-hero__content` - Left side text container
  - `.split-hero__image` - Right side image container
  - `.split-hero__title` - Main heading
  - `.split-hero__subtitle` - Supporting text
- **Modifiers**: `.split-hero--{color}` - Color palette variants

---

## Special Variant: Post Hero

For individual journal posts with smaller typography:

### `.split-hero--post`

**Title Sizing**:
- Mobile: `var(--text-2xl)`
- Tablet: `var(--text-3xl)`
- Desktop: `var(--text-4xl)`

**Subtitle Sizing**:
- Mobile: `var(--text-base)`
- Tablet+: `var(--text-lg)`

**Additional Elements**:

```html
<!-- Post metadata -->
<div class="post-hero__meta">
  <span class="post-hero__date">March 15, 2025</span>
  <span class="separator">•</span>
  <span class="post-hero__author">Author Name</span>
  <span class="separator">•</span>
  <span class="post-hero__reading-time">5 min read</span>
</div>

<!-- Category badge -->
<div class="post-hero__category">Category Name</div>

<!-- Tags -->
<div class="post-hero__tags">
  <a href="#" class="post-hero__tag">Tag 1</a>
  <a href="#" class="post-hero__tag">Tag 2</a>
</div>
```

---

## Implementation Examples

### Example 1: Brands Navigation Section

```html
<section class="panel panel--hero-split">
  <div class="panel__content">
    <div class="split-hero split-hero--orange">

      <div class="split-hero__content">
        <h1 class="split-hero__title">Discover Exceptional Brands</h1>
        <p class="split-hero__subtitle">
          Explore founder-led consumer brands from the Global South
          breaking through to international markets
        </p>
      </div>

      <div class="split-hero__image">
        <img src="/assets/images/heroes/brands-hero.jpg"
             alt="Curated brand products showcase">
      </div>

    </div>
  </div>
</section>
```

### Example 2: Founders Navigation Section

```html
<section class="panel panel--hero-split">
  <div class="panel__content">
    <div class="split-hero split-hero--purple">

      <div class="split-hero__content">
        <h1 class="split-hero__title">Meet the Founders</h1>
        <p class="split-hero__subtitle">
          The visionary entrepreneurs building world-class brands
          across emerging markets
        </p>
      </div>

      <div class="split-hero__image">
        <img src="/assets/images/heroes/founders-hero.jpg"
             alt="Founder portrait collage">
      </div>

    </div>
  </div>
</section>
```

### Example 3: Insights Navigation Section

```html
<section class="panel panel--hero-split">
  <div class="panel__content">
    <div class="split-hero split-hero--blue">

      <div class="split-hero__content">
        <h1 class="split-hero__title">Brand Intelligence</h1>
        <p class="split-hero__subtitle">
          Strategic insights on consumer brands, markets, and
          cross-border expansion opportunities
        </p>
      </div>

      <div class="split-hero__image">
        <img src="/assets/images/heroes/insights-hero.jpg"
             alt="Data visualization and analysis">
      </div>

    </div>
  </div>
</section>
```

---

## Configuration via `page_sections.yml`

The panel is configured through Jekyll's data-driven architecture:

```yaml
brands:
  sections:
    - type: panel
      variant: hero-split
      content_file: pages/brands/hero-split
```

**Include File** (`_includes/pages/brands/hero-split.html`):

```html
<div class="split-hero split-hero--orange">
  <div class="split-hero__content">
    <h1 class="split-hero__title">{{ page.hero_title }}</h1>
    <p class="split-hero__subtitle">{{ page.hero_subtitle }}</p>
  </div>
  <div class="split-hero__image">
    <img src="{{ page.hero_image }}" alt="{{ page.hero_image_alt }}">
  </div>
</div>
```

---

## Best Practices

### Content Guidelines

1. **Title**: 3-7 words, action-oriented or descriptive
2. **Subtitle**: 15-25 words, explain value proposition
3. **Max Width**: Subtitle limited to 50 characters for readability
4. **Tone**: Direct, benefit-focused, aligned with section purpose

### Image Guidelines

1. **Quality**: High-resolution (minimum 1200×800px)
2. **Subject**: Clear focal point, visually relevant to content
3. **Cropping**: Allow 10-15% safe area on all edges for object-fit
4. **Optimization**: Compress to <200KB without quality loss
5. **Format**: WebP preferred, JPG fallback
6. **Alt Text**: Descriptive, specific, non-redundant with title

### Accessibility

- **Contrast Ratio**: Maintained via gradient + white text
- **Semantic HTML**: Use `<h1>` for title (single per page)
- **Alt Text**: Required on all images
- **Focus States**: Inherit from global link styles
- **Screen Readers**: Logical content order (content before image in DOM)

### Performance

- **Lazy Loading**: Add `loading="lazy"` to images below fold
- **Responsive Images**: Consider `<picture>` with multiple sources
- **CSS Grid**: Supported by all modern browsers (no fallback needed)
- **Font Loading**: System uses self-hosted fonts (already optimized)

---

## Technical Details

### Grid Configuration

```scss
.split-hero {
  display: grid;

  /* Mobile: Stacked */
  grid-template-columns: 1fr;
  grid-template-rows: auto auto;

  /* Desktop: Side-by-side */
  @media (min-width: 768px) {
    grid-template-columns: 1fr 1fr;
    grid-template-rows: 1fr;
    align-items: center;
  }
}
```

### Gradient Mechanics

All color variants use **radial gradients** for visual depth:

```scss
background: radial-gradient(
  circle at 30% 40%,        // Offset center for asymmetric interest
  var(--color-400) 0%,      // Lighter shade at center
  var(--color-600) 100%     // Darker shade at edges
);
```

**Effect**: Creates subtle dimensionality, draws eye toward content area

---

## Troubleshooting

### Common Issues

**Issue**: Image not maintaining aspect ratio
- **Solution**: Ensure `.split-hero__image` has `overflow: hidden`

**Issue**: Text not centered on mobile
- **Solution**: Verify `@media (max-width: 767px)` applies `text-align: center`

**Issue**: Content vertically misaligned on desktop
- **Solution**: Check `align-items: center` on grid container

**Issue**: Gradient not applying to content side
- **Solution**: Use `.split-hero--{color}` modifier on `.split-hero` container

---

## Related Components

- **Tier 1 Hero**: `.panel--hero` - [Centered hero for navigation pages](assets/css/layout/panels/_panel-types.scss#L38-L43)
- **Tier 2 Hero**: `.panel--hero-subtle` - [Profile pages](assets/css/layout/panels/_panel-types.scss#L82-L179)
- **Tier 3 Hero**: `.panel--hero-image` - [Editorial content with background images](assets/css/layout/panels/_panel-types.scss#L182-L248)
- **Panel System**: [Complete panel architecture](assets/css/layout/panels/_panel-types.scss)

---

## Architecture Notes

### Logic-Light Configuration

Following Brandmine's "Logic Light" principle:
- Configuration via `_data/page_sections.yml`
- Minimal conditional logic in templates
- Reusable component includes
- Data-driven color variants

### BEM Compliance

Strict BEM methodology:
- **Block**: `.panel--hero-split`
- **Element**: `.split-hero__content`, `.split-hero__image`
- **Modifier**: `.split-hero--orange`, `.split-hero--post`

### Mobile-First Foundation

All styles written mobile-first per CLAUDE.md requirements:
- Base styles apply to mobile
- `@media (min-width: X)` for progressive enhancement
- Never use `max-width` queries (except explicit mobile-only overrides)

---

## Future Enhancements

**Potential additions** (not yet implemented):

1. **Animation**: Fade-in on scroll for content/image
2. **Video Support**: Replace static image with background video
3. **CTA Buttons**: Standardized call-to-action button in content area
4. **Metadata Variants**: Structured metadata for category pages
5. **Icon Support**: Optional icons in title or metadata areas

---

**Last Updated**: 2025-10-05
**Maintained By**: Brandmine Development Team
**Related Docs**:
- [CLAUDE.md](../CLAUDE.md) - Project architecture
- [technical-standards.md](../_templates/documentation/technical-standards.md) - Complete technical reference
- [Panel Types Source](../assets/css/layout/panels/_panel-types.scss) - Full SCSS implementation
