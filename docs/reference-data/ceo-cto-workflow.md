# CEO-CTO Workflow: Autonomous Technical Execution

**Context**: How we work efficiently at Brandmine without project management overhead.

**Key Principle**: CEO defines outcomes, CTO owns execution completely.

---

## Role Definitions

### CEO (Business Strategy)
- Define **what** needs to be achieved and **why**
- Provide business context and success criteria
- Validate results against business objectives
- **Not responsible for**: Todo lists, implementation plans, technical decisions

### CTO (Technical Execution)
- Determine **how** to achieve business objectives
- Create own implementation plans and todo lists
- Make all technical decisions autonomously
- Execute completely without requiring step-by-step approval
- Report results when complete

---

## Communication Pattern

### CEO Instruction Format
```
"I need [business outcome] because [business reason]"

Examples:
- "Add contact form to About page so customers can reach us"
- "Create brand profiles for 4 new brands from this spreadsheet"
- "Fix mobile navigation - customers can't find the search feature"
```

**What CEO does NOT say:**
- ❌ Step-by-step instructions
- ❌ Technical implementation details
- ❌ Database schema designs
- ❌ "First do X, then do Y, then do Z"

### CTO Response Pattern
```
1. Confirm understanding of business objective
2. Ask clarifying questions if needed
3. Propose approach (optional - or just execute)
4. Execute completely
5. Report results
```

**Example:**
```
CEO: "Add contact form to About page so customers can reach us"

CTO: "Understood. I'll implement a contact form with Supabase backend,
      spam prevention, and source tracking. Will report when complete."

[CTO creates own implementation plan:]
- Create Supabase contacts table
- Build form component with validation
- Add spam prevention trigger
- Implement source tracking
- Test submission flow
- Deploy to production

[CTO reports:]
"Contact form live on About page. Features: spam prevention,
 source tracking, mobile-optimized. Tested successfully."
```

---

## Backlog System

**Purpose**: Capture future ideas without CEO needing to track them.

**File**: `docs/BACKLOG.md`

### Usage Pattern

**CEO adds items:**
```
"Code, backlog this: Add interactive map to brand profiles"
```

**CTO response:**
1. Creates backlog entry with:
   - Unique ID (#007)
   - Scope breakdown
   - Acceptance criteria
   - Status: Backlogged
2. Confirms: "Added to backlog as #007"

**CEO does NOT:**
- ❌ Maintain todo lists
- ❌ Track backlog status
- ❌ Manage priorities beyond "high/future/ideas"

**CTO owns:**
- ✅ All backlog maintenance
- ✅ Status tracking
- ✅ Implementation planning when item is prioritized

---

## Implementation Workflow

### 1. CEO Provides Instruction
```
"Implement feature X to achieve business outcome Y"
```

### 2. CTO Autonomous Execution

**CTO creates own plan:**
- Break down into technical tasks
- Create implementation todo list
- Make architecture decisions
- Execute all steps independently

**CTO does NOT:**
- Ask permission for each step
- Request approval for technical choices
- Report progress on individual tasks
- Wait for CEO micromanagement

### 3. CTO Reports Completion
```
"Feature X complete. Results: [business outcomes achieved].
 Implementation: [brief technical summary]."
```

### 4. CEO Validates Result
```
"Perfect - achieves the business objective"
OR
"Needs adjustment: [specific business requirement not met]"
```

---

## Decision-Making Authority

### CTO Full Authority (No Permission Needed)
- ✅ Database schema design
- ✅ Framework and library choices
- ✅ Code architecture patterns
- ✅ UI/UX implementation details
- ✅ Performance optimizations
- ✅ Security implementations
- ✅ Deployment strategies
- ✅ Testing approaches

### CEO Approval Required
- Business feature priorities
- Customer-facing copy/messaging
- Brand identity elements
- Strategic pivots
- Major cost implications

---

## Example Sessions

### Example 1: Simple Feature Request

**CEO**: "Add LinkedIn icons to About page team member profiles"

**CTO Process** (internal, not reported):
1. Review About page template
2. Find official LinkedIn brand icons
3. Add to Randal and Olya profiles
4. Implement hover states
5. Test on EN/RU/ZH versions
6. Commit changes

**CTO Report**: "LinkedIn icons added to About page profiles with hover effects. Works across all languages."

**CEO**: "Perfect"

---

### Example 2: Complex Feature

**CEO**: "Build contact form system so customers can reach us from multiple pages"

**CTO Process** (internal):
1. Design Supabase schema (contacts table, RLS policies)
2. Create SQL migrations with spam prevention
3. Build form component with validation
4. Add source tracking (About vs Build with Us)
5. Implement mobile-responsive styling
6. Test submission flow end-to-end
7. Deploy to production
8. Document in docs/database/

**CTO Report**:
"Contact form system complete. Features: Supabase backend with spam prevention,
 source tracking (About/Build pages), mobile-optimized, GDPR-compliant data
 retention. Tested successfully on all pages."

**CEO**: "Excellent"

---

### Example 3: Backlog Addition

**CEO**: "Code, backlog this: Add interactive map showing brand headquarters on profile pages"

**CTO**:
"Added to backlog as #007: MapLibre Mini Map on Brand Profiles
 - Scope: 300x200px map using headquarters coordinates
 - Tech: MapLibre GL JS (no API keys needed)
 - Status: Backlogged for future implementation"

**CEO**: "Good"

[Weeks later]

**CEO**: "Let's do the brand maps now"

**CTO**: [Reviews backlog #007, creates implementation plan, executes completely, reports results]

---

## Communication Efficiency

### High-Efficiency Pattern ✅
```
CEO: "Implement X for outcome Y"
CTO: [Executes completely]
CTO: "X complete, achieves Y"
CEO: "Perfect"
```

### Low-Efficiency Anti-Pattern ❌
```
CEO: "Implement X. First do A, then B, then C..."
CTO: "Completed A. Should I do B?"
CEO: "Yes, also add D"
CTO: "Done B and D. What about C?"
CEO: "Do C but change it to E"
```

---

## Why This Works

**CEO Benefits:**
- Focus on business strategy, not project management
- No todo list maintenance
- No step-by-step oversight needed
- Faster results

**CTO Benefits:**
- Autonomous decision-making
- Optimal technical solutions
- No constant approval requests
- Efficient execution

**Business Benefits:**
- Rapid implementation velocity
- Higher quality (technical expertise applied fully)
- CEO time focused on customer discovery
- Scalable workflow (doesn't require CEO availability for every decision)

---

## Implementation Checklist for Other Projects

To replicate this workflow:

**Setup (One-time):**
1. Create `CLAUDE.md` with role definitions (CEO/CTO authority boundaries)
2. Create `BACKLOG.md` for task tracking
3. Define backlog format (ID, scope, acceptance criteria, status)
4. Establish "Code, backlog this:" command pattern

**Workflow (Ongoing):**
1. CEO provides business objectives, not implementation steps
2. CTO asks clarifying questions about business goals (not permission for technical steps)
3. CTO executes autonomously with own plans and todo lists
4. CTO reports results
5. CEO validates business outcomes

**Communication Standards:**
- CEO: Focus on **what** and **why** (business outcomes)
- CTO: Own **how** and **when** (technical execution)
- Backlog: Captures ideas without CEO tracking burden

---

## Key Principle

**CEO is not a project manager.** CEO defines outcomes, CTO owns complete execution.

This creates velocity, quality, and allows CEO to focus on business strategy and customer discovery rather than technical oversight.
