# Thread-Based Engineering Plugin - Project Memory

> **What is this file?** This is the CLAUDE.md file - a special file that Claude Code reads
> automatically when working in this project. It provides context about the project, coding
> conventions, and important information for both AI assistants and human developers.

---

## Project Overview

**Name:** Agent Threads - Thread-Based Engineering Plugin for Claude Code

**Purpose:** A comprehensive educational plugin that teaches and demonstrates the 7 thread
types for agentic engineering, based on Andy Devdan's Thread-Based Engineering framework.

**Target Audience:**
- Software engineers learning to work with AI coding assistants
- Developers transitioning from traditional coding to agentic workflows
- Teams looking to scale their engineering output with AI

**Version:** 1.0.0

---

## What is Thread-Based Engineering?

Thread-Based Engineering is a mental framework for understanding and improving your ability
to work with AI coding assistants (like Claude Code).

### The Core Concept

A **thread** is a unit of engineering work over time:

```
┌─────────┐     ┌─────────────────┐     ┌─────────┐
│   YOU   │ ──▶ │  AI AGENT       │ ──▶ │   YOU   │
│ Prompt  │     │  (tool calls)   │     │ Review  │
└─────────┘     └─────────────────┘     └─────────┘
   START            MIDDLE                 END
```

- **You** show up at the START (prompt/plan)
- **AI Agent** does the MIDDLE (tool calls - reading, writing, executing)
- **You** show up at the END (review/validate)

### The 7 Thread Types

| Thread | Name | Description | Difficulty |
|--------|------|-------------|------------|
| **Base** | Base Thread | Single prompt → agent work → review | Beginner |
| **P** | Parallel | Multiple agents working simultaneously | Beginner |
| **C** | Chained | Multi-phase work with human checkpoints | Intermediate |
| **F** | Fusion | Best-of-N - multiple agents, aggregate results | Intermediate |
| **B** | Big/Meta | Agents orchestrating other agents | Advanced |
| **L** | Long | Extended autonomous work with validation loops | Advanced |
| **Z** | Zero-Touch | Fully automated with comprehensive validation | Expert |

### How to Know You're Improving

1. **Run MORE threads** → Parallelize work across multiple agents
2. **Run LONGER threads** → Increase agent autonomy with better prompts
3. **Run THICKER threads** → Use nested sub-agents for complex tasks
4. **Run FEWER checkpoints** → Build trust through automated validation

---

## Project Structure

```
agent-threads/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest (required)
├── CLAUDE.md                # This file - project memory
├── README.md                # Main documentation entry point
│
├── docs/                    # Comprehensive documentation
│   ├── QUICK_START.md       # Quick start with 10+ use cases
│   ├── USER_GUIDE.md        # Complete user guide
│   ├── DEVELOPER_GUIDE.md   # Developer documentation
│   ├── ARCHITECTURE.md      # Technical architecture
│   ├── GLOSSARY.md          # Terms and definitions
│   ├── TROUBLESHOOTING.md   # Common issues and solutions
│   └── FAQ.md               # Frequently asked questions
│
├── commands/                # Slash commands (one per thread type)
│   ├── base.md              # /agent-threads:base
│   ├── parallel.md          # /agent-threads:parallel
│   ├── chained.md           # /agent-threads:chained
│   ├── fusion.md            # /agent-threads:fusion
│   ├── big.md               # /agent-threads:big
│   ├── long.md              # /agent-threads:long
│   └── zero-touch.md        # /agent-threads:zero-touch
│
├── agents/                  # Custom sub-agent definitions
│   ├── researcher.md        # Fast codebase exploration
│   ├── reviewer.md          # Code quality analysis
│   ├── builder.md           # Implementation specialist
│   └── validator.md         # Test and build verification
│
├── skills/                  # Skills for Claude to use
│   └── thread-patterns/
│       ├── SKILL.md         # Pattern selection guidance
│       └── examples.md      # Detailed code examples
│
├── hooks/                   # Event hooks
│   └── hooks.json           # Stop hook for Ralph Wiggum pattern
│
└── scripts/                 # Standalone bash scripts
    ├── parallel-runner.sh   # Run N parallel agents
    ├── fusion-aggregator.sh # Aggregate multiple results
    ├── chained-workflow.sh  # Multi-phase workflow
    ├── ralph-loop.sh        # Stop hook validation
    └── zero-touch-validator.sh # Comprehensive validation
```

---

## Quick Reference

### Slash Commands

| Command | Purpose |
|---------|---------|
| `/agent-threads:base` | Learn Base Thread pattern |
| `/agent-threads:parallel` | Learn Parallel Thread pattern |
| `/agent-threads:chained` | Learn Chained Thread pattern |
| `/agent-threads:fusion` | Learn Fusion Thread pattern |
| `/agent-threads:big` | Learn Big Thread pattern |
| `/agent-threads:long` | Learn Long Thread pattern |
| `/agent-threads:zero-touch` | Learn Zero-Touch Thread pattern |

### Custom Agents

| Agent | Purpose | Access Level |
|-------|---------|--------------|
| `@researcher` | Explore codebase quickly | Read-only |
| `@reviewer` | Analyze code quality | Read-only |
| `@builder` | Implement changes | Read/Write |
| `@validator` | Run tests and checks | Bash access |

### Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| `parallel-runner.sh` | Spawn parallel agents | `./scripts/parallel-runner.sh "task" 3` |
| `fusion-aggregator.sh` | Aggregate results | `./scripts/fusion-aggregator.sh *.json` |
| `chained-workflow.sh` | Multi-phase workflow | `./scripts/chained-workflow.sh "feature"` |
| `ralph-loop.sh` | Stop hook | (automatic via hooks.json) |
| `zero-touch-validator.sh` | Full validation | `./scripts/zero-touch-validator.sh` |

---

## Key Concepts for AI Assistants

When working on this project, remember:

1. **Educational Focus**: This plugin teaches concepts. Explanations should be clear and
   beginner-friendly while remaining technically accurate.

2. **Practical Examples**: Every concept should have runnable examples. Users learn by doing.

3. **Progressive Complexity**: Start with Base Thread, progress to Zero-Touch. Don't
   overwhelm beginners with advanced patterns.

4. **The Core Four**: Context, Model, Prompt, Tools - these are the fundamentals that
   underlie all thread patterns.

5. **Ralph Wiggum Pattern**: This is the key insight - "Code + Agents > Agents Alone".
   Deterministic code controlling when agents continue or stop.

---

## Development Guidelines

### For Future Developers

1. **File Naming**: Use lowercase with hyphens (e.g., `my-command.md`)
2. **Markdown Format**: All commands, agents, and skills use Markdown with YAML frontmatter
3. **Scripts**: Bash scripts should work in Git Bash on Windows and native bash on Mac/Linux
4. **Documentation**: Update docs when adding features. No technical debt.

### Testing Changes

1. Install the plugin: `claude /plugin install ./agent-threads`
2. Test commands: `/agent-threads:base`, etc.
3. Test scripts: Run directly from `scripts/` directory
4. Verify hooks: Check with `/hooks` command

### Adding New Content

- **New Command**: Add `.md` file to `commands/`
- **New Agent**: Add `.md` file to `agents/`
- **New Skill**: Add `SKILL.md` to `skills/<skill-name>/`
- **New Script**: Add `.sh` file to `scripts/`, make executable

---

## Acknowledgements

This project was inspired by the YouTube video **"AGENT THREADS. How to SHIP like Boris Cherny. Ralph Wiggnum in Claude Code."** by IndyDevDan:
- Video: https://www.youtube.com/watch?v=-WBHNFAB0OE

All code and documentation in this project were generated by **Claude Code** powered by **Opus 4.5**.

## References and Credits

- **Thread-Based Engineering Framework**: IndyDevDan (Andy Devdan) - YouTube video
- **Boris Cherny's Setup**: Creator of Claude Code, runs 5+ parallel instances
- **Ralph Wiggum Technique**: Geoffrey Huntley (ghuntley.com/ralph/)
- **mprocs Tool**: Terminal multiplexer for parallel agents

---

## Getting Help

- **Documentation**: See `docs/` directory for comprehensive guides
- **Quick Start**: `docs/QUICK_START.md` has 10+ beginner use cases
- **Troubleshooting**: `docs/TROUBLESHOOTING.md` for common issues
- **FAQ**: `docs/FAQ.md` for frequently asked questions

---

*Last updated: January 2025*
