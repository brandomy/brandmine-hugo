# 2025-10-05: Founder Profile Social Media & Quick Facts Enhancement

## Overview

Enhanced founder profile pages with improved quick facts display, social media integration, and Global South platform icons. Fixed multiple UX issues and implemented icon-only social media links.

## Quick Facts Improvements

### Generation & Experience Display Logic
**Problem**: Quick facts showed EITHER generation OR experience, not both.

**Solution**: Changed from exclusive (`else if`) to inclusive (`if`) logic in `layouts/founders/single.html:69-91`

```html
{{ if .Params.generation }}
  <div class="fact">
    <span class="fact-label">Generation</span>
    <span class="fact-value">1st</span>
  </div>
{{ end }}

{{ if .Params.yearsExperience }}
  <div class="fact">
    <span class="fact-label">Experience</span>
    <span class="fact-value">9+ Years</span>
  </div>
{{ end }}
```

**Result**: Profile now shows both "1st" generation AND "9+ Years" experience when both values exist.

### Language Formatting Fix
**Problem**: Language list displayed with incorrect spacing: "Russian , English"

**Solution**: Added Hugo whitespace trimming syntax `{{- -}}` in `layouts/founders/single.html:97-106`

```html
{{- range $index, $langCode := . -}}
  {{- if $index}}, {{ end -}}
  {{- $langData := index $.Site.Data.languages.language_codes $langCode -}}
  {{- if $langData -}}
    {{- index $langData $currentLang -}}
  {{- end -}}
{{- end -}}
```

**Result**: Proper formatting with space after comma only: "Russian, English"

### Separator Bullet Consistency
**Problem**: Teal bullet separator (✦) between brand name and location had inconsistent font size.

**Solution**: Changed CSS from `font-size: 1em` to `font-size: inherit` in `layouts/founders/single.html:264-267`

```css
.separator--bullet {
  color: var(--primary-600);
  font-size: inherit;
}
```

**Result**: Bullet now matches size of adjacent text (brand name and city).

## Profile Page vs Card View Styling

### Two Different Contexts

**Card View (Founder List Page)**: Bold, attention-grabbing badges
- Large teal value on top (2xl, primary-600, bold)
- Small gray label below (xs, neutral-500, uppercase)
- Example: "1st" / "GEN"

**Profile Page (Individual Founder)**: Subdued, readable presentation
- Small gray label on top (sm, neutral-600, uppercase)
- Normal dark value below (base, neutral-900, semibold)
- Example: "Generation" / "1st"

### Generation Badge Label
Changed from "GENERATION" to "GEN" on cards for space efficiency and clarity:
- `layouts/partials/card-founder.html:52`: `<span class="metric__label">GEN</span>`

## Social Media Integration

### Icon-Only Social Links
Added social media section to founder profile sidebar between "Associated Brand" and "Connect" sections.

**Template**: `layouts/founders/single.html:169-211`

```html
{{ if or .Params.social_linkedin .Params.social_twitter .Params.social_instagram .Params.social_vk .Params.social_facebook }}
  <div class="sidebar-box">
    <h3>Follow</h3>
    <div class="social-icons">
      {{ if .Params.social_linkedin }}
        <a href="https://linkedin.com/in/{{ .Params.social_linkedin }}" class="social-icon" target="_blank" rel="noopener noreferrer" aria-label="LinkedIn">
          <svg>...</svg>
        </a>
      {{ end }}
      <!-- VK, Instagram, Twitter, Facebook -->
    </div>
  </div>
{{ end }}
```

**CSS Styling**: `layouts/founders/single.html:473-501`

```css
.social-icons {
  display: flex;
  gap: var(--space-3);
  flex-wrap: wrap;
}

.social-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 44px;
  color: var(--neutral-600);
  background: var(--neutral-50);
  border-radius: var(--radius-md);
  transition: all var(--transition-fast);
}

.social-icon:hover {
  background: var(--primary-600);
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}
```

**Features**:
- Icons only (no text labels) for cleaner look
- 44x44px square buttons (WCAG AA touch target compliant)
- Horizontal layout with wrapping
- Light gray background, teal hover with lift effect
- Only displays platforms founder actually has accounts on
- Conditional rendering prevents empty box

### Conditional Logic Fix
**Problem**: Initially used `{{ with }}` which treats empty strings as truthy.

**Solution**: Changed to `{{ if }}` for all social media conditionals to properly check for non-empty values.

```html
{{ if .Params.social_linkedin }}  <!-- Not {{ with }} -->
  <a href="...">LinkedIn</a>
{{ end }}
```

## Global South Social Media Icons

Downloaded 11 official platform icons from Simple Icons (https://simpleicons.org/) with proper brand colors.

**Location**: `/static/icons/social/`

### BRICS Countries
- **vk.svg** (1.2KB) - VK (Russia) - #0077FF
- **wechat.svg** (1.3KB) - WeChat (China) - #07C160
- **weibo.svg** (1.5KB) - Sina Weibo (China) - #E6162D
- **telegram.svg** (757B) - Telegram (Russia/Global) - #26A5E4
- **odnoklassniki.svg** (682B) - OK (Russia) - #EE8208

### ASEAN
- **line.svg** (1.2KB) - LINE (Thailand/Japan) - #00C300
- **zalo.svg** (1.1KB) - Zalo (Vietnam) - #0068FF
- **kakaotalk.svg** (1.7KB) - KakaoTalk (South Korea) - #FFCD00

### Global South General
- **whatsapp.svg** (1.2KB) - WhatsApp - #25D366
- **viber.svg** (2.3KB) - Viber - #7360F2
- **xiaohongshu.svg** (3.5KB) - Xiaohongshu/RED (China) - #FF2442

### VK Icon Fix
Initial download had wrong icon design. Fixed by re-downloading official VK icon from Simple Icons source.

```bash
rm /static/icons/social/vk.svg
curl -sL https://simpleicons.org/icons/vk.svg -o /static/icons/social/vk.svg
```

Result: Official VK logo with proper viewBox and path data.

## Files Modified

### Templates
- `layouts/founders/single.html` - Quick facts logic, language formatting, separator styling, social media section
- `layouts/partials/card-founder.html` - Generation badge label change to "GEN"

### Content
- `content/founders/maria-kuznetsova/index.en.md` - Updated social media handles for testing

### Static Assets
- `/static/icons/social/` - 11 new social media platform icons

## Technical Details

### Hugo Whitespace Trimming
Hugo's `{{- -}}` syntax strips whitespace before (`{{-`) and after (`-}}`) template tags. Critical for preventing unwanted spaces in inline content like comma-separated lists.

### Conditional Rendering Best Practices
- Use `{{ if .Params.field }}` for checking non-empty values
- Use `{{ with .Params.field }}` when you also need the value in scope
- Empty strings (`""`) are truthy in `{{ with }}` but falsy in `{{ if }}`

### Touch Target Accessibility
44x44px minimum ensures WCAG 2.1 AA compliance for touch targets. Applied to social media icon buttons.

### CSS Flexbox Gap Property
Modern approach for spacing flex items. Used `gap: var(--space-3)` instead of margins for cleaner, more maintainable code.

## Testing

Verified on Maria Kuznetsova profile (`/en/founders/maria-kuznetsova/`):
- ✅ Generation "1st" AND Experience "9+ Years" both display
- ✅ Languages show proper comma spacing: "Russian, English"
- ✅ Teal bullet separator matches text size
- ✅ Social media icons display for LinkedIn, Instagram, VK
- ✅ Icons hover to teal background with white icon
- ✅ No empty social box when founder has no accounts

## Build Metrics

```
Pages           │ 108 │ 86 │ 86
Static files    │  65 │ 65 │ 65
Processed images│  95 │  3 │  0
Built in 227 ms
```

Static files increased from 54 to 65 (+11 social media icons).

## Next Steps

1. Add social media fields to other founder profiles
2. Consider adding social media to brand profiles
3. Test social icons with all 11 platforms (currently only using 5)
4. Add WeChat, Weibo, Telegram for Chinese/Russian founders
5. Add LINE, Zalo, KakaoTalk for ASEAN founders

## Commits

- `fix: enhance founder profile quick facts display and formatting` (e847bb1)
  - Generation/experience inclusive display logic
  - Language comma spacing fix
  - Separator bullet font-size inheritance

- *(Pending)* Social media icon integration
- *(Pending)* Global South platform icons download

---

**Session Duration**: ~2 hours
**Files Changed**: 2 templates, 1 content file, 11 new static assets
**Lines Modified**: ~150 lines (template + CSS)
