# People System Usage Guide

The people system provides a centralized way to manage and display information about team members, authors, clients, and testimonial providers.

## Structure

### Data Source
All people information is stored in `data/people.yaml`:

```yaml
people:
  person-slug:
    name: "Full Name"
    roles: ["team", "author", "client", "testimonial"]
    photo: "headshot-professional.jpg"
    portrait: "portrait.jpg"  # Optional alternate image
    title: "Job Title"
    company: "Company Name"  # For clients
    bio: "Short biography..."
    testimonial: "Quote..."  # For testimonials
    email: "email@example.com"
    linkedin: "https://linkedin.com/in/username"
    featured: true  # Optional flag
```

### Images
Original images are stored in `assets/images/people/`:

```
assets/images/people/
├── randal-eastman/
│   └── originals/
│       └── headshot-professional.jpg
├── olya-eastman/
│   └── originals/
│       └── headshot-professional.jpg
└── georgie-yam/
    └── originals/
        ├── headshot.jpg
        └── portrait.jpg
```

Hugo automatically generates responsive versions (400w, 800w, 1200w) when needed.

## Usage Examples

### 1. Author Byline

Add to article templates to show author information:

```go
{{ partial "author-byline.html" (dict "author" .Params.author "context" .) }}
```

In content frontmatter:
```yaml
---
title: "Article Title"
author: "randal-eastman"
---
```

### 2. Team Member Card

Display team members on an About page:

```go
<div class="team-grid">
  {{ range $slug, $person := .Site.Data.people.people }}
    {{ if in $person.roles "team" }}
      {{ partial "team-card.html" (dict "slug" $slug "context" $) }}
    {{ end }}
  {{ end }}
</div>
```

### 3. Testimonial

Show client testimonials:

```go
{{ partial "testimonial.html" (dict "slug" "georgie-yam" "context" .) }}
```

Or with custom quote:
```go
{{ partial "testimonial.html" (dict
  "slug" "georgie-yam"
  "quote" "Custom testimonial text..."
  "context" .
) }}
```

### 4. Featured Testimonials

Show only featured testimonials:

```go
{{ range $slug, $person := .Site.Data.people.people }}
  {{ if and (in $person.roles "testimonial") $person.featured }}
    {{ partial "testimonial.html" (dict "slug" $slug "context" $) }}
  {{ end }}
{{ end }}
```

## Adding New People

1. Add person to `data/people.yaml`
2. Create directory: `assets/images/people/new-person-slug/originals/`
3. Add images to originals directory
4. Reference by slug in templates or content

## Benefits

✅ **Single Source of Truth**: One person, one entry
✅ **Flexible Roles**: Same person can be team/author/client
✅ **Automatic Image Processing**: Hugo generates responsive versions
✅ **Type-Safe**: Data structure ensures consistency
✅ **Easy Updates**: Change once, updates everywhere

## Component Styles

All components include scoped styles that use your design tokens:
- `--space-*` for spacing
- `--text-*` for typography
- `--neutral-*`, `--primary-*` for colors
- `--radius-*` for border radius
- `--shadow-*` for shadows
