# Workflow Documentation

Team processes, migration procedures, and operational workflows for Brandmine.

## Available Workflows

### [ceo-coo-cto-workflow.md](ceo-coo-cto-workflow.md)
**Team collaboration process** adapted for Brandmine's Hugo/Supabase context.

**Key principles**:
- CEO defines outcomes, validates results
- COO advises on feasibility, ensures quality
- CTO owns complete autonomous execution

**Covers**:
- Role definitions and responsibilities
- Communication patterns
- Brandmine-specific constraints (Hugo env vars, multilingual, taxonomy)
- System access constraints (CEO runs SQL, CTO writes it)
- Example workflows (simple feature, complex feature, database migration)

**Use this for**: Understanding team dynamics, clarifying responsibilities, resolving workflow questions.

---

### [database-migration-workflow.md](database-migration-workflow.md)
**Supabase schema change process** with Brandmine constraints.

**Key constraint**: Only CEO can execute SQL in Supabase dashboard.

**Process**:
1. Requirements gathering (CEO business need)
2. SQL development (CTO creates migration file)
3. CEO execution (runs SQL in Supabase SQL Editor)
4. Verification (CTO tests in application)
5. Documentation (CTO updates docs and commits)

**Use this for**: Database schema changes, adding tables/columns, data migrations.

---

### [translation-workflow.md](translation-workflow.md)
**Russian and Chinese translation process**.

**Authority**: CTO owns all RU/ZH translations (creates autonomously, no CEO approval needed).

**Process**:
1. CEO creates English content
2. CTO generates RU/ZH translations
3. CTO commits all 3 language versions
4. COO reviews for strategic alignment (optional)

**Use this for**: Translating content, maintaining multilingual consistency.

---

### [portrait-styling-workflow.md](portrait-styling-workflow.md)
**Founder photo styling standards**.

**Covers**:
- Portrait composition (headshots, environmental)
- Aspect ratios (2:3 for founder cards)
- Cropping patterns (top-aligned for vertical compositions)
- File organization (assets/images/founders/{slug}/originals/)

**Use this for**: Processing founder photos, maintaining visual consistency.

---

### [dev-charter.md](dev-charter.md)
**Development team charter** defining roles and operational patterns.

**Covers**:
- Role definitions (CEO, COO, CTO)
- Translation authority
- Backlog command patterns ("Code, backlog this" / "CTO, backlog this")
- COO role clarification (advisor, not blocker)

**Use this for**: Team onboarding, clarifying authority, operational questions.

---

## Quick Reference

### Backlog Commands
```
CEO: "Code, backlog this: [idea]"
OR
CEO: "CTO, backlog this: [idea]"

CTO Response: "Added to backlog as #XXX"
```

### Database Migration Pattern
```
CEO: "We need to add [field] to support [business need]"
CTO: [Creates SQL migration file]
CTO: "SQL ready in docs/database/sql/NNN-description.sql"
CEO: [Executes in Supabase dashboard]
CTO: [Tests in application, commits documentation]
```

### Translation Pattern
```
CEO: [Creates EN content]
CTO: [Generates RU/ZH, commits all 3 versions]
(No approval needed - CTO has translation authority)
```

---

**Last Updated**: 2025-10-23
