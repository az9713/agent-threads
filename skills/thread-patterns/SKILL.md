---
name: thread-patterns
description: Guide for implementing thread-based engineering patterns. Use when discussing or implementing Base, Parallel, Chained, Fusion, Big, Long, or Zero-Touch thread patterns for agentic coding.
allowed-tools: Read, Grep, Glob
---

# Thread-Based Engineering Patterns

This skill provides guidance on choosing and implementing the right thread pattern for your task.

## Quick Reference

| Thread | Best For | Complexity | Human Time |
|--------|----------|------------|------------|
| Base | Simple tasks | Low | High |
| Parallel | Independent work | Medium | Medium |
| Chained | Critical work | Medium | High |
| Fusion | High confidence | Medium | Low |
| Big | Complex orchestration | High | Low |
| Long | Extended autonomy | High | Very Low |
| Zero-Touch | Full automation | Very High | None |

## Decision Tree

```
Is it a simple, single task?
├─ YES → Base Thread
└─ NO → Can tasks run independently?
         ├─ YES → Need multiple perspectives?
         │        ├─ YES → Fusion Thread
         │        └─ NO → Parallel Thread
         └─ NO → Is it high-risk/production?
                  ├─ YES → Chained Thread
                  └─ NO → Need specialized agents?
                           ├─ YES → Big Thread
                           └─ NO → Want extended autonomy?
                                    ├─ YES → Have validation suite?
                                    │        ├─ YES → Zero-Touch or Long
                                    │        └─ NO → Long Thread
                                    └─ NO → Base Thread
```

## Pattern Details

### Base Thread
**When:** Simple tasks, learning, experimentation
**Pattern:** Prompt → Tools → Review
**Example:** "Explain this codebase"

### Parallel Thread (P)
**When:** Multiple independent tasks, scaling compute
**Pattern:** Spawn N agents, each on different work
**Example:** Review auth/, api/, and db/ simultaneously

### Chained Thread (C)
**When:** Production work, large migrations, high-risk changes
**Pattern:** Phase 1 → Review → Phase 2 → Review → ...
**Example:** Plan migration → Review → Execute → Review → Validate

### Fusion Thread (F)
**When:** Need high confidence, comparing approaches
**Pattern:** N agents same prompt → Aggregate best
**Example:** 3 reviewers → Synthesize findings

### Big Thread (B)
**When:** Complex workflows needing specialized agents
**Pattern:** Primary agent orchestrates sub-agents
**Example:** Researcher → Reviewer → Builder → Validator

### Long Thread (L)
**When:** Extended autonomous work, self-correcting
**Pattern:** Work → Stop Hook validates → Continue if needed
**Example:** "Fix all bugs until tests pass" (Ralph Wiggum)

### Zero-Touch Thread (Z)
**When:** Mature codebase, comprehensive validation
**Pattern:** Prompt → Work → Auto-validate → Done
**Example:** Automated dependency updates with full CI

## Improvement Metrics

You're getting better when you:
1. Run **more** threads (P-Threads)
2. Run **longer** threads (L-Threads)
3. Run **thicker** threads (B-Threads)
4. Run **fewer checkpoints** (toward Z-Threads)

## See Also

- `examples.md` for detailed code examples
- Plugin commands: `/agent-threads:<type>`
- Scripts in `scripts/` directory
