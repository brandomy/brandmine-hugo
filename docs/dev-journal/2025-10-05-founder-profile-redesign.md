# Founder Profile Redesign & Privacy Policy Implementation

**Date:** October 5, 2025
**Status:** Complete
**Developer:** Claude Code (CTO)

## Overview

Complete redesign of founder profile pages with split-panel layout, professional sidebar, and facts bar. Added privacy policy pages with multilingual support. Fixed founder card styling across brand profiles and updated footer.

---

## 1. Founder Card Styling Updates

### Issue
Founder photos displayed as circles (50% border-radius) instead of rounded rectangles, inconsistent with brand design standards.

### Implementation
Updated founder card styling in multiple locations:

**Files Modified:**
- `assets/css/components/cards.css`
- `layouts/brands/single.html`

**Changes:**
```css
/* Before: Circular photos */
.card--founder .card__image {
  aspect-ratio: 4 / 5;
}

.founder-photo {
  border-radius: 50%;  /* Circular */
}

/* After: Rounded rectangle portraits */
.card--founder .card__image {
  aspect-ratio: 2 / 3;  /* Vertical portrait */
}

.card--founder .card__image img {
  aspect-ratio: 2 / 3;
  border-radius: 12px;  /* Rounded rectangle */
  object-fit: cover;
  width: 100%;
}
```

**Impact:**
- Consistent 2:3 aspect ratio across all founder images
- Preserves portrait composition without excessive cropping
- Matches brand profile photo treatment

---

## 2. Placeholder Image System

### Issue
Missing brand logos and founder headshots for 4 case study profiles (Perfect Diary, SoleRebels, Sugar Cosmetics, Walk of Shame).

### Implementation
Created comprehensive fallback system using existing placeholder images.

**Files Modified:**
- `layouts/partials/card-brand.html`
- `layouts/partials/card-founder.html`
- `layouts/partials/responsive-image.html`

**Placeholder Images Added:**
```
assets/images/brands/perfect-diary/originals/logo-color.jpg
assets/images/brands/solerebels/originals/logo-color.jpg
assets/images/brands/sugar-cosmetics/originals/logo-color.jpg
assets/images/brands/walk-of-shame/originals/logo-color.jpg
assets/images/founders/huang-jinfeng/originals/photo-headshot.jpg
assets/images/founders/bethlehem-alemu/originals/photo-headshot.jpg
assets/images/founders/vineeta-singh/originals/photo-headshot.jpg
assets/images/founders/yana-puaca/originals/photo-headshot.jpg
```

**Smart Fallback Logic:**
```go
{{ $img := resources.Get $src }}
{{ if not $img }}
  {{ if strings.Contains $src "founders" }}
    {{ $img = resources.Get "images/placeholders/originals/founder-headshot.jpg" }}
  {{ else if strings.Contains $src "brands" }}
    {{ if strings.Contains $src "logo" }}
      {{ $img = resources.Get "images/placeholders/originals/brand-logo.jpg" }}
    {{ else }}
      {{ $img = resources.Get "images/placeholders/originals/brand-hero.jpg" }}
    {{ end }}
  {{ end }}
{{ end }}
```

**Impact:**
- All brand/founder profiles display correctly even with missing images
- Graceful degradation ensures professional appearance
- No broken image icons

---

## 3. Founder Profile Page Redesign

### Issue
Original layout: gradient background, circular photo, scattered information, expertise tags in multiple locations, full brand cards at bottom.

### New Design Requirements
- Split-panel hero (photo left, info right)
- Clean professional aesthetic (no gradient backgrounds)
- Quick facts bar below hero
- Sidebar with expertise tags, compact brand card, connect CTA
- 2:3 rounded rectangle photo (12px border radius)

### Implementation

**File:** `layouts/founders/single.html` (complete rewrite)

#### Hero Section (Split Panel)
```
┌─────────────────────────────────────────────────┐
│ [Photo]    │ Name                               │
│   2:3      │ Role                               │
│  aspect    │ Brand • Location 🇷🇺               │
│  ratio     │                                    │
│  12px      │ 🏆 KEY ACHIEVEMENT                 │
│  radius    │ Achievement text                   │
│            │                                    │
│            │ Bio snippet (one paragraph)        │
│            │                                    │
│            │ ┌────────────────────────────┐    │
│            │ │ EXPERIENCE    COUNTRY      │    │
│            │ │ 9+ Years      🇷🇺 Russia    │    │
│            │ └────────────────────────────┘    │
└─────────────────────────────────────────────────┘
```

**Key Features:**
- Custom ✦ separator (teal, full size) between brand name and location
- Key achievement callout with indigo accent
- Quick facts bar (gray background) in right column
- Responsive: stacks vertically on mobile, 1:2 ratio on desktop

#### Content + Sidebar Layout
```
┌──────────────────────┬─────────────────┐
│                      │ Professional    │
│                      │ Expertise       │
│ Biography Content    │ • digital...    │
│ (Full markdown)      │ • KOL...        │
│                      │                 │
│ ## Section Headings  │ Associated      │
│ Body text...         │ Brand           │
│                      │ [Logo]          │
│                      │ Brand Name      │
│                      │ View Profile →  │
│                      │                 │
│                      │ Connect CTA     │
│                      │ Premium text    │
│                      │ [Upgrade]       │
└──────────────────────┴─────────────────┘
```

**Sidebar Components:**

1. **Professional Expertise Box**
   - Gray pill tags (left-aligned, auto-width)
   - Stacked vertically with small gaps
   - Uses `.tag--expertise` class

2. **Associated Brand Card**
   - Compact format with logo (120px max)
   - Brand name (centered)
   - "View Brand Profile →" link
   - Gray background with subtle border

3. **Connect CTA Box**
   - Teal accent background
   - Personalized heading: "Connect with [Name]"
   - Premium membership description
   - "Upgrade to Premium" button → `/premium/`

**Code Highlights:**
```html
{{/* Quick Facts Bar */}}
<div class="quick-facts">
  {{ if .Params.yearsExperience }}
    <div class="fact">
      <span class="fact-label">Experience</span>
      <span class="fact-value">{{ .Params.yearsExperience }}+ Years</span>
    </div>
  {{ end }}
  <!-- Country, brands founded if >1 -->
</div>

{{/* Expertise Tags (sidebar) */}}
<div class="expertise-tags">
  {{ range .Params.expertise }}
    <span class="tag tag--expertise">{{ . }}</span>
  {{ end }}
</div>

{{/* Compact Brand Card */}}
<div class="brand-compact">
  <img src="{{ $resized.RelPermalink }}" class="brand-logo-small">
  <h4 class="brand-name">{{ $brandPage.Title }}</h4>
  <a href="{{ $brandPage.RelPermalink }}" class="brand-cta">View Brand Profile →</a>
</div>
```

**Responsive Behavior:**
- Mobile (<768px): Single column, photo centered, full-width content
- Tablet (768-992px): Same as mobile
- Desktop (≥992px): 1:2 split hero, 2:1 content+sidebar

**Removed:**
- Gradient background header
- Circular photo treatment
- Bottom "Brands" section (replaced by compact sidebar card)
- Scattered social links (moved to simpler inline layout)

---

## 4. Privacy Policy Implementation

### Requirements
- Migrate 3 privacy policy files from Jekyll temp folder
- Add multilingual support (EN/RU/ZH)
- Update footer with Privacy Policy link
- Remove "Built with Hugo" text

### Implementation

**Privacy Policy Files:**
```
content/privacy/index.en.md
content/privacy/index.ru.md
content/privacy/index.zh.md
```

**Front Matter Migration:**
```yaml
# Before (Jekyll)
---
layout: default
title: Privacy Policy
permalink: /en/privacy/
lang: en
ref: privacy
---

# After (Hugo)
---
title: "Privacy Policy"
translationKey: "privacy"
date: 2025-09-16
draft: false
description: "Brandmine Privacy Policy - How we collect, use, and protect your data"
---
```

**Content Updates:**
- Removed Jekyll liquid template syntax: `{% include helpers/t.html ... %}`
- Fixed email link: `Email: hello@brandmine.io`
- Preserved complete Malaysian PDPA compliance content
- Maintained TL;DR summary and detailed sections

**Footer Updates:**
```html
<!-- Before -->
<p class="built-with">{{ i18n "built_with_hugo" | default "Built with Hugo" }}</p>

<!-- After -->
<p class="privacy-link">
  <a href="{{ "/privacy" | relLangURL }}">{{ i18n "privacy_policy" | default "Privacy Policy" }}</a>
</p>
```

**Footer Styling:**
```css
.privacy-link a {
  color: rgba(255, 255, 255, 0.7);
  transition: color 0.2s ease, font-weight 0.1s ease;
  text-decoration: none;
}

.privacy-link a:hover {
  color: var(--secondary-200);  /* Orange */
  font-weight: var(--font-semibold);
}
```

**Impact:**
- Privacy policy accessible at `/privacy/`, `/ru/privacy/`, `/zh/privacy/`
- Footer decluttered (removed unnecessary "Built with Hugo")
- Legal compliance maintained with proper multilingual support

---

## 5. Footer Social Icon Fix

### Issue
Social media icons appeared as white boxes instead of transparent icons.

### Root Cause
Missing explicit `background: transparent` declaration allowed default styling to override.

### Fix
```css
.social-link {
  color: rgba(255, 255, 255, 0.7);
  background: transparent;  /* Explicit declaration */
  transition: all 0.2s ease;
  border-radius: var(--radius-sm);
}

.social-link:hover {
  color: white;
  background: var(--primary-500);  /* Lighter teal on hover */
  transform: translateY(-2px);
}
```

**Impact:**
- Icons display correctly with transparent background
- Hover state shows lighter teal background with lift effect
- Consistent with footer link hover patterns

---

## 6. Custom Separator Implementation

### Issue
Standard bullet (•) between brand name and location needed brand-specific styling.

### Solution
Implemented ✦ (four-pointed star) separator from Jekyll design system.

**Reference File:**
`temp/separators/bullet-separator.html`

**Implementation:**
```html
<span class="separator separator--bullet" aria-hidden="true">✦</span>
```

**Styling:**
```css
.separator {
  color: var(--neutral-400);
  display: inline-flex;
  align-items: center;
  margin: 0 var(--space-2);
}

.separator--bullet {
  color: var(--primary-600);  /* Teal */
  font-size: 1em;  /* Full size, not 0.75em */
}
```

**Impact:**
- Visually distinctive brand accent
- Consistent with Brandmine design system
- Accessible (aria-hidden ensures screen readers skip it)

---

## Technical Decisions

### 1. Quick Facts Bar Placement
**Decision:** Place inside hero-content (right column) instead of standalone section
**Rationale:**
- Keeps all founder metadata in one visual grouping
- Reduces vertical scrolling on mobile
- Matches brand profile pattern (facts bar below hero)

### 2. Expertise Tag Display
**Decision:** Use gray pills in sidebar instead of bulleted list
**Rationale:**
- Visual consistency with brand card tags
- Better scannability than plain text list
- Maintains professional appearance
- Auto-width prevents stretching across full column

### 3. Compact Brand Card vs. Full Cards
**Decision:** Single compact card in sidebar instead of full card grid at bottom
**Rationale:**
- Reduces redundancy (brand already linked in hero)
- Keeps focus on founder (not brands)
- Sidebar real estate better used for connect CTA
- User can visit brand profile for full details

### 4. Privacy Policy in Footer Bottom
**Decision:** Place in footer-bottom right (where "Built with Hugo" was)
**Rationale:**
- Standard web convention for legal links
- Doesn't clutter main footer columns
- Paired with copyright notice logically
- Reduces visual noise in main footer

---

## Files Modified

### Layouts
- `layouts/founders/single.html` (complete rewrite - 437 lines)
- `layouts/brands/single.html` (founder photo styling)
- `layouts/partials/card-brand.html` (placeholder fallback)
- `layouts/partials/card-founder.html` (placeholder fallback, 2:3 ratio)
- `layouts/partials/responsive-image.html` (smart fallback logic)
- `layouts/partials/footer.html` (privacy link, social icons)

### Styles
- `assets/css/components/cards.css` (founder card 2:3 aspect ratio)

### Content
- `content/privacy/index.en.md` (new)
- `content/privacy/index.ru.md` (new)
- `content/privacy/index.zh.md` (new)
- `content/brands/perfect-diary/index.en.md` (logo extension fix)
- `content/brands/solerebels/index.{en,ru,zh}.md` (logo extension fix)
- `content/brands/sugar-cosmetics/index.{en,ru,zh}.md` (logo extension fix)
- `content/brands/walk-of-shame/index.{en,ru,zh}.md` (logo extension fix)

### Assets
- 8 placeholder image files (4 brand logos + 4 founder headshots)

**Total:** 22 files modified, 8 files created

---

## Build & Performance

**Build Stats:**
- Pages: 108 (EN), 86 (RU), 86 (ZH)
- Processed images: 95
- Build time: 604ms
- No errors, 1 warning (deprecated `lang` in front matter)

**Server:** http://localhost:1313/

---

## Testing Checklist

- [x] Founder profile hero displays correctly (split panel)
- [x] Photo aspect ratio 2:3 with 12px border radius
- [x] Quick facts bar shows in right column
- [x] Expertise tags display as gray pills, left-aligned
- [x] Compact brand card shows logo and link
- [x] Connect CTA button links to `/premium/`
- [x] ✦ separator displays at full size in teal
- [x] Privacy policy accessible in all 3 languages
- [x] Footer privacy link displays and hovers correctly
- [x] Footer social icons display (not white boxes)
- [x] Placeholder images show when brand/founder images missing
- [x] Responsive layout works on mobile/tablet/desktop
- [x] No related brands section at bottom (removed)

---

## Future Enhancements

1. **Social Link Icons**
   - Add founder social links to hero or sidebar
   - LinkedIn, Twitter/X, personal website
   - Use same icon pattern as footer

2. **Achievement Timeline**
   - Expand key achievement to multiple achievements
   - Timeline or list format in sidebar
   - Year + milestone description

3. **Brand Relationship Details**
   - Show founder role at each brand (if multiple)
   - Founding year per brand
   - Current vs. past affiliations

4. **Premium Member Features**
   - Direct contact form (email/message)
   - Calendly integration for meetings
   - Video introduction embed

5. **Related Founders**
   - "Other founders in [sector]" section
   - Based on shared markets/sectors
   - Card carousel format

---

## Lessons Learned

### Hugo Template Syntax
**Issue:** Used `{{ with }}...{{ else if }}` which caused template error
**Solution:** Changed to `{{ if }}...{{ else if }}` pattern
**Learning:** Hugo doesn't support `else if` with `with` blocks

### Image Path Resolution
**Issue:** Placeholder images not found initially
**Root Cause:** Files had `.png` extension in front matter but were actually JPEG
**Solution:** Renamed files to `.jpg` and updated all front matter
**Learning:** Always verify actual file type vs. extension

### Sidebar Layout Balance
**Issue:** Initial sidebar too sparse with just expertise list
**Solution:** Added compact brand card + connect CTA for better balance
**Learning:** Sidebars need 2-3 distinct sections for visual weight

### Facts Bar Placement
**Issue:** Initially placed facts bar as standalone section between hero and content
**Solution:** Moved inside hero-content for better grouping
**Learning:** Keep related metadata together in one visual block

---

## Commit Message

```
feat: redesign founder profiles and add privacy policy

Complete redesign of founder profile pages with split-panel layout,
professional sidebar, and quick facts bar. Add privacy policy with
multilingual support (EN/RU/ZH). Fix founder card styling across site.

## Founder Profile Redesign

**Hero Section (Split Panel):**
- Left: Founder photo (2:3 aspect ratio, 12px border radius)
- Right: Name, role, brand link + location, key achievement, bio, facts bar
- Custom ✦ separator (teal) between brand name and location
- Quick facts bar (gray background) shows experience, country, brands

**Content + Sidebar Layout:**
- Left column (65%): Full biography content
- Right sidebar (35%):
  1. Professional Expertise - Gray pill tags (left-aligned, auto-width)
  2. Associated Brand - Compact card with logo, name, "View Profile →"
  3. Connect CTA - "Connect with [Name]", premium text, upgrade button

**Removed:**
- Gradient background header
- Circular photo treatment (now 2:3 rounded rectangle)
- Bottom "Brands" section (replaced by compact sidebar card)
- Expertise tags from hero (moved to sidebar only)

## Privacy Policy

**Files Added:**
- content/privacy/index.en.md
- content/privacy/index.ru.md
- content/privacy/index.zh.md

**Implementation:**
- Migrated from Jekyll temp folder (3 files)
- Updated front matter: Jekyll → Hugo (translationKey, date, description)
- Fixed Jekyll liquid syntax: removed {% include %} tags
- Preserved full Malaysian PDPA compliance content

**Footer Updates:**
- Remove "Built with Hugo" text
- Add Privacy Policy link in footer-bottom (right side)
- Orange hover effect matching footer link patterns

## Founder Card Styling

**Files Modified:**
- assets/css/components/cards.css
- layouts/brands/single.html
- layouts/partials/card-founder.html

**Changes:**
- Change aspect ratio from 4:5 to 2:3 (vertical portrait)
- Replace border-radius: 50% (circle) with 12px (rounded rectangle)
- Consistent treatment across brand profiles and cards

## Placeholder Image System

**Files Added:**
- 4 brand logos (Perfect Diary, SoleRebels, Sugar Cosmetics, Walk of Shame)
- 4 founder headshots (Huang Jinfeng, Bethlehem Alemu, Vineeta Singh, Yana Puaca)

**Implementation:**
- Smart fallback logic in responsive-image.html partial
- Detects founders vs. brands, logo vs. hero
- Graceful degradation when images missing
- Fix file extensions: .png → .jpg (files were JPEG despite extension)

## Footer Social Icons Fix

**Issue:** Icons appeared as white boxes instead of transparent
**Fix:** Add explicit `background: transparent` to base state
**Hover:** Lighter teal background (primary-500) with lift effect

## Custom Separator

**Implementation:**
- Use ✦ (four-pointed star) from Jekyll bullet-separator.html
- Teal color (primary-600), full size (1em not 0.75em)
- Placed between brand name and location in hero meta

## Files Modified

**Layouts:** 6 files (founders/single.html complete rewrite)
**Styles:** 1 file (cards.css)
**Content:** 13 files (3 privacy + 10 brand front matter)
**Assets:** 8 placeholder images

**Total:** 22 files modified, 11 files created

## Build Status
- 30+ successful rebuilds during implementation
- No errors, 1 warning (deprecated lang field)
- Server: localhost:1313

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

---

**Session Duration:** ~2.5 hours
**Commits:** Ready to commit (all changes staged)
**Status:** ✅ Complete and tested
