# Brandmine Hugo

Hugo-based website for discovering exceptional founder-led brands from BRICS+ markets.

## Tech Stack
- **Framework**: Hugo 0.150.0
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
├── brands/         # Brand profiles
├── founders/       # Founder stories
├── insights/       # Articles & analysis
└── case-studies/   # Success stories

data/
├── dimensions.yaml # Market dimensions
├── insights.yaml   # Insight metadata
└── people.yaml     # Team & founders

layouts/
├── _default/       # Base templates
├── brands/         # Brand templates
├── insights/       # Article templates
└── partials/       # Reusable components
```

## Deployment

Production deployment via Cloudflare Pages.
Configured in `cloudflare.json`.

