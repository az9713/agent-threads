---
description: Demonstrate the Base Thread - the atomic unit of agentic work
allowed-tools: Read, Grep, Glob, Bash
---

# Base Thread Demo

## Concept

The **Base Thread** is the fundamental unit of agentic engineering:

```
┌─────────┐     ┌─────────────────┐     ┌─────────┐
│   YOU   │ ──▶ │  AGENT (tools)  │ ──▶ │   YOU   │
│ Prompt  │     │  Tool calls...  │     │ Review  │
└─────────┘     └─────────────────┘     └─────────┘
```

- **YOU** show up at the **beginning** (prompt/plan)
- **AGENT** does the **middle** (tool calls)
- **YOU** show up at the **end** (review/validate)

## Key Insight

Pre-2023, **you** were the tool calls - reading docs, editing files, running commands.
Now the agent handles the middle. You show up at the endpoints.

## Measuring Base Threads

The fundamental metric is **tool calls**. More useful tool calls = more value created.

A base thread might involve:
- 10-50 tool calls for simple tasks
- 50-200 tool calls for moderate tasks
- 200+ tool calls for complex tasks

## CLI Example

```bash
# Simple base thread
claude -p "Explain what this codebase does" --max-turns 5

# Base thread with output
claude -p "Find all TODO comments" --output-format json
```

## Live Demo

I'll now demonstrate a Base Thread by analyzing the target you specify.

**Target:** $ARGUMENTS

If no target specified, I'll analyze the current directory structure.

---

**Starting Base Thread...**

Let me explore and summarize what I find. After this completes, you review my work - that's the Base Thread pattern in action.
