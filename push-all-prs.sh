#!/usr/bin/env bash
set -euo pipefail

# Push all 11 PR branches to origin (your fork)

echo "=== Pushing 11 PR Branches to Origin ==="
echo ""

BRANCHES=(
  "feat/ui-mode-system"
  "feat/ui-design-tokens"
  "refactor/ui-logs-debug"
  "refactor/ui-lucide-icons"
  "refactor/ui-core-views"
  "refactor/ui-channel-views"
  "feat/ui-autocomplete"
  "feat/ui-chat-session-tabs"
  "feat/ui-chat-queue-tools"
  "fix/ui-chat-polish"
  "feat/patch-ui-script"
)

for branch in "${BRANCHES[@]}"; do
  echo "→ Pushing $branch"
  git push -u origin "$branch" --force-with-lease
  echo ""
done

echo "=== Done ==="
echo ""
echo "All 11 branches pushed to origin."
echo ""
echo "Next: Create PRs on GitHub using the descriptions in PR_DESCRIPTIONS.md"
echo ""
echo "Or use GitHub CLI (gh):"
echo "  See create-github-prs.sh"
