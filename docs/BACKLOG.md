# Brandmine Development Backlog

**Purpose**: Track ideas, features, and improvements for future implementation.

**Usage**: CEO can say "Code, backlog this: [idea/task]" and CTO adds it here with unique ID.

---

## High Priority

### #001: Implement Separator Shortcode
**Type**: Enhancement  
**Description**: Create Hugo shortcode for decorative content separators (diamond, etc.)  
**Reference**: temp/separators folder has existing patterns  
**Scope**:
- Create `layouts/shortcodes/separator.html`
- Support multiple separator types (diamond, line, etc.)
- Add CSS styling with teal brand color
- Document usage in content authoring guide

**Acceptance Criteria**:
- Authors can use `{{< separator "diamond" >}}` in content
- Renders accessible markup (role="presentation")
- Works across all 3 languages
- Matches brand visual style

**Status**: Backlogged  
**Added**: 2025-10-03

### #002: Implement Pagefind Search
**Type**: Feature
**Description**: Integrate Pagefind static search for Hugo site
**Reference**: CLEAN-BUILD-PLAN.md Phase 2, Day 10
**Scope**:
- Install Pagefind npm package
- Add to build process (hugo → pagefind)
- Create search page (`content/search/_index.md`)
- Create search layout (`layouts/search/list.html`)
- Add search input to navigation
- Test multilingual search (en, ru, zh)

**Acceptance Criteria**:
- Search indexes all content (brands, founders, insights, dimensions)
- Search works in all 3 languages
- Results show relevant excerpts
- No backend required
- < 2s search response time

**Status**: Backlogged (Week 2 of clean build)
**Added**: 2025-10-03

### #003: Supabase Integration Script
**Type**: Feature
**Description**: Create sync script to fetch content from Supabase and generate Hugo markdown files
**Reference**: CLEAN-BUILD-PLAN.md Phase 4, Day 18
**Scope**:
- Design Supabase schema (brands, founders, insights tables)
- Create `scripts/sync-from-supabase.js`
- Fetch data from Supabase API
- Generate Hugo markdown files (multilingual .en.md, .ru.md, .zh.md)
- Update front matter from database fields
- Add to build process (`npm run sync && hugo`)

**Acceptance Criteria**:
- Script fetches all content from Supabase
- Generates valid Hugo markdown files
- Preserves all front matter fields
- Handles multilingual content correctly
- Can run in CI/CD pipeline

**Status**: Backlogged (Week 4 of clean build)
**Added**: 2025-10-03

### #004: Clean Hugo Card Components
**Type**: Enhancement
**Description**: Build minimal, Hugo-native card components (brand, founder, insight)
**Reference**: CLEAN-BUILD-PLAN.md Phase 2
**Scope**:
- Create `layouts/partials/brand-card.html`
  - Image, name, tagline, taxonomy pills, card metric, link
- Create `layouts/partials/founder-card.html`
  - Photo, name, role, associated brands, link
- Create `layouts/partials/insight-card.html`
  - Hero image, title, excerpt, category, date, reading time, link
- Mobile-first responsive design
- Accessible markup (ARIA labels, semantic HTML)
- Clean CSS (BEM naming, minimal complexity)

**Acceptance Criteria**:
- Cards render on list pages
- Images load with lazy loading
- Touch-friendly (44px minimum targets)
- Work across all screen sizes (320px+)
- No JavaScript required
- Lighthouse accessibility score > 95

**Status**: Backlogged (Week 2 of clean build)
**Added**: 2025-10-03

---

## Future Enhancements

*No items yet*

---

## Ideas to Explore

*No items yet*

---

## Completed

*Track completed backlog items here for reference*

---

## Backlog Management

**Adding items:**
```
CEO: "Code, backlog this: [description]"
CTO: Creates new entry with unique ID, description, acceptance criteria
```

**Prioritizing:**
- High Priority: Needed for customer discovery / market validation
- Future Enhancements: Value-add but not blocking
- Ideas to Explore: Interesting concepts, needs more definition

**Completing items:**
- Move to "Completed" section with completion date
- Reference commit hash that implemented it
- Keep for historical reference

**Format:**
```markdown
### #XXX: Short Title
**Type**: Feature | Enhancement | Bug | Idea  
**Description**: What needs to be done
**Scope**: Detailed breakdown
**Acceptance Criteria**: How we know it's done
**Status**: Backlogged | In Progress | Completed
**Added**: YYYY-MM-DD
**Completed**: YYYY-MM-DD (if done)
```