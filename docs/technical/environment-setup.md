# .env.local Setup for Hugo Projects

**Problem**: Hugo needs access to secrets (API keys, database URLs) without committing them to git.

**Solution**: Use `.env.local` file with explicit environment variable loading.

---

## File Structure

Create `.env.local` in project root:

```bash
# Supabase Configuration
SUPABASE_URL=https://[project-id].supabase.co
SUPABASE_ANON_KEY=eyJ...

# Other secrets
ANALYTICS_ID=G-XXXXXXXXXX
```

---

## Critical Difference: Hugo vs JavaScript Frameworks

**JavaScript frameworks** (Next.js, Vite, Nuxt):
- ✅ Auto-load `.env.local` files
- ✅ Just run `npm run dev` and it works

**Hugo**:
- ❌ Does NOT auto-load `.env.local`
- ⚠️ Requires explicit shell environment variable loading

---

## Hugo Usage Pattern

### Local Development

**Load environment variables before Hugo:**

```bash
# Load .env.local, then run Hugo
set -a && source .env.local && set +a && hugo server
```

**What this does:**
- `set -a` - Auto-export all variables
- `source .env.local` - Load variables from file
- `set +a` - Disable auto-export
- `hugo server` - Start Hugo with variables available

### Production Build

```bash
# Load environment variables before build
set -a && source .env.local && set +a && hugo --gc --minify
```

---

## Template Usage

Access environment variables in Hugo templates:

```go-html-template
{{ $supabaseUrl := getenv "SUPABASE_URL" }}
{{ $supabaseKey := getenv "SUPABASE_ANON_KEY" }}

<script>
  const supabase = createClient("{{ $supabaseUrl }}", "{{ $supabaseKey }}");
</script>
```

**Result**: Secrets injected at build time, not hardcoded in templates.

---

## Cloudflare Pages Deployment

**Local**: Load from `.env.local` file
**Production**: Set environment variables in Cloudflare Pages dashboard

**Steps:**
1. Go to Cloudflare Pages → Settings → Environment Variables
2. Add each variable:
   - `SUPABASE_URL` = `https://[project].supabase.co`
   - `SUPABASE_ANON_KEY` = `eyJ...`
3. Deploy - Cloudflare auto-injects variables during build

**No .env.local upload needed** - Variables exist in platform, not in repo.

---

## Gitignore Configuration

**Add to `.gitignore`:**

```gitignore
# Environment variables
.env
.env.local
.env.*.local
```

**Why**: Prevents committing secrets to version control.

---

## Package.json Scripts (Optional)

Simplify commands with npm scripts:

```json
{
  "scripts": {
    "dev": "set -a && source .env.local && set +a && hugo server",
    "build": "set -a && source .env.local && set +a && hugo --gc --minify"
  }
}
```

**Usage:**
```bash
npm run dev    # Starts Hugo with environment variables
npm run build  # Builds with environment variables
```

---

## Security Best Practices

**DO commit to git:**
- ✅ `.env.example` - Template showing required variables (no real values)

**DO NOT commit to git:**
- ❌ `.env.local` - Contains real secrets
- ❌ `.env` - Contains real secrets

**Example `.env.example`:**

```bash
# Copy to .env.local and fill in real values

# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here

# Analytics
ANALYTICS_ID=G-XXXXXXXXXX
```

---

## Common Mistakes

### ❌ Mistake 1: Forgetting to load .env.local

```bash
# This won't work - Hugo can't access variables
hugo server
```

**Fix:**
```bash
# Load variables first
set -a && source .env.local && set +a && hugo server
```

### ❌ Mistake 2: Using relative paths in .env.local

```bash
# Don't do this
SUPABASE_URL=../config/supabase-url.txt
```

**Fix:**
```bash
# Use actual values
SUPABASE_URL=https://project.supabase.co
```

### ❌ Mistake 3: Committing .env.local to git

**Prevention**: Always check `.gitignore` includes `.env.local`

---

## Verification

**Test that variables are loaded:**

```bash
# Load environment
set -a && source .env.local && set +a

# Check variable exists
echo $SUPABASE_URL

# Should print: https://your-project.supabase.co
```

**Test Hugo can access variables:**

Create test template:
```go-html-template
<!-- layouts/partials/env-test.html -->
SUPABASE_URL: {{ getenv "SUPABASE_URL" }}
```

**Expected output**: URL appears in HTML
**Bad output**: Empty string (variables not loaded)

---

## Summary

**Key Takeaway**: Hugo requires **explicit environment variable loading** before running. Unlike JavaScript frameworks, `.env.local` is not automatically processed.

**Production Pattern**:
- **Local**: `set -a && source .env.local && set +a && hugo server`
- **Cloudflare Pages**: Environment variables in platform dashboard

**Security**: Never commit `.env.local` to git. Use `.env.example` for documentation.

---

**When to use this pattern:**
- ✅ Hugo projects needing API keys or secrets
- ✅ Database connection strings (Supabase, Firebase, etc.)
- ✅ Analytics IDs that should differ between dev/production
- ✅ Any configuration that varies by environment

**When NOT needed:**
- ❌ Public configuration (can go in `hugo.yaml`)
- ❌ Static site with no external services
- ❌ Projects already using Hugo modules with built-in config
