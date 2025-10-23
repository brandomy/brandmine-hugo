# Technical Documentation

Hugo implementation patterns, taxonomy system, and environment configuration for Brandmine.

## Quick Reference

### Essential Commands

```bash
# Development
hugo server                      # Start dev server (localhost:1313)
hugo server --logLevel info      # With detailed logging

# Production
set -a && source .env.local && set +a && hugo --gc --minify

# Content Creation
hugo new content/brands/brand-name.en.md
hugo new content/founders/founder-name.en.md
hugo new content/insights/article-name.en.md
```

### Critical Constraints

1. **Taxonomy**: Only 4 dimensions (markets, sectors, attributes, signals)
2. **Images**: ALL content images go in `assets/images/` (NOT `static/`)
3. **Translations**: Hugo i18n files MUST be in `i18n/` directory
4. **Mobile-first**: Primary viewport 320px-414px
5. **Fonts**: PT Sans/Serif (EN/RU), Noto Sans SC (ZH), all self-hosted

## Documents

### [hugo-essentials.md](hugo-essentials.md)
Complete Hugo implementation guide covering:
- Directory structure and conventions
- Image placement standards (assets/ vs static/)
- Typography system and font loading
- Card philosophy and patterns
- Multilingual search architecture
- Layout principles and responsive design
- Hugo-specific template patterns
- Performance standards

**Use this for**: Understanding Hugo patterns, implementing new features, troubleshooting builds.

### [taxonomy-guide.md](taxonomy-guide.md)
Taxonomy system standards covering:
- The 4 dimensions (markets, sectors, attributes, signals)
- Authorized terms from registry files
- Usage in front matter
- Validation rules
- Adding new terms

**Use this for**: Creating content, validating taxonomy usage, adding new terms.

### [environment-setup.md](environment-setup.md)
Hugo environment configuration covering:
- .env.local setup for Supabase integration
- Environment variable loading patterns
- Hugo vs JavaScript framework differences
- Deployment configuration

**Use this for**: Local development setup, Supabase integration, deployment configuration.

## Common Tasks

### Adding a New Brand Profile
1. Create EN/RU/ZH markdown files in `content/brands/`
2. Add brand images to `assets/images/brands/{slug}/originals/`
3. Use only authorized taxonomy terms (see [taxonomy-guide.md](taxonomy-guide.md))
4. Verify all language versions use identical taxonomy values

### Updating Taxonomy
1. Edit `data/taxonomies/{taxonomy}.json`
2. Add EN/RU/ZH translations
3. Provide icon and hero_image paths
4. Update [taxonomy-guide.md](taxonomy-guide.md)

### Troubleshooting Builds
- **Images not displaying**: Check they're in `assets/images/` not `static/images/`
- **Translations missing**: Check files exist in `i18n/` directory
- **Taxonomy errors**: Verify terms exist in `data/taxonomies/*.json`
- **Environment variables empty**: Run `set -a && source .env.local && set +a` before Hugo

## Hugo Version

**Current**: 0.139.3

See [hugo-essentials.md](hugo-essentials.md) for complete technical standards.

---

**Last Updated**: 2025-10-23
