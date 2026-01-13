# Complete User Guide - Thread-Based Engineering

This comprehensive guide teaches you everything you need to know about thread-based
engineering with Claude Code. It's designed for users with little to no experience
with AI coding assistants.

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Understanding the Basics](#2-understanding-the-basics)
3. [Thread Types In-Depth](#3-thread-types-in-depth)
4. [Using Slash Commands](#4-using-slash-commands)
5. [Using Custom Agents](#5-using-custom-agents)
6. [Using Scripts](#6-using-scripts)
7. [Best Practices](#7-best-practices)
8. [Advanced Topics](#8-advanced-topics)
9. [Real-World Examples](#9-real-world-examples)

---

## 1. Introduction

### What is Thread-Based Engineering?

Thread-Based Engineering is a way of thinking about how you work with AI coding assistants.
Instead of thinking "I'm chatting with an AI," think "I'm running a thread of work."

### Why Does This Matter?

Traditional programming:
- You write code yourself
- You debug yourself
- You test yourself
- Everything depends on YOUR time

Thread-Based Engineering:
- You direct AI agents
- Agents write/debug/test
- Multiple agents can work in parallel
- Your output scales with compute, not just your time

### The Mental Shift

**Old way:** "How fast can I type and think?"
**New way:** "How many agents can I effectively coordinate?"

---

## 2. Understanding the Basics

### 2.1 What is Claude Code?

Claude Code is a command-line AI assistant made by Anthropic. It can:

- Read files and understand codebases
- Write and edit code
- Run commands in your terminal
- Search through code
- Answer questions about programming

### 2.2 How to Start Claude Code

**Step 1:** Open your terminal
- Windows: Git Bash
- Mac: Terminal app
- Linux: Terminal app

**Step 2:** Navigate to your project
```bash
cd /path/to/your/project
```

**Step 3:** Start Claude Code
```bash
claude
```

**Step 4:** Start typing prompts!

### 2.3 What is a Thread?

A thread has three parts:

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   1. YOU PROMPT          2. AGENT WORKS       3. YOU REVIEW     │
│   ┌─────────────┐        ┌─────────────┐      ┌─────────────┐   │
│   │  "Fix the   │   ──▶  │ Read files  │ ──▶  │ Check the   │   │
│   │   bug in    │        │ Analyze     │      │ fix, test   │   │
│   │  auth.js"   │        │ Edit file   │      │ it works    │   │
│   └─────────────┘        └─────────────┘      └─────────────┘   │
│                                                                 │
│   START                  MIDDLE               END               │
│   (Your time)            (Agent time)         (Your time)       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Key insight:** The middle part (agent work) happens WITHOUT you. This is where you
save time.

### 2.4 What are Tool Calls?

When Claude works, it makes "tool calls" - actions it takes:

| Tool | What It Does | Example |
|------|-------------|---------|
| Read | Reads a file | Read `src/auth.js` |
| Write | Creates a new file | Create `tests/auth.test.js` |
| Edit | Modifies a file | Change line 42 in `auth.js` |
| Bash | Runs terminal commands | Run `npm test` |
| Grep | Searches for text | Find all uses of `loginUser` |
| Glob | Finds files by pattern | Find all `*.test.js` files |

Each tool call is the agent doing work that you would have done manually.

### 2.5 The Core Four

Everything in agentic engineering comes back to four things:

| Element | What It Is | How to Improve It |
|---------|-----------|-------------------|
| **Context** | What the agent knows | Write better CLAUDE.md files |
| **Model** | The AI powering it | Choose Opus for complex, Haiku for fast |
| **Prompt** | Your instructions | Be clear, specific, give examples |
| **Tools** | Actions available | Enable right tools, add custom ones |

---

## 3. Thread Types In-Depth

### 3.1 Base Thread - The Foundation

**What it is:** The simplest thread - one prompt, one response.

**When to use:**
- Quick questions
- Simple tasks
- Learning and experimenting

**Example:**
```
You: What does the function calculateTotal do?

Claude: [Reads the file, explains the function]

You: [Review the explanation]
```

**Command to learn more:** `/agent-threads:base`

---

### 3.2 P-Thread (Parallel) - Scale Your Work

**What it is:** Multiple threads running at the same time.

**When to use:**
- Independent tasks (don't depend on each other)
- Code review of different modules
- Multiple explorations

**How it works:**

```
                    ┌── Terminal 1: Review auth/ ──┐
                    │                              │
YOU ────────────────┼── Terminal 2: Review api/  ──┼──── YOU REVIEW ALL
(one moment)        │                              │     (later)
                    └── Terminal 3: Review db/  ───┘
```

**Ways to run parallel threads:**

1. **Multiple terminals (easiest):**
   - Open 3 terminal windows
   - Run a different `claude -p "task"` in each

2. **Using the script:**
   ```bash
   ./scripts/parallel-runner.sh "Review this code" 3
   ```

**Command to learn more:** `/agent-threads:parallel`

---

### 3.3 C-Thread (Chained) - Safe Multi-Step Work

**What it is:** Work broken into phases with human review between each.

**When to use:**
- Important/risky changes
- Large refactoring
- Production deployments
- Anything where you want to catch mistakes early

**How it works:**

```
Phase 1          Phase 2          Phase 3
┌─────────┐      ┌─────────┐      ┌─────────┐
│  PLAN   │ ──▶  │  BUILD  │ ──▶  │  TEST   │
└─────────┘      └─────────┘      └─────────┘
     │                │                │
     ▼                ▼                ▼
┌─────────┐      ┌─────────┐      ┌─────────┐
│ YOU     │      │ YOU     │      │ YOU     │
│ REVIEW  │      │ REVIEW  │      │ REVIEW  │
└─────────┘      └─────────┘      └─────────┘
```

**Using the script:**
```bash
./scripts/chained-workflow.sh "Add user authentication"
```

**Command to learn more:** `/agent-threads:chained`

---

### 3.4 F-Thread (Fusion) - Best of Multiple Opinions

**What it is:** Run multiple agents on the same task, combine the best results.

**When to use:**
- Need high confidence in answer
- Comparing different approaches
- Rapid prototyping

**How it works:**

```
                    ┌── Agent 1: "Use Redis" ──────┐
                    │                              │
SAME PROMPT ────────┼── Agent 2: "Use Memcached" ──┼──── AGGREGATOR ──── BEST ANSWER
"How should we      │                              │     (Compare &
cache this?"        └── Agent 3: "Use in-memory" ──┘      choose)
```

**Using the scripts:**
```bash
# Step 1: Run 3 agents in parallel on same task
./scripts/parallel-runner.sh "Propose caching solution" 3

# Step 2: Aggregate the results
./scripts/fusion-aggregator.sh parallel-result-*.json
```

**Command to learn more:** `/agent-threads:fusion`

---

### 3.5 B-Thread (Big/Meta) - Agents Coordinating Agents

**What it is:** A primary agent that orchestrates sub-agents for complex work.

**When to use:**
- Complex multi-step workflows
- Tasks needing different specializations
- When you want "thicker" threads (more happening per unit of your time)

**How it works:**

```
┌─────────────────────────────────────────────────────────────────┐
│                     PRIMARY AGENT                                │
│                                                                  │
│   ┌─────────────┐   ┌─────────────┐   ┌─────────────┐           │
│   │ @researcher │   │  @reviewer  │   │ @validator  │           │
│   │  (explore)  │   │  (analyze)  │   │   (test)    │           │
│   └─────────────┘   └─────────────┘   └─────────────┘           │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘

YOU ──▶ [One prompt] ──▶ PRIMARY ──▶ [Orchestrates all] ──▶ YOU REVIEW
```

**This plugin provides these agents:**
- `@researcher` - Fast exploration (read-only)
- `@reviewer` - Code quality analysis (read-only)
- `@builder` - Implementation (read/write)
- `@validator` - Testing (bash access)

**Command to learn more:** `/agent-threads:big`

---

### 3.6 L-Thread (Long) - Extended Autonomous Work

**What it is:** Long-running threads with automatic continuation (Ralph Wiggum pattern).

**When to use:**
- Multi-hour tasks
- Self-correcting workflows
- "Fix everything until tests pass" type work

**How it works:**

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│   AGENT WORKS ──▶ TRIES TO STOP ──▶ STOP HOOK CHECKS ──┐        │
│        ▲                                               │        │
│        │         ┌──────────────────────────────────────┤        │
│        │         │                                      ▼        │
│        │         │  Tests passing?  ──NO──▶  CONTINUE WORKING    │
│        │         │                                               │
│        │         │  Tests passing?  ──YES──▶ ALLOW STOP          │
│        │         │                                               │
│        └─────────┴───────────────────────────────────────────────┘
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**The Ralph Wiggum Pattern:**
"Code + Agents > Agents Alone"

The stop hook (`scripts/ralph-loop.sh`) is CODE that decides if the AGENT should
continue. This is deterministic control over non-deterministic AI.

**Command to learn more:** `/agent-threads:long`

---

### 3.7 Z-Thread (Zero-Touch) - Full Automation

**What it is:** Threads that require no human review because validation is comprehensive.

**When to use:**
- Mature codebases with great test coverage
- Routine/repetitive tasks
- When you've built complete trust

**Requirements for Z-Thread:**
1. Comprehensive tests (unit, integration, e2e)
2. Type checking (TypeScript, mypy, etc.)
3. Linting (ESLint, Ruff, etc.)
4. Build verification
5. Security scanning

**Checking your readiness:**
```bash
./scripts/zero-touch-validator.sh
```

**Command to learn more:** `/agent-threads:zero-touch`

---

## 4. Using Slash Commands

### What are Slash Commands?

Slash commands are shortcuts that start with `/`. They trigger pre-defined actions.

### Available Commands in This Plugin

| Command | What It Does |
|---------|-------------|
| `/agent-threads:base` | Learn about Base Threads |
| `/agent-threads:parallel` | Learn about Parallel Threads |
| `/agent-threads:chained` | Learn about Chained Threads |
| `/agent-threads:fusion` | Learn about Fusion Threads |
| `/agent-threads:big` | Learn about Big Threads |
| `/agent-threads:long` | Learn about Long Threads |
| `/agent-threads:zero-touch` | Learn about Zero-Touch Threads |

### How to Use Them

1. Start Claude Code: `claude`
2. Type the command: `/agent-threads:base`
3. Press Enter
4. Claude explains the concept and may do a demo

### Getting Help

To see all available slash commands:
```
/help
```

---

## 5. Using Custom Agents

### What are Custom Agents?

Custom agents are specialized AI helpers with specific purposes and tool access.

### Available Agents

#### @researcher
**Purpose:** Quickly explore and understand codebases
**Tools:** Read, Grep, Glob (read-only)
**Speed:** Fast (uses Haiku model)

**When to use:**
- "What does this codebase do?"
- "Find where authentication is implemented"
- "Map out the project structure"

#### @reviewer
**Purpose:** Analyze code quality and find issues
**Tools:** Read, Grep, Glob (read-only)
**Speed:** Thorough (uses Sonnet model)

**When to use:**
- "Review this code for bugs"
- "Check for security vulnerabilities"
- "Assess code quality"

#### @builder
**Purpose:** Write and modify code
**Tools:** Read, Write, Edit, Grep, Glob (has write access)
**Speed:** Thorough (uses Sonnet model)

**When to use:**
- "Implement this feature"
- "Fix this bug"
- "Refactor this module"

#### @validator
**Purpose:** Run tests and verify code works
**Tools:** Bash, Read, Grep (can run commands)
**Speed:** Fast (uses Haiku model)

**When to use:**
- "Run the tests"
- "Check if the build passes"
- "Verify type safety"

### How Claude Uses Agents

When you give Claude a complex task, it may use the Task tool to delegate to agents:

```
You: "Do a complete code review of this project"

Claude thinks: "This needs research and review. I'll use agents."

Claude: "I'll use @researcher to explore, then @reviewer to analyze..."
```

---

## 6. Using Scripts

### What are the Scripts?

Bash scripts that demonstrate thread patterns. You can run them directly.

### Where are They?

All scripts are in the `scripts/` directory:

```
scripts/
├── parallel-runner.sh       # Run N agents in parallel
├── fusion-aggregator.sh     # Combine results from multiple agents
├── chained-workflow.sh      # Multi-phase workflow with checkpoints
├── ralph-loop.sh            # Stop hook for Long threads
└── zero-touch-validator.sh  # Comprehensive validation suite
```

### How to Run Scripts

**On Mac/Linux:**
```bash
./scripts/parallel-runner.sh "Your task here" 3
```

**On Windows (Git Bash):**
```bash
bash scripts/parallel-runner.sh "Your task here" 3
```

### Script Details

#### parallel-runner.sh

**Purpose:** Spawn multiple Claude instances in parallel

**Usage:**
```bash
./scripts/parallel-runner.sh "task description" [number_of_agents]
```

**Example:**
```bash
./scripts/parallel-runner.sh "Review this code for bugs" 3
```

**What it does:**
1. Starts 3 Claude instances in the background
2. Each runs the same task
3. Saves results to `parallel-result-1.json`, `parallel-result-2.json`, etc.
4. Waits for all to complete

---

#### fusion-aggregator.sh

**Purpose:** Combine results from parallel agents

**Usage:**
```bash
./scripts/fusion-aggregator.sh result1.json result2.json result3.json
```

**Example:**
```bash
./scripts/fusion-aggregator.sh parallel-result-*.json
```

**What it does:**
1. Reads all JSON result files
2. Uses Claude to synthesize findings
3. Identifies consensus, conflicts, and unique insights
4. Provides final recommendation

---

#### chained-workflow.sh

**Purpose:** Run a multi-phase workflow with human checkpoints

**Usage:**
```bash
./scripts/chained-workflow.sh "feature or task description"
```

**Example:**
```bash
./scripts/chained-workflow.sh "Add user profile page"
```

**What it does:**
1. **Phase 1:** Creates a plan (you review)
2. **Phase 2:** Implements the plan (you review)
3. **Phase 3:** Validates the work (you review)

---

#### zero-touch-validator.sh

**Purpose:** Check if codebase is ready for zero-touch automation

**Usage:**
```bash
./scripts/zero-touch-validator.sh
```

**What it does:**
1. Runs lint checks
2. Runs type checks
3. Runs tests
4. Runs build
5. Checks security
6. Reports overall status

---

## 7. Best Practices

### 7.1 Writing Good Prompts

**Bad prompt:**
```
Fix the bug
```

**Good prompt:**
```
Fix the bug in src/auth.js where login fails when the username contains
special characters. The expected behavior is that any valid email should
work as a username. Please add a test case to verify the fix.
```

**Key elements of good prompts:**
1. **What:** What do you want done?
2. **Where:** What files/code are involved?
3. **Why:** What's the context/problem?
4. **How:** Any constraints or preferences?
5. **Verify:** How to confirm it's done?

### 7.2 When to Use Each Thread Type

| Situation | Recommended Thread |
|-----------|-------------------|
| Quick question | Base |
| Simple task | Base |
| Multiple independent tasks | Parallel |
| Reviewing multiple areas | Parallel |
| Important changes | Chained |
| Production deployments | Chained |
| Need high confidence | Fusion |
| Complex multi-step work | Big |
| Extended autonomous work | Long |
| Routine automation | Zero-Touch |

### 7.3 Building Trust Incrementally

**Start here:**
1. Base Threads - Learn to prompt well
2. Get comfortable reviewing AI work

**Then:**
3. Try Parallel Threads - Scale your output
4. Use Chained Threads for important work

**Advanced:**
5. Orchestrate Big Threads with sub-agents
6. Set up Long Threads with validation loops

**Expert:**
7. Work toward Zero-Touch for mature codebases

### 7.4 Common Mistakes to Avoid

| Mistake | Why It's Bad | What to Do Instead |
|---------|-------------|-------------------|
| Vague prompts | AI guesses what you want | Be specific |
| No context | AI doesn't understand codebase | Use CLAUDE.md |
| Skipping review | Errors compound | Always review, reduce gradually |
| Too ambitious | Long prompts fail | Break into phases |
| Not testing | Bugs slip through | Always verify changes |

---

## 8. Advanced Topics

### 8.1 The Ralph Wiggum Pattern

**What is it?**
Code + Agents > Agents Alone

**The insight:**
Deterministic code (scripts, hooks) can control non-deterministic AI (Claude).
Use code to decide WHEN the AI should continue or stop.

**How it works:**
1. Agent works on a task
2. Agent tries to stop (thinks it's done)
3. Stop hook runs validation code
4. If validation fails → Continue message injected
5. Agent keeps working
6. Repeat until validation passes

**Implementation:**
The `hooks/hooks.json` configures a stop hook that runs `scripts/ralph-loop.sh`.

### 8.2 Context Engineering

**What is context?**
Everything the AI knows when working on your task:
- The conversation so far
- Files it has read
- Your CLAUDE.md
- Tool results

**How to improve context:**

1. **CLAUDE.md files** - Write project-specific guidance
2. **Clear file structure** - Organized code is easier to understand
3. **Documentation** - Comments and READMEs help the AI
4. **Examples** - Show what you want, don't just describe it

### 8.3 Prompt Engineering

**Key techniques:**

1. **Be specific:** "Fix line 42" not "Fix the code"
2. **Provide examples:** "Like this: [example]"
3. **Set constraints:** "Don't change the API"
4. **Define done:** "Tests must pass"
5. **Use personas:** "You are a security expert..."

### 8.4 Tool Selection

**Principle:** Give agents the minimum tools needed.

| Task | Tools to Enable |
|------|----------------|
| Research | Read, Grep, Glob |
| Code review | Read, Grep, Glob |
| Implementation | Read, Write, Edit, Grep, Glob |
| Testing | Bash, Read |
| Everything | All tools (use sparingly) |

---

## 9. Real-World Examples

### Example 1: Daily Code Review

**Scenario:** Review yesterday's changes every morning.

**Approach:** Parallel Thread

```bash
# Run parallel reviews on different areas
./scripts/parallel-runner.sh "Review changes in the last 24 hours for bugs" 3
./scripts/fusion-aggregator.sh parallel-result-*.json
```

### Example 2: Bug Fix with Safety

**Scenario:** Fix a bug in production code.

**Approach:** Chained Thread

```bash
./scripts/chained-workflow.sh "Fix the login timeout bug in auth.js"
```

### Example 3: Codebase Exploration

**Scenario:** Understand a new project you just joined.

**Approach:** Base Thread with @researcher

```
You: Use @researcher to give me a complete map of this codebase.
     What are the main components? How do they connect?
```

### Example 4: Feature Implementation

**Scenario:** Add a new feature.

**Approach:** Big Thread with multiple agents

```
You: I need to add a user profile page.
     Use @researcher to understand current user data structures.
     Use @reviewer to check existing patterns.
     Use @builder to implement the feature.
     Use @validator to run tests.
```

### Example 5: Dependency Updates

**Scenario:** Update all npm packages.

**Approach:** Zero-Touch (if you have good test coverage)

```bash
# First check if you're Z-Thread ready
./scripts/zero-touch-validator.sh

# If all passes, you can trust autonomous updates
claude -p "Update all npm dependencies to latest compatible versions. Run tests after each update."
```

---

## Summary

Thread-Based Engineering is about **scaling your impact** through AI agents:

1. **Base Thread** - Foundation, start here
2. **Parallel Thread** - Do more at once
3. **Chained Thread** - Safety for important work
4. **Fusion Thread** - High confidence through multiple perspectives
5. **Big Thread** - Complex orchestration
6. **Long Thread** - Extended autonomy
7. **Zero-Touch Thread** - Full automation (the goal)

**The journey:**
- Start with Base Threads
- Add parallelism as you get comfortable
- Use chains for safety
- Build toward autonomy
- Eventually achieve zero-touch for routine work

**Remember:** The goal isn't to replace yourself, but to **multiply** yourself.

---

*Need help? See [Troubleshooting](TROUBLESHOOTING.md) or [FAQ](FAQ.md)*
