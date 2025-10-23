# Temp Folder Cleanup Recommendations

**Date**: 2025-10-23
**Status**: Recommendations for CEO approval

---

## Executive Summary

**Current state**: 280+ files in temp/ folder, mostly obsolete Jekyll migration artifacts.

**Recommendation**:
- **KEEP**: 5 files (Georgetown docs + 3 Brandmine strategy docs worth reviewing)
- **DELETE**: 275+ files (ready to delete folder + duplicates)

---

## Files to KEEP

### Georgetown Rotary Project (2 files) - KEEP AS REQUESTED

```
temp/georgetown setup/
├── README.md                    # Georgetown project documentation index
└── react-spa-playbook.md        # React SPA technical playbook
```

**Rationale**: You specifically requested to keep these Georgetown files temporarily.

**Action**: No action needed.

---

### Brandmine Strategy Documents (3 files) - REVIEW RECOMMENDED

#### 1. brandmine-content-automation-framework-corrected.md
**Size**: ~200 lines (estimated from preview)
**Topic**: Database schema for AI-powered content generation

**Content**:
- Relational database design for brands, founders, markets, milestones
- Multilingual content fields for authentic translation
- Content generation metadata for AI storytelling
- Bridge tables for relationships (brand_founders, milestones)

**Assessment**: **WORTH REVIEWING** - This is future Phase 4/5 database expansion beyond current contact forms.

**Recommendation**:
- **If you're planning AI content generation**: Move to `docs/database/future-content-automation.md`
- **If not immediate priority**: Add to backlog and delete this file
- **If outdated/abandoned**: Delete

**Questions for CEO**:
- Is AI-generated content (brand stories, founder profiles) on your roadmap?
- Timeline: Next 3 months? 6 months? 12+ months?

---

#### 2. brandmine-database-multilingual-clarification.md
**Size**: ~50 lines
**Topic**: How multilingual translations are stored in database

**Content**:
- ONE table (`generated_content`) with multiple rows (one per language)
- NOT three separate tables
- Example SQL structure for EN/RU/ZH content storage

**Assessment**: **REDUNDANT** - This clarifies the automation framework structure, but you're not using `generated_content` table yet.

**Recommendation**: **DELETE** - If you implement content automation framework, this detail is embedded in that larger doc.

---

#### 3. georgetown-workflow-alignment-summary.md
**Size**: ~50 lines
**Topic**: Summary of workflow changes made Oct 8

**Content**:
- Documents what changed when Georgetown workflow was adapted for Brandmine
- Lists updated files (ceo-coo-cto-workflow.md, database-migration-workflow.md)
- Historical record of Oct 8 session

**Assessment**: **REDUNDANT** - This information is already in:
- `docs/dev-journal/2025-10-08-workflow-alignment-georgetown-to-brandmine.md`
- `docs/workflows/ceo-coo-cto-workflow.md` (the actual workflow doc)

**Recommendation**: **DELETE** - Dev journal already documents this session comprehensively.

---

### Duplicate Workflow Files (2 files) - DELETE

```
temp/ceo-coo-cto-workflow.md           # Duplicate of docs/workflows/ceo-coo-cto-workflow.md
temp/database-migration-workflow.md    # Duplicate of docs/workflows/database-migration-workflow.md
```

**Recommendation**: **DELETE** - These are exact copies of files now in `docs/workflows/`.

---

## Files to DELETE

### Ready to Delete Folder (~275 files)

**Path**: `temp/ready to delete/`

**Contents**:
- Jekyll brand/founder/insight markdown files (obsolete - migrated to Hugo)
- Jekyll data files (dimensions, translations, etc. - migrated to Hugo)
- Jekyll includes and helpers (not used in Hugo)
- JSON/YAML configuration files (Jekyll-specific)
- Privacy policy drafts (3 languages)
- Press kit documentation
- Scripts and technical documentation from Jekyll era

**Recommendation**: **DELETE ENTIRE FOLDER**

**Rationale**:
- Hugo migration complete (Oct 3-8)
- All content migrated to Hugo `content/` directory
- All data migrated to Hugo `data/` directory
- Jekyll patterns not used in Hugo
- 3 weeks since migration - no longer needed

**Safety**: All files preserved in git history if needed.

---

## Summary & Action Plan

### KEEP (5 files)
```
temp/
├── georgetown setup/
│   ├── README.md                                          # Georgetown docs
│   └── react-spa-playbook.md                              # Georgetown playbook
├── brandmine-content-automation-framework-corrected.md    # REVIEW: AI content generation plan
├── brandmine-database-multilingual-clarification.md       # DELETE: Redundant detail
└── georgetown-workflow-alignment-summary.md               # DELETE: Covered in dev journal
```

### DELETE (277+ files)
```
temp/
├── ceo-coo-cto-workflow.md                    # Duplicate
├── database-migration-workflow.md             # Duplicate
└── ready to delete/ (~275 files)              # Jekyll migration artifacts
```

---

## Questions for CEO

### Question 1: AI Content Generation Framework

**File**: `brandmine-content-automation-framework-corrected.md`

Do you want to preserve this database schema for future AI-generated content (brand stories, founder profiles, etc.)?

**Option A**: Yes, move to `docs/database/future-content-automation.md`
**Option B**: Yes, but add to backlog and delete file
**Option C**: No, delete (not on roadmap)

---

### Question 2: Deletion Confirmation

Confirm deletion of:
- ✅ `temp/ready to delete/` folder (~275 files)
- ✅ `temp/brandmine-database-multilingual-clarification.md`
- ✅ `temp/georgetown-workflow-alignment-summary.md`
- ✅ `temp/ceo-coo-cto-workflow.md`
- ✅ `temp/database-migration-workflow.md`

**Total deletion**: 279 files

---

## Execution Plan

### If CEO approves full cleanup:

```bash
# Delete duplicate workflow files
rm temp/ceo-coo-cto-workflow.md
rm temp/database-migration-workflow.md

# Delete redundant docs
rm temp/brandmine-database-multilingual-clarification.md
rm temp/georgetown-workflow-alignment-summary.md

# Delete Jekyll migration artifacts
rm -rf "temp/ready to delete"

# Optional: Move content automation to docs if keeping
mv temp/brandmine-content-automation-framework-corrected.md docs/database/future-content-automation.md
# OR delete if not on roadmap:
# rm temp/brandmine-content-automation-framework-corrected.md
```

### Final temp/ structure:
```
temp/
└── georgetown setup/
    ├── README.md
    └── react-spa-playbook.md
```

**Result**: 2 files in temp/ (down from 280+, 99% reduction)

---

## Benefits

### Before Cleanup
- **280+ files** in temp/
- Mix of Georgetown, Brandmine strategy, Jekyll artifacts, duplicates
- Unclear what's relevant vs obsolete
- Cognitive overhead to navigate

### After Cleanup
- **2-3 files** in temp/ (Georgetown docs + optionally content automation framework)
- 99% reduction in temp folder size
- Crystal clear purpose (temporary Georgetown reference)
- Zero Jekyll artifacts

---

## CEO Decision Required

**Question 1**: Keep AI content automation framework? (Yes → move to docs/database/ | No → delete)

**Question 2**: Approve deletion of 279 files? (Yes → execute plan | No → specify what to keep)

---

**Status**: Awaiting CEO approval
**Next Steps**: CEO provides answers, CTO executes cleanup
