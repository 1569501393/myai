# OpenCode Skill Shortcuts & Best Practices

> Comprehensive guide to skill management, shortcuts, and best practices for OpenCode AI assistant.

## 1. Skill Shortcuts & Invocation

### 1.1 Automatic Skill Triggering

Skills are automatically loaded when the user's request matches the skill's `description`. OpenCode analyzes the description to determine which skill to use.

```yaml
---
name: pdf-editor
description: Comprehensive PDF manipulation including merge, split, rotate, and watermark. Use when user needs to work with PDF files for: (1) Merging multiple PDFs, (2) Splitting a PDF, (3) Rotating pages, (4) Adding watermarks, (5) Extracting pages
---
```

**Trigger keywords:** Merge/split PDF, rotate pages, add watermark, extract text from PDF

### 1.2 Manual Skill Loading

Use the `skill` tool to explicitly load a skill:

```bash
# Load a specific skill
skill name="pdf"

# After loading, skill instructions become available in context
```

### 1.3 Skill Discovery

```bash
# Find skills for specific tasks
npx -y @lobehub/market-cli skills search --q "pdf"

# Search by category
npx -y @lobehub/market-cli skills search --q "deploy" --category development

# Sort by popularity
npx -y @lobehub/market-cli skills search --q "api" --sort installCount
```

## 2. Skill Structure

### 2.1 Directory Layout

```
skill-name/
├── SKILL.md              # Required: skill definition
├── scripts/              # Optional: executable code
├── references/           # Optional: documentation to load as needed
└── assets/               # Optional: files used in output
```

### 2.2 SKILL.md Format

```yaml
---
name: skill-name
description: Clear description of what the skill does and when to use it
---

# Skill Name

## Overview
Brief description of the skill

## Usage
How to use this skill

## Examples
Code examples showing correct usage
```

### 2.3 Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Skill identifier (lowercase, hyphens) |
| `description` | Yes | Triggers skill loading; be comprehensive |

**Important:** The `description` field is the PRIMARY triggering mechanism. Include all "when to use" information here, not in the body.

## 3. Best Practices

### 3.1 Concise is Key

The context window is a shared resource. Only add information that Codex doesn't already know.

**Do:**
- Prefer concise examples over verbose explanations
- Challenge each piece of information: "Does Codex really need this?"
- Keep SKILL.md under 500 lines

**Don't:**
- Include redundant explanations
- Add information that the model already knows
- Create auxiliary documentation files

### 3.2 Progressive Disclosure

Skills use a three-level loading system:

1. **Metadata** (~100 words) - Always in context
2. **SKILL.md body** (<5k words) - When skill triggers
3. **Bundled resources** - As needed

```markdown
# PDF Processing

## Quick Start
Extract text with pdfplumber:
[code example]

## Advanced Features
- Form filling: See [FORMS.md](FORMS.md)
- API reference: See [REFERENCE.md](REFERENCE.md)
```

Codex loads reference files only when needed.

### 3.3 Appropriate Degrees of Freedom

Match specificity to task fragility:

| Freedom Level | Use When |
|--------------|----------|
| High (text) | Multiple valid approaches, context-dependent |
| Medium (pseudocode) | Preferred pattern exists, some variation OK |
| Low (specific scripts) | Fragile operations, consistency critical |

### 3.4 Bundle Resources Wisely

| Resource Type | When to Use | Example |
|--------------|-------------|---------|
| `scripts/` | Deterministic reliability needed | `rotate_pdf.py` |
| `references/` | Codex should reference while working | Schema docs, API specs |
| `assets/` | Files used in output | Templates, logos |

### 3.5 Skill Naming

- Use lowercase, digits, and hyphens only
- Keep under 64 characters
- Prefer short, verb-led phrases
- Name folder exactly as skill name

```bash
# Good names
code-review
pdf-editor
deploy-aws

# Bad names
CodeReviewSkill  # PascalCase
review_code      # underscore
```

## 4. Creating Custom Skills

### 4.1 Skill Creation Process

1. **Understand** - Get concrete examples of usage
2. **Plan** - Identify reusable contents (scripts, references, assets)
3. **Initialize** - Run `init_skill.py`
4. **Edit** - Implement resources and write SKILL.md
5. **Package** - Run `package_skill.py`
6. **Iterate** - Based on real usage

### 4.2 Initialization

```bash
# Create new skill
scripts/init_skill.py my-skill --path skills/public

# With specific resources
scripts/init_skill.py my-skill --path skills/public --resources scripts,references
```

### 4.3 Validation & Packaging

```bash
# Package (auto-validates)
scripts/package_skill.py path/to/skill-folder

# With output directory
scripts/package_skill.py path/to/skill-folder ./dist
```

The packager validates:
- YAML frontmatter format
- Required fields present
- Naming conventions
- Description completeness

## 5. Available Skills Reference

| Skill | Description |
|-------|-------------|
| `find-skills` | Discover and install agent skills |
| `skill-vetter` | Security vetting for installing skills |
| `github` | Interact with GitHub (issues, PRs, CI) |
| `pdf` | PDF operations (read, merge, split, etc.) |
| `pptx` | PowerPoint operations |
| `summarize` | Summarize URLs, podcasts, and files |
| `sc-refactor-review` | Code review, refactoring, bug hunt |
| `weather` | Get weather forecasts |
| `playwright-cli` | Browser automation |
| `tmux` | Remote-control tmux sessions |
| `agent-docs` | Create AI-optimized documentation |
| `exa-web-search-free` | Free AI web/code search |
| `draft-release` | Draft releases with changelog |
| `discover-testing` | Discover testing skills |
| `skill-creator` | Create/update AgentSkills |
| `hello-generator` | Generate friendly greetings |

## 6. Common Errors & Solutions

| Error | Cause | Solution |
|-------|-------|----------|
| Skill not loading | YAML frontmatter format error | Ensure `---` delimiters correct |
| Instructions ignored | Context overload | Keep skill concise |
| Inconsistent behavior | Model differences | Test with multiple models |
| Path errors | Wrong installation location | Check agent path configuration |

## 7. Integration with Workflow

```
Development Phase
├─ Before: Architect Agent (design decisions)
├─ During: TDD Guide Agent (test-driven development)
├─ Before commit: Code Review Skill
└─ Deploy: Kubernetes Plugin

Team Collaboration
├─ Shared team skills in internal Git
├─ Semantic versioning
└─ Regular updates matching project changes
```

## 8. Tips & Tricks

1. **Trigger keywords matter**: Write comprehensive descriptions with specific keywords
2. **Reference files**: Use for large documentation (>10k words), load as needed
3. **Test skills**: Run actual scripts to ensure correctness
4. **Iterate**: Update based on real usage feedback
5. **Avoid duplication**: Information lives in SKILL.md OR reference files, not both

---

*This guide covers OpenCode skill shortcuts and best practices. For more details, see the official OpenCode documentation.*