# Brandmine Press Kit Service

Professional press kit service for Russian SME brands expanding globally.

## Tech Stack
- **Framework**: Hugo 0.136.0
- **Languages**: EN/RU/ZH/AR with RTL support
- **Deployment**: Cloudflare Pages
- **Database**: Supabase (future)
- **CDN**: Cloudflare (China-friendly)

## Development

```bash
# Install Hugo (Mac)
brew install hugo

# Run development server
hugo server -D

# Build for production
hugo --minify
```

## Structure
```
content/
├── press-kits/     # Client newsrooms
├── pages/          # Static pages
└── _index.md       # Homepage

data/
├── pricing/        # Service tiers
├── clients/        # Client testimonials
└── team/           # Team members

layouts/
├── _default/       # Base templates
├── press-kits/     # Newsroom templates
└── partials/       # Reusable components
```

## Deployment

Automatically deploys to GitHub Pages on push to main branch.
Production deployment via Cloudflare Pages (configured separately).

