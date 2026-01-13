# Glossary - Thread-Based Engineering Terms

This glossary defines all technical terms used in the Thread-Based Engineering plugin.
Terms are organized alphabetically for easy reference.

---

## Quick Navigation

[A](#a) | [B](#b) | [C](#c) | [D](#d) | [E](#e) | [F](#f) | [G](#g) | [H](#h) | [I](#i) | [J](#j) | [K](#k) | [L](#l) | [M](#m) | [N](#n) | [O](#o) | [P](#p) | [Q](#q) | [R](#r) | [S](#s) | [T](#t) | [U](#u) | [V](#v) | [W](#w) | [X](#x) | [Y](#y) | [Z](#z)

---

## A

### Agent
A specialized AI helper with a defined role and limited tool access. Agents are like
team members with specific jobs - a reviewer reviews, a builder builds, etc.

**Example:** The `@reviewer` agent only has Read, Grep, and Glob tools - it can look
at code but cannot modify anything.

### Aggregation
The process of combining results from multiple sources into one unified output.
Used in Fusion Threads where multiple agents work on the same problem.

**Example:** Three agents each propose a solution, then an aggregator combines the
best parts into a final recommendation.

### Allowed Tools
The set of Claude Code tools that a command or agent is permitted to use.
Defined in the YAML frontmatter of commands and agents.

**Example:**
```yaml
allowed-tools: Read, Grep, Glob, Bash
```

### API (Application Programming Interface)
A way for programs to communicate with each other. Claude Code uses Anthropic's
API to communicate with Claude AI.

### Arguments
Extra information passed to a command. In this plugin, `$ARGUMENTS` is a placeholder
that gets replaced with whatever the user types after the command.

**Example:** In `/agent-threads:base src/`, the `src/` is the argument.

---

## B

### Background Job
A process that runs separately from your main terminal session. Used in parallel
threads to run multiple Claude instances at once.

**Example:** `claude -p "task" &` - the `&` makes it a background job.

### Base Thread (B-Thread)
The simplest thread pattern. One prompt goes in, Claude works, you review the result.
This is the atomic unit of all agentic work.

**Pattern:** You (prompt) → Claude (works) → You (review)

### Bash
A command-line shell (program that runs commands). On Windows, Git Bash provides
bash; on Mac/Linux, it's built in.

**Example:** `/bin/bash` or just opening Terminal on Mac.

### Big Thread
See [Meta Thread](#meta-thread).

---

## C

### Chained Thread (C-Thread)
A multi-phase workflow where you review after each phase before continuing.
Used for high-risk work that needs human checkpoints.

**Pattern:** Phase 1 → Review → Phase 2 → Review → Phase 3

### Checkpoint
A point in a workflow where Claude stops and waits for human review before
continuing. Essential for Chained Threads.

### CLI (Command Line Interface)
A text-based way to interact with a program by typing commands.
Claude Code is a CLI tool - you type commands in a terminal.

### Claude
The AI assistant created by Anthropic. Claude Code is a CLI that lets you
interact with Claude for coding tasks.

### Claude Code
Anthropic's official command-line tool for working with Claude on software
engineering tasks. This plugin extends Claude Code.

### Command
A slash command that triggers specific functionality. In this plugin, commands
like `/agent-threads:base` teach thread patterns.

**Format:** `/plugin-name:command-name`

### Context
Information available to Claude when responding. Includes the conversation history,
files it has read, and the current prompt.

### Context Window
The maximum amount of text Claude can consider at once. Like working memory -
limited capacity that affects how much Claude can "remember" in one session.

---

## D

### Deterministic
Something that always produces the same output given the same input. Code is
deterministic; AI responses are not.

**Example:** `2 + 2` always equals `4` (deterministic)

### Directory
A folder in a file system. Contains files and other directories.

**Example:** `commands/` is a directory containing command files.

---

## E

### Event Hook
See [Hook](#hook).

### Exit Code
A number returned by a program when it finishes. `0` means success; non-zero
means failure.

**Example:** `exit 0` means "all good", `exit 1` means "something went wrong"

---

## F

### Frontmatter
Metadata at the top of a Markdown file, enclosed in `---` markers.
Written in YAML format.

**Example:**
```yaml
---
description: My command description
allowed-tools: Read, Grep
---
```

### Fusion Thread (F-Thread)
A pattern where multiple agents work on the same problem, and their results
are combined (fused) into one best answer.

**Pattern:** Same prompt → Multiple agents → Aggregate results → Best answer

---

## G

### Git
A version control system that tracks changes to files. Used by developers to
manage code history.

### Git Bash
A program for Windows that provides a bash shell environment. Required for
running the bash scripts in this plugin on Windows.

### Glob
A pattern-matching syntax for finding files by name.

**Example:** `*.md` matches all files ending in `.md`

### Grep
A tool for searching file contents. Finds lines matching a pattern.

**Example:** `grep "TODO" src/` finds all lines containing "TODO"

---

## H

### Haiku
Anthropic's fastest and most cost-effective Claude model. Best for simple
tasks where speed matters more than depth.

### Headless Mode
Running Claude Code without an interactive terminal. Used for automation
and background tasks.

**Example:** `claude -p "task" --print` runs non-interactively

### Hook
A script that runs automatically when certain events happen in Claude Code.
Used to intercept and modify behavior.

**Types:** PreToolUse, PostToolUse, Stop, Notification

---

## I

### Instance
A running copy of a program. Multiple Claude instances means multiple
Claude sessions running at the same time.

---

## J

### JSON (JavaScript Object Notation)
A text format for storing structured data. Used for configuration files
like `plugin.json` and `hooks.json`.

**Example:**
```json
{
  "name": "value",
  "count": 42
}
```

### jq
A command-line tool for processing JSON data. Used in the fusion-aggregator
script to combine results.

---

## K

### Kill
To stop a running process forcefully.

**Example:** Pressing Ctrl+C kills the current process.

---

## L

### Lint / Linter
A tool that checks code for style issues and potential errors without
running it.

**Example:** ESLint for JavaScript, Flake8 for Python

### Long Thread (L-Thread)
A high-autonomy thread that runs for an extended duration with validation
loops. Uses the Ralph Wiggum pattern.

**Pattern:** Claude works → Stop hook validates → Continue if incomplete → Repeat

---

## M

### Manifest
A file that describes a package or plugin. For Claude Code plugins, this
is `.claude-plugin/plugin.json`.

### Markdown
A simple text formatting language used for documentation. Files end in `.md`.

**Example:** `**bold**` becomes **bold**, `# Header` creates a heading

### Meta Thread
Also called **Big Thread** or **B-Thread**. A thread where agents prompt
other agents. Creates recursive, nested structures.

**Pattern:** You → Primary Agent → Sub-agents → Synthesized result

### Model
The specific AI system used. Claude has multiple models: Haiku (fast),
Sonnet (balanced), Opus (powerful).

---

## N

### Node.js
A JavaScript runtime used by many development tools. Required to install
Claude Code via npm.

### npm (Node Package Manager)
A tool for installing JavaScript packages. Used to install Claude Code:
`npm install -g @anthropic-ai/claude-code`

---

## O

### Opus
Anthropic's most powerful Claude model. Best for complex reasoning tasks
but slower and more expensive than others.

### Output Format
How Claude Code returns its results. Can be `text`, `json`, or other formats.

**Example:** `--output-format json` returns structured JSON data

---

## P

### Parallel Thread (P-Thread)
A pattern where multiple Claude instances work on different tasks at the
same time. Scales output by using more compute.

**Pattern:** Same time: Task 1, Task 2, Task 3 → Combine results

### Path
The location of a file or directory in the file system.

**Example:** `C:\Users\simon\project\file.txt` (Windows)
**Example:** `/home/simon/project/file.txt` (Mac/Linux)

### Plugin
An extension that adds functionality to a program. This Thread-Based
Engineering toolkit is a Claude Code plugin.

### Prompt
The text you give to Claude to tell it what to do. The starting point
of any thread.

---

## Q

### Query
A search term or pattern. Used with Grep to find specific content.

---

## R

### Ralph Wiggum Pattern
A technique where deterministic code controls when an AI agent continues
or stops working. Named after a community contributor.

**Key insight:** "Code + Agents > Agents Alone"

**Implementation:** Stop hooks run validation scripts that decide whether
Claude should keep working or is truly done.

### Read-Only
Having permission to view but not modify. Agents like `@researcher` and
`@reviewer` are read-only for safety.

### Repository (Repo)
A storage location for code, usually managed by Git. Contains all project
files and their history.

### Resume
To continue a previous Claude session. Uses `--resume` flag with a session ID.

**Example:** `claude -p "continue" --resume "session-123"`

---

## S

### Script
A file containing commands to be executed. In this plugin, scripts are
bash files (`.sh`) that automate tasks.

### Session
A continuous conversation with Claude. Has a unique ID that can be used
to resume later.

### Shell
A program that interprets commands. Bash, Zsh, and PowerShell are shells.

### Slash Command
A command starting with `/`. In Claude Code, plugins add commands like
`/agent-threads:base`.

### Sonnet
Anthropic's balanced Claude model. Good mix of speed, cost, and capability.
Most commonly used for general tasks.

### Stop Hook
A hook that fires when Claude tries to end a session. Used in the Ralph
Wiggum pattern to validate work before allowing stop.

### Sub-agent
An agent spawned by another agent. Used in Big/Meta Threads for
task delegation.

---

## T

### Terminal
A program for typing commands. Called "Command Prompt" or "Git Bash"
on Windows, "Terminal" on Mac/Linux.

### Thread
A unit of engineering work over time. The core concept of Thread-Based
Engineering.

**Structure:** You (start) → AI (middle) → You (end)

### Thread-Based Engineering
A mental framework for understanding and improving your ability to work
with AI coding assistants. Created by IndyDevDan.

### Timeout
A maximum time limit for an operation. If exceeded, the operation is
cancelled.

**Example:** `"timeout": 60` means 60 seconds maximum

### Tool
A capability that Claude can use, like reading files or running commands.
Tools are the building blocks of agent work.

**Common tools:** Read, Write, Edit, Bash, Grep, Glob, Task

### Tool Call
When Claude uses a tool during a session. The "middle" part of a thread.

---

## U

### Unit Test
A test that checks a small piece of code works correctly. Part of the
validation pipeline in Zero-Touch Threads.

---

## V

### Validation
Checking that work is correct and complete. Includes tests, linting,
type checking, and other automated checks.

### Validator (Agent)
The `@validator` agent in this plugin. Runs tests and checks using
Bash access.

---

## W

### Workflow
A series of steps to accomplish a task. Chained Threads implement
workflows with checkpoints.

### Worktree
A Git feature allowing multiple working copies of a repository. Useful
for parallel development on different branches.

---

## X

*No terms starting with X*

---

## Y

### YAML (YAML Ain't Markup Language)
A human-readable format for configuration data. Used in frontmatter
for commands and agents.

**Example:**
```yaml
name: example
description: A description
tools: Read, Grep
```

---

## Z

### Zero-Touch Thread (Z-Thread)
The theoretical ideal where AI works with such high confidence that
human review becomes optional. Requires comprehensive automated
validation.

**Pattern:** Prompt → AI works → Automated validation → Done
(No human review needed)

---

## Thread Type Quick Reference

| Short Name | Full Name | Key Characteristic |
|------------|-----------|-------------------|
| B-Thread | Base Thread | Single prompt, simple review |
| P-Thread | Parallel Thread | Multiple agents, same time |
| C-Thread | Chained Thread | Multiple phases, human checkpoints |
| F-Thread | Fusion Thread | Multiple agents, aggregated result |
| M-Thread | Meta/Big Thread | Agents spawning agents |
| L-Thread | Long Thread | Extended work, Ralph Wiggum |
| Z-Thread | Zero-Touch Thread | Fully automated validation |

---

## Related Documentation

- [Quick Start Guide](QUICK_START.md) - Get started with examples
- [User Guide](USER_GUIDE.md) - Complete usage instructions
- [Developer Guide](DEVELOPER_GUIDE.md) - Extend the plugin
- [Architecture](ARCHITECTURE.md) - Technical design details
- [Troubleshooting](TROUBLESHOOTING.md) - Common problems and solutions
- [FAQ](FAQ.md) - Frequently asked questions

---

*Glossary for Thread-Based Engineering Plugin v1.0.0*
