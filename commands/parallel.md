---
description: Demonstrate P-Thread - parallel execution for scaling output
allowed-tools: Read, Bash, Grep, Glob
---

# Parallel Thread (P-Thread) Demo

## Concept

Scale your engineering output by running **multiple threads simultaneously**.

```
        ┌─ Thread 1 (terminal 1) ─┐
YOU ────┼─ Thread 2 (terminal 2) ─┼───▶ YOU (review all)
        └─ Thread 3 (terminal 3) ─┘
```

Boris Cherny (creator of Claude Code) runs:
- **5 Claude Codes** in his terminal (tabs 1-5)
- **5-10 more** in the Claude Code web interface (background)

## Key Insight

- More agents = more compute = more done
- Each agent works **independently**
- You review **all results** at the end
- Independent tasks can be parallelized

## When to Use P-Threads

- Code review (multiple reviewers on different files)
- Codebase exploration (different areas simultaneously)
- Multiple unrelated tasks
- Scaling research/analysis

## Implementation Methods

### Method 1: Multiple Terminals
Simply open 3-5 terminal windows and run different prompts in each.

### Method 2: Background Jobs (bash)
```bash
#!/bin/bash
for task in "review auth" "review api" "review db"; do
  claude -p "$task" --output-format json > "result-$task.json" &
done
wait  # All complete, now review
```

### Method 3: GNU Parallel
```bash
echo -e "task1\ntask2\ntask3" | parallel -j3 'claude -p "{}"'
```

### Method 4: Script Runner
Use the included `scripts/parallel-runner.sh`:
```bash
./scripts/parallel-runner.sh "Analyze this code for bugs" 3
```

## Live Demo

**Target:** $ARGUMENTS

I'll demonstrate the concept by explaining how you would parallelize analysis of the target.

The script at `scripts/parallel-runner.sh` lets you actually spawn multiple agents.

---

**Parallel Thread Pattern:**

To analyze "$ARGUMENTS" with P-Threads:

1. **Split the work** into independent pieces
2. **Spawn agents** for each piece (different terminals or background)
3. **Wait** for all to complete
4. **Review** all results together

Example for a codebase:
- Agent 1: Review `src/auth/`
- Agent 2: Review `src/api/`
- Agent 3: Review `src/database/`
- Agent 4: Review `src/utils/`

Each runs independently. You review the combined findings.
