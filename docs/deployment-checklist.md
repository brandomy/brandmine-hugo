# Brandmine Production Deployment Checklist

**Purpose**: Ensure clean, reliable deployment to Cloudflare Pages with Supabase integration.

**Status**: Ready for deployment after completion of Phase 4 (Week 4, Day 18-20)

---

## Pre-Deployment Verification

### 1. Database Setup ✅
- [x] Supabase project created (`brandmine-prod`)
- [x] SQL migrations run (11 tables, indexes, triggers, RLS)
- [x] Storage buckets created (4 buckets: brand-images, founder-images, insight-images, dimension-icons)
- [x] Dimensions seeded (43 dimensions, 258 translations)
- [x] Test brands synced (6 brands, 54 translations, 12 images)
- [x] Credentials stored in `.env.local` (gitignored)

### 2. Hugo Site Build ✅
- [x] Hugo configuration valid (`hugo.yaml`)
- [x] Content structure correct (`content/brands/`, `content/founders/`, `content/insights/`)
- [x] Taxonomies configured (markets, sectors, attributes, signals)
- [x] Multilingual support enabled (en, ru, zh)
- [x] Fonts self-hosted (`static/fonts/`)
- [x] Typography system configured (PT Sans/Serif, Noto Sans SC)

### 3. Pagefind Search ✅
- [x] Pagefind installed (`npm install pagefind`)
- [x] Build process includes search indexing (`hugo --gc --minify && npx pagefind --site public`)
- [x] Search page created (`content/search/_index.md`)
- [x] Search layout implemented (`layouts/search/list.html`)
- [x] Multilingual search tested (en, ru, zh)

### 4. Supabase Sync ✅
- [x] Sync script created (`scripts/sync-to-supabase.js`)
- [x] Image path corrected (`assets/images/brands/{brand}/originals/`)
- [x] NPM script added (`npm run sync`)
- [x] Test sync successful (6 brands, 12 images)
- [x] Upsert logic working (idempotent syncs)

---

## Environment Variables

### Required in Cloudflare Pages

**Build Settings**:
```bash
# Build command
npm run build

# Build output directory
public

# Node version
18
```

**Environment Variables** (Cloudflare Pages Dashboard):
```
SUPABASE_URL=https://wcfhbzbmxztdzwjaujoq.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
HUGO_VERSION=0.139.3
NODE_VERSION=18
```

**⚠️ Important**:
- Only `SUPABASE_ANON_KEY` should be exposed to frontend
- `SUPABASE_SERVICE_ROLE_KEY` is for build-time sync only (never exposed to client)
- All keys stored in Cloudflare Pages encrypted environment variables

---

## Deployment Steps

### Step 1: Prepare Repository
```bash
# Ensure all changes committed
git status

# Verify .env.local is gitignored
git check-ignore .env.local  # Should output: .env.local

# Verify build works locally
npm run build
```

### Step 2: Cloudflare Pages Setup
1. Go to [Cloudflare Dashboard](https://dash.cloudflare.com/)
2. Navigate to **Workers & Pages** → **Create Application** → **Pages**
3. Connect GitHub repository: `brandmine-hugo`
4. Configure build settings:
   - **Framework preset**: None (Hugo)
   - **Build command**: `npm run build`
   - **Build output directory**: `public`
   - **Root directory**: `/` (project root)

### Step 3: Add Environment Variables
In Cloudflare Pages project settings → **Environment variables**:

**Production**:
- `SUPABASE_URL`: `https://wcfhbzbmxztdzwjaujoq.supabase.co`
- `SUPABASE_ANON_KEY`: `[from .env.local]`
- `SUPABASE_SERVICE_ROLE_KEY`: `[from .env.local]`
- `HUGO_VERSION`: `0.139.3`
- `NODE_VERSION`: `18`

**Preview** (optional, same values for now):
- Same as production

### Step 4: Trigger First Deploy
```bash
# Push to main branch triggers auto-deploy
git push origin main

# Or manually trigger in Cloudflare Pages dashboard
```

### Step 5: Verify Deployment
After deployment completes, verify:

1. **Site loads**: Visit `https://brandmine.pages.dev` (or custom domain)
2. **Brands render**: Check `/brands/` page
3. **Search works**: Try searching for brand names
4. **Images load**: Verify Supabase CDN images display
5. **Multilingual**: Switch languages (en, ru, zh)

---

## Post-Deployment Verification

### Manual Checks
- [ ] Homepage loads without errors
- [ ] Brand list page shows all 6 brands
- [ ] Individual brand pages render correctly
- [ ] Images load from Supabase Storage
- [ ] Search functionality works (try "honey", "hotel", "tea")
- [ ] Language switcher works (en → ru → zh)
- [ ] Taxonomy pills display correctly (markets, sectors, attributes, signals)
- [ ] Mobile responsive design works (320px - 414px)
- [ ] No console errors in browser dev tools

### Performance Checks
- [ ] Lighthouse score > 90 (Performance)
- [ ] Lighthouse score > 95 (Accessibility)
- [ ] Lighthouse score > 90 (Best Practices)
- [ ] Lighthouse score > 100 (SEO)
- [ ] First Contentful Paint < 1.5s
- [ ] Largest Contentful Paint < 2.5s

### Database Checks
```bash
# Run verification script
npm run verify  # (if created)

# Or manually check via Supabase dashboard:
# - brands table: 6 records
# - translations table: 54 records (brand translations)
# - dimensions table: 43 records
# - Storage: 12 files in brand-images bucket
```

---

## CI/CD Automation (Future)

### GitHub Actions Workflow
Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Cloudflare Pages

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm install

      - name: Sync to Supabase
        env:
          SUPABASE_URL: ${{ secrets.SUPABASE_URL }}
          SUPABASE_SERVICE_ROLE_KEY: ${{ secrets.SUPABASE_SERVICE_ROLE_KEY }}
        run: npm run sync

      - name: Build site
        run: npm run build

      - name: Deploy to Cloudflare Pages
        uses: cloudflare/pages-action@v1
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          projectName: brandmine
          directory: public
```

### Required GitHub Secrets
- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`
- `CLOUDFLARE_API_TOKEN`
- `CLOUDFLARE_ACCOUNT_ID`

---

## Rollback Plan

### If Deployment Fails

**Option 1: Rollback in Cloudflare Pages**
1. Go to Cloudflare Pages dashboard
2. Navigate to **Deployments** tab
3. Find last working deployment
4. Click **⋯** → **Rollback to this deployment**

**Option 2: Revert Git Commit**
```bash
# Revert last commit
git revert HEAD
git push origin main

# Or reset to specific commit
git reset --hard <commit-hash>
git push --force origin main  # Use with caution
```

**Option 3: Manual Fix**
```bash
# Fix issue locally
git commit -m "fix: resolve deployment issue"
git push origin main
# Cloudflare auto-deploys
```

---

## Custom Domain Setup (Optional)

### Add Custom Domain
1. Cloudflare Pages → **Custom domains**
2. Add domain: `brandmine.com`
3. Configure DNS:
   - Add CNAME: `brandmine.com` → `brandmine.pages.dev`
   - Or use Cloudflare proxied records

### SSL Certificate
- Automatic via Cloudflare (Let's Encrypt)
- Force HTTPS in Cloudflare Pages settings

---

## Monitoring & Maintenance

### Regular Checks
- **Weekly**: Review Cloudflare Pages analytics
- **Weekly**: Check Supabase database size (500 MB limit on free tier)
- **Monthly**: Review Supabase Storage usage (1 GB limit on free tier)
- **Monthly**: Run Lighthouse performance audit

### Logs & Debugging
- **Build logs**: Cloudflare Pages → Deployments → [deployment] → View details
- **Function logs**: N/A (static site, no functions)
- **Supabase logs**: Supabase dashboard → Logs

### Scaling Considerations
- **Content growth**: Monitor database size, upgrade Supabase plan if needed
- **Image storage**: Optimize images, consider CDN caching
- **Traffic**: Cloudflare Pages handles high traffic automatically

---

## Known Issues & Limitations

### Current Limitations
1. **No CI/CD yet**: Manual sync required before deployment
2. **Founder images**: Only brand images uploaded so far
3. **Insight images**: Not yet implemented
4. **Image optimization**: No WebP conversion or responsive images yet

### Future Enhancements
- Automated CI/CD pipeline (GitHub Actions)
- Image optimization (WebP, srcset, lazy loading)
- Founder and Insight content sync
- API endpoints for dynamic content (if needed)

---

## Support & Troubleshooting

### Common Issues

**Issue**: Build fails with "Hugo not found"
**Solution**: Add `HUGO_VERSION=0.139.3` environment variable

**Issue**: Search doesn't work
**Solution**: Ensure `npx pagefind --site public` runs in build command

**Issue**: Images don't load
**Solution**:
- Check Supabase Storage bucket is public
- Verify image URLs in brand records
- Check CORS settings in Supabase

**Issue**: Translations missing
**Solution**:
- Verify `data/translations/*.yml` files exist
- Check front matter has `translationKey`
- Ensure multilingual content files exist (.en.md, .ru.md, .zh.md)

### Contact
- **CTO (Claude)**: Technical implementation questions
- **CEO**: Content strategy and business decisions
- **Supabase Support**: Database and storage issues
- **Cloudflare Support**: Deployment and CDN issues

---

**Last Updated**: 2025-10-03
**Deployment Status**: Ready for production
**Next Steps**: CEO approval → Deploy to Cloudflare Pages
