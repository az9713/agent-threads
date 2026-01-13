# Frequently Asked Questions (FAQ)

This document answers common questions about the Thread-Based Engineering plugin.
Questions are organized by topic for easy navigation.

---

## Table of Contents

1. [General Questions](#1-general-questions)
2. [Getting Started](#2-getting-started)
3. [Thread Types](#3-thread-types)
4. [Commands and Usage](#4-commands-and-usage)
5. [Agents](#5-agents)
6. [Scripts](#6-scripts)
7. [Hooks and Ralph Wiggum](#7-hooks-and-ralph-wiggum)
8. [Best Practices](#8-best-practices)
9. [Technical Questions](#9-technical-questions)
10. [Costs and Billing](#10-costs-and-billing)

---

## 1. General Questions

### What is Thread-Based Engineering?

Thread-Based Engineering is a mental framework for understanding and improving your
ability to work with AI coding assistants like Claude. It was created by IndyDevDan.

A "thread" is a unit of engineering work over time:
- **You** show up at the START (prompt/plan)
- **AI Agent** does the MIDDLE (tool calls)
- **You** show up at the END (review/validate)

The framework defines 7 thread types that represent different patterns of working
with AI agents.

### What is this plugin?

This is an educational toolkit for Claude Code that teaches the 7 thread types
through practical, executable examples. It includes:
- 7 slash commands (one per thread type)
- 4 custom agents
- 5 helper scripts
- Comprehensive documentation

### Do I need this plugin to use Claude Code?

No. Claude Code works fine without any plugins. This plugin is for learning the
Thread-Based Engineering framework and demonstrating advanced patterns.

### Is this an official Anthropic product?

No. This is a community/educational plugin that works with Claude Code, which IS
an official Anthropic product.

### How is this different from just using Claude Code normally?

Without this plugin, you can still do everything demonstrated here. The plugin
provides:
- Pre-built examples to learn from
- Ready-to-use scripts for parallel/fusion patterns
- Documentation explaining the concepts
- A structured way to learn the framework

---

## 2. Getting Started

### What do I need to install?

1. **Required:**
   - Claude Code (`npm install -g @anthropic-ai/claude-code`)
   - Git Bash (on Windows) or Terminal (Mac/Linux)

2. **Optional but helpful:**
   - jq (for fusion-aggregator script)
   - A code editor (VS Code recommended)

### How do I know if the plugin is installed correctly?

1. Start Claude Code: `claude`
2. Type: `/agent-threads:base`
3. If you see the Base Thread explanation, it's working.

### Do I need programming experience?

Basic familiarity with the command line helps. You should know:
- How to open a terminal
- How to navigate directories (`cd`)
- How to run commands

No coding experience is required to USE the plugin, but the Developer Guide
assumes some programming knowledge.

### Can I use this on Windows?

Yes! Use Git Bash (comes with Git for Windows). Don't use Command Prompt or
PowerShell - the scripts are written in bash.

---

## 3. Thread Types

### What's the difference between all the thread types?

| Thread | One-Line Summary |
|--------|-----------------|
| Base | One prompt, AI works, you review |
| Parallel | Multiple AIs working at the same time |
| Chained | Multiple steps with human review between each |
| Fusion | Multiple AIs on same task, combine best results |
| Big | AI using other AIs to help |
| Long | AI working for extended time with validation loops |
| Zero-Touch | Full automation, no human review needed |

### Which thread type should I start with?

**Start with Base Thread.** It's the foundation for everything else. Get comfortable
with:
- Writing clear prompts
- Understanding tool calls
- Reviewing AI output

Then progress to Parallel and Chained before attempting the advanced patterns.

### What's the "Ralph Wiggum" pattern I keep hearing about?

Ralph Wiggum is a technique for Long Threads where deterministic code (scripts)
controls when the AI continues or stops working.

**Key insight:** "Code + Agents > Agents Alone"

An AI might stop early thinking it's done. The Ralph Wiggum pattern uses a Stop Hook
to run validation checks. If checks fail, the AI continues working. If checks pass,
the AI can stop.

Named after a community contributor who popularized the technique.

### What is a Zero-Touch Thread really?

Zero-Touch is the theoretical ideal where you trust the AI so much that human review
is optional. This requires:
- Comprehensive automated tests
- Strong type checking
- Thorough linting
- Complete validation pipeline

In practice, most work still needs human review. Zero-Touch is a goal to work toward,
not where you start.

### How do I know which thread type to use?

| Situation | Use This Thread |
|-----------|-----------------|
| Quick question or simple task | Base |
| Need to review multiple areas | Parallel |
| High-risk or production changes | Chained |
| Want multiple perspectives | Fusion |
| Complex multi-step work | Big |
| Overnight or long-running work | Long |
| Mature codebase, repetitive tasks | Zero-Touch |

---

## 4. Commands and Usage

### How do I use a slash command?

1. Start Claude Code: `claude`
2. Type the command: `/agent-threads:base`
3. Optionally add arguments: `/agent-threads:base src/auth/`

### What's the difference between commands and just asking Claude?

Commands provide:
- Structured prompts for specific tasks
- Tool restrictions for safety
- Pre-built explanations and examples

You can always just type natural language instead.

### Can I modify the commands?

Yes! Commands are just Markdown files in the `commands/` directory.
See the [Developer Guide](DEVELOPER_GUIDE.md) for how to edit them.

### What does $ARGUMENTS mean in commands?

`$ARGUMENTS` is a placeholder that gets replaced with whatever you type after
the command name.

Example:
- You type: `/agent-threads:base src/api/`
- `$ARGUMENTS` becomes: `src/api/`
- Claude sees: "Analyze src/api/"

---

## 5. Agents

### What are custom agents?

Agents are specialized AI helpers with defined roles and restricted tools.
Think of them as team members with specific jobs:
- `@researcher` - Explores codebases (read-only)
- `@reviewer` - Analyzes code quality (read-only)
- `@builder` - Implements changes (can write)
- `@validator` - Runs tests (can run bash)

### When should I use an agent vs. a command?

| Use Command When | Use Agent When |
|-----------------|----------------|
| Learning a concept | Doing specialized work |
| Running a demo | Delegating specific tasks |
| Following a pattern | Orchestrating multiple AIs |

### Can agents call other agents?

Yes! In Big Threads, agents can spawn sub-agents. The primary Claude can use
`@researcher` to find code, then `@reviewer` to analyze it.

### Why do different agents use different models?

| Agent | Model | Reason |
|-------|-------|--------|
| researcher | haiku | Speed matters for exploration |
| reviewer | sonnet | Needs thorough analysis |
| builder | sonnet | Quality code generation |
| validator | haiku | Simple test execution |

This optimizes for cost and performance.

---

## 6. Scripts

### Do I have to use the scripts?

No. Scripts are optional helpers that demonstrate patterns. You can:
- Run them directly
- Use them as learning examples
- Ignore them entirely

### Can I run scripts without Claude Code?

Yes! The scripts are standalone bash programs. You can run them directly:
```bash
./scripts/parallel-runner.sh "your task" 3
```

### What if I don't have jq installed?

jq is only needed for `fusion-aggregator.sh`. Options:
1. Install jq (recommended)
2. Skip the fusion script
3. Aggregate results manually

### Can I write my own scripts?

Absolutely! See the [Developer Guide](DEVELOPER_GUIDE.md) for how to create
custom scripts.

---

## 7. Hooks and Ralph Wiggum

### What is a hook?

A hook is code that runs automatically when certain events happen in Claude Code.
Like a tripwire that triggers a script.

### What hooks does this plugin use?

The main hook is the **Stop Hook** in `hooks/hooks.json`. It runs `ralph-loop.sh`
whenever Claude tries to stop working.

### Why would I want to prevent Claude from stopping?

Sometimes Claude thinks it's done when it isn't:
- Tests are still failing
- TODOs remain in the code
- Lint errors exist

The Stop Hook validates work before allowing stop.

### Is the Stop Hook always active?

The hook is loaded when the plugin is installed, but it only does anything if
your project has tests/linting that the script can check.

### Can I disable the Stop Hook?

Yes:
1. Edit `hooks/hooks.json`
2. Remove or comment out the Stop section
3. Reinstall the plugin

---

## 8. Best Practices

### How do I write good prompts?

1. **Be specific:** "Review src/auth.js" not "Review the code"
2. **State the goal:** "Find security vulnerabilities" not "Look at this"
3. **Provide context:** "This handles user login" helps Claude understand
4. **Set expectations:** "List top 3 issues" gives structure

### How many parallel agents should I run?

Start with 2-3. Factors to consider:
- Your computer's resources
- API rate limits
- Task complexity

Boris Cherny runs 5+ in terminal plus 5-10 in background, but he's advanced.

### When should I use human checkpoints?

Add checkpoints for:
- Production changes
- Security-sensitive code
- Work you can't easily undo
- Learning/teaching scenarios

Skip checkpoints for:
- Experimental work
- Well-tested codebases
- Low-risk changes

### How do I build toward Zero-Touch?

1. Add comprehensive tests (aim for high coverage)
2. Add type checking (TypeScript, mypy)
3. Add linting (ESLint, Prettier)
4. Add security scanning
5. Make validation automatic (CI/CD)
6. Gradually reduce manual reviews

---

## 9. Technical Questions

### Where are plugin files stored?

Plugin files stay in the original directory where you installed from:
```
agent-threads/
├── .claude-plugin/plugin.json
├── commands/
├── agents/
├── hooks/
├── scripts/
└── ...
```

### How does Claude Code find my plugin?

When you run `/plugin install .`, Claude Code:
1. Records the plugin location
2. Scans for commands, agents, skills, hooks
3. Makes them available in sessions

### Can I have multiple plugins installed?

Yes! Each plugin has its own namespace:
- `/agent-threads:base` (this plugin)
- `/other-plugin:command` (another plugin)

### How do I uninstall the plugin?

```bash
claude /plugin uninstall agent-threads
```

### Does this plugin send data anywhere?

No. The plugin is purely local. All data goes through Claude Code's normal
API connection to Anthropic.

---

## 10. Costs and Billing

### Does using this plugin cost money?

The plugin itself is free. However, using Claude Code uses Anthropic API credits,
which do cost money based on:
- Model used (Haiku < Sonnet < Opus)
- Amount of text processed
- Number of tool calls

### How can I minimize costs?

1. **Use Haiku** for simple tasks
2. **Be specific** in prompts (less exploration needed)
3. **Set max-turns** to limit long sessions
4. **Don't run unnecessary parallel agents**

### Are there free tiers?

Check Anthropic's current pricing at https://www.anthropic.com/pricing

### Which thread types cost the most?

| Thread | Cost Factor | Why |
|--------|-------------|-----|
| Base | Low | Single session |
| Parallel | Medium-High | Multiple sessions |
| Chained | Medium | Sequential sessions |
| Fusion | High | Multiple sessions + aggregation |
| Big | High | Nested sub-agents |
| Long | Very High | Extended duration |
| Zero-Touch | Varies | Depends on validation |

---

## Still Have Questions?

If your question isn't answered here:

1. **Check the documentation:**
   - [Quick Start Guide](QUICK_START.md)
   - [User Guide](USER_GUIDE.md)
   - [Developer Guide](DEVELOPER_GUIDE.md)
   - [Troubleshooting](TROUBLESHOOTING.md)

2. **Search the Glossary:**
   - [Glossary](GLOSSARY.md) - All terms defined

3. **Check Claude Code docs:**
   - https://docs.anthropic.com/claude-code

4. **Ask Claude directly:**
   - Claude can explain concepts from the plugin
   - Try: "Explain what a Parallel Thread is"

---

*FAQ for Thread-Based Engineering Plugin v1.0.0*
