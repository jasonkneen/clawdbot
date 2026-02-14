#!/usr/bin/env bash
set -euo pipefail

# Create PR branches at specific commit points in dev-web-ui history
# These will be submitted as stacked PRs (each depends on the previous)

echo "=== Creating 11 Stacked UI Overhaul PR Branches ==="
echo ""

# Fetch latest
git fetch upstream
git fetch origin

# Start from upstream/main
BASE="upstream/main"

echo "→ PR 1: feat/ui-mode-system (Basic/Advanced Mode)"
git branch -D feat/ui-mode-system 2>/dev/null || true
git checkout -b feat/ui-mode-system fa6e519ca
echo "  ✓ Branch created at commit fa6e519 (15 commits from $BASE)"
echo ""

echo "→ PR 2: feat/ui-design-tokens (Design Tokens)"
git branch -D feat/ui-design-tokens 2>/dev/null || true
git checkout -b feat/ui-design-tokens 1d8835aa5
echo "  ✓ Branch created at commit 1d8835a (18 commits from $BASE)"
echo ""

echo "→ PR 3: refactor/ui-logs-debug (Logs & Debug Overhaul)"
git branch -D refactor/ui-logs-debug 2>/dev/null || true
git checkout -b refactor/ui-logs-debug ff0d907cc
echo "  ✓ Branch created at commit ff0d907 (33 commits from $BASE)"
echo ""

echo "→ PR 4: refactor/ui-lucide-icons (Icon Consistency)"
git branch -D refactor/ui-lucide-icons 2>/dev/null || true
git checkout -b refactor/ui-lucide-icons 107ec2b81
echo "  ✓ Branch created at commit 107ec2b (36 commits from $BASE)"
echo ""

echo "→ PR 5: refactor/ui-core-views (Core Views Consistency)"
git branch -D refactor/ui-core-views 2>/dev/null || true
git checkout -b refactor/ui-core-views 5e034d203
echo "  ✓ Branch created at commit 5e034d2 (44 commits from $BASE)"
echo ""

echo "→ PR 6: refactor/ui-channel-views (Channel Views Consistency)"
git branch -D refactor/ui-channel-views 2>/dev/null || true
git checkout -b refactor/ui-channel-views 54259d95b
echo "  ✓ Branch created at commit 54259d9 (50 commits from $BASE)"
echo ""

echo "→ PR 7: feat/ui-autocomplete (Autocomplete & Inputs)"
git branch -D feat/ui-autocomplete 2>/dev/null || true
git checkout -b feat/ui-autocomplete b3e7eb6cd
echo "  ✓ Branch created at commit b3e7eb6 (52 commits from $BASE)"
echo ""

echo "→ PR 8: feat/ui-chat-session-tabs (Chat Session Tabs)"
git branch -D feat/ui-chat-session-tabs 2>/dev/null || true
git checkout -b feat/ui-chat-session-tabs 410c7ad85
echo "  ✓ Branch created at commit 410c7ad (55 commits from $BASE)"
echo ""

echo "→ PR 9: feat/ui-chat-queue-tools (Chat Queue & Tool Cards)"
git branch -D feat/ui-chat-queue-tools 2>/dev/null || true
git checkout -b feat/ui-chat-queue-tools fc4e8fa17
echo "  ✓ Branch created at commit fc4e8fa (60 commits from $BASE)"
echo ""

echo "→ PR 10: fix/ui-chat-polish (Chat Visual Polish)"
git branch -D fix/ui-chat-polish 2>/dev/null || true
git checkout -b fix/ui-chat-polish fb2ed955b
echo "  ✓ Branch created at commit fb2ed95 (65 commits from $BASE)"
echo ""

echo "→ PR 11: feat/patch-ui-script (Patch Script)"
git branch -D feat/patch-ui-script 2>/dev/null || true
git checkout -b feat/patch-ui-script 9f838f457
echo "  ✓ Branch created at commit 9f838f4 (67 commits from $BASE)"
echo ""

# Return to dev-web-ui
git checkout dev-web-ui

echo "=== Done ==="
echo ""
echo "Created 11 stacked PR branches (each includes previous changes):"
echo "  1. feat/ui-mode-system          → fa6e519"
echo "  2. feat/ui-design-tokens        → 1d8835a"
echo "  3. refactor/ui-logs-debug       → ff0d907"
echo "  4. refactor/ui-lucide-icons     → 107ec2b"
echo "  5. refactor/ui-core-views       → 5e034d2"
echo "  6. refactor/ui-channel-views    → 54259d9"
echo "  7. feat/ui-autocomplete         → b3e7eb6"
echo "  8. feat/ui-chat-session-tabs    → 410c7ad"
echo "  9. feat/ui-chat-queue-tools     → fc4e8fa"
echo " 10. fix/ui-chat-polish           → fb2ed95"
echo " 11. feat/patch-ui-script         → 9f838f4"
echo ""
echo "Each PR should be submitted with:"
echo "  - Base: previous PR's branch (or upstream/main for PR 1)"
echo "  - Title: from PR_PLAN.md"
echo "  - Description: 'Part X/11 of UI overhaul. Depends on #PREV_PR_NUMBER'"
echo ""
echo "Test a branch:"
echo "  git checkout feat/ui-mode-system"
echo "  cd ui && pnpm run build"
