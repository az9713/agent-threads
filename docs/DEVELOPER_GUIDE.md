# Developer Guide - Thread-Based Engineering Plugin

This guide is for developers who want to understand, modify, or extend this plugin.
It assumes you have some programming experience (C, C++, Java, Python, etc.) but may
be new to modern JavaScript/TypeScript tooling, AI assistants, or plugin development.

---

## Table of Contents

1. [Understanding the Technology Stack](#1-understanding-the-technology-stack)
2. [Project Structure Explained](#2-project-structure-explained)
3. [How Claude Code Plugins Work](#3-how-claude-code-plugins-work)
4. [Creating Slash Commands](#4-creating-slash-commands)
5. [Creating Custom Agents](#5-creating-custom-agents)
6. [Creating Skills](#6-creating-skills)
7. [Creating Hooks](#7-creating-hooks)
8. [Creating Scripts](#8-creating-scripts)
9. [Testing Your Changes](#9-testing-your-changes)
10. [Contributing Guidelines](#10-contributing-guidelines)

---

## 1. Understanding the Technology Stack

### 1.1 What Technologies Are Used?

| Technology | What It Is | Why We Use It |
|------------|-----------|---------------|
| **Claude Code** | Anthropic's AI coding CLI | The platform we're extending |
| **Markdown** | Text formatting language | Commands, agents, skills are all Markdown |
| **YAML** | Data format (frontmatter) | Configuration in Markdown files |
| **JSON** | Data format | Plugin manifest, hooks config |
| **Bash** | Shell scripting | Standalone scripts |

### 1.2 Key Concepts for Traditional Developers

If you're coming from C/C++/Java, here are the key differences:

| Traditional | This Project | Notes |
|-------------|-------------|-------|
| Compile then run | Interpreted/JIT | Changes take effect immediately |
| `.h` and `.c` files | `.md` and `.json` files | Configuration-driven |
| `main()` function | Slash command invocation | User triggers commands |
| Linked libraries | Plugin system | Plugins extend Claude Code |
| Make/CMake | No build step | Just edit files and test |

### 1.3 File Formats You'll Work With

#### Markdown (.md)
Text with formatting. Used for commands, agents, skills.

```markdown
# Heading 1
## Heading 2

Normal paragraph text.

- Bullet point
- Another point

**Bold text** and *italic text*

`code inline`

```code block```
```

#### YAML Frontmatter
Configuration at the top of Markdown files, between `---` marks.

```markdown
---
name: my-command
description: What this command does
allowed-tools: Read, Write
---

# Rest of the file is Markdown
```

#### JSON
Data format for structured configuration.

```json
{
  "name": "plugin-name",
  "version": "1.0.0",
  "description": "What this plugin does"
}
```

---

## 2. Project Structure Explained

### 2.1 Complete Directory Tree

```
agent-threads/
│
├── .claude-plugin/           # REQUIRED: Plugin identity
│   └── plugin.json           # Plugin manifest (name, version, etc.)
│
├── CLAUDE.md                 # Project memory for Claude
├── README.md                 # Main documentation
│
├── docs/                     # Documentation files
│   ├── QUICK_START.md
│   ├── USER_GUIDE.md
│   ├── DEVELOPER_GUIDE.md    # This file
│   ├── ARCHITECTURE.md
│   ├── GLOSSARY.md
│   ├── TROUBLESHOOTING.md
│   └── FAQ.md
│
├── commands/                 # Slash commands
│   ├── base.md               # /agent-threads:base
│   ├── parallel.md           # /agent-threads:parallel
│   ├── chained.md            # etc.
│   ├── fusion.md
│   ├── big.md
│   ├── long.md
│   └── zero-touch.md
│
├── agents/                   # Custom sub-agents
│   ├── researcher.md
│   ├── reviewer.md
│   ├── builder.md
│   └── validator.md
│
├── skills/                   # Skills (knowledge + guidance)
│   └── thread-patterns/
│       ├── SKILL.md          # Main skill file
│       └── examples.md       # Supporting file
│
├── hooks/                    # Event hooks
│   └── hooks.json            # Hook configuration
│
└── scripts/                  # Bash scripts
    ├── parallel-runner.sh
    ├── fusion-aggregator.sh
    ├── chained-workflow.sh
    ├── ralph-loop.sh
    └── zero-touch-validator.sh
```

### 2.2 What Each Directory Does

#### `.claude-plugin/`
**Purpose:** Identifies this folder as a Claude Code plugin.

**Required:** Yes. Without this, Claude Code won't recognize it as a plugin.

**Contents:** Just `plugin.json` with basic metadata.

#### `commands/`
**Purpose:** Defines slash commands users can invoke.

**How it works:** Each `.md` file becomes a command named after the plugin and file.
Example: `commands/base.md` → `/agent-threads:base`

#### `agents/`
**Purpose:** Defines custom AI sub-agents with specific roles and tool access.

**How it works:** Claude Code loads these and can delegate work to them using
the Task tool.

#### `skills/`
**Purpose:** Provides knowledge and guidance Claude can draw upon.

**How it works:** When Claude encounters relevant tasks, it may reference
these skills for guidance.

#### `hooks/`
**Purpose:** Defines event handlers that run at specific times.

**How it works:** When events occur (like tool use or stopping), these hooks
run custom code.

#### `scripts/`
**Purpose:** Standalone bash scripts users can run directly.

**How it works:** Users execute these from the terminal independently of
Claude Code.

---

## 3. How Claude Code Plugins Work

### 3.1 Plugin Lifecycle

```
1. INSTALLATION
   User runs: claude /plugin install ./agent-threads
   Claude Code reads plugin.json and registers the plugin

2. LOADING
   When Claude Code starts, it loads all installed plugins
   Commands, agents, skills, hooks become available

3. USAGE
   User invokes /agent-threads:base
   Claude Code finds commands/base.md and executes it

4. UNINSTALLATION
   User runs: claude /plugin uninstall agent-threads
   Plugin is removed
```

### 3.2 The Plugin Manifest

**File:** `.claude-plugin/plugin.json`

```json
{
  "name": "agent-threads",
  "description": "Thread-Based Engineering examples",
  "version": "1.0.0",
  "author": {
    "name": "Your Name"
  }
}
```

**Fields explained:**

| Field | Required | Purpose |
|-------|----------|---------|
| `name` | Yes | Unique identifier, used in command prefixes |
| `description` | Yes | Shown in plugin listings |
| `version` | Yes | Semantic versioning (major.minor.patch) |
| `author.name` | No | Credit information |

### 3.3 How Commands Get Named

The command name follows this pattern:
```
/[plugin-name]:[command-file-name]
```

Examples:
- Plugin `agent-threads` + file `base.md` = `/agent-threads:base`
- Plugin `my-tools` + file `format-code.md` = `/my-tools:format-code`

---

## 4. Creating Slash Commands

### 4.1 Basic Command Structure

```markdown
---
description: What this command does (shown in help)
allowed-tools: Tool1, Tool2, Tool3
---

# Command Title

Instructions for Claude go here.

Claude will follow these instructions when the user runs this command.
```

### 4.2 Step-by-Step: Create a New Command

**Goal:** Create a command that summarizes a file.

**Step 1:** Create the file
```bash
# Navigate to commands directory
cd agent-threads/commands

# Create new file
touch summarize.md
```

**Step 2:** Add content
```markdown
---
description: Summarize any file in plain language
allowed-tools: Read
---

# File Summarizer

## Instructions

The user wants you to summarize a file.

1. Read the file specified in $ARGUMENTS
2. Analyze its contents
3. Provide a summary that includes:
   - What the file does (purpose)
   - Key components or sections
   - Any important patterns or structures

## If No File Specified

If the user didn't specify a file, ask them which file they'd like summarized.
List some files in the current directory as suggestions.

## Output Format

Start with a one-sentence summary, then provide bullet points for details.
```

**Step 3:** Test the command
```bash
# Reinstall the plugin
claude /plugin install ./agent-threads

# Start Claude Code and test
claude
/agent-threads:summarize README.md
```

### 4.3 Available Frontmatter Options

| Option | Type | Purpose |
|--------|------|---------|
| `description` | string | Help text shown to users |
| `allowed-tools` | string | Comma-separated tool names |
| `model` | string | Override AI model (sonnet, opus, haiku) |

### 4.4 Using Arguments

Users can pass arguments to commands:
```
/agent-threads:summarize README.md
```

In your command file, use `$ARGUMENTS` to reference them:
```markdown
Read the file: $ARGUMENTS

If $ARGUMENTS is empty, ask the user which file to summarize.
```

---

## 5. Creating Custom Agents

### 5.1 What Are Agents?

Agents are specialized AI helpers with:
- A specific purpose
- Defined tool access
- A chosen AI model
- Custom instructions

### 5.2 Agent File Structure

```markdown
---
name: agent-name
description: When Claude should use this agent
tools: Tool1, Tool2
model: sonnet
---

# Agent Instructions

You are a [role]. Your job is to:

1. First task
2. Second task
3. Third task

## Guidelines

- Do this
- Don't do that

## Output Format

How to structure your responses.
```

### 5.3 Step-by-Step: Create a New Agent

**Goal:** Create an agent that writes test cases.

**Step 1:** Create the file
```bash
cd agent-threads/agents
touch test-writer.md
```

**Step 2:** Add content
```markdown
---
name: test-writer
description: Test case writer. Use when you need to create unit tests for code. Specializes in writing comprehensive test suites.
tools: Read, Write, Grep, Glob
model: sonnet
---

# Test Writer Agent

You are an expert test engineer. Your job is to write comprehensive unit tests.

## Process

1. First, read and understand the code to be tested
2. Identify all functions and methods that need tests
3. For each function, write tests for:
   - Normal/happy path
   - Edge cases
   - Error conditions
4. Write the test file(s)

## Test Writing Guidelines

- Use descriptive test names that explain what's being tested
- Follow the Arrange-Act-Assert pattern
- One assertion per test when possible
- Test behavior, not implementation details

## Output Format

Create test files following the project's existing patterns.
If no test patterns exist, use Jest for JavaScript or pytest for Python.
```

**Step 3:** Test the agent

Claude will automatically use this agent when appropriate, or you can ask:
```
Use @test-writer to create tests for the UserService class.
```

### 5.4 Available Agent Options

| Option | Type | Purpose |
|--------|------|---------|
| `name` | string | Identifier (lowercase, hyphens) |
| `description` | string | When Claude should use this agent |
| `tools` | string | Comma-separated tools to enable |
| `disallowedTools` | string | Tools to explicitly block |
| `model` | string | AI model (sonnet, opus, haiku, inherit) |
| `permissionMode` | string | Permission handling |
| `skills` | string | Skills to load |
| `hooks` | object | Agent-specific hooks |

---

## 6. Creating Skills

### 6.1 What Are Skills?

Skills provide knowledge and guidance. Unlike commands (user-invoked) or agents
(work delegation), skills are background knowledge Claude draws upon.

### 6.2 Skill File Structure

```
skills/
└── my-skill/
    ├── SKILL.md        # Required: Main skill file
    └── details.md      # Optional: Supporting information
```

### 6.3 SKILL.md Structure

```markdown
---
name: skill-name
description: When this skill should be used
allowed-tools: Tool1, Tool2
---

# Skill Title

## Overview

What this skill provides.

## When to Use

Situations where this skill applies.

## Guidelines

Specific guidance for Claude.

## Examples

Examples of applying this skill.
```

### 6.4 Step-by-Step: Create a New Skill

**Goal:** Create a skill for writing good commit messages.

**Step 1:** Create the directory and files
```bash
mkdir -p agent-threads/skills/commit-messages
touch agent-threads/skills/commit-messages/SKILL.md
```

**Step 2:** Add content to SKILL.md
```markdown
---
name: commit-messages
description: Guidance for writing clear, conventional commit messages. Use when creating git commits.
allowed-tools: Read, Bash
---

# Commit Message Best Practices

## When This Applies

Use this guidance whenever creating a git commit message.

## Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting, no code change
- `refactor`: Code change that neither fixes nor adds
- `test`: Adding tests
- `chore`: Maintenance

## Rules

1. Subject line max 50 characters
2. Use imperative mood ("Add feature" not "Added feature")
3. No period at end of subject
4. Blank line between subject and body
5. Body explains what and why, not how

## Examples

Good:
```
feat(auth): add password reset functionality

Users can now reset their password via email.
Implements the forgot password flow with secure tokens.

Closes #123
```

Bad:
```
fixed stuff
```
```

**Step 3:** Test the skill

The skill will be used automatically when Claude writes commit messages.

---

## 7. Creating Hooks

### 7.1 What Are Hooks?

Hooks are event handlers that run at specific times:
- Before/after tool use
- When Claude tries to stop
- When sessions start/end

### 7.2 Hook Configuration

**File:** `hooks/hooks.json`

```json
{
  "description": "Description of these hooks",
  "hooks": {
    "EventName": [
      {
        "matcher": "ToolPattern",
        "hooks": [
          {
            "type": "command",
            "command": "your-script.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### 7.3 Available Events

| Event | When It Fires | Common Uses |
|-------|---------------|-------------|
| `PreToolUse` | Before a tool runs | Validation, blocking |
| `PostToolUse` | After a tool runs | Linting, formatting |
| `Stop` | Claude finishes | Validation loops |
| `SubagentStop` | Sub-agent finishes | Continuation logic |
| `UserPromptSubmit` | User sends prompt | Context injection |
| `SessionStart` | Session begins | Setup |
| `SessionEnd` | Session ends | Cleanup |

### 7.4 Step-by-Step: Create a New Hook

**Goal:** Run prettier on saved files.

**Step 1:** Create the script
```bash
touch agent-threads/scripts/format-on-save.sh
chmod +x agent-threads/scripts/format-on-save.sh
```

**Step 2:** Add script content
```bash
#!/bin/bash
# Read file path from stdin (passed by hook system)
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only format JS/TS files
if [[ "$FILE_PATH" == *.js || "$FILE_PATH" == *.ts ]]; then
    npx prettier --write "$FILE_PATH" 2>/dev/null
fi

exit 0
```

**Step 3:** Add to hooks.json
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "bash ${CLAUDE_PROJECT_DIR}/scripts/format-on-save.sh",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

### 7.5 Hook Return Values

| Exit Code | Meaning |
|-----------|---------|
| 0 | Success, continue |
| 2 | Block the action (for PreToolUse) |
| Other | Error, logged but continues |

For Stop hooks, return JSON to control continuation:
```json
{"continue": true, "reason": "Tests still failing"}
```

---

## 8. Creating Scripts

### 8.1 Script Guidelines

- Use bash (works in Git Bash on Windows)
- Include usage instructions in comments
- Handle errors gracefully
- Provide meaningful output

### 8.2 Script Template

```bash
#!/bin/bash
#
# Script Name: What this script does
#
# Usage: ./script-name.sh [arguments]
#
# Example:
#   ./script-name.sh "my input"
#

set -e  # Exit on error

# Default values
INPUT="${1:-default value}"

# Main logic here
echo "Processing: $INPUT"

# More logic...

echo "Done!"
```

### 8.3 Step-by-Step: Create a New Script

**Goal:** Create a script that shows thread type recommendations.

**Step 1:** Create the file
```bash
touch agent-threads/scripts/recommend-thread.sh
chmod +x agent-threads/scripts/recommend-thread.sh
```

**Step 2:** Add content
```bash
#!/bin/bash
#
# Thread Recommender: Suggests which thread type to use
#
# Usage: ./recommend-thread.sh
#

echo "Thread Type Recommender"
echo "======================"
echo ""
echo "Answer these questions to find the right thread type:"
echo ""

read -p "1. Is this a quick question or simple task? (y/n): " simple
if [ "$simple" = "y" ]; then
    echo ""
    echo "Recommendation: BASE THREAD"
    echo "Just type your question into Claude Code."
    exit 0
fi

read -p "2. Can the work be split into independent parts? (y/n): " parallel
if [ "$parallel" = "y" ]; then
    read -p "3. Do you want multiple opinions/approaches? (y/n): " fusion
    if [ "$fusion" = "y" ]; then
        echo ""
        echo "Recommendation: FUSION THREAD (F-Thread)"
        echo "Run: ./scripts/parallel-runner.sh 'your task' 3"
        echo "Then: ./scripts/fusion-aggregator.sh parallel-result-*.json"
    else
        echo ""
        echo "Recommendation: PARALLEL THREAD (P-Thread)"
        echo "Run: ./scripts/parallel-runner.sh 'your task' 3"
    fi
    exit 0
fi

read -p "4. Is this production-critical or high-risk? (y/n): " risky
if [ "$risky" = "y" ]; then
    echo ""
    echo "Recommendation: CHAINED THREAD (C-Thread)"
    echo "Run: ./scripts/chained-workflow.sh 'your task'"
    exit 0
fi

read -p "5. Does this need multiple specialized steps? (y/n): " complex
if [ "$complex" = "y" ]; then
    echo ""
    echo "Recommendation: BIG THREAD (B-Thread)"
    echo "Use multiple agents: @researcher, @reviewer, @builder, @validator"
    exit 0
fi

read -p "6. Should this run for a long time autonomously? (y/n): " long
if [ "$long" = "y" ]; then
    echo ""
    echo "Recommendation: LONG THREAD (L-Thread)"
    echo "Configure stop hooks for validation loops."
    exit 0
fi

echo ""
echo "Recommendation: BASE THREAD"
echo "When in doubt, start simple and scale up as needed."
```

---

## 9. Testing Your Changes

### 9.1 Testing Commands

1. **Reinstall the plugin:**
   ```bash
   claude /plugin uninstall agent-threads
   claude /plugin install ./agent-threads
   ```

2. **Test the command:**
   ```bash
   claude
   /agent-threads:your-command
   ```

3. **Verify behavior matches expectations.**

### 9.2 Testing Agents

1. Reinstall the plugin (as above)

2. Ask Claude to use the agent:
   ```
   Use @your-agent to [task]
   ```

3. Verify the agent behaves as expected.

### 9.3 Testing Hooks

1. Reinstall the plugin

2. Trigger the event the hook responds to

3. Verify the hook runs and produces expected results

4. Check for errors:
   ```bash
   claude /hooks
   ```

### 9.4 Testing Scripts

Run scripts directly:
```bash
./scripts/your-script.sh "test input"
```

### 9.5 Common Testing Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Command not found | Plugin not installed | Reinstall plugin |
| Changes not appearing | Cached version | Reinstall plugin |
| Script errors | Permission or syntax | Check `bash -n script.sh` |
| Hook not firing | Wrong event or matcher | Check hooks.json syntax |

---

## 10. Contributing Guidelines

### 10.1 Code Style

- **Markdown:** Use proper headers, blank lines for readability
- **JSON:** 2-space indentation, trailing newline
- **Bash:** Include comments, use `set -e`, quote variables

### 10.2 Naming Conventions

| Type | Convention | Example |
|------|-----------|---------|
| Commands | lowercase, hyphens | `my-command.md` |
| Agents | lowercase, hyphens | `code-reviewer.md` |
| Skills | lowercase, hyphens | `commit-messages/` |
| Scripts | lowercase, hyphens | `run-tests.sh` |

### 10.3 Documentation Requirements

When adding features:
1. Add inline comments in the file
2. Update relevant docs (USER_GUIDE, etc.)
3. Add to CLAUDE.md if significant
4. Update README if needed

### 10.4 Pull Request Checklist

- [ ] Feature/fix works as expected
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
- [ ] Tested on Windows (Git Bash) and Mac/Linux
- [ ] Follows naming conventions

---

## Summary

You now know how to:

1. ✅ Understand the plugin structure
2. ✅ Create new slash commands
3. ✅ Create custom agents
4. ✅ Create skills
5. ✅ Create hooks
6. ✅ Create scripts
7. ✅ Test your changes

**Remember:**
- Start simple, iterate
- Test after every change
- Update documentation
- No technical debt!

---

*Questions? Check [FAQ](FAQ.md) or [Troubleshooting](TROUBLESHOOTING.md)*
