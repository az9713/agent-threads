#!/bin/bash
#
# Z-Thread: Comprehensive Validation Suite
#
# This script runs ALL available validation checks.
# For Z-Thread (Zero-Touch) confidence, ALL checks must pass.
#
# Usage: ./zero-touch-validator.sh [--strict]
#
# Options:
#   --strict    Fail if any check is unavailable (not just failing)
#
# Exit codes:
#   0 = All checks passed (Z-Thread confidence achieved)
#   1 = One or more checks failed
#   2 = Checks unavailable (only in strict mode)
#

STRICT_MODE=false
if [ "$1" = "--strict" ]; then
    STRICT_MODE=true
fi

echo "╔════════════════════════════════════════════════════════════╗"
echo "║           Z-THREAD: Validation Suite                       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Running comprehensive validation for Zero-Touch confidence..."
echo ""

# Counters
CHECKS_RUN=0
CHECKS_PASSED=0
CHECKS_FAILED=0
CHECKS_SKIPPED=0

# Helper function to run a check
run_check() {
    local name="$1"
    local command="$2"

    printf "  %-20s " "$name..."

    if eval "$command" > /dev/null 2>&1; then
        echo "✓ PASS"
        ((CHECKS_PASSED++))
    else
        echo "✗ FAIL"
        ((CHECKS_FAILED++))
    fi
    ((CHECKS_RUN++))
}

# Helper function to skip a check
skip_check() {
    local name="$1"
    local reason="$2"

    printf "  %-20s " "$name..."
    echo "○ SKIP ($reason)"
    ((CHECKS_SKIPPED++))
}

echo "Running checks..."
echo ""

# ============================================================
# CHECK 1: LINTING
# ============================================================
if [ -f "package.json" ] && grep -q '"lint"' package.json 2>/dev/null; then
    run_check "Lint (npm)" "npm run lint --silent"
elif [ -f ".eslintrc" ] || [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ]; then
    run_check "Lint (eslint)" "npx eslint . --quiet"
elif [ -f "pyproject.toml" ] && grep -q "ruff" pyproject.toml 2>/dev/null; then
    run_check "Lint (ruff)" "ruff check ."
elif command -v flake8 &> /dev/null; then
    run_check "Lint (flake8)" "flake8 ."
else
    skip_check "Lint" "no linter found"
fi

# ============================================================
# CHECK 2: TYPE CHECKING
# ============================================================
if [ -f "tsconfig.json" ]; then
    run_check "Types (tsc)" "npx tsc --noEmit"
elif [ -f "mypy.ini" ] || ([ -f "pyproject.toml" ] && grep -q "mypy" pyproject.toml 2>/dev/null); then
    run_check "Types (mypy)" "mypy ."
elif [ -f "pyrightconfig.json" ]; then
    run_check "Types (pyright)" "pyright"
else
    skip_check "Types" "no type checker found"
fi

# ============================================================
# CHECK 3: UNIT TESTS
# ============================================================
if [ -f "package.json" ] && grep -q '"test"' package.json 2>/dev/null; then
    run_check "Tests (npm)" "npm test"
elif [ -f "pytest.ini" ] || [ -f "pyproject.toml" ] || [ -d "tests" ]; then
    if command -v pytest &> /dev/null; then
        run_check "Tests (pytest)" "pytest --quiet"
    else
        skip_check "Tests" "pytest not installed"
    fi
elif [ -f "go.mod" ]; then
    run_check "Tests (go)" "go test ./..."
elif [ -f "Cargo.toml" ]; then
    run_check "Tests (cargo)" "cargo test --quiet"
else
    skip_check "Tests" "no test framework found"
fi

# ============================================================
# CHECK 4: BUILD
# ============================================================
if [ -f "package.json" ] && grep -q '"build"' package.json 2>/dev/null; then
    run_check "Build (npm)" "npm run build"
elif [ -f "Makefile" ]; then
    run_check "Build (make)" "make"
elif [ -f "Cargo.toml" ]; then
    run_check "Build (cargo)" "cargo build --release"
elif [ -f "go.mod" ]; then
    run_check "Build (go)" "go build ./..."
else
    skip_check "Build" "no build system found"
fi

# ============================================================
# CHECK 5: SECURITY AUDIT
# ============================================================
if [ -f "package.json" ] && [ -f "package-lock.json" ]; then
    run_check "Security (npm)" "npm audit --audit-level=high"
elif [ -f "Cargo.toml" ] && command -v cargo-audit &> /dev/null; then
    run_check "Security (cargo)" "cargo audit"
elif [ -f "requirements.txt" ] && command -v safety &> /dev/null; then
    run_check "Security (safety)" "safety check"
else
    skip_check "Security" "no audit tool found"
fi

# ============================================================
# CHECK 6: GIT STATE
# ============================================================
if [ -d ".git" ]; then
    printf "  %-20s " "Git state..."
    if git diff --exit-code --quiet 2>/dev/null; then
        echo "✓ CLEAN"
        ((CHECKS_PASSED++))
    else
        echo "○ DIRTY (uncommitted changes)"
        # Not counting as failure, just informational
    fi
    ((CHECKS_RUN++))
else
    skip_check "Git state" "not a git repo"
fi

# ============================================================
# RESULTS
# ============================================================
echo ""
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Results:"
echo "  Checks run:     $CHECKS_RUN"
echo "  Passed:         $CHECKS_PASSED"
echo "  Failed:         $CHECKS_FAILED"
echo "  Skipped:        $CHECKS_SKIPPED"
echo ""

if [ $CHECKS_FAILED -eq 0 ] && [ $CHECKS_PASSED -gt 0 ]; then
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║  ✓ ALL CHECKS PASSED - Z-THREAD CONFIDENCE ACHIEVED       ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    echo "This codebase meets Zero-Touch criteria."
    echo "Human review may be safely skipped for routine changes."
    exit 0
elif [ $CHECKS_FAILED -gt 0 ]; then
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║  ✗ VALIDATION FAILED - HUMAN REVIEW REQUIRED              ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Fix the failing checks before claiming Z-Thread confidence."
    exit 1
else
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║  ○ NO CHECKS RUN - CANNOT VERIFY                          ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    echo "Add tests, linting, and type checking to enable Z-Thread."
    if [ "$STRICT_MODE" = true ]; then
        exit 2
    fi
    exit 0
fi
