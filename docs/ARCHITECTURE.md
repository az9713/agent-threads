# Architecture Guide - Thread-Based Engineering Plugin

This document explains the technical architecture of the Thread-Based Engineering plugin.
It's designed for developers who want to understand how the plugin works internally.

---

## Table of Contents

1. [High-Level Overview](#1-high-level-overview)
2. [How Claude Code Plugins Work](#2-how-claude-code-plugins-work)
3. [Plugin Component Architecture](#3-plugin-component-architecture)
4. [Data Flow Diagrams](#4-data-flow-diagrams)
5. [Component Deep Dives](#5-component-deep-dives)
6. [Integration Points](#6-integration-points)
7. [Design Decisions](#7-design-decisions)
8. [Security Considerations](#8-security-considerations)

---

## 1. High-Level Overview

### What is This Plugin?

This plugin is an **educational toolkit** that teaches the Thread-Based Engineering framework
through practical, executable examples. It doesn't add new functionality to Claude Code -
instead, it provides pre-built commands, agents, and scripts that demonstrate concepts.

### Architecture Philosophy

```
┌─────────────────────────────────────────────────────────────┐
│                    USER INTERFACE                           │
│  (Claude Code CLI - command line terminal)                  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    PLUGIN LAYER                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐    │
│  │ Commands │  │  Agents  │  │  Skills  │  │  Hooks   │    │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘    │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    SCRIPTS LAYER                            │
│  (Standalone bash scripts for parallel/fusion/etc)          │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    CLAUDE CODE ENGINE                       │
│  (The AI model and tool execution system)                   │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. How Claude Code Plugins Work

### Plugin Discovery

When you run `claude /plugin install ./agent-threads`, Claude Code:

1. **Looks for `.claude-plugin/plugin.json`** - This file MUST exist
2. **Reads the manifest** - Gets plugin name, version, description
3. **Scans directories** - Finds commands, agents, skills, hooks
4. **Registers components** - Makes them available in Claude Code

### Directory Structure Rules

Claude Code follows these conventions (case-sensitive):

| Directory | What Goes Here | File Format |
|-----------|---------------|-------------|
| `commands/` | Slash commands | `.md` files with YAML frontmatter |
| `agents/` | Custom sub-agents | `.md` files with YAML frontmatter |
| `skills/` | Background knowledge | `<name>/SKILL.md` pattern |
| `hooks/` | Event handlers | `hooks.json` file |
| `scripts/` | Helper scripts | `.sh` (bash) or `.ps1` (PowerShell) |

### Component Loading Order

```
1. plugin.json is read first (mandatory)
2. hooks/hooks.json is loaded (if exists)
3. commands/*.md are registered
4. agents/*.md are registered
5. skills/*/SKILL.md are registered
```

---

## 3. Plugin Component Architecture

### 3.1 Commands Architecture

Commands are the primary user interface to the plugin.

```
┌─────────────────────────────────────────────────────────┐
│                    COMMAND STRUCTURE                    │
├─────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────┐   │
│  │              YAML FRONTMATTER                   │   │
│  │  - description: What the command does           │   │
│  │  - allowed-tools: Tools Claude can use          │   │
│  │  - model: Optional model override               │   │
│  └─────────────────────────────────────────────────┘   │
│                         │                               │
│                         ▼                               │
│  ┌─────────────────────────────────────────────────┐   │
│  │              MARKDOWN CONTENT                   │   │
│  │  - Explanation text                             │   │
│  │  - Code examples                                │   │
│  │  - Instructions for Claude                      │   │
│  │  - $ARGUMENTS placeholder                       │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

**Example Command Flow:**

```
User types: /agent-threads:base src/
                   │
                   ▼
Claude Code finds: commands/base.md
                   │
                   ▼
Parses frontmatter: allowed-tools: Read, Grep, Glob, Bash
                   │
                   ▼
Replaces $ARGUMENTS with "src/"
                   │
                   ▼
Claude receives the processed prompt
                   │
                   ▼
Claude executes using allowed tools only
```

### 3.2 Agents Architecture

Agents are specialized AI personas with restricted tool access.

```
┌────────────────────────────────────────────────────────┐
│                    AGENT STRUCTURE                     │
├────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────┐ │
│  │              YAML FRONTMATTER                    │ │
│  │  - name: Agent identifier                        │ │
│  │  - description: What the agent does              │ │
│  │  - tools: Allowed tools (subset)                 │ │
│  │  - model: haiku, sonnet, or opus                 │ │
│  └──────────────────────────────────────────────────┘ │
│                         │                              │
│                         ▼                              │
│  ┌──────────────────────────────────────────────────┐ │
│  │              SYSTEM PROMPT                       │ │
│  │  - Agent's role and personality                  │ │
│  │  - Guidelines for behavior                       │ │
│  │  - Output format expectations                    │ │
│  └──────────────────────────────────────────────────┘ │
└────────────────────────────────────────────────────────┘
```

**Agent Hierarchy:**

```
Primary Claude (your conversation)
       │
       ├──▶ @researcher (haiku, read-only, fast)
       │         └── Explores codebase
       │
       ├──▶ @reviewer (sonnet, read-only, thorough)
       │         └── Analyzes code quality
       │
       ├──▶ @builder (sonnet, read/write)
       │         └── Implements changes
       │
       └──▶ @validator (haiku, bash access)
                 └── Runs tests and checks
```

**Model Selection Rationale:**

| Agent | Model | Why |
|-------|-------|-----|
| researcher | haiku | Speed over depth for exploration |
| reviewer | sonnet | Balance of speed and analysis |
| builder | sonnet | Needs quality code generation |
| validator | haiku | Simple test execution |

### 3.3 Skills Architecture

Skills provide background knowledge that Claude can access.

```
skills/
└── thread-patterns/
    ├── SKILL.md        # Main skill definition
    └── examples.md     # Supplementary content

SKILL.md Structure:
┌──────────────────────────────────────────┐
│  YAML Frontmatter                        │
│  - name: skill identifier                │
│  - description: when to use              │
│  - allowed-tools: tools available        │
├──────────────────────────────────────────┤
│  Markdown Content                        │
│  - Knowledge and guidelines              │
│  - Decision trees                        │
│  - Reference information                 │
└──────────────────────────────────────────┘
```

### 3.4 Hooks Architecture

Hooks intercept events during Claude Code execution.

```
┌─────────────────────────────────────────────────────────┐
│                    HOOKS SYSTEM                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│   Event Flow:                                           │
│                                                         │
│   Claude wants to stop                                  │
│          │                                              │
│          ▼                                              │
│   ┌─────────────────┐                                   │
│   │   Stop Hook     │ ──▶ runs ralph-loop.sh            │
│   └─────────────────┘                                   │
│          │                                              │
│          ▼                                              │
│   ┌─────────────────┐                                   │
│   │ Script checks:  │                                   │
│   │ - Tests pass?   │                                   │
│   │ - TODOs done?   │                                   │
│   │ - Lint clean?   │                                   │
│   └─────────────────┘                                   │
│          │                                              │
│          ├──▶ All pass: exit 0 (allow stop)             │
│          │                                              │
│          └──▶ Fail: output JSON (continue working)      │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**hooks.json Structure:**

```json
{
  "hooks": {
    "EVENT_NAME": [
      {
        "matcher": "optional pattern",
        "hooks": [
          {
            "type": "command",
            "command": "script to run",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

**Available Hook Events:**

| Event | When It Fires | Use Case |
|-------|--------------|----------|
| `PreToolUse` | Before any tool call | Validate inputs |
| `PostToolUse` | After any tool call | Log changes |
| `Stop` | When Claude tries to stop | Ralph Wiggum pattern |
| `Notification` | System notifications | Alerting |

---

## 4. Data Flow Diagrams

### 4.1 Base Thread Data Flow

```
┌─────────┐     ┌─────────────────┐     ┌─────────────┐
│  User   │────▶│  Claude Code    │────▶│   Claude    │
│ Prompt  │     │  (parses cmd)   │     │   (works)   │
└─────────┘     └─────────────────┘     └─────────────┘
                                               │
                                               ▼
                                        ┌─────────────┐
                                        │ Tool Calls  │
                                        │ (Read,Grep) │
                                        └─────────────┘
                                               │
                                               ▼
                                        ┌─────────────┐
                                        │   Result    │
                                        │  to User    │
                                        └─────────────┘
```

### 4.2 Parallel Thread Data Flow

```
                        ┌─────────────────┐
                   ┌───▶│ Claude Agent 1  │───┐
                   │    └─────────────────┘   │
┌─────────┐        │    ┌─────────────────┐   │    ┌─────────┐
│parallel-│────────┼───▶│ Claude Agent 2  │───┼───▶│ Results │
│runner.sh│        │    └─────────────────┘   │    │  Files  │
└─────────┘        │    ┌─────────────────┐   │    └─────────┘
                   └───▶│ Claude Agent 3  │───┘
                        └─────────────────┘

                        (all run in parallel)
```

### 4.3 Chained Thread Data Flow

```
┌─────────┐     ┌─────────────┐     ┌─────────┐     ┌─────────────┐
│ Phase 1 │────▶│   Human     │────▶│ Phase 2 │────▶│   Human     │
│ (Plan)  │     │  Review     │     │ (Build) │     │  Review     │
└─────────┘     └─────────────┘     └─────────┘     └─────────────┘
                                                            │
                                                            ▼
                                                    ┌─────────────┐
                                                    │  Phase 3    │
                                                    │  (Test)     │
                                                    └─────────────┘
```

### 4.4 Fusion Thread Data Flow

```
                     ┌─────────────┐
                ┌───▶│ Solution 1  │───┐
                │    └─────────────┘   │
┌────────┐      │    ┌─────────────┐   │    ┌────────────┐    ┌────────┐
│ Same   │──────┼───▶│ Solution 2  │───┼───▶│ Aggregator │───▶│  Best  │
│ Prompt │      │    └─────────────┘   │    │  (Claude)  │    │ Result │
└────────┘      │    ┌─────────────┐   │    └────────────┘    └────────┘
                └───▶│ Solution 3  │───┘
                     └─────────────┘
```

### 4.5 Big Thread Data Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    PRIMARY CLAUDE                           │
│                                                             │
│   ┌──────────┐      ┌──────────┐      ┌──────────┐         │
│   │@researcher│─────▶│@reviewer │─────▶│@validator│         │
│   └──────────┘      └──────────┘      └──────────┘         │
│        │                 │                 │                │
│        ▼                 ▼                 ▼                │
│   ┌──────────┐      ┌──────────┐      ┌──────────┐         │
│   │ Findings │      │ Issues   │      │ Results  │         │
│   └──────────┘      └──────────┘      └──────────┘         │
│                                                             │
│                          │                                  │
│                          ▼                                  │
│                   ┌─────────────┐                           │
│                   │ Synthesized │                           │
│                   │   Report    │                           │
│                   └─────────────┘                           │
└─────────────────────────────────────────────────────────────┘
```

### 4.6 Long Thread Data Flow (Ralph Wiggum)

```
┌───────────────────────────────────────────────────────────────────┐
│                                                                   │
│  ┌─────────┐     ┌───────────────┐     ┌─────────────┐           │
│  │ Claude  │────▶│ Tries to Stop │────▶│ Stop Hook   │           │
│  │ Works   │     └───────────────┘     │ (ralph.sh)  │           │
│  └─────────┘                           └─────────────┘           │
│       ▲                                      │                    │
│       │                                      ▼                    │
│       │                              ┌─────────────────┐          │
│       │                              │ Tests passing?  │          │
│       │                              │ TODOs done?     │          │
│       │                              │ Lint clean?     │          │
│       │                              └─────────────────┘          │
│       │                                      │                    │
│       │         ┌────────────────────────────┼────────────────┐   │
│       │         │                            │                │   │
│       │         ▼                            ▼                │   │
│       │    ┌─────────┐                 ┌─────────┐            │   │
│       │    │   NO    │                 │   YES   │            │   │
│       │    │ (fail)  │                 │ (pass)  │            │   │
│       │    └─────────┘                 └─────────┘            │   │
│       │         │                            │                │   │
│       │         ▼                            ▼                │   │
│       │  ┌─────────────┐            ┌─────────────┐           │   │
│       └──│ Continue    │            │ Exit 0      │           │   │
│          │ Message     │            │ (Stop OK)   │           │   │
│          └─────────────┘            └─────────────┘           │   │
│                                                               │   │
└───────────────────────────────────────────────────────────────┘   │
                                                                    │
                              LOOP UNTIL DONE                       │
```

### 4.7 Zero-Touch Thread Data Flow

```
┌─────────┐     ┌─────────────────────────────────────────────┐
│  User   │────▶│           VALIDATION PIPELINE               │
│ Prompt  │     │                                             │
└─────────┘     │  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐    │
                │  │ Lint │─▶│Types │─▶│Tests │─▶│Build │    │
                │  └──────┘  └──────┘  └──────┘  └──────┘    │
                │      │         │         │         │        │
                │      ▼         ▼         ▼         ▼        │
                │  ┌──────────────────────────────────────┐   │
                │  │      ALL MUST PASS                   │   │
                │  └──────────────────────────────────────┘   │
                │                    │                        │
                └────────────────────┼────────────────────────┘
                                     │
                    ┌────────────────┼────────────────┐
                    │                │                │
                    ▼                ▼                ▼
             ┌──────────┐     ┌──────────┐    ┌──────────┐
             │ ANY FAIL │     │ ALL PASS │    │  NO      │
             │ Exit 1   │     │ Exit 0   │    │ CHECKS   │
             │ (Review) │     │ (Z-Trust)│    │ (Warn)   │
             └──────────┘     └──────────┘    └──────────┘
```

---

## 5. Component Deep Dives

### 5.1 The Plugin Manifest (plugin.json)

The manifest is the **identity card** of the plugin.

```json
{
  "name": "agent-threads",
  "description": "Thread-Based Engineering examples...",
  "version": "1.0.0",
  "author": {
    "name": "Thread Engineering Demo"
  }
}
```

**Required Fields:**

| Field | Type | Purpose |
|-------|------|---------|
| `name` | string | Unique identifier, used in command prefixes |
| `description` | string | What the plugin does |
| `version` | string | Semantic version (major.minor.patch) |

**Optional Fields:**

| Field | Type | Purpose |
|-------|------|---------|
| `author` | object | Creator information |
| `homepage` | string | Documentation URL |
| `repository` | string | Source code URL |

### 5.2 Command Frontmatter Deep Dive

```yaml
---
description: Short description for help text
allowed-tools: Read, Grep, Glob, Bash
model: sonnet
---
```

**Allowed Tools Reference:**

| Tool | What It Does | Risk Level |
|------|--------------|------------|
| `Read` | Read file contents | Low |
| `Grep` | Search file contents | Low |
| `Glob` | Find files by pattern | Low |
| `Write` | Create/overwrite files | High |
| `Edit` | Modify existing files | High |
| `Bash` | Run shell commands | Highest |
| `Task` | Spawn sub-agents | Medium |

**Model Options:**

| Model | Best For | Speed | Cost |
|-------|----------|-------|------|
| `haiku` | Quick tasks | Fastest | Lowest |
| `sonnet` | Balanced work | Medium | Medium |
| `opus` | Complex reasoning | Slowest | Highest |

### 5.3 Script Architecture

Scripts are **standalone executables** that work outside Claude Code.

```bash
#!/bin/bash
#
# Header explaining purpose
# Usage: ./script.sh [arguments]
#

# Configuration
VARIABLE="value"

# Main logic
function main() {
    # Implementation
}

# Entry point
main "$@"
```

**Cross-Platform Considerations:**

| Platform | Shell | Notes |
|----------|-------|-------|
| Windows | Git Bash | Comes with Git for Windows |
| macOS | zsh/bash | Native, use `#!/bin/bash` |
| Linux | bash | Native, most common |

---

## 6. Integration Points

### 6.1 How Components Integrate

```
┌─────────────────────────────────────────────────────────────┐
│                    INTEGRATION MAP                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  /agent-threads:big                                         │
│         │                                                   │
│         ├──▶ Uses agents/researcher.md                      │
│         ├──▶ Uses agents/reviewer.md                        │
│         ├──▶ Uses agents/validator.md                       │
│         └──▶ References scripts/                            │
│                                                             │
│  /agent-threads:long                                        │
│         │                                                   │
│         └──▶ Triggers hooks/hooks.json                      │
│                   │                                         │
│                   └──▶ Runs scripts/ralph-loop.sh           │
│                                                             │
│  /agent-threads:parallel                                    │
│         │                                                   │
│         └──▶ References scripts/parallel-runner.sh          │
│                                                             │
│  /agent-threads:fusion                                      │
│         │                                                   │
│         └──▶ References scripts/fusion-aggregator.sh        │
│                                                             │
│  /agent-threads:zero-touch                                  │
│         │                                                   │
│         └──▶ References scripts/zero-touch-validator.sh     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 6.2 External Dependencies

| Component | Dependencies | Required? |
|-----------|-------------|-----------|
| Bash scripts | Git Bash (Windows) | Yes |
| Fusion aggregator | jq (JSON processor) | Optional |
| Zero-touch validator | Project build tools | Optional |
| Ralph loop | Project test framework | Optional |

---

## 7. Design Decisions

### 7.1 Why Markdown for Everything?

**Decision:** Use Markdown with YAML frontmatter for all definitions.

**Rationale:**
- Human-readable without special tools
- Easy to edit in any text editor
- Git-friendly (good diffs)
- Claude Code convention
- Supports rich formatting

### 7.2 Why Separate Agents by Capability?

**Decision:** Four agents with different tool access levels.

**Rationale:**
- **Principle of Least Privilege** - Only give tools needed
- **Clear Responsibility** - Each agent has a defined role
- **Model Efficiency** - Use cheaper models for simple tasks
- **Safety** - Read-only agents can't break things

### 7.3 Why Bash Scripts?

**Decision:** Use bash for helper scripts.

**Rationale:**
- Works on all platforms (via Git Bash)
- Simple syntax for common tasks
- No compilation needed
- Easy to modify and extend
- Standard in DevOps/engineering

### 7.4 Why the Ralph Wiggum Pattern?

**Decision:** Use Stop hooks for long-running validation.

**Rationale:**
- Deterministic code can enforce rules
- Agents alone can forget or stop early
- Validation loops ensure completeness
- "Code + Agents > Agents Alone"

---

## 8. Security Considerations

### 8.1 Tool Access Restrictions

```
┌─────────────────────────────────────────────────────────────┐
│                SECURITY MODEL                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  High Risk (Write/Execute)                                  │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Bash - Can run any command                          │   │
│  │  Write - Can create/overwrite files                  │   │
│  │  Edit - Can modify files                             │   │
│  └──────────────────────────────────────────────────────┘   │
│                         │                                   │
│                         │ Given only when needed            │
│                         ▼                                   │
│  Low Risk (Read-only)                                       │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  Read - Read file contents                           │   │
│  │  Grep - Search files                                 │   │
│  │  Glob - List files                                   │   │
│  └──────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 8.2 Agent Isolation

Each agent is a **separate context** that:
- Has only its allowed tools
- Cannot access parent conversation history
- Cannot modify plugin files
- Returns results to parent for review

### 8.3 Hook Safety

Hooks run with **limited scope**:
- Timeout prevents infinite loops
- Exit codes control flow
- Scripts should be idempotent
- No access to Claude's context

### 8.4 Script Safety Guidelines

When writing or modifying scripts:

1. **Never store credentials** in scripts
2. **Use absolute paths** when possible
3. **Validate inputs** before using
4. **Handle errors gracefully**
5. **Document what the script does**

---

## Summary

This architecture is designed to be:

1. **Educational** - Easy to understand and learn from
2. **Modular** - Each component works independently
3. **Extensible** - Easy to add new commands, agents, scripts
4. **Safe** - Principle of least privilege throughout
5. **Cross-platform** - Works on Windows, Mac, and Linux

For questions about specific components, see the relevant documentation:
- [Developer Guide](DEVELOPER_GUIDE.md) - How to extend the plugin
- [User Guide](USER_GUIDE.md) - How to use the plugin
- [Glossary](GLOSSARY.md) - Technical terms explained

---

*Architecture document for Thread-Based Engineering Plugin v1.0.0*
