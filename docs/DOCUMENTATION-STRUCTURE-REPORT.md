# Brandmine Documentation Structure Report

**Prepared for**: COO (Claude Console)
**Prepared by**: CTO (Claude Code)
**Date**: 2025-10-08
**Purpose**: Explain current documentation organization, Supabase workflow, and project management systems

---

## Executive Summary

Our documentation system is designed to keep the root directory clean while maintaining organized, discoverable technical and business documentation. We currently have **6 root-level docs files** and **49 total documentation files** organized across 4 specialized subdirectories.

**Key Principle**: Minimize root clutter, maximize discoverability through logical organization.

---

## Root-Level Documentation Files (6 files)

These are strategic, frequently-referenced documents that warrant root-level visibility:

### 1. **BACKLOG.md** - Project Task Management
- **Purpose**: Track all future features, enhancements, and ideas
- **Usage**: CEO says "Code, backlog this: [idea]" → CTO adds with unique ID
- **Format**: Structured with IDs (#001, #002, etc.), scope, acceptance criteria, status
- **Sections**:
  - High Priority (immediate business value)
  - Future Enhancements (value-add, not blocking)
  - Ideas to Explore (needs refinement)
  - Completed (historical reference)

**Current Status**: 7 backlog items (4 active, 3 future, 1 completed)

**Business Value**: Prevents task loss, enables CEO to delegate without tracking, provides clear priorities.

---

### 2. **TAXONOMY-STANDARDS.md** - Data Classification Rules
- **Purpose**: Define and enforce the 4-dimension taxonomy system
- **Critical Rule**: Only 4 taxonomies permitted (markets, sectors, attributes, signals)
- **Content**: Standards for taxonomy term creation, naming conventions, multilingual labels
- **Authority**: Foundational architecture - changes require strategic review

---

### 3. **brandmine-brand-guide.md** - Visual Identity Standards
- **Purpose**: Complete brand identity system (colors, typography, voice, design patterns)
- **Sections**:
  - Color system (teal primary, orange secondary, dimension colors)
  - Typography standards (PT Sans/Serif for EN/RU, Noto Sans SC for ZH)
  - Component design patterns (cards, panels, buttons)
  - Accessibility requirements (WCAG 2.1 AA minimum)

**Usage**: Reference for all UI/UX decisions, ensures brand consistency across implementations.

---

### 4. **brandmine-vision-mission-values.md** - Strategic Foundation
- **Purpose**: Core business identity and strategic positioning
- **Content**:
  - Vision: 🔆 Illuminate the world's hidden brands to fuel their growth
  - Mission: Connect exceptional Global South SME brands with global partners
  - Values: 3 core values (Bridge Cultures, Champion Founders, Create Connections)
  - Target market definition

**Usage**: Ensures all decisions align with strategic positioning.

---

### 5. **dev-charter.md** - Team Roles & Workflows
- **Purpose**: Define team structure, responsibilities, communication protocols
- **Key Sections**:
  - **Role definitions**: CEO (business strategy), COO (quality assurance), CTO (technical execution)
  - **Workflow protocol**: Requirements → strategic assessment → technical approach → approval → execution → review → validation
  - **Communication patterns**: Clear boundaries between business, advisory, and technical roles
  - **Success definition**: Customer discovery enablement, market validation capability

**Authority**: Governance document for project execution.

---

### 6. **hugo-technical-standards.md** - Technical Architecture Standards
- **Purpose**: Hugo-specific patterns, best practices, implementation standards
- **Content**:
  - Directory structure conventions
  - Template patterns (Hugo Go templating)
  - Image placement rules (CRITICAL: assets/ vs static/)
  - Multilingual content patterns
  - Performance benchmarks
  - CSS architecture standards
  - Button system standards

**Usage**: Technical reference for all Hugo implementation decisions.

---

## Specialized Subdirectories (4 directories, 43 files)

### 1. **docs/database/** - Database Documentation

**Purpose**: Centralized database documentation and SQL management system.

**Structure**:
```
docs/database/
├── README.md              # Overview, conventions, usage guide
├── schema-design.md       # Full database schema (Phase 4 - future)
├── contact-forms.md       # Contact form implementation (Phase 3 - current)
├── sql/                   # Executable SQL files (4 files)
│   ├── 001-contacts-table.sql
│   ├── 002-duplicate-prevention.sql
│   ├── 003-data-retention-policy.sql
│   └── queries.sql       # Analytics and GDPR queries
└── guides/               # Step-by-step procedures (1 file)
    └── setup-guide.md
```

**Total Files**: 8 files

#### Key Principles

**SQL Migration System**:
- Sequential numbering: `NNN-description.sql` (001, 002, 003...)
- Header comments: Purpose, created date, production date, prerequisites
- Idempotent where possible: Use `CREATE OR REPLACE`
- Execution tracking: Note production deployment dates in file headers

**Documentation Standards**:
- **README.md**: Directory overview, naming conventions, usage instructions
- **contact-forms.md**: Implementation guide for contact form integration
- **schema-design.md**: Future comprehensive schema documentation
- **sql/ directory**: All executable SQL commands (migrations and queries)
- **guides/ directory**: Step-by-step procedures for setup and maintenance

#### Current Implementation Status

**Phase 3 - Contact Forms** (Production):
- ✅ Contacts table with RLS policies (`001-contacts-table.sql`)
- ✅ Duplicate prevention trigger - 5-minute window (`002-duplicate-prevention.sql`)
- ✅ GDPR data retention policy - 2-year auto-deletion (`003-data-retention-policy.sql`)
- ✅ Analytics queries for source attribution and GDPR compliance (`queries.sql`)

**Environment Variables** (Critical for Hugo):
```bash
# Hugo does NOT automatically load .env.local files
# Must explicitly source before running Hugo:
set -a && source .env.local && set +a && hugo server

# Required variables:
SUPABASE_URL=https://[project].supabase.co
SUPABASE_ANON_KEY=eyJ...
```

**Source Tracking System**:
- Contact form partial accepts `source` parameter
- Build with Us page: `source="build-with-us"`
- About page: `source="about"`
- Enables conversion funnel analysis in analytics

#### Workflow for Supabase Changes

1. **SQL Development**:
   - Write SQL in `sql/NNN-description.sql` with proper header
   - Test locally in Supabase SQL Editor
   - Document execution results in header

2. **Production Deployment**:
   - Copy SQL to Supabase Dashboard → SQL Editor
   - Execute migration
   - Note production deployment date in file header
   - Commit updated SQL file to git

3. **Documentation Updates**:
   - Update `contact-forms.md` or `schema-design.md` as needed
   - Add to `queries.sql` if creating reusable queries
   - Update `README.md` if changing conventions

**Business Value**: Single source of truth for database, executable SQL ready for deployment, clear migration history.

---

### 2. **docs/workflows/** - Process Documentation

**Purpose**: Step-by-step workflows for recurring processes.

**Current Files**: 2 files
- **translation-workflow.md**: RU/ZH translation process and role responsibilities
- **portrait-styling-workflow.md**: Founder photo styling standards

**Pattern**:
- Role-based responsibilities (CEO drafts, CTO executes, COO reviews)
- Clear step-by-step procedures
- Quality assurance checkpoints
- Special case handling

**When to Add**: Create new workflow doc when process is repeated 3+ times and has clear steps.

---

### 3. **docs/dev-journal/** - Technical Session Logs

**Purpose**: Detailed technical documentation of implementation sessions.

**Current Files**: 17 entries from October 2025

**Naming Convention**: `YYYY-MM-DD-topic-description.md`

**Content Pattern**:
```markdown
# Session Title

## Problem Statement
What business/technical problem needed solving

## Solution Approach
How CTO addressed it (architecture, patterns, decisions)

## Implementation Details
Code examples, file changes, technical specifics

## Testing & Verification
How solution was validated

## Lessons Learned
What went well, what to improve

## Next Steps
Follow-up tasks or future enhancements
```

**Examples**:
- `2025-10-06-supabase-documentation-reorganization.md`: Database docs restructure
- `2025-10-06-cta-button-hover-standardization.md`: Button UX improvements
- `2025-10-05-hero-gradients-search-footer.md`: Visual system enhancements
- `2025-10-04-edge-to-edge-layout-accessibility.md`: Layout + WCAG compliance

**Business Value**:
- Provides audit trail for technical decisions
- Documents reasoning for future reference
- Captures lessons learned for process improvement
- Enables knowledge transfer without relying on memory

**Retention**: Keep indefinitely for historical reference and decision archaeology.

---

### 4. **docs/archive/** - Completed/Superseded Documentation

**Purpose**: Historical documentation no longer actively used but valuable for reference.

**Current Files**: 16 archived documents

**Examples**:
- `HUGO-MIGRATION.md`: Original migration plan (superseded by actual implementation)
- `CLEAN-BUILD-PLAN.md`: Week-by-week build plan (completed)
- `multilingual-readiness-report.md`: Pre-launch i18n audit (100% complete, archived)
- `deployment-checklist.md`: Launch checklist (completed)
- `CEO-WORKFLOW-ADDING-BRANDS.md`: Content creation workflow (evolved)

**Archival Criteria**:
- Document purpose completed (migration plans, checklists)
- Content superseded by newer approach
- Historical value but not actively referenced
- Migration artifacts from Jekyll → Hugo transition

**Business Value**: Preserves decision context without cluttering active documentation.

---

## Documentation Workflow

### Creating New Documentation

**Decision Tree**:

1. **Is it a task/feature?** → Add to `BACKLOG.md`
2. **Is it a repeatable process?** → Create in `docs/workflows/`
3. **Is it a technical session?** → Create in `docs/dev-journal/`
4. **Is it foundational/strategic?** → Consider root-level placement
5. **Is it Supabase-related?** → Add to `docs/database/`
6. **Is it completed/superseded?** → Move to `docs/archive/`

### Naming Conventions

**Root-level files**:
- ALL-CAPS for universal reference docs (BACKLOG.md, TAXONOMY-STANDARDS.md)
- kebab-case for content docs (brandmine-brand-guide.md)

**Subdirectory files**:
- Descriptive kebab-case names
- Date prefixes for dev-journal: `YYYY-MM-DD-description.md`
- Sequential numbers for SQL: `NNN-description.sql`

### Update Protocol

**Who Updates What**:
- **CEO**: Content strategy, business requirements (via backlog or direct requests)
- **CTO**: All technical documentation (dev-journal, supabase, workflows)
- **COO**: Strategic review and approval (validates alignment, not execution)

**Commit Standards**:
- Documentation changes committed alongside code changes when relevant
- Standalone documentation updates get dedicated commits
- All commits reference documentation in commit message when applicable

---

## Integration with Development Process

### BACKLOG.md Integration

**CEO Workflow**:
```
CEO: "Code, backlog this: Add interactive map to brand profiles showing headquarters location"
CTO: [Creates #007 in BACKLOG.md with scope, acceptance criteria, status]
```

**Status Tracking**:
- Backlogged → In Progress → Completed
- Completed items moved to bottom with completion date and commit reference

**Business Value**: System holds tasks, CEO doesn't need to remember, clear priorities established.

---

### Dev-Journal Integration

**When CTO Completes Work**:
1. Make code changes
2. Document session in dev-journal with problem/solution/lessons
3. Commit both code and journal entry together
4. Reference journal in commit message if significant

**Example Commit**:
```bash
git commit -m "feat: add LinkedIn icons to About page and update copy

Add official LinkedIn brand icons to team member profiles.
See docs/dev-journal/2025-10-06-about-page-updates.md for details.
```

**Business Value**: Creates audit trail, documents decision reasoning, enables future reference.

---

### Supabase Integration

**Development Workflow**:
1. **Design**: Draft SQL in local editor
2. **Document**: Create `sql/NNN-description.sql` with header
3. **Test**: Execute in Supabase SQL Editor
4. **Deploy**: Run in production, note date in header
5. **Update Docs**: Update `contact-forms.md` or `schema-design.md`
6. **Commit**: Save all changes to git

**Environment Setup** (Critical):
```bash
# Hugo requires explicit env var loading
set -a && source .env.local && set +a && hugo server

# For production builds
set -a && source .env.local && set +a && hugo --gc --minify
```

**Business Value**: Database changes tracked, SQL ready for deployment, clear migration history.

---

## Metrics & Health

### Current State (2025-10-08)

**Documentation Files**:
- Root-level: 6 files (strategic references)
- Supabase: 8 files (database management)
- Workflows: 2 files (repeatable processes)
- Dev-Journal: 17 files (technical sessions)
- Archive: 16 files (historical reference)
- **Total**: 49 documentation files

**Organization Health**:
- ✅ Root directory clean (6 strategic files only)
- ✅ Logical subdirectory organization
- ✅ Clear naming conventions followed
- ✅ Active vs archived separation maintained
- ✅ Supabase centralized with executable SQL
- ✅ Dev-journal capturing technical decisions

**Areas of Excellence**:
1. **Supabase documentation reorganization** (2025-10-06): All database docs centralized, SQL migration system established
2. **Dev-journal discipline**: 17 sessions documented since October 3
3. **Archive hygiene**: Completed docs moved out of active directories

---

## Recommendations for COO Review

### Strategic Documentation Priorities

**High Value / Well Maintained**:
- ✅ BACKLOG.md: Clear task tracking, CEO can delegate effectively
- ✅ docs/database/: Centralized, executable, well-organized
- ✅ docs/dev-journal/: Consistent documentation, valuable audit trail

**Needs Attention**:
- ⚠️ docs/workflows/: Only 2 workflows documented, consider adding more as processes stabilize
- ⚠️ TAXONOMY-STANDARDS.md: May need review as taxonomy usage evolves

**Future Enhancements**:
- Consider adding `docs/decisions/` for Architecture Decision Records (ADRs)
- Consider adding `docs/runbooks/` for operational procedures (deployment, rollback, etc.)
- Consider consolidating root-level docs if more than 8-10 accumulate

---

## Questions for COO Consideration

1. **Documentation Granularity**: Is dev-journal level of detail appropriate for business needs?
2. **Workflow Coverage**: What other repeatable processes should be documented in docs/workflows/?
3. **Supabase Standards**: Do SQL migration conventions meet quality/audit requirements?
4. **Archive Policy**: Should archived docs be purged after certain timeframe or retained indefinitely?
5. **Root-Level Threshold**: At what point do we need to consolidate root docs into subdirectories?

---

## Conclusion

Our documentation system balances **accessibility** (root-level strategic docs) with **organization** (specialized subdirectories) while maintaining **cleanliness** (minimal root clutter). The Supabase documentation reorganization (2025-10-06) established a strong pattern for centralized, executable database management that can serve as a model for other technical domains.

**Key Strengths**:
- Clear separation of strategic vs technical docs
- Executable SQL ready for deployment
- Strong audit trail through dev-journal
- Effective task tracking through BACKLOG.md
- Clean root directory (6 files)

**Key Opportunities**:
- Expand workflow documentation as processes stabilize
- Consider ADR pattern for significant architectural decisions
- Formalize retention policy for archived documentation

---

**Prepared by**: Claude Code (CTO)
**Review Status**: Pending COO review
**Next Update**: As documentation structure evolves or after COO feedback
