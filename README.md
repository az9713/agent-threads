# Agent Threads - Thread-Based Engineering Plugin

A comprehensive Claude Code plugin that teaches and demonstrates all 7 thread types
from the Thread-Based Engineering framework. Learn to work more effectively with
AI coding assistants through practical, hands-on examples.

---

## What is Thread-Based Engineering?

Thread-Based Engineering is a mental framework for understanding how to work with
AI coding assistants like Claude. Created by Andy Devdan, it defines 7 patterns
("threads") for human-AI collaboration:

```
┌─────────┐     ┌─────────────────┐     ┌─────────┐
│   YOU   │ ──▶ │  AI AGENT       │ ──▶ │   YOU   │
│ Prompt  │     │  (tool calls)   │     │ Review  │
└─────────┘     └─────────────────┘     └─────────┘
   START            MIDDLE                 END
```

**The Core Idea:** You show up at the beginning (prompt) and end (review).
The AI does the work in the middle. Getting better means running MORE threads,
LONGER threads, and THICKER threads (agents using agents).

---

## Quick Navigation

### For New Users (Start Here!)

| Document | Description | Time |
|----------|-------------|------|
| [Quick Start Guide](docs/QUICK_START.md) | Step-by-step setup with 10 hands-on exercises | 15 min |
| [User Guide](docs/USER_GUIDE.md) | Complete guide to all features | 30-60 min |
| [FAQ](docs/FAQ.md) | Common questions answered | As needed |

### For Developers

| Document | Description |
|----------|-------------|
| [Developer Guide](docs/DEVELOPER_GUIDE.md) | How to extend and modify the plugin |
| [Architecture](docs/ARCHITECTURE.md) | Technical design and data flow diagrams |
| [CLAUDE.md](CLAUDE.md) | Project memory for AI assistants |

### Reference

| Document | Description |
|----------|-------------|
| [Glossary](docs/GLOSSARY.md) | All technical terms explained |
| [Troubleshooting](docs/TROUBLESHOOTING.md) | Solutions to common problems |

---

## Installation

### Prerequisites

- **Claude Code** - Anthropic's CLI for Claude ([installation instructions](docs/QUICK_START.md#1-prerequisites---what-you-need))
- **Git Bash** (Windows only) - Download from [git-scm.com](https://git-scm.com)

### Install the Plugin

```bash
# Navigate to the plugin directory
cd /path/to/agent-threads

# Install
claude /plugin install .
```

### Verify Installation

```bash
# Start Claude Code
claude

# Test a command
/agent-threads:base
```

If you see the Base Thread explanation, you're ready to go!

---

## The 7 Thread Types

| Thread | Name | What It Does | Difficulty |
|--------|------|--------------|------------|
| **Base** | Base Thread | Single prompt → agent work → review | Beginner |
| **P** | Parallel | Multiple agents working simultaneously | Beginner |
| **C** | Chained | Multi-phase work with human checkpoints | Intermediate |
| **F** | Fusion | Best-of-N - multiple agents, aggregate results | Intermediate |
| **B** | Big/Meta | Agents orchestrating other agents | Advanced |
| **L** | Long | Extended autonomous work with validation loops | Advanced |
| **Z** | Zero-Touch | Fully automated with comprehensive validation | Expert |

### Try Each Thread Type

```bash
/agent-threads:base        # The fundamental pattern
/agent-threads:parallel    # Scale with multiple agents
/agent-threads:chained     # Safe multi-phase workflows
/agent-threads:fusion      # Get the best of multiple attempts
/agent-threads:big         # Orchestrate agent teams
/agent-threads:long        # Extended autonomous work
/agent-threads:zero-touch  # Full automation (the goal)
```

---

## What's Included

### Slash Commands (7)
One command per thread type, with explanations and live demos.

### Custom Agents (4)
Specialized AI helpers with different capabilities:

| Agent | Role | Access |
|-------|------|--------|
| `@researcher` | Fast codebase exploration | Read-only |
| `@reviewer` | Code quality analysis | Read-only |
| `@builder` | Implementation | Read/Write |
| `@validator` | Test verification | Bash access |

### Helper Scripts (5)
Standalone bash scripts for advanced patterns:

| Script | Purpose |
|--------|---------|
| `parallel-runner.sh` | Spawn N parallel Claude instances |
| `fusion-aggregator.sh` | Aggregate results from multiple agents |
| `chained-workflow.sh` | Multi-phase workflow with checkpoints |
| `ralph-loop.sh` | Stop hook for validation loops |
| `zero-touch-validator.sh` | Comprehensive automated validation |

### Hooks
Stop hook implementing the "Ralph Wiggum" pattern - code that controls
when AI continues or stops working.

---

## Quick Examples

### Basic Usage
```bash
# Start Claude Code
claude

# Ask about thread types
/agent-threads:base

# Analyze code
/agent-threads:base src/
```

### Run Parallel Agents
```bash
./scripts/parallel-runner.sh "Review this code" 3
```

### Run Validation Suite
```bash
./scripts/zero-touch-validator.sh
```

---

## How to Improve

Thread-Based Engineering defines 4 metrics for improvement:

1. **Run MORE threads** - Parallelize work across multiple agents
2. **Run LONGER threads** - Increase agent autonomy with better prompts
3. **Run THICKER threads** - Use nested sub-agents for complex tasks
4. **Run FEWER checkpoints** - Build trust through automated validation

Start with Base Threads, progress to Zero-Touch as you build confidence.

---

## Documentation Map

```
docs/
├── QUICK_START.md      # Start here! 10 hands-on exercises
├── USER_GUIDE.md       # Complete feature documentation
├── DEVELOPER_GUIDE.md  # How to extend the plugin
├── ARCHITECTURE.md     # Technical design details
├── GLOSSARY.md         # All terms explained
├── TROUBLESHOOTING.md  # Common problems and solutions
└── FAQ.md              # Frequently asked questions
```

---

## Project Structure

```
agent-threads/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── CLAUDE.md                # Project memory (for AI)
├── README.md                # This file
├── docs/                    # Documentation (see above)
├── commands/                # Slash commands (7 files)
├── agents/                  # Custom agents (4 files)
├── skills/                  # Skills and patterns
├── hooks/                   # Event hooks (Ralph Wiggum)
└── scripts/                 # Helper scripts (5 files)
```

---

## Getting Help

1. **Read the docs** - Start with [Quick Start Guide](docs/QUICK_START.md)
2. **Check FAQ** - See [FAQ](docs/FAQ.md)
3. **Troubleshoot** - See [Troubleshooting](docs/TROUBLESHOOTING.md)
4. **Ask Claude** - Claude can explain concepts from this plugin

---

## Acknowledgements

This project was inspired by the YouTube video **"AGENT THREADS. How to SHIP like Boris Cherny. Ralph Wiggnum in Claude Code."** by IndyDevDan:
- Video: https://www.youtube.com/watch?v=-WBHNFAB0OE

All code and documentation in this project were generated by **Claude Code** powered by **Opus 4.5**.

## Credits

- **Thread-Based Engineering Framework:** IndyDevDan (Andy Devdan)
- **Ralph Wiggum Pattern:** Geoffrey Huntley
- **Claude Code:** Anthropic

---

## Requirements

- Claude Code CLI (latest version recommended)
- Bash shell (Git Bash on Windows, Terminal on Mac/Linux)
- jq (optional, for fusion aggregation script)

---

## License

MIT

---

*Happy threading!*
