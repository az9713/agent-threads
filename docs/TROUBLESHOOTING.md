# Troubleshooting Guide

This guide helps you solve common problems with the Thread-Based Engineering plugin.
Problems are organized by category for easy lookup.

---

## Table of Contents

1. [Installation Problems](#1-installation-problems)
2. [Command Problems](#2-command-problems)
3. [Script Problems](#3-script-problems)
4. [Hook Problems](#4-hook-problems)
5. [Agent Problems](#5-agent-problems)
6. [Performance Problems](#6-performance-problems)
7. [Platform-Specific Issues](#7-platform-specific-issues)
8. [Getting More Help](#8-getting-more-help)

---

## 1. Installation Problems

### Problem: "Command not found: claude"

**Symptoms:**
```
bash: claude: command not found
```

**Causes:**
- Claude Code is not installed
- Claude Code is not in your PATH

**Solutions:**

1. **Install Claude Code:**
   ```bash
   npm install -g @anthropic-ai/claude-code
   ```

2. **Check installation:**
   ```bash
   claude --version
   ```

3. **If still not found, add npm global bin to PATH:**

   **Windows (Git Bash):**
   ```bash
   export PATH="$PATH:$(npm config get prefix)/bin"
   ```

   **Mac/Linux:**
   ```bash
   export PATH="$PATH:$(npm bin -g)"
   ```

4. **Make permanent by adding to shell config:**
   - Windows: Add to `~/.bashrc`
   - Mac: Add to `~/.zshrc` or `~/.bash_profile`
   - Linux: Add to `~/.bashrc`

---

### Problem: "Plugin not found" after installation

**Symptoms:**
```
Plugin 'agent-threads' not found
```
or
```
Unknown command: /agent-threads:base
```

**Causes:**
- Plugin not properly installed
- Wrong directory path during install
- Missing plugin.json file

**Solutions:**

1. **Verify plugin.json exists:**
   ```bash
   ls -la /path/to/agent-threads/.claude-plugin/plugin.json
   ```

2. **Reinstall the plugin:**
   ```bash
   cd /path/to/agent-threads
   claude /plugin install .
   ```

3. **Check plugin list:**
   ```bash
   claude /plugins
   ```
   You should see `agent-threads` in the list.

4. **Try with absolute path:**
   ```bash
   # Windows (Git Bash)
   claude /plugin install /c/Users/YourName/path/to/agent-threads

   # Mac/Linux
   claude /plugin install /Users/YourName/path/to/agent-threads
   ```

---

### Problem: npm installation fails

**Symptoms:**
```
npm ERR! code EACCES
npm ERR! permission denied
```

**Causes:**
- Insufficient permissions for global install

**Solutions:**

1. **Mac/Linux - Use sudo (not ideal):**
   ```bash
   sudo npm install -g @anthropic-ai/claude-code
   ```

2. **Better - Fix npm permissions:**
   ```bash
   mkdir ~/.npm-global
   npm config set prefix '~/.npm-global'
   export PATH=~/.npm-global/bin:$PATH
   ```
   Add the export line to your shell config file.

3. **Windows - Run Git Bash as Administrator:**
   Right-click Git Bash → "Run as administrator"

---

## 2. Command Problems

### Problem: Command shows "undefined" instead of arguments

**Symptoms:**
When you type `/agent-threads:base src/`, Claude says something about "undefined"

**Causes:**
- The `$ARGUMENTS` placeholder isn't being replaced properly
- Older version of Claude Code

**Solutions:**

1. **Update Claude Code:**
   ```bash
   npm update -g @anthropic-ai/claude-code
   ```

2. **Pass arguments directly after the command:**
   ```
   /agent-threads:base src/main.js
   ```

3. **If still broken, ask Claude directly:**
   ```
   Analyze the src/ directory for me
   ```

---

### Problem: "Tool not allowed" error

**Symptoms:**
```
Error: Tool 'Bash' is not allowed for this command
```

**Causes:**
- The command's frontmatter restricts available tools
- Trying to do something the command wasn't designed for

**Solutions:**

1. **Check what tools are allowed:**
   Look at the command file's frontmatter:
   ```yaml
   allowed-tools: Read, Grep, Glob
   ```

2. **Use a different command:**
   - For read-only work: `/agent-threads:base`
   - For writing files: `/agent-threads:chained`
   - For running tests: `/agent-threads:zero-touch`

3. **Ask directly without using a command:**
   Just type your request without using a slash command.

---

### Problem: Command takes too long

**Symptoms:**
- Claude Code seems stuck
- No output for several minutes

**Causes:**
- Large codebase taking time to analyze
- Network latency
- Model processing complex request

**Solutions:**

1. **Be more specific:**
   Instead of:
   ```
   /agent-threads:base
   ```
   Try:
   ```
   /agent-threads:base src/auth/
   ```

2. **Set a timeout:**
   ```bash
   claude -p "your prompt" --max-turns 10
   ```

3. **Check if it's actually working:**
   Look for tool call output (like file reads) appearing.

4. **Cancel and try again:**
   Press `Ctrl+C` and restart with a narrower scope.

---

## 3. Script Problems

### Problem: "Permission denied" when running scripts

**Symptoms:**
```
bash: ./scripts/parallel-runner.sh: Permission denied
```

**Causes:**
- Script doesn't have execute permissions

**Solutions:**

1. **Add execute permission:**
   ```bash
   chmod +x scripts/*.sh
   ```

2. **Or run with bash explicitly:**
   ```bash
   bash scripts/parallel-runner.sh
   ```

---

### Problem: Scripts don't work on Windows

**Symptoms:**
- Syntax errors
- Commands not found
- Path issues

**Causes:**
- Using Windows Command Prompt instead of Git Bash
- Windows path format issues

**Solutions:**

1. **Always use Git Bash on Windows:**
   Open Git Bash, not Command Prompt or PowerShell.

2. **Use forward slashes:**
   ```bash
   # Wrong (Windows style)
   cd C:\Users\name\project

   # Right (Git Bash style)
   cd /c/Users/name/project
   ```

3. **Install Git for Windows:**
   Download from https://git-scm.com/download/win
   - Includes Git Bash
   - Choose "Git Bash Here" context menu option during install

---

### Problem: "jq: command not found"

**Symptoms:**
```
bash: jq: command not found
```
when running fusion-aggregator.sh

**Causes:**
- jq (JSON processor) not installed

**Solutions:**

1. **Windows (Git Bash):**
   - Download from https://stedolan.github.io/jq/download/
   - Put `jq.exe` in a directory in your PATH

2. **Mac:**
   ```bash
   brew install jq
   ```

3. **Linux (Debian/Ubuntu):**
   ```bash
   sudo apt install jq
   ```

4. **Skip jq requirement:**
   The fusion-aggregator script is optional. You can manually aggregate
   results or use Claude directly.

---

### Problem: Scripts produce wrong line endings

**Symptoms:**
```
-bash: ./script.sh: /bin/bash^M: bad interpreter
```

**Causes:**
- Windows-style line endings (CRLF) instead of Unix (LF)

**Solutions:**

1. **Convert line endings:**
   ```bash
   sed -i 's/\r$//' scripts/*.sh
   ```

2. **Or use dos2unix:**
   ```bash
   dos2unix scripts/*.sh
   ```

3. **Configure Git to handle this automatically:**
   ```bash
   git config --global core.autocrlf input
   ```

---

## 4. Hook Problems

### Problem: Stop hook not triggering

**Symptoms:**
- Claude stops without running validation
- Ralph Wiggum pattern not working

**Causes:**
- hooks.json not loaded
- Hook syntax error
- Script path incorrect

**Solutions:**

1. **Verify hooks are loaded:**
   ```
   /hooks
   ```
   Should show the Stop hook listed.

2. **Check hooks.json syntax:**
   ```bash
   cat hooks/hooks.json | python -m json.tool
   ```
   or
   ```bash
   cat hooks/hooks.json | jq .
   ```

3. **Check script path:**
   The path in hooks.json should be:
   ```json
   "command": "bash \"${CLAUDE_PROJECT_DIR}/scripts/ralph-loop.sh\""
   ```

4. **Reinstall plugin:**
   ```bash
   claude /plugin install .
   ```

---

### Problem: Hook script fails silently

**Symptoms:**
- Hook runs but doesn't do anything
- No error message but behavior is wrong

**Causes:**
- Script errors being swallowed
- Missing dependencies in script

**Solutions:**

1. **Test script manually:**
   ```bash
   ./scripts/ralph-loop.sh
   echo $?
   ```

2. **Check script has correct shebang:**
   First line should be:
   ```bash
   #!/bin/bash
   ```

3. **Add debugging to script:**
   Temporarily add `set -x` at the top to see what's happening.

---

### Problem: Hook timeout

**Symptoms:**
```
Hook timed out after X seconds
```

**Causes:**
- Script takes too long
- Script waiting for input
- Infinite loop in script

**Solutions:**

1. **Increase timeout in hooks.json:**
   ```json
   {
     "type": "command",
     "command": "...",
     "timeout": 120
   }
   ```

2. **Make script faster:**
   - Run fewer checks
   - Skip slow operations
   - Cache results

3. **Check for infinite loops:**
   Review script logic for conditions that never complete.

---

## 5. Agent Problems

### Problem: Agent not found

**Symptoms:**
```
Agent '@researcher' not found
```

**Causes:**
- Agent file missing
- Agent file has wrong format
- Plugin not installed properly

**Solutions:**

1. **Check agent file exists:**
   ```bash
   ls -la agents/researcher.md
   ```

2. **Verify frontmatter format:**
   ```yaml
   ---
   name: researcher
   description: ...
   tools: Read, Grep, Glob
   model: haiku
   ---
   ```

3. **Reinstall plugin:**
   ```bash
   claude /plugin install .
   ```

---

### Problem: Agent has wrong tools

**Symptoms:**
- Agent tries to use tools it shouldn't have
- "Tool not available" errors

**Causes:**
- Frontmatter tools list is incorrect
- Claude is ignoring tool restrictions (shouldn't happen)

**Solutions:**

1. **Check agent definition:**
   ```bash
   head -20 agents/researcher.md
   ```

2. **Verify tools match intent:**
   - Read-only agents: `tools: Read, Grep, Glob`
   - Write agents: `tools: Read, Write, Edit, Grep, Glob`
   - Validation agents: `tools: Bash, Read, Grep`

---

### Problem: Agent returns empty or no response

**Symptoms:**
- Agent spawns but returns nothing
- Task tool says "completed" but no output

**Causes:**
- Agent prompt is too vague
- Agent hit an error internally
- Context too large

**Solutions:**

1. **Be more specific in agent prompt:**
   Instead of "review the code", try "review src/auth.js for security issues"

2. **Check if project is too large:**
   Use narrower scope for agent tasks.

3. **Try with more capable model:**
   Change agent's model from `haiku` to `sonnet` in the frontmatter.

---

## 6. Performance Problems

### Problem: Claude Code is very slow

**Symptoms:**
- Long delays between responses
- Tool calls taking forever

**Causes:**
- Large files being processed
- Network latency
- API rate limiting

**Solutions:**

1. **Work with smaller scope:**
   ```
   Analyze only src/api/ instead of the entire project
   ```

2. **Use faster models:**
   Use Haiku for simple tasks.

3. **Check your internet connection:**
   Claude Code requires internet to work.

4. **Check API status:**
   Visit https://status.anthropic.com

---

### Problem: Running out of context

**Symptoms:**
- Claude "forgets" earlier conversation
- "Context limit reached" errors
- Summarization messages appearing

**Causes:**
- Too many files read
- Very long conversation
- Large code chunks

**Solutions:**

1. **Start a new session for new topics:**
   Exit and restart Claude Code.

2. **Be more targeted in requests:**
   Don't ask to "read everything" - specify what you need.

3. **Use agents for large tasks:**
   Agents have their own context windows.

---

## 7. Platform-Specific Issues

### Windows-Specific

**Problem: Paths with spaces don't work**

```bash
# This fails:
cd /c/Users/John Doe/Documents

# This works:
cd "/c/Users/John Doe/Documents"
# or
cd /c/Users/John\ Doe/Documents
```

**Problem: Git Bash not finding Claude**

Add to `~/.bashrc`:
```bash
export PATH="$PATH:/c/Users/YOUR_NAME/AppData/Roaming/npm"
```

---

### Mac-Specific

**Problem: "Developer cannot be verified" warning**

Go to System Preferences → Security & Privacy → General
Click "Allow Anyway" for Claude Code.

**Problem: zsh syntax issues**

Add to `~/.zshrc`:
```bash
alias claude='claude'
export PATH="$PATH:$(npm bin -g)"
```

---

### Linux-Specific

**Problem: Snap/Flatpak npm conflicts**

Use system npm instead:
```bash
sudo apt install nodejs npm
```

---

## 8. Getting More Help

### Before Asking for Help

1. **Check this guide** - Your problem might be listed above
2. **Check the FAQ** - See [FAQ.md](FAQ.md)
3. **Check Claude Code docs** - https://docs.anthropic.com/claude-code
4. **Reproduce the problem** - Can you reliably trigger it?

### Information to Gather

When asking for help, include:

1. **Operating System:**
   ```bash
   # Windows
   echo $OS

   # Mac/Linux
   uname -a
   ```

2. **Claude Code version:**
   ```bash
   claude --version
   ```

3. **Node/npm version:**
   ```bash
   node --version
   npm --version
   ```

4. **Exact error message** (copy-paste, don't paraphrase)

5. **Steps to reproduce** (numbered list)

6. **What you expected vs what happened**

### Where to Get Help

- **Claude Code Issues:** https://github.com/anthropics/claude-code/issues
- **Anthropic Support:** https://support.anthropic.com
- **Community Discord:** (if available)

### Quick Diagnostic Commands

Run these and include output when asking for help:

```bash
# Check Claude Code
claude --version

# Check plugin installation
claude /plugins

# Check hooks loaded
claude
/hooks

# Test a simple command
claude -p "Say hello" --print
```

---

## Quick Fixes Checklist

When something isn't working, try these in order:

- [ ] Are you using Git Bash (Windows) or Terminal (Mac/Linux)?
- [ ] Is Claude Code installed? (`claude --version`)
- [ ] Is the plugin installed? (`/plugins` shows `agent-threads`)
- [ ] Are you in the right directory?
- [ ] Do scripts have execute permission? (`chmod +x scripts/*.sh`)
- [ ] Is your internet working?
- [ ] Have you tried restarting Claude Code?
- [ ] Have you tried reinstalling the plugin?

---

## Related Documentation

- [Quick Start Guide](QUICK_START.md) - Step-by-step setup
- [User Guide](USER_GUIDE.md) - How to use features
- [Developer Guide](DEVELOPER_GUIDE.md) - How to extend
- [FAQ](FAQ.md) - Common questions
- [Glossary](GLOSSARY.md) - Terms explained

---

*Troubleshooting Guide for Thread-Based Engineering Plugin v1.0.0*
