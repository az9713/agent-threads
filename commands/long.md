---
description: Demonstrate L-Thread - high-autonomy extended workflows with Ralph Wiggum
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# Long Thread (L-Thread) Demo

## Concept

High-autonomy, **long-duration workflows**. Hundreds or thousands of tool calls.
Running for **hours or even days**.

Boris Cherny had a run that lasted: **1 day, 2 hours**

```
┌─────────┐     ┌──────────────────────────────────────────┐     ┌─────────┐
│   YOU   │ ──▶ │  AGENT (100s-1000s of tool calls)        │ ──▶ │   YOU   │
│ Prompt  │     │  ...hours or days of autonomous work...  │     │ Review  │
└─────────┘     └──────────────────────────────────────────┘     └─────────┘
```

## The Ralph Wiggum Pattern

**Code + Agents > Agents Alone**

Named after Geoffrey Huntley's technique. The key innovation: a **Stop Hook** that intercepts when Claude tries to finish.

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│  ┌─────────┐    ┌────────────┐    ┌─────────────┐  │
│  │  Agent  │───▶│ Stop Hook  │───▶│  Continue?  │  │
│  │  works  │    │ validates  │    │  yes → loop │  │
│  └─────────┘    └────────────┘    │  no → done  │  │
│       ▲                           └──────┬──────┘  │
│       │                                  │         │
│       └──────────────────────────────────┘         │
│                                                     │
└─────────────────────────────────────────────────────┘
```

## How It Works

1. Claude completes work, attempts to stop
2. **Stop Hook** runs validation script
3. Script checks: tests passing? TODOs done? errors fixed?
4. If incomplete → inject "continue" message
5. Claude continues working
6. Repeat until truly done

## Implementation

**hooks.json:**
```json
{
  "hooks": {
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "./scripts/ralph-loop.sh"
      }]
    }]
  }
}
```

**ralph-loop.sh:**
```bash
#!/bin/bash
# Check if work is truly complete

# Are tests passing?
npm test || echo '{"continue": true, "reason": "Tests failing"}'

# Any TODOs left?
grep -r "TODO" src/ && echo '{"continue": true, "reason": "TODOs remain"}'

# All good - allow stop
exit 0
```

## When to Use L-Threads

- Extended refactoring sessions
- Large feature implementations
- Overnight batch processing
- Self-correcting workflows
- Migration tasks

## Live Demo

**Target:** $ARGUMENTS

I'll explain how an L-Thread would work for your target.

---

**Long Thread Setup:**

For "$ARGUMENTS", an L-Thread would:

1. **Initial prompt**: Describe the full task with clear completion criteria
2. **Stop hook**: Validates work after each "completion" attempt
3. **Continuation**: If validation fails, agent continues automatically
4. **True completion**: Only stops when all criteria met

The magic is in the Stop hook - it's deterministic code that checks conditions and decides whether the agent should keep working.

This plugin includes `scripts/ralph-loop.sh` - a working Stop hook implementation.
