---
description: Demonstrate C-Thread - serialized phases with human checkpoints
allowed-tools: Read, Bash, Write, Edit, Grep, Glob
---

# Chained Thread (C-Thread) Demo

## Concept

Break large work into **phases** with **human review between each**.

```
┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐
│ Phase 1 │──▶│   YOU   │──▶│ Phase 2 │──▶│   YOU   │──▶│ Phase 3 │
│  Plan   │   │ Review  │   │  Build  │   │ Review  │   │  Test   │
└─────────┘   └─────────┘   └─────────┘   └─────────┘   └─────────┘
```

## When to Use C-Threads

Use chained threads when:
- Work is **too large** for one context window
- **Production-critical** (need to verify each step)
- **High-risk changes** requiring careful validation
- You want to catch errors early before they compound

## Key Insight

This is NOT for when your agent messes up (that's bad prompting).
C-Threads are for **intentionally chunking** complex work.

## Trade-off

C-Threads cost **your time and attention**. Only use when the work truly requires checkpoints.

## Implementation

```bash
#!/bin/bash
# Phase 1: Planning
SESSION=$(claude -p "Create a plan for: $FEATURE" --output-format json | jq -r '.session_id')
echo "Review the plan..."
read -p "Press Enter to continue to Phase 2..."

# Phase 2: Building (continues same session with context)
claude -p "Now implement the plan" --resume "$SESSION"
echo "Review the implementation..."
read -p "Press Enter to continue to Phase 3..."

# Phase 3: Testing
claude -p "Run tests and validate" --resume "$SESSION"
```

## Claude Code Features for C-Threads

- `--continue` or `-c`: Continue most recent conversation
- `--resume SESSION_ID` or `-r`: Resume specific session
- `--output-format json`: Get session ID programmatically
- `AskUserQuestion` tool: Agent can pause for your input

## Live Demo

**Target:** $ARGUMENTS

I'll demonstrate Phase 1 of a chained workflow. After my analysis, you decide whether to proceed to Phase 2.

---

**PHASE 1: Analysis**

Let me analyze the current state of the target. This is the "Plan" phase of a C-Thread.

After this completes:
1. You review my findings
2. Decide if the plan looks good
3. Then we proceed to Phase 2 (or abort)

This checkpoint is what makes it a **Chained Thread**.
