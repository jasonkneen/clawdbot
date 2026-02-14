#!/usr/bin/env bash
set -euo pipefail

# Create all 11 PRs using GitHub CLI (gh)
# Requires: gh auth login

UPSTREAM_REPO="openclaw/openclaw"

echo "=== Creating 11 PRs on GitHub ==="
echo ""

# PR 1: Base on upstream/main
echo "→ PR 1: feat/ui-mode-system"
gh pr create \
  --repo "$UPSTREAM_REPO" \
  --base main \
  --head "jasonkneen:feat/ui-mode-system" \
  --title "feat(ui): add Basic/Advanced mode system with per-view filtering" \
  --body "Part 1/11 of comprehensive UI overhaul.

Adds a mode preference system allowing users to toggle between:
- **Basic mode**: Simplified interface showing only essential features
- **Advanced mode**: Full access to all features and debugging tools

Changes:
- Add mode preference storage (basic/advanced) in UiSettings
- Add @state() mode property to app with load/save
- Add mode toggle UI in dashboard header
- Add mode-aware tab filtering to navigation
- Add navigation guards to redirect advanced-only views
- Update all views with conditional rendering

Default mode is Advanced (existing users get full functionality).

**Testing:**
\`\`\`bash
cd ui && pnpm run build
\`\`\`
Toggle mode in UI header, verify views adjust accordingly."

echo ""

# PR 2: Base on PR 1
echo "→ PR 2: feat/ui-design-tokens (will base on PR 1 once merged)"
gh pr create \
  --repo "$UPSTREAM_REPO" \
  --base main \
  --head "jasonkneen:feat/ui-design-tokens" \
  --title "feat(ui): add AI SDK-inspired design tokens and spacing system" \
  --body "Part 2/11 of comprehensive UI overhaul. **Depends on PR 1** (change base after merge).

Adds consistent design tokens following AI SDK patterns:
- **Color tokens**: \`--ai\`, \`--ai-hover\`, \`--streaming\`, etc.
- **Spacing tokens**: \`--space-1\` through \`--space-20\`
- **Typography tokens**: \`--text-xs\` through \`--text-4xl\`
- Consistent toggle heights, tighter nav, better dark mode"

echo ""

# PR 3
echo "→ PR 3: refactor/ui-logs-debug (will base on PR 2 once merged)"
gh pr create \
  --repo "$UPSTREAM_REPO" \
  --base main \
  --head "jasonkneen:refactor/ui-logs-debug" \
  --title "refactor(ui): redesign logs and debug views with detail panels" \
  --body "Part 3/11 of comprehensive UI overhaul. **Depends on PR 2**.

Complete redesign of logs and debug views:
- Compact toolbar, fixed-height rows, detail panels
- RPC method autocomplete, JSON toggle
- Shared renderJsonBlock utility"

echo ""

# PR 4
echo "→ PR 4: refactor/ui-lucide-icons (will base on PR 3 once merged)"
gh pr create \
  --repo "$UPSTREAM_REPO" \
  --base main \
  --head "jasonkneen:refactor/ui-lucide-icons" \
  --title "refactor(ui): replace all emoji with Lucide icons" \
  --body "Part 4/11 of comprehensive UI overhaul. **Depends on PR 3**.

Replaces all hardcoded emoji with professional Lucide SVG icons:
- Add \`icon-sm\` utility class
- Ensures accessibility and consistent rendering"

echo ""

# PR 5
echo "→ PR 5: refactor/ui-core-views (will base on PR 4 once merged)"
gh pr create \
  --repo "$UPSTREAM_REPO" \
  --base main \
  --head "jasonkneen:refactor/ui-core-views" \
  --title "refactor(ui): apply consistent log-table patterns to core views" \
  --body "Part 5/11 of comprehensive UI overhaul. **Depends on PR 4**.

Applies consistent styling to: Skills, Sessions, Nodes, Cron, Instances, Overview, Nav
- Log-table layout, detail panels, Lucide icons
- Card-with-header pattern, .field wrappers"

echo ""

# PR 6
echo "→ PR 6: refactor/ui-channel-views (will base on PR 5 once merged)"
gh pr create \
  --repo "$UPSTREAM_REPO" \
  --base main \
  --head "jasonkneen:refactor/ui-channel-views" \
  --title "refactor(ui): apply consistent patterns to all channel views" \
  --body "Part 6/11 of comprehensive UI overhaul. **Depends on PR 5**.

Applies consistent UI patterns to all channel provider views:
- Fixed-width status chips (green for positive states)
- Log-level badge styling, .field wrappers"

echo ""

# PR 7
echo "→ PR 7: feat/ui-autocomplete (will base on PR 6 once merged)"
gh pr create \
  --repo "$UPSTREAM_REPO" \
  --base main \
  --head "jasonkneen:feat/ui-autocomplete" \
  --title "feat(ui): add autocomplete for RPC methods and model selection" \
  --body "Part 7/11 of comprehensive UI overhaul. **Depends on PR 6**.

Adds intelligent autocomplete:
- RPC method autocomplete with templates
- Model autocomplete on agents
- Tab key completion"

echo ""

# PR 8
echo "→ PR 8: feat/ui-chat-session-tabs (will base on PR 7 once merged)"
gh pr create \
  --repo "$UPSTREAM_REPO" \
  --base main \
  --head "jasonkneen:feat/ui-chat-session-tabs" \
  --title "feat(ui/chat): add session tabs and improve input layout" \
  --body "Part 8/11 of comprehensive UI overhaul. **Depends on PR 7**.

Major chat UI improvements:
- Recent session chips (sorted by updatedAt)
- Stacked Send/Stop buttons
- Slash command autocomplete (/status, /help, etc.)
- @ mention autocomplete for sub-agents"

echo ""

# PR 9
echo "→ PR 9: feat/ui-chat-queue-tools (will base on PR 8 once merged)"
gh pr create \
  --repo "$UPSTREAM_REPO" \
  --base main \
  --head "jasonkneen:feat/ui-chat-queue-tools" \
  --title "feat(ui/chat): compact queue tab and improved tool cards" \
  --body "Part 9/11 of comprehensive UI overhaul. **Depends on PR 8**.

Chat queue and tool card improvements:
- Compact collapsible queue tab
- All tool results as cards
- View button opens sidebar"

echo ""

# PR 10
echo "→ PR 10: fix/ui-chat-polish (will base on PR 9 once merged)"
gh pr create \
  --repo "$UPSTREAM_REPO" \
  --base main \
  --head "jasonkneen:fix/ui-chat-polish" \
  --title "fix(ui/chat): visual polish and system event dividers" \
  --body "Part 10/11 of comprehensive UI overhaul. **Depends on PR 9**.

Visual polish:
- Top-align avatar with first message
- System event dividers (new session, heartbeat, model change)
- Green status chips
- 3-state mode with per-tab toggles"

echo ""

# PR 11
echo "→ PR 11: feat/patch-ui-script (will base on PR 10 once merged)"
gh pr create \
  --repo "$UPSTREAM_REPO" \
  --base main \
  --head "jasonkneen:feat/patch-ui-script" \
  --title "feat(ui): add patch script for rapid UI development" \
  --body "Part 11/11 of comprehensive UI overhaul. **Depends on PR 10**.

Adds patch-ui.sh script:
- Builds UI from local dev repo
- Patches globally installed openclaw
- Dynamic path detection (no hardcoded paths)
- Added pnpm run patch command"

echo ""
echo "=== Done ==="
echo ""
echo "All 11 PRs created!"
echo "Remember to update base branches as previous PRs merge."
