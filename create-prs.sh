#!/usr/bin/env bash
set -euo pipefail

# Script to create 11 focused PR branches from dev-web-ui
# Each branch is created from upstream/main and cherry-picks specific commits

UPSTREAM="upstream/main"

echo "=== Creating 11 UI Overhaul PR Branches ==="
echo ""

# Fetch latest upstream
git fetch upstream

# PR 1: Foundation - Basic/Advanced Mode System
echo "→ PR 1: feat/ui-mode-system"
git checkout -B feat/ui-mode-system "$UPSTREAM"
git cherry-pick 50fe6225a..fa6e519ca
echo "  ✓ 15 commits"
echo ""

# PR 2: Design Tokens & Base Styling
echo "→ PR 2: feat/ui-design-tokens"
git checkout -B feat/ui-design-tokens "$UPSTREAM"
git cherry-pick 5dacb45c5 5b25d9165 1d8835aa5
echo "  ✓ 3 commits"
echo ""

# PR 3: Logs & Debug Views Overhaul
echo "→ PR 3: refactor/ui-logs-debug"
git checkout -B refactor/ui-logs-debug "$UPSTREAM"
git cherry-pick de4035f50 829d6d5d5 c73bc4dc6 2e6b70cdd 69735edd4 dfd6f3c67 58250efe6 5ea0a7dcc 3fd76abaf f22e577b1 0dcf6e880 a984ccd73 a00e23ff6 72f32af90 ff0d907cc
echo "  ✓ 15 commits"
echo ""

# PR 4: Icon Consistency - Replace Emoji with Lucide
echo "→ PR 4: refactor/ui-lucide-icons"
git checkout -B refactor/ui-lucide-icons "$UPSTREAM"
git cherry-pick c85eb965a 1b3f85e51 107ec2b81
echo "  ✓ 3 commits"
echo ""

# PR 5: Core Views Consistency
echo "→ PR 5: refactor/ui-core-views"
git checkout -B refactor/ui-core-views "$UPSTREAM"
git cherry-pick 2fda8bbc4 3f13c4ea2 d19083505 dfe58e429 e34a81331 70037dab4 5e034d203 bfe295dcf
echo "  ✓ 8 commits"
echo ""

# PR 6: Channel Views Consistency
echo "→ PR 6: refactor/ui-channel-views"
git checkout -B refactor/ui-channel-views "$UPSTREAM"
git cherry-pick d658d35b2 251d98728 2c5228f0f bc723c48a 54259d95b 1cbaf9059
echo "  ✓ 6 commits"
echo ""

# PR 7: Autocomplete & Input Enhancements
echo "→ PR 7: feat/ui-autocomplete"
git checkout -B feat/ui-autocomplete "$UPSTREAM"
git cherry-pick 053373c96 b3e7eb6cd 8aecc774a
echo "  ✓ 3 commits"
echo ""

# PR 8: Chat UI - Session Tabs & Input Layout
echo "→ PR 8: feat/ui-chat-session-tabs"
git checkout -B feat/ui-chat-session-tabs "$UPSTREAM"
git cherry-pick 4d56c5e48 410c7ad85
echo "  ✓ 2 commits"
echo ""

# PR 9: Chat UI - Queue & Tool Cards
echo "→ PR 9: feat/ui-chat-queue-tools"
git checkout -B feat/ui-chat-queue-tools "$UPSTREAM"
git cherry-pick 7ba5666ff ef20b7e4d 48eb1a2fb 2f205e71f fc4e8fa17
echo "  ✓ 5 commits"
echo ""

# PR 10: Chat UI - Visual Polish
echo "→ PR 10: fix/ui-chat-polish"
git checkout -B fix/ui-chat-polish "$UPSTREAM"
git cherry-pick 1f53b9425 b20735be7 7c0ffa441 942f7e4ad fb2ed955b
echo "  ✓ 5 commits"
echo ""

# PR 11: Tooling - Patch Script
echo "→ PR 11: feat/patch-ui-script"
git checkout -B feat/patch-ui-script "$UPSTREAM"
git cherry-pick 69fae8c4e 9f838f457
echo "  ✓ 2 commits (includes path fix)"
echo ""

# Return to dev-web-ui
git checkout dev-web-ui

echo "=== Done ==="
echo ""
echo "Created 11 branches ready for PR submission:"
echo "  1. feat/ui-mode-system          (15 commits)"
echo "  2. feat/ui-design-tokens        (3 commits)"
echo "  3. refactor/ui-logs-debug       (15 commits)"
echo "  4. refactor/ui-lucide-icons     (3 commits)"
echo "  5. refactor/ui-core-views       (8 commits)"
echo "  6. refactor/ui-channel-views    (6 commits)"
echo "  7. feat/ui-autocomplete         (3 commits)"
echo "  8. feat/ui-chat-session-tabs    (2 commits)"
echo "  9. feat/ui-chat-queue-tools     (5 commits)"
echo " 10. fix/ui-chat-polish           (5 commits)"
echo " 11. feat/patch-ui-script         (2 commits)"
echo ""
echo "Next steps:"
echo "  1. Test each branch: git checkout <branch> && pnpm run build"
echo "  2. Push to your fork: git push -u origin <branch>"
echo "  3. Create PR on GitHub for each branch"
