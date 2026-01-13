---
description: Demonstrate B-Thread - recursive agent structures with sub-agents
allowed-tools: Read, Grep, Glob, Bash, Task
---

# Big Thread (B-Thread) Demo

## Concept

Your prompts fire off **other prompts**. Agents prompt sub-agents.
From your perspective: **one prompt in, one review at the end**.
Inside: a whole **team of specialized agents** working.

```
                    ┌─────────────────────────────────────┐
                    │         PRIMARY AGENT               │
                    │                                     │
YOU ──────────────▶ │  ┌─────────┐  ┌─────────┐          │ ──────────▶ YOU
    one prompt      │  │@research│  │@reviewer│          │    review
                    │  └────┬────┘  └────┬────┘          │
                    │       │            │               │
                    │       ▼            ▼               │
                    │  ┌─────────┐  ┌─────────┐          │
                    │  │@builder │  │@validate│          │
                    │  └─────────┘  └─────────┘          │
                    └─────────────────────────────────────┘
                              "THICK" THREAD
```

## Key Insight

- **Thicker threads** = more happening per unit of YOUR time
- Specialized agents for specialized tasks
- Recursive depth = exponential capability
- You engineer the inside once, then reuse

## Why "Thicker"?

A base thread has one line of tool calls.
A B-thread has nested sub-threads inside.
More total tool calls, more work done, same human endpoints.

## Built-in Sub-agents

Claude Code provides:
- `Explore` - Fast read-only (Haiku) for codebase search
- `Plan` - Research agent for planning
- `general-purpose` - Full toolkit for complex tasks
- `Bash` - Terminal command specialist

## Custom Sub-agents (This Plugin)

This plugin provides:
- `@researcher` - Fast codebase exploration (read-only, Haiku)
- `@reviewer` - Code quality analysis (read-only, Sonnet)
- `@builder` - Implementation specialist (write access, Sonnet)
- `@validator` - Test runner (Bash access, Haiku)

## The Ralph Wiggum Connection

B-Threads connect to the insight: **Code + Agents > Agents Alone**

You write code that orchestrates agents. The orchestration is deterministic (code), the work is intelligent (agents).

## Live Demo

**Target:** $ARGUMENTS

I'll demonstrate a B-Thread by orchestrating multiple sub-agents to analyze the target.

---

**Spawning Sub-Agent Team...**

I'll now use the Task tool to dispatch specialized agents:

1. **Researcher**: Quick codebase mapping
2. **Reviewer**: Quality and bug analysis
3. **Validator**: Test/build verification

Each sub-agent runs in its own context with its own tools.
I'll synthesize their findings into a unified report.

This is the B-Thread pattern - you prompted once, I orchestrate many.
