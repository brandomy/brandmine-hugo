# Portrait Styling Workflows for Brandmine

**Purpose:** Apply consistent teal + fabric texture treatment to founder/team portraits, inspired by WSJ/NYT editorial style.

**Legal benefit:** Stylized portraits avoid copyright claims and personality rights issues while establishing distinctive brand identity.

---

## File Organization

```
assets/images/people/
├── team/
│   ├── randal-eastman/
│   │   └── originals/
│   │       └── photo-headshot.jpg
│   └── olya-eastman/
│       └── originals/
│           └── photo-headshot.jpg
├── founders/
│   └── [founder-name]/
│       └── originals/
│           └── photo-profile.jpg
└── textures/
    └── fabric_weave_light.jpg

temp/_scripts/image-processing/
└── apply_teal_fabric_style.sh
```

## Naming Conventions

**Original photos:** `photo-[descriptor].jpg`
- Examples: `photo-headshot.jpg`, `photo-casual.jpg`, `photo-profile.jpg`
- Always lowercase, hyphen-separated

**Styled outputs:** Same filename, one directory level up
- Input: `assets/images/people/team/randal-eastman/originals/photo-headshot.jpg`
- Output: `assets/images/people/team/randal-eastman/photo-headshot.jpg`

---

## Workflow 1: Hugo Native Processing

**Status:** Start here for testing  
**Quality:** Adequate for web, simpler than ImageMagick  
**Processing:** Automatic on Hugo build

### Setup Steps

**1. Place texture file:**
```
assets/images/textures/fabric_weave_light.jpg
```

**2. Create template partial** (`layouts/partials/styled-portrait.html`):
```go-html-template
{{/* 
  Usage: {{ partial "styled-portrait.html" (dict "person" . "photo" "photo-headshot.jpg") }}
*/}}
{{ $personSlug := .person.Params.slug }}
{{ $photoPath := printf "images/people/team/%s/originals/%s" $personSlug .photo }}
{{ $texture := resources.Get "images/textures/fabric_weave_light.jpg" }}

{{ with resources.Get $photoPath }}
  {{ $styled := . | images.Filter
    (images.Colorize 12 12 90)
    (images.Overlay $texture 0 0)
  }}
  <img src="{{ $styled.RelPermalink }}" 
       alt="{{ $.person.Title }}" 
       class="team-photo"
       loading="lazy">
{{ else }}
  <p>Photo not found: {{ $photoPath }}</p>
{{ end }}
```

**3. Add to content front matter:**
```yaml
---
title: "Randal Eastman"
slug: "randal-eastman"
photo: "photo-headshot.jpg"
---
```

**4. Use in page template:**
```go-html-template
{{ partial "styled-portrait.html" (dict "person" . "photo" .Params.photo) }}
```

### Hugo Processing Flow

1. Add original photos to `originals/` folders
2. Run `hugo server` or `hugo build`
3. Hugo processes images on-demand
4. Cached in `resources/_gen/images/` (gitignored)
5. Served from `/public/`

### Selective Processing Control

**Option A: Conditional by section**
```go-html-template
{{ if eq .Section "team" }}
  {{/* Apply styling */}}
  {{ $styled := . | images.Filter (images.Colorize 12 12 90) }}
{{ else }}
  {{/* Use original */}}
  <img src="{{ .RelPermalink }}">
{{ end }}
```

**Option B: Front matter flag**
```yaml
---
applyTreatment: true  # or false to skip
---
```

```go-html-template
{{ if .Params.applyTreatment }}
  {{ $styled := . | images.Filter ... }}
{{ else }}
  <img src="{{ .RelPermalink }}">
{{ end }}
```

**Option C: Different paths**
```go-html-template
{{/* Styled: reads from originals/ folder */}}
{{ $teamPhoto := resources.Get "images/people/team/randal/originals/photo.jpg" }}
{{ $styled := $teamPhoto.Filter ... }}

{{/* Unstyled: reads from parent folder (no originals/) */}}
{{ $clientPhoto := resources.Get "images/people/clients/photo.jpg" }}
<img src="{{ $clientPhoto.RelPermalink }}">
```

### Advantages
- ✅ No manual processing
- ✅ Automatic cache management
- ✅ Updates when originals change
- ✅ No external dependencies

### Limitations
- ⚠️ Less sophisticated than ImageMagick
- ⚠️ Can't replicate exact softlight blend
- ⚠️ Limited color control

---

## Workflow 2: ImageMagick Script

**Status:** Production quality when brand consistency critical  
**Quality:** Professional editorial style  
**Processing:** Manual, run before committing

### Setup Steps

**1. Verify ImageMagick installed:**
```bash
magick --version
# Should show ImageMagick 7.x
```

**2. Script location:**
```
temp/_scripts/image-processing/apply_teal_fabric_style.sh
```

**3. Script contents:**
```bash
#!/bin/bash
# apply_teal_fabric_style.sh
# Apply teal colorization + fabric texture overlay to portraits

BASE_DIR="./assets/images/people"
TEXTURE="./assets/images/textures/fabric_weave_light.jpg"

echo "Starting portrait styling from: $BASE_DIR"
echo "Using texture: $TEXTURE"

find "$BASE_DIR" -type d -name originals | while read -r SOURCE_DIR; do
  OUTPUT_DIR="$(dirname "$SOURCE_DIR")"
  echo "Processing: $SOURCE_DIR → $OUTPUT_DIR"

  for FILE in "$SOURCE_DIR"/*.{jpg,jpeg,png}; do
    [ -e "$FILE" ] || continue
    FILENAME=$(basename "$FILE")
    OUTPUT_FILE="$OUTPUT_DIR/$FILENAME"

    # Apply teal filter + fabric texture
    magick "$FILE" \
      -fill "#38B2AC" -colorize 12% \
      -modulate 100,90,102 \
      \( "$TEXTURE" -resize "$(identify -format "%wx%h!" "$FILE")" \) \
      -compose softlight -composite \
      "$OUTPUT_FILE"

    echo "  ✓ Styled: $OUTPUT_FILE"
  done
done

echo "✅ Complete."
```

**4. Make executable:**
```bash
chmod +x temp/_scripts/image-processing/apply_teal_fabric_style.sh
```

### Processing Workflow

```bash
# 1. Add original photos to originals/ folders
cp photo-randal.jpg assets/images/people/team/randal-eastman/originals/photo-headshot.jpg

# 2. Run script
bash temp/_scripts/image-processing/apply_teal_fabric_style.sh

# 3. Review output
open assets/images/people/team/randal-eastman/photo-headshot.jpg

# 4. Commit styled versions
git add assets/images/people/team/
git commit -m "Add styled portrait: Randal Eastman"

# 5. Hugo serves pre-styled images (no processing needed)
```

### Template Usage

```go-html-template
{{/* Simple - styled version already exists */}}
{{ $photoPath := printf "images/people/team/%s/%s" .Params.slug .Params.photo }}

{{ with resources.Get $photoPath }}
  <img src="{{ .RelPermalink }}" 
       alt="{{ $.Title }}" 
       class="team-photo"
       loading="lazy">
{{ end }}
```

### Advantages
- ✅ Professional quality (softlight blend)
- ✅ Exact teal colorization (#38B2AC)
- ✅ Full ImageMagick control
- ✅ Consistent with WSJ/NYT style
- ✅ Fast Hugo builds (no processing)

### Limitations
- ⚠️ Manual processing step
- ⚠️ Must re-run after adding originals
- ⚠️ Requires ImageMagick installed

---

## Git Strategy

### Commit to repository:
- ✅ Styled images (`assets/images/people/team/*/photo-*.jpg`)
- ✅ Script (`temp/_scripts/image-processing/`)
- ✅ Texture (`assets/images/textures/fabric_weave_light.jpg`)

### Do NOT commit:
- ❌ `originals/` folders (keep as local backups)
- ❌ `resources/_gen/` (Hugo build cache - add to .gitignore)

**Rationale:** Styled images are production assets. Originals are pre-production source files.

---

## Decision Framework

### Use Hugo Native if:
- Testing the concept
- Processing < 5 portraits
- Quality adequate for your brand standards
- Want automatic updates

### Use ImageMagick if:
- Brand consistency critical
- Processing 10+ portraits
- Need editorial-quality styling
- Hugo quality insufficient after testing

### Hybrid Approach:
- ImageMagick for team/featured founders (high visibility)
- Hugo native for less prominent portraits (adequate quality)

---

## Recommended Start

**Phase 1: Test Hugo Native**
1. Add 2-3 sample portraits to `originals/`
2. Implement Hugo processing template
3. Build site and evaluate quality
4. Show stakeholders for approval

**Phase 2: Scale Decision**
- If quality adequate → Continue with Hugo native
- If quality insufficient → Switch to ImageMagick script
- If mixed needs → Use hybrid approach

---

## Troubleshooting

### Hugo processing not working
```bash
# Clear Hugo cache
rm -rf resources/_gen/

# Rebuild
hugo --gc
```

### ImageMagick script errors
```bash
# Check ImageMagick installed
which magick

# Test on single file
magick input.jpg -fill "#38B2AC" -colorize 12% output.jpg

# Check texture path exists
ls -l assets/images/textures/fabric_weave_light.jpg
```

### Images not appearing
```bash
# Verify file path
ls -R assets/images/people/

# Check Hugo resources
hugo --debug | grep "images/people"
```

---

**Last Updated:** 2025-10-06  
**For Questions:** Consult COO (Claude Console) for strategic guidance, CTO (Claude Code) for implementation
