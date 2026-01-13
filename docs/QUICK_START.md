# Quick Start Guide - Thread-Based Engineering

Welcome! This guide will get you up and running with the Thread-Based Engineering plugin
in just a few minutes. By the end, you'll have completed 14+ hands-on exercises that
demonstrate the power of working with AI agents across all 7 thread types.

---

## Table of Contents

1. [Prerequisites - What You Need](#1-prerequisites---what-you-need)
2. [Installation - Step by Step](#2-installation---step-by-step)
3. [Your First Thread](#3-your-first-thread)
4. [Hands-On Exercises by Thread Type](#4-hands-on-exercises-by-thread-type)
   - [Base Thread Examples](#base-thread-examples)
   - [Parallel Thread Examples](#parallel-thread-examples)
   - [Chained Thread Examples](#chained-thread-examples)
   - [Fusion Thread Examples](#fusion-thread-examples)
   - [Big Thread Examples](#big-thread-examples)
   - [Long Thread Examples](#long-thread-examples)
   - [Zero-Touch Thread Examples](#zero-touch-thread-examples)
5. [Quick Reference Card](#5-quick-reference-card)
6. [What's Next?](#6-whats-next)

---

## 1. Prerequisites - What You Need

Before starting, make sure you have these tools installed on your computer.

### Required Software

| Software | What It Is | How to Check | How to Install |
|----------|-----------|--------------|----------------|
| **Claude Code** | The AI coding assistant | Type `claude --version` | See [Installation](#installing-claude-code) |
| **Git Bash** (Windows) | A terminal that runs bash scripts | Open "Git Bash" from Start menu | Download from git-scm.com |
| **Terminal** (Mac/Linux) | Built-in command line | Open "Terminal" app | Already installed |

### Optional (But Helpful)

| Software | What It Is | Why It's Useful |
|----------|-----------|-----------------|
| **jq** | JSON processor | Needed for some scripts |
| **VS Code** | Code editor | Nice interface for Claude Code |

### Installing Claude Code

If you don't have Claude Code installed, follow these steps:

**On Mac/Linux:**
```bash
# Open Terminal and run:
npm install -g @anthropic-ai/claude-code

# Verify installation:
claude --version
```

**On Windows:**
```bash
# Open Git Bash and run:
npm install -g @anthropic-ai/claude-code

# Verify installation:
claude --version
```

> **Don't have npm?** Install Node.js first from nodejs.org - npm comes with it.

---

## 2. Installation - Step by Step

### Step 2.1: Open Your Terminal

- **Windows**: Open "Git Bash" from the Start menu
- **Mac**: Press Cmd+Space, type "Terminal", press Enter
- **Linux**: Press Ctrl+Alt+T

### Step 2.2: Navigate to the Plugin Folder

```bash
# Change to where the plugin is located
cd /path/to/agent-threads

# Example on Windows (Git Bash):
cd /c/Users/YourName/Downloads/agent_threads_dan/agent-threads

# Example on Mac/Linux:
cd ~/Downloads/agent_threads_dan/agent-threads
```

### Step 2.3: Install the Plugin

```bash
# Install the plugin into Claude Code
claude /plugin install .
```

You should see a message confirming the installation.

### Step 2.4: Verify Installation

```bash
# Start Claude Code
claude

# Once inside, type:
/agent-threads:base
```

If you see the Base Thread explanation, congratulations! You're ready to go.

---

## 3. Your First Thread

Let's run your very first thread to understand how this all works.

### What is a Thread?

Think of a thread like asking a skilled assistant to do a task:

1. **You START** - Give instructions (the prompt)
2. **AI WORKS** - The assistant does the work (tool calls)
3. **You REVIEW** - Check the results

That's it! Every interaction with Claude Code follows this pattern.

### Try It Now

Open Claude Code and type:

```
What files are in this directory? Give me a brief summary.
```

Watch what happens:
1. You provided the prompt (START)
2. Claude reads files, analyzes them (WORK)
3. Claude shows you results, you review them (END)

**Congratulations!** You just completed your first Base Thread.

---

## 4. Hands-On Exercises by Thread Type

These exercises teach you all 7 thread types with at least 2 examples each.
Each exercise takes 2-5 minutes.

---

### Base Thread Examples

The **Base Thread** is the fundamental pattern: You prompt, AI works, you review.

---

#### Exercise 1: Explore a Codebase

**Goal:** Quickly understand what a project does.

**Steps:**
1. Open Claude Code in any project folder:
   ```bash
   cd /path/to/any/project
   claude
   ```

2. Ask Claude:
   ```
   What does this project do? Give me a high-level overview.
   ```

3. Review the summary Claude provides.

**What You Learned:** The Base Thread pattern - prompt, work, review.

---

#### Exercise 2: Find Specific Code

**Goal:** Locate where something is implemented.

**Steps:**
1. In Claude Code, ask:
   ```
   Where is user authentication handled in this codebase?
   Show me the specific files and functions.
   ```

2. Review the files and functions Claude identifies.

3. Ask a follow-up:
   ```
   How does the password validation work in that file?
   ```

**What You Learned:** Claude can search, navigate, and explain code for you.

---

### Parallel Thread Examples

**Parallel Threads** run multiple Claude instances at the same time for more output.

---

#### Exercise 3: Parallel Code Reviews

**Goal:** Run multiple reviews simultaneously.

**Steps:**
1. Learn about parallel threads:
   ```
   /agent-threads:parallel
   ```

2. Open TWO terminal windows side by side.

3. In **Terminal 1**, run:
   ```bash
   claude -p "Review the authentication code in this project for security issues"
   ```

4. In **Terminal 2**, run at the same time:
   ```bash
   claude -p "Review the database queries in this project for performance issues"
   ```

5. Both run at the same time! Review both results when done.

**What You Learned:** Multiple agents = more work done in parallel.

---

#### Exercise 4: Use the Parallel Runner Script

**Goal:** Spawn multiple agents with one command.

**Steps:**
1. Navigate to the plugin directory:
   ```bash
   cd /path/to/agent-threads
   ```

2. Run the parallel runner script:
   ```bash
   ./scripts/parallel-runner.sh "Analyze this codebase for potential bugs" 3
   ```
   This spawns 3 parallel Claude instances.

3. Wait for all to complete, then check the result files:
   ```bash
   ls parallel-result-*.json
   ```

4. Review each result file to see what different instances found.

**What You Learned:** Scripts can automate parallel agent orchestration.

---

### Chained Thread Examples

**Chained Threads** break work into phases with human review between each.

---

#### Exercise 5: Plan-Then-Build Workflow

**Goal:** Safely implement a feature with planning first.

**Steps:**
1. Learn about chained threads:
   ```
   /agent-threads:chained
   ```

2. **Phase 1 - Planning** (ask Claude):
   ```
   I want to add a new feature: user profile pages.
   Create a detailed plan. What files need to change? What's the approach?
   DO NOT implement yet - just create the plan.
   ```

3. **Review the plan carefully.** Is it sensible? Any concerns?

4. **Phase 2 - Implementation** (if plan looks good):
   ```
   The plan looks good. Now implement step 1 of the plan only.
   Stop after step 1 so I can review.
   ```

5. Review the implementation, then continue with step 2, etc.

**What You Learned:** Breaking work into phases = safer, more controlled changes.

---

#### Exercise 6: Use the Chained Workflow Script

**Goal:** Run a multi-phase workflow with automatic pauses.

**Steps:**
1. Run the chained workflow script:
   ```bash
   ./scripts/chained-workflow.sh "Add input validation to the login form"
   ```

2. The script will:
   - Run Phase 1 (Planning)
   - **PAUSE** and ask you to review
   - Press Enter to continue to Phase 2 (Implementation)
   - **PAUSE** again for review
   - Press Enter for Phase 3 (Validation)

3. Notice how you're in control at each checkpoint.

**What You Learned:** Chained workflows give you review points for safety.

---

### Fusion Thread Examples

**Fusion Threads** get multiple perspectives on the same problem, then combine them.

---

#### Exercise 7: Get Multiple Design Approaches

**Goal:** Compare different solutions to the same problem.

**Steps:**
1. Learn about fusion threads:
   ```
   /agent-threads:fusion
   ```

2. Ask Claude for multiple approaches in one prompt:
   ```
   Give me THREE different approaches to implement caching in a REST API.

   For each approach:
   - Name the approach
   - Explain how it works
   - List 3 pros and 3 cons
   - Rate complexity (Easy/Medium/Hard)

   Then recommend which approach is best for a small team.
   ```

3. Review all three approaches and the recommendation.

**What You Learned:** Multiple perspectives lead to better decisions.

---

#### Exercise 8: Use the Fusion Aggregator Script

**Goal:** Combine results from multiple parallel agents.

**Steps:**
1. First, run parallel agents with the same task:
   ```bash
   # Terminal 1
   claude -p "What are the top 3 bugs in this codebase?" --output-format json > fusion-1.json &

   # Terminal 2
   claude -p "What are the top 3 bugs in this codebase?" --output-format json > fusion-2.json &

   # Terminal 3
   claude -p "What are the top 3 bugs in this codebase?" --output-format json > fusion-3.json &

   wait  # Wait for all to complete
   ```

2. Run the fusion aggregator:
   ```bash
   ./scripts/fusion-aggregator.sh fusion-*.json
   ```

3. The aggregator uses Claude to synthesize the best answer from all three.

**What You Learned:** Fusion combines multiple agent outputs into one superior result.

---

### Big Thread Examples

**Big Threads** (also called Meta Threads) use agents that orchestrate other agents.
The primary Claude delegates to specialized sub-agents.

---

#### Exercise 9: Orchestrate a Code Review Team

**Goal:** Use Claude to coordinate multiple specialized agents.

**Steps:**
1. Learn about big threads:
   ```
   /agent-threads:big
   ```

2. Ask Claude to orchestrate a review using sub-agents:
   ```
   I need a comprehensive code review of this project.

   Please orchestrate this as follows:
   1. First, use an exploration agent to map the codebase structure
   2. Then, use a review agent to find bugs and security issues
   3. Finally, use a validation agent to check if tests pass

   Synthesize all findings into a final report.
   ```

3. Watch as Claude spawns sub-agents (you'll see "Task" tool calls).

4. Review the synthesized final report.

**What You Learned:** Big threads let you orchestrate teams of specialized agents.

---

#### Exercise 10: Research-Plan-Build Pipeline

**Goal:** Use nested agents for a complete feature workflow.

**Steps:**
1. Give Claude a complex task requiring multiple specialists:
   ```
   I want to add rate limiting to my API.

   Please handle this with specialized agents:
   1. RESEARCH: First, explore my codebase and find where API routes are defined.
      Identify the framework being used.
   2. PLAN: Based on the research, create a plan for adding rate limiting.
      Consider what library to use and where to add the middleware.
   3. BUILD: Implement the rate limiting based on the plan.

   Use sub-agents for each phase. Report back after each phase completes.
   ```

2. Claude will:
   - Spawn a research agent (read-only exploration)
   - Use those findings to spawn a planning agent
   - Use the plan to spawn a builder agent

3. Review the progression through each phase.

**What You Learned:** Big threads enable complex, multi-step workflows with specialized agents.

---

### Long Thread Examples

**Long Threads** run for extended periods with validation loops.
They use the "Ralph Wiggum" pattern - code that controls when the agent continues or stops.

---

#### Exercise 11: Extended Bug Fixing Session

**Goal:** Let Claude work autonomously with validation checkpoints.

**Steps:**
1. Learn about long threads:
   ```
   /agent-threads:long
   ```

2. Give Claude an extended task with validation criteria:
   ```
   Fix all the lint errors in this project.

   Rules:
   - Run the linter after each fix
   - Keep working until ALL lint errors are resolved
   - If you think you're done, verify by running the linter one more time
   - Only stop when the linter reports zero errors
   ```

3. Watch Claude work through multiple iterations:
   - Fix some errors
   - Run linter
   - Find more errors
   - Fix those
   - Repeat until clean

**What You Learned:** Long threads continue until validation criteria are met.

---

#### Exercise 12: Understand the Ralph Wiggum Stop Hook

**Goal:** See how the stop hook validates work before allowing completion.

**Steps:**
1. Check that hooks are loaded:
   ```
   /hooks
   ```
   You should see a Stop hook listed.

2. Look at the hook script:
   ```bash
   cat scripts/ralph-loop.sh
   ```

3. The script checks:
   - Are tests passing?
   - Are there remaining TODOs?
   - Are there lint errors?

4. Try a task that triggers validation:
   ```
   Fix any failing tests in this project.
   Don't stop until all tests pass.
   ```

5. If your project has tests, the Stop hook will prevent Claude from
   stopping until tests actually pass.

**What You Learned:** Stop hooks enforce "Code + Agents > Agents Alone" -
deterministic code controls when AI can stop.

---

### Zero-Touch Thread Examples

**Zero-Touch Threads** are fully automated with no human review needed.
This requires comprehensive validation that you trust completely.

---

#### Exercise 13: Run the Validation Suite

**Goal:** See what comprehensive validation looks like.

**Steps:**
1. Learn about zero-touch threads:
   ```
   /agent-threads:zero-touch
   ```

2. Run the zero-touch validator:
   ```bash
   ./scripts/zero-touch-validator.sh
   ```

3. The script checks (if available in your project):
   - Linting (code style)
   - Type checking (TypeScript/mypy)
   - Unit tests
   - Build process
   - Security audit
   - Git state (uncommitted changes)

4. Review the output:
   - ALL PASSED = Z-Thread confidence achieved
   - ANY FAILED = Human review still required

**What You Learned:** Zero-Touch requires passing ALL automated checks.

---

#### Exercise 14: Experience the Zero-Touch Ideal

**Goal:** Understand when Zero-Touch is appropriate.

**Steps:**
1. Ask Claude about your project's readiness:
   ```
   Analyze this project's test coverage and validation setup.

   Tell me:
   1. What percentage of code is covered by tests?
   2. Is there linting configured?
   3. Is there type checking?
   4. Is there a CI/CD pipeline?

   Based on this, rate my project's "Zero-Touch readiness" from 1-10.
   What would I need to add to achieve Zero-Touch confidence?
   ```

2. Review Claude's assessment.

3. The goal is to build toward Zero-Touch over time:
   - Add tests
   - Add type checking
   - Add linting
   - Add CI/CD

**What You Learned:** Zero-Touch is a goal to work toward, achieved through
comprehensive automated validation.

---

## 5. Quick Reference Card

Print this out or keep it handy!

### Thread Types Summary

| Thread | Name | Pattern | When to Use |
|--------|------|---------|-------------|
| **Base** | Base Thread | Prompt → Work → Review | Simple tasks, learning |
| **P** | Parallel | Multiple agents, same time | Independent tasks, scaling |
| **C** | Chained | Phases with checkpoints | High-risk changes |
| **F** | Fusion | Multiple agents, aggregate | Need high confidence |
| **B** | Big/Meta | Agents using agents | Complex workflows |
| **L** | Long | Extended work + validation | Autonomous tasks |
| **Z** | Zero-Touch | Full automation | Mature codebases |

### Common Commands

| I Want To... | Command/Approach |
|--------------|------------------|
| Learn about a thread type | `/agent-threads:base` (or parallel, chained, etc.) |
| Run parallel agents | `./scripts/parallel-runner.sh "task" 3` |
| Run chained workflow | `./scripts/chained-workflow.sh "task"` |
| Aggregate fusion results | `./scripts/fusion-aggregator.sh *.json` |
| Run validation suite | `./scripts/zero-touch-validator.sh` |
| Check loaded hooks | `/hooks` |

### Improvement Metrics

1. **Run MORE threads** - Parallelize independent work
2. **Run LONGER threads** - Increase autonomy
3. **Run THICKER threads** - Use nested sub-agents
4. **Run FEWER checkpoints** - Build trust with validation

---

## 6. What's Next?

Congratulations! You've completed the Quick Start Guide with all 7 thread types.

### For Users
- **[User Guide](USER_GUIDE.md)** - Complete guide to all features
- **[FAQ](FAQ.md)** - Answers to common questions
- **[Troubleshooting](TROUBLESHOOTING.md)** - Solutions to common problems

### For Developers
- **[Developer Guide](DEVELOPER_GUIDE.md)** - How to extend the plugin
- **[Architecture](ARCHITECTURE.md)** - Technical design details
- **[Glossary](GLOSSARY.md)** - All terms and definitions

### Keep Practicing

The key to mastering thread-based engineering:
1. **Start simple** - Use Base Threads until comfortable
2. **Add parallelism** - Try P-Threads when you have independent tasks
3. **Add checkpoints** - Use C-Threads for important work
4. **Try orchestration** - Use B-Threads for complex multi-step work
5. **Extend autonomy** - Use L-Threads with validation loops
6. **Build toward automation** - Work toward Z-Threads

---

## Need Help?

- **Stuck?** Check [Troubleshooting](TROUBLESHOOTING.md)
- **Questions?** Check [FAQ](FAQ.md)
- **Want to learn more?** Read the [User Guide](USER_GUIDE.md)

---

*Happy threading!*
