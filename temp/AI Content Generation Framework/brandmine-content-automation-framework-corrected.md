# Brandmine Content Automation Framework
## Database Structure & Data Aggregation for AI-Powered Storytelling

---

## Executive Summary

This framework structures brand and founder data to enable AI-powered content generation across multiple languages. The relational database design separates entities (brands, founders, markets) while maintaining connections through relationship tables (brand_founders, milestones), allowing flexible content creation for different formats and audiences.

**Key Design Principles:**
- **Structured narrative elements** (challenges, turning points, cultural context)
- **Multilingual content fields** for authentic translation
- **Relationship mapping** between brands, founders, markets, and milestones
- **Content generation metadata** to optimize AI storytelling

---

## Database Schema Overview

```
┌─────────────┐
│   BRANDS    │◄───────┐
└──────┬──────┘        │
       │               │
       ├──────────┐    │
       │          │    │
       ▼          ▼    │
┌──────────┐ ┌────────┴────┐
│ FOUNDERS │ │  MILESTONES │──────┐
└────┬─────┘ └─────────────┘      │
     │              │              │
     │              ▼              │
     │         ┌──────────┐        │
     └────────►│ MARKETS  │◄───────┘
               └──────────┘
```

**Table Types:**
- **Entity Tables**: BRANDS, FOUNDERS, MARKETS (core data)
- **Bridge/Relationship Tables**: BRAND_FOUNDERS, MILESTONES (connect entities with descriptive data)
- **Content Tables**: CONTENT_TEMPLATES, GENERATED_CONTENT (AI generation infrastructure)

---

## Table 1: BRANDS (Entity Table)

### Core Identity
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `brand_id` | UUID | Primary key | `uuid-123-abc` |
| `brand_name_primary` | VARCHAR(200) | Official brand name | "Yandex" |
| `brand_name_local` | VARCHAR(200) | Local language name | "Яндекс" |
| `brand_name_romanized` | VARCHAR(200) | Transliteration | "Yandeks" |
| `tagline_primary` | TEXT | Brand tagline (English) | "Everything you need is here" |
| `tagline_local` | TEXT | Brand tagline (local) | "Всё что нужно" |
| `year_founded` | INTEGER | Founding year | 1997 |
| `headquarters_city` | VARCHAR(100) | Primary location | "Moscow" |
| `headquarters_country` | VARCHAR(3) | Country code (ISO 3166) | "RUS" |
| `website_url` | VARCHAR(500) | Official website | "yandex.com" |
| `logo_url` | VARCHAR(500) | Brand logo path | "/assets/yandex-logo.png" |

### Business Fundamentals
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `industry_primary` | VARCHAR(100) | Main sector | "Technology" |
| `industry_secondary` | VARCHAR(100) | Secondary sector | "Media" |
| `business_model` | ENUM | Revenue model | "B2C, Advertising" |
| `revenue_range` | VARCHAR(50) | Annual revenue bracket | "$100M-$500M" |
| `employee_count_range` | VARCHAR(50) | Team size bracket | "1000-5000" |
| `growth_stage` | ENUM | Business maturity | "Scale-up, Public" |
| `funding_status` | VARCHAR(100) | Funding stage | "IPO 2011" |
| `total_funding_usd` | DECIMAL | Total capital raised | 1500000000.00 |

### Market Position
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `geographic_footprint` | TEXT[] | Countries served | ["RUS", "TUR", "BLR"] |
| `market_position` | VARCHAR(200) | Competitive standing | "Market leader in Russian search" |
| `key_competitors` | TEXT[] | Main rivals | ["Google", "Mail.ru"] |
| `unique_selling_points` | TEXT[] | Differentiators | ["Local language expertise", "Russia-first"] |

### Narrative Elements (Critical for AI Content Generation)
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `origin_story_brief` | TEXT | 2-3 sentence origin | "Founded by Arkady Volozh to create Russian language search when Western engines failed at Cyrillic" |
| `founding_challenge` | TEXT | Core problem solved | "Western search engines couldn't handle Russian grammar complexity" |
| `cultural_context` | TEXT | Cultural significance | "Post-Soviet tech renaissance, national pride in local innovation" |
| `turning_point_moment` | TEXT | Pivotal event | "2008 financial crisis when Russian users chose local over Google" |
| `mission_statement` | TEXT | Core purpose | "Make technology work for Russian language and culture" |
| `vision_statement` | TEXT | Future ambition | "Global technology company rooted in Russian innovation" |

### Content Generation Metadata
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `storytelling_angle` | ENUM | Primary narrative frame | "Underdog, Cultural champion, Tech innovator" |
| `emotional_tone` | ENUM | Story emotional arc | "Triumphant, Resilient, Pioneering" |
| `target_audience` | TEXT[] | Content audience focus | ["Diaspora investors", "International partners"] |
| `content_themes` | TEXT[] | Story themes | ["Innovation", "Cultural pride", "David vs Goliath"] |
| `language_priorities` | TEXT[] | Translation priorities | ["RUS", "ENG", "ZHO"] |

### SEO & Discovery
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `slug` | VARCHAR(200) | URL-friendly identifier | "yandex-russian-search-pioneer" |
| `meta_description_en` | TEXT | English SEO description | "Yandex pioneered Russian language search..." |
| `meta_description_local` | TEXT | Local language SEO | "Яндекс создал поиск для русского языка..." |
| `keywords` | TEXT[] | Search keywords | ["Russian tech", "search engine", "BRICS innovation"] |

### Status & Versioning
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `content_status` | ENUM | Publication status | "Published, Draft, Review" |
| `content_quality_score` | INTEGER | Completeness (1-10) | 8 |
| `last_updated` | TIMESTAMP | Last modification | "2025-10-15 14:32:00" |
| `created_at` | TIMESTAMP | Record creation | "2025-08-01 09:00:00" |
| `created_by` | VARCHAR(100) | Creator identifier | "research_team" |

---

## Table 2: FOUNDERS (Entity Table)

### Personal Identity
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `founder_id` | UUID | Primary key | `uuid-456-def` |
| `full_name_primary` | VARCHAR(200) | Name (Latin script) | "Arkady Volozh" |
| `full_name_local` | VARCHAR(200) | Name (local script) | "Аркадий Волож" |
| `name_romanized` | VARCHAR(200) | Transliteration | "Arkadiy Volozh" |
| `birth_year` | INTEGER | Year of birth | 1964 |
| `birth_city` | VARCHAR(100) | Birthplace | "Atyrau, Kazakhstan" |
| `birth_country` | VARCHAR(3) | Birth country code | "KAZ" |
| `current_location` | VARCHAR(100) | Current residence | "Tel Aviv, Israel" |
| `current_country` | VARCHAR(3) | Current country code | "ISR" |
| `photo_url` | VARCHAR(500) | Profile photo path | "/assets/arkady-volozh.jpg" |
| `linkedin_url` | VARCHAR(500) | LinkedIn profile | "linkedin.com/in/volozh" |

### Professional Background
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `education_background` | TEXT | Academic history | "Moscow Institute of Oil and Gas, Applied Math" |
| `prior_experience` | TEXT | Pre-founder career | "Research scientist, early Russian tech entrepreneur" |
| `founding_age` | INTEGER | Age when founded brand | 33 |
| `current_role` | VARCHAR(100) | Current title | "Former CEO (resigned 2024)" |
| `founder_type` | ENUM | Founder classification | "Serial entrepreneur, Technical founder" |

### Founder Journey Narrative (Critical for AI Content)
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `origin_story` | TEXT | Personal background arc | "Grew up in Soviet Kazakhstan, witnessed tech limitations of command economy" |
| `motivation_why` | TEXT | Why they started | "Frustration with Western tech ignoring Russian language complexity" |
| `biggest_challenge` | TEXT | Major obstacle overcome | "Building tech company in 1990s Russia with zero infrastructure" |
| `personal_turning_point` | TEXT | Pivotal personal moment | "Realized Russian internet needed native solutions after 1998 crisis" |
| `leadership_philosophy` | TEXT | How they lead | "Data-driven decisions, Russian talent development, user obsession" |
| `personal_sacrifice` | TEXT | What they gave up | "Comfortable research career for entrepreneurial uncertainty" |
| `proudest_achievement` | TEXT | Career highlight | "Creating Russia's first globally competitive tech company" |
| `current_focus` | TEXT | Present activities | "Rebuilding tech ventures from Tel Aviv after leaving Russia" |

### Cultural & Personal Context
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `cultural_identity` | TEXT[] | Cultural influences | ["Soviet", "Russian", "Jewish", "Kazakh"] |
| `languages_spoken` | TEXT[] | Language capabilities | ["Russian", "English", "Hebrew"] |
| `diaspora_status` | BOOLEAN | Living outside home country | TRUE |
| `diaspora_narrative` | TEXT | Diaspora story if applicable | "Relocated to Israel in 2024 amid geopolitical tensions" |
| `family_business_context` | TEXT | Family influence | "First-generation entrepreneur" |
| `mentor_influences` | TEXT[] | Key mentors | ["Early Russian tech pioneers"] |

### Values & Themes
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `core_values` | TEXT[] | Personal values | ["Innovation", "Persistence", "Russian talent"] |
| `personality_traits` | TEXT[] | Character descriptors | ["Analytical", "Resilient", "Visionary"] |
| `storytelling_themes` | TEXT[] | Narrative themes | ["Immigrant success", "Tech sovereignty", "Against the odds"] |

### Status & Metadata
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `content_status` | ENUM | Publication status | "Published" |
| `content_quality_score` | INTEGER | Completeness (1-10) | 9 |
| `last_updated` | TIMESTAMP | Last modification | "2025-10-20 11:15:00" |
| `created_at` | TIMESTAMP | Record creation | "2025-08-01 09:00:00" |

---

## Table 3: MARKETS (Entity Table)

### Geographic Identity
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `market_id` | UUID | Primary key | `uuid-market-rus-001` |
| `country_code` | VARCHAR(3) | ISO 3166-1 alpha-3 code | "RUS" |
| `country_name_en` | VARCHAR(100) | English country name | "Russia" |
| `country_name_local` | VARCHAR(100) | Local language name | "Россия" |
| `region` | VARCHAR(100) | Geographic region | "Eastern Europe" |
| `brics_status` | BOOLEAN | BRICS member | TRUE |
| `brics_plus_status` | BOOLEAN | BRICS+ member | TRUE |

### Market Context (Critical for Cultural Translation)
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `business_culture_notes` | TEXT | Cultural business norms | "Relationship-driven, longer sales cycles, importance of personal trust" |
| `regulatory_environment` | TEXT | Key regulations | "Data localization laws, Western sanctions impact" |
| `language_primary` | VARCHAR(50) | Primary language | "Russian" |
| `language_business` | VARCHAR(50) | Business language | "Russian, English" |
| `market_maturity` | ENUM | Market stage | "Emerging, Mature, Frontier" |
| `tech_adoption_level` | ENUM | Tech sophistication | "High, Medium, Low" |
| `diaspora_size_estimate` | INTEGER | Diaspora population | 10000000 |
| `diaspora_concentration` | TEXT[] | Where diaspora lives (country codes) | ["USA", "DEU", "ISR", "GBR"] |

### Economic Context
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `gdp_usd` | DECIMAL | GDP in USD | 1780000000000.00 |
| `gdp_per_capita_usd` | DECIMAL | Per capita GDP | 12000.00 |
| `internet_penetration_pct` | DECIMAL | % with internet | 85.0 |
| `mobile_penetration_pct` | DECIMAL | % with mobile | 95.0 |

### Status & Metadata
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `last_updated` | TIMESTAMP | Last modification | "2025-10-20 11:15:00" |
| `data_quality_score` | INTEGER | Completeness (1-10) | 8 |

---

## Table 4: BRAND_FOUNDERS (Bridge/Relationship Table)

**Purpose**: Many-to-many relationship between BRANDS and FOUNDERS with role-specific metadata

| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `brand_founder_id` | UUID | Primary key | `uuid-bf-001` |
| `brand_id` | UUID | Foreign key to BRANDS | `uuid-123-abc` |
| `founder_id` | UUID | Foreign key to FOUNDERS | `uuid-456-def` |
| `role` | VARCHAR(100) | Founder's role | "Co-founder & CEO" |
| `is_primary_founder` | BOOLEAN | Main founder flag | TRUE |
| `founding_contribution` | TEXT | Specific contribution | "Technical vision and product development" |
| `equity_stake` | VARCHAR(50) | Ownership (if public) | "5.1%" |
| `active_status` | BOOLEAN | Currently involved | FALSE |
| `start_date` | DATE | When they joined | "1997-09-23" |
| `departure_date` | DATE | When they left (if applicable) | "2024-06-15" |
| `departure_reason` | TEXT | Why they left | "Geopolitical pressures post-Ukraine invasion" |

---

## Table 5: MILESTONES (Bridge/Relationship Table with Rich Descriptive Data)

**Purpose**: Many-to-many relationship connecting BRANDS, FOUNDERS, and MARKETS with event narratives

### Milestone Identity
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `milestone_id` | UUID | Primary key | `uuid-789-ghi` |
| `milestone_type` | ENUM | Event category | "Funding, Product Launch, Market Entry, Crisis, Exit, Award" |
| `milestone_date` | DATE | When it occurred | "2011-05-24" |
| `milestone_title_en` | VARCHAR(200) | English title | "Yandex IPO on NASDAQ" |
| `milestone_title_local` | VARCHAR(200) | Local language title | "IPO Яндекса на NASDAQ" |

### Relations (Foreign Keys)
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `brand_id` | UUID | Foreign key to BRANDS | `uuid-123-abc` |
| `founder_id` | UUID | Foreign key to FOUNDERS (nullable) | `uuid-456-def` |
| `market_id` | UUID | Foreign key to MARKETS | `uuid-market-rus-001` |

### Narrative Elements (Critical for AI Content)
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `milestone_description` | TEXT | Detailed explanation | "First Russian tech company to list on NASDAQ, raising $1.3B" |
| `significance_why_matters` | TEXT | Why this matters | "Validated Russian tech on global stage, created blueprint for future IPOs" |
| `context_before` | TEXT | Situation before | "Russian tech seen as isolated, unable to compete globally" |
| `context_after` | TEXT | Impact after | "Opened doors for Russian tech internationally, inspired generation of entrepreneurs" |
| `challenges_faced` | TEXT | Obstacles during | "Skepticism from Western investors about Russian governance" |
| `key_players` | TEXT[] | People involved | ["Arkady Volozh", "Ilya Segalovich", "Greg Coleman"] |
| `emotional_arc` | TEXT | Story emotional journey | "Underdog proving doubters wrong, national pride moment" |

### Quantifiable Metrics
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `financial_amount_usd` | DECIMAL | Dollar value if applicable | 1300000000.00 |
| `valuation_usd` | DECIMAL | Company valuation at time | 8000000000.00 |
| `metric_type` | VARCHAR(100) | Type of metric | "Revenue, Users, Funding" |
| `metric_value` | VARCHAR(100) | Metric achievement | "60M daily users" |

### Content Metadata
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `storytelling_priority` | INTEGER | Content importance (1-10) | 9 |
| `media_assets` | TEXT[] | Related images/videos | ["/assets/nasdaq-bell.jpg"] |
| `source_citations` | TEXT[] | Evidence sources | ["NASDAQ press release", "Reuters article"] |

### Status & Versioning
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `last_updated` | TIMESTAMP | Last modification | "2025-10-20 11:15:00" |
| `created_at` | TIMESTAMP | Record creation | "2025-08-01 09:00:00" |

---

## Table 6: CONTENT_TEMPLATES (Content Infrastructure)

### Template Identity
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `template_id` | UUID | Primary key | `uuid-template-001` |
| `template_name` | VARCHAR(200) | Template identifier | "Founder Origin Story - Long Form" |
| `content_type` | ENUM | Output format | "Article, Profile, Case Study, Social Post" |
| `target_length_words` | INTEGER | Desired word count | 1500 |
| `target_audience` | VARCHAR(100) | Intended readers | "Diaspora Investors" |
| `language` | VARCHAR(10) | Output language (ISO 639-3) | "ENG" |

### AI Generation Instructions
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `prompt_template` | TEXT | AI instruction template | "Write a {length} word article about {founder.full_name_primary}'s journey founding {brand.brand_name_primary}. Focus on {founder.motivation_why} and emphasize {content_themes}. Tone: {emotional_tone}." |
| `required_data_fields` | TEXT[] | Data dependencies | ["founder.origin_story", "brand.founding_challenge", "milestone.significance_why_matters"] |
| `optional_data_fields` | TEXT[] | Nice-to-have data | ["founder.personal_sacrifice", "brand.cultural_context"] |
| `structure_outline` | TEXT | Content structure | "1. Hook with founder challenge\n2. Background context\n3. Founding moment\n4. Key milestone\n5. Current impact" |
| `tone_guidelines` | TEXT | Writing style rules | "Respectful, inspirational, data-grounded, avoid hype" |
| `cultural_sensitivity_notes` | TEXT | Cultural considerations | "Acknowledge Soviet legacy without Cold War stereotypes" |

### Status & Metadata
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `active_status` | BOOLEAN | Currently in use | TRUE |
| `last_updated` | TIMESTAMP | Last modification | "2025-10-20 11:15:00" |
| `created_at` | TIMESTAMP | Record creation | "2025-08-01 09:00:00" |

---

## Table 7: GENERATED_CONTENT (Content Output)

**Purpose**: Stores final AI-generated content ready for publication

### Content Identity
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `content_id` | UUID | Primary key | `uuid-content-123` |
| `content_type` | ENUM | Format | "Article, Profile, Case Study, Social Post" |
| `language` | VARCHAR(10) | Content language (ISO 639-3) | "ENG" |
| `title` | VARCHAR(300) | Content title | "How Arkady Volozh Built Russia's Answer to Google" |
| `slug` | VARCHAR(300) | URL slug | "arkady-volozh-yandex-story" |

### Generated Content
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `body_content` | TEXT | Full content text | "In 1997, when Western search engines..." |
| `excerpt` | TEXT | Short summary | "The story of how a Soviet mathematician..." |
| `meta_description` | TEXT | SEO description | "Arkady Volozh overcame Cold War tech isolation to build Yandex..." |
| `word_count` | INTEGER | Actual word count | 1487 |

### Relations (Foreign Keys)
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `brand_id` | UUID | Related brand | `uuid-123-abc` |
| `founder_id` | UUID | Related founder | `uuid-456-def` |
| `template_id` | UUID | Template used | `uuid-template-001` |

### Generation Metadata
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `generation_model` | VARCHAR(100) | AI model used | "claude-sonnet-4-20250514" |
| `generation_date` | TIMESTAMP | When generated | "2025-10-23 15:45:00" |
| `generation_prompt` | TEXT | Actual prompt used | "Write a 1500 word article..." |
| `human_edited` | BOOLEAN | Human modified | TRUE |
| `human_editor` | VARCHAR(100) | Who edited | "content_team" |
| `edit_notes` | TEXT | What was changed | "Adjusted cultural references for sensitivity" |

### Publication Status
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `publication_status` | ENUM | Status | "Draft, Review, Published, Archived" |
| `published_date` | TIMESTAMP | When published | "2025-10-24 10:00:00" |
| `published_url` | VARCHAR(500) | Live URL | "brandmine.com/stories/arkady-volozh-yandex" |
| `quality_score` | INTEGER | Content quality (1-10) | 8 |
| `engagement_metrics` | JSONB | Analytics data | {"views": 1250, "time_on_page": 245} |

### SEO & Discovery
| Field | Type | Purpose | Example |
|-------|------|---------|---------|
| `featured_image_url` | VARCHAR(500) | Main image | "/assets/volozh-yandex-hero.jpg" |
| `keywords` | TEXT[] | SEO keywords | ["Russian tech", "Yandex founder", "search engine"] |
| `related_content_ids` | UUID[] | Related articles | [uuid-content-456, uuid-content-789] |

---

## Data Aggregation Priorities

### Tier 1: Essential for Basic Content (MVP)
**Minimum viable data to generate publishable content**

#### BRANDS (Table 1)
- `brand_name_primary`, `brand_name_local`
- `origin_story_brief`
- `industry_primary`
- `year_founded`
- `headquarters_country`
- `founding_challenge`

#### FOUNDERS (Table 2)
- `full_name_primary`, `full_name_local`
- `origin_story`
- `motivation_why`
- `biggest_challenge`

#### MARKETS (Table 3)
- `country_code`, `country_name_en`, `country_name_local`
- `business_culture_notes`
- `language_primary`

#### MILESTONES (Table 5)
- At least ONE major milestone with:
  - `milestone_title_en`, `milestone_date`
  - `significance_why_matters`
  - Proper foreign keys: `brand_id`, `market_id`

#### BRAND_FOUNDERS (Table 4)
- `brand_id`, `founder_id`
- `role`
- `is_primary_founder`

### Tier 2: Enhanced Storytelling (Post-MVP)
**Enriched data for compelling narratives**

#### BRANDS (Table 1)
- `cultural_context`
- `turning_point_moment`
- `unique_selling_points`
- `storytelling_angle`, `emotional_tone`
- `content_themes`

#### FOUNDERS (Table 2)
- `personal_turning_point`
- `leadership_philosophy`
- `cultural_identity`
- `personal_sacrifice`

#### MILESTONES (Table 5)
- 3-5 milestones with:
  - `context_before`, `context_after`
  - `emotional_arc`
  - `challenges_faced`
  - Financial metrics where applicable

### Tier 3: Premium Content (Scale Phase)
**Comprehensive data for sophisticated audiences**

#### MARKETS (Table 3)
- `diaspora_size_estimate`
- `diaspora_concentration`
- `regulatory_environment`
- Economic context fields

#### FOUNDERS (Table 2)
- `diaspora_narrative` (if applicable)
- `mentor_influences`
- `current_focus`

#### BRANDS (Table 1)
- `key_competitors`
- `market_position`
- Full multilingual support

#### MILESTONES (Table 5)
- Complete narrative elements
- `key_players`
- `media_assets`
- `source_citations`

---

## AI Content Generation Workflow

### Step 1: Data Retrieval Query
```sql
-- Fetch all relevant data for content generation
SELECT 
    b.brand_name_primary,
    b.brand_name_local,
    b.origin_story_brief,
    b.founding_challenge,
    b.cultural_context,
    b.storytelling_angle,
    b.emotional_tone,
    b.content_themes,
    
    f.full_name_primary,
    f.full_name_local,
    f.origin_story,
    f.motivation_why,
    f.biggest_challenge,
    f.personal_turning_point,
    f.cultural_identity,
    
    bf.role,
    bf.founding_contribution,
    
    m.milestone_title_en,
    m.milestone_date,
    m.significance_why_matters,
    m.emotional_arc,
    m.context_before,
    m.context_after,
    
    mk.country_name_en,
    mk.business_culture_notes,
    mk.diaspora_size_estimate,
    mk.diaspora_concentration
    
FROM brands b
INNER JOIN brand_founders bf ON b.brand_id = bf.brand_id
INNER JOIN founders f ON bf.founder_id = f.founder_id
LEFT JOIN milestones m ON b.brand_id = m.brand_id
LEFT JOIN markets mk ON b.headquarters_country = mk.country_code
WHERE b.brand_id = '{target_brand_id}'
  AND b.content_status = 'Published'
  AND bf.is_primary_founder = TRUE
ORDER BY m.storytelling_priority DESC, m.milestone_date DESC
LIMIT 5;
```

### Step 2: AI Prompt Construction
```
You are writing about {brand.brand_name_primary}, a {brand.industry_primary} company from {market.country_name_en}.

**Brand Context:**
- Origin: {brand.origin_story_brief}
- Challenge solved: {brand.founding_challenge}
- Cultural significance: {brand.cultural_context}

**Founder Story:**
- Name: {founder.full_name_primary} (born {founder.birth_year})
- Role: {brand_founder.role}
- Background: {founder.origin_story}
- Motivation: {founder.motivation_why}
- Major challenge: {founder.biggest_challenge}
- Turning point: {founder.personal_turning_point}
- Cultural identity: {founder.cultural_identity}

**Key Milestone:**
- Event: {milestone.milestone_title_en} ({milestone.milestone_date})
- Significance: {milestone.significance_why_matters}
- Before: {milestone.context_before}
- After: {milestone.context_after}
- Emotional arc: {milestone.emotional_arc}

**Cultural Context:**
- Market: {market.country_name_en}
- Business culture: {market.business_culture_notes}
- Diaspora: {market.diaspora_size_estimate} living in {market.diaspora_concentration}

**Storytelling Instructions:**
- Tone: {brand.emotional_tone}
- Themes: {brand.content_themes}
- Audience: {template.target_audience}
- Angle: {brand.storytelling_angle}
- Length: {template.target_length_words} words
- Structure: {template.structure_outline}
- Guidelines: {template.tone_guidelines}
- Cultural sensitivity: {template.cultural_sensitivity_notes}

Write compelling content that brings this founder's journey to life, emphasizing the intersection of personal story, cultural context, and business achievement. Avoid clichés and focus on specific, authentic details.
```

### Step 3: Translation Workflow
```
Original English content: {generated_content.body_content}

Translate to {target_language} (ISO 639-3: {market.language_primary}) considering:

**Cultural Context:**
- Business culture: {market.business_culture_notes}
- Target audience: Native {market.language_primary} speakers
- Cultural references: Adapt metaphors and idioms naturally

**Terminology:**
- Brand name: Use {brand.brand_name_local}
- Founder name: Use {founder.full_name_local}
- Preserve emotional tone: {brand.emotional_tone}

**Translation Guidelines:**
- Natural phrasing (not literal word-for-word)
- Culturally appropriate business terminology
- Maintain storytelling rhythm
- Preserve technical accuracy
- Keep paragraph structure similar

Ensure the translation reads as if originally written by a native speaker, not as a translation.
```

### Step 4: Content Storage
```sql
-- Store generated content
INSERT INTO generated_content (
    content_id,
    brand_id,
    founder_id,
    template_id,
    content_type,
    language,
    title,
    slug,
    body_content,
    excerpt,
    meta_description,
    word_count,
    generation_model,
    generation_date,
    generation_prompt,
    publication_status,
    quality_score
) VALUES (
    uuid_generate_v4(),
    '{brand_id}',
    '{founder_id}',
    '{template_id}',
    'Article',
    'ENG',
    'How Arkady Volozh Built Russia''s Answer to Google',
    'arkady-volozh-yandex-story',
    '{generated_body_content}',
    '{generated_excerpt}',
    '{generated_meta_description}',
    1487,
    'claude-sonnet-4-20250514',
    NOW(),
    '{full_prompt_used}',
    'Draft',
    8
);
```

---

## Implementation Roadmap

### Phase 1: Core Schema (Weeks 1-2)
**Objective**: Establish foundational database structure

- ✅ Implement BRANDS, FOUNDERS, MARKETS tables
- ✅ Implement BRAND_FOUNDERS bridge table
- ✅ Implement MILESTONES relationship table
- ✅ Focus on Tier 1 essential fields only
- ✅ Manual data entry for 10-15 brands
- ✅ Validate foreign key relationships

**Success Criteria**: 
- 10-15 brands with complete Tier 1 data
- All foreign keys properly linked
- No orphaned records

### Phase 2: Content Generation (Weeks 3-4)
**Objective**: Enable AI-powered content creation

- ✅ Implement CONTENT_TEMPLATES table
- ✅ Implement GENERATED_CONTENT table
- ✅ Create 3-5 standard templates:
  - Long-form article (1500 words)
  - Founder profile (800 words)
  - Social media post (280 characters)
  - Case study (1000 words)
  - Executive summary (500 words)
- ✅ Test AI generation with manual review
- ✅ Document prompt refinements

**Success Criteria**:
- 5 content templates functional
- Generate 20+ pieces of content
- 80%+ require only minor edits

### Phase 3: Markets & Translation (Weeks 5-6)
**Objective**: Enable multilingual content

- ✅ Populate MARKETS table with cultural context
- ✅ Implement translation workflow
- ✅ Test Russian content generation
- ✅ Test Chinese content generation
- ✅ Validate cultural appropriateness with native speakers

**Success Criteria**:
- 5+ markets with complete cultural data
- 10+ translated articles per language
- Native speaker validation: 8/10 quality score

### Phase 4: Optimization (Weeks 7-8)
**Objective**: Refine data model and improve quality

- ✅ Add Tier 2 fields based on content needs
- ✅ Refine AI prompts based on output analysis
- ✅ Build content approval workflow
- ✅ Implement quality scoring system
- ✅ Add SEO optimization fields

**Success Criteria**:
- Content quality score: 8+/10 average
- Publication workflow: <24 hours
- SEO metrics: defined and tracked

---

## Success Metrics

### Data Quality Metrics
| Metric | Target | Measurement |
|--------|--------|-------------|
| **Completeness Score** | >85% | % of Tier 1 fields filled per brand |
| **Data Accuracy** | >95% | % of facts verified against sources |
| **Cultural Sensitivity** | >8/10 | Native speaker validation score |
| **Multilingual Coverage** | 3 languages | Active languages per brand |

### Content Output Metrics
| Metric | Target | Measurement |
|--------|--------|-------------|
| **Generation Speed** | <10 min | Time from data to draft |
| **Content Quality** | >8/10 | Human editorial rating |
| **Edit Rate** | <20% | % requiring substantial revision |
| **Translation Quality** | >8/10 | Native speaker rating |
| **Content Variety** | 5+ types | Unique formats per brand |

### Business Impact Metrics
| Metric | Target | Measurement |
|--------|--------|-------------|
| **User Engagement** | >3 min | Average time on page |
| **Scroll Depth** | >70% | % of article read |
| **SEO Traffic** | +50% MoM | Organic search visits |
| **Lead Generation** | 5% | Content → trial conversion |
| **Content Velocity** | 20+/week | Published articles per week |

---

## Database Relationships Summary

### Entity Relationships (ERD)
```
BRANDS (1) ←→ (M) BRAND_FOUNDERS (M) ←→ (1) FOUNDERS
   │                                              │
   │                                              │
   └────→ (M) MILESTONES (M) ←────────────────────┘
              │
              └────→ (1) MARKETS

BRANDS (1) ←→ (M) GENERATED_CONTENT (M) ←→ (1) FOUNDERS
                      │
                      └────→ (1) CONTENT_TEMPLATES
```

### Cardinality Rules
- **BRANDS ↔ FOUNDERS**: Many-to-many (via BRAND_FOUNDERS)
  - One brand can have multiple founders
  - One founder can be involved in multiple brands
  
- **BRANDS ↔ MILESTONES**: One-to-many
  - One brand has many milestones
  - One milestone belongs to one brand
  
- **FOUNDERS ↔ MILESTONES**: One-to-many (nullable)
  - One founder can be associated with many milestones
  - One milestone may or may not be founder-specific
  
- **MARKETS ↔ MILESTONES**: One-to-many
  - One market context applies to many milestones
  - One milestone occurs in one market
  
- **BRANDS ↔ GENERATED_CONTENT**: One-to-many
  - One brand has many pieces of generated content
  - One piece of content is about one brand
  
- **CONTENT_TEMPLATES ↔ GENERATED_CONTENT**: One-to-many
  - One template generates many pieces of content
  - One piece of content uses one template

---

## Notes on AI Content Generation

### What Makes Good AI Training Data

1. **Narrative Structure**: Not just facts, but "before/after", "challenge/solution", "context/significance"
   - ❌ "Founded company in 1997"
   - ✅ "Founded in 1997 after witnessing Western search engines fail to understand Russian grammar during post-Soviet internet boom"

2. **Emotional Hooks**: Personal sacrifices, turning points, proud achievements
   - ❌ "Changed careers"
   - ✅ "Left secure research position for entrepreneurial uncertainty"

3. **Cultural Bridges**: Explicit cultural context that Western audiences might miss
   - ❌ "Based in Moscow"
   - ✅ "Based in Moscow during 1990s chaos, building tech infrastructure from scratch"

4. **Concrete Details**: Specific moments, quotes, sensory descriptions where available
   - ❌ "Successful IPO"
   - ✅ "NASDAQ bell ringing moment validated Russian tech globally"

5. **Multiple Perspectives**: Brand + Founder + Market context creates depth
   - Combine all three for richest narratives

### What AI Struggles With (Requires Human Input)

1. **Nuanced Cultural Translation**: Idioms, business norms that don't translate literally
   - Example: "guanxi" (关系) requires cultural explanation, not just "relationships"

2. **Emotional Authenticity**: Distinguishing genuine struggles from manufactured drama
   - Human editor must verify "biggest_challenge" is real, not embellished

3. **Source Verification**: Ensuring "facts" aren't hallucinated
   - Always populate `source_citations` in MILESTONES table

4. **Tonal Balance**: Inspirational without being promotional
   - Human review ensures avoiding "marketing speak"

5. **Competitive Sensitivity**: What to say/not say about competitors
   - `key_competitors` field requires strategic curation

---

## Example: Complete Data Population for Yandex

### BRANDS Table
```sql
brand_id: uuid-yandex-001
brand_name_primary: "Yandex"
brand_name_local: "Яндекс"
year_founded: 1997
headquarters_country: "RUS"
industry_primary: "Technology"
origin_story_brief: "Founded to create Russian-language search when Western engines failed at Cyrillic"
founding_challenge: "Western search engines couldn't handle Russian grammar complexity"
cultural_context: "Post-Soviet tech renaissance, national pride in local innovation"
storytelling_angle: "Cultural champion, Tech innovator"
emotional_tone: "Triumphant, Resilient"
content_themes: ["Innovation", "Cultural pride", "David vs Goliath"]
```

### FOUNDERS Table
```sql
founder_id: uuid-volozh-001
full_name_primary: "Arkady Volozh"
full_name_local: "Аркадий Волож"
birth_year: 1964
birth_country: "KAZ"
origin_story: "Grew up in Soviet Kazakhstan, witnessed tech limitations of command economy"
motivation_why: "Frustration with Western tech ignoring Russian language complexity"
biggest_challenge: "Building tech company in 1990s Russia with zero infrastructure"
personal_turning_point: "Realized Russian internet needed native solutions after 1998 crisis"
cultural_identity: ["Soviet", "Russian", "Jewish", "Kazakh"]
```

### BRAND_FOUNDERS Table
```sql
brand_id: uuid-yandex-001
founder_id: uuid-volozh-001
role: "Co-founder & CEO"
is_primary_founder: TRUE
founding_contribution: "Technical vision and product development"
```

### MARKETS Table
```sql
market_id: uuid-market-rus-001
country_code: "RUS"
country_name_en: "Russia"
country_name_local: "Россия"
business_culture_notes: "Relationship-driven, longer sales cycles, importance of personal trust"
language_primary: "Russian"
diaspora_size_estimate: 10000000
diaspora_concentration: ["USA", "DEU", "ISR", "GBR"]
```

### MILESTONES Table
```sql
milestone_id: uuid-milestone-001
brand_id: uuid-yandex-001
founder_id: uuid-volozh-001
market_id: uuid-market-rus-001
milestone_type: "IPO"
milestone_date: 2011-05-24
milestone_title_en: "Yandex IPO on NASDAQ"
significance_why_matters: "Validated Russian tech on global stage, created blueprint for future IPOs"
context_before: "Russian tech seen as isolated, unable to compete globally"
context_after: "Opened doors for Russian tech internationally"
emotional_arc: "Underdog proving doubters wrong"
storytelling_priority: 9
```

### Query Result Enables:
- "Write 1500-word article about Arkady Volozh's journey for diaspora investors"
- "Create 300-word Russian social post about Yandex IPO moment"
- "Generate founder profile emphasizing cultural bridge narrative"

Each query produces contextually rich, culturally sensitive content from structured data.

---

## Conclusion

This database structure enables:
- ✅ **Scalable content generation** across brands, founders, and languages
- ✅ **Cultural sensitivity** through explicit context fields
- ✅ **Narrative richness** via structured storytelling elements
- ✅ **Relationship tracking** between brands, founders, markets, and milestones
- ✅ **Quality control** through versioning and human review workflows
- ✅ **Multilingual support** with proper foreign key relationships

The framework balances automation efficiency with editorial quality, ensuring Brandmine's Global South stories maintain authenticity and cultural nuance.
