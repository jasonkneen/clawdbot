# UI Overhaul PR Descriptions

## PR 1: Foundation - Basic/Advanced Mode System
**Branch:** `feat/ui-mode-system`  
**Base:** `upstream/main`  
**Title:** `feat(ui): add Basic/Advanced mode system with per-view filtering`

**Description:**
Part 1/11 of comprehensive UI overhaul.

Adds a mode preference system allowing users to toggle between:
- **Basic mode**: Simplified interface showing only essential features
- **Advanced mode**: Full access to all features and debugging tools

Changes:
- Add mode preference storage (basic/advanced) in UiSettings
- Add `@state()` mode property to app with load/save
- Add mode toggle UI in dashboard header
- Add mode-aware tab filtering to navigation
- Add navigation guards to redirect advanced-only views
- Update all views with conditional rendering based on mode:
  - Overview: simplified stats in basic mode
  - Sessions: hide technical columns
  - Config: show only env and gateway sections
  - Agents: hide internal tabs
  - Nodes: hide exec approvals
  - Usage: hide detailed analytics
  - Channels: hide health section
  - Logs: hide subsystem column

Default mode is Advanced (existing users get full functionality).

**Testing:**
```bash
cd ui && pnpm run build
# Toggle mode in UI header, verify views adjust accordingly
```

---

## PR 2: Design Tokens & Base Styling
**Branch:** `feat/ui-design-tokens`  
**Base:** `feat/ui-mode-system`  
**Title:** `feat(ui): add AI SDK-inspired design tokens and spacing system`

**Description:**
Part 2/11 of comprehensive UI overhaul. Depends on #PR1.

Adds consistent design tokens following AI SDK patterns:
- **Color tokens**: `--ai`, `--ai-hover`, `--ai-muted`, `--streaming`, etc.
- **Spacing tokens**: `--space-1` through `--space-20`
- **Typography tokens**: `--text-xs` through `--text-4xl`
- **Line height tokens**: `--leading-tight`, `--leading-normal`, `--leading-relaxed`

Improvements:
- Consistent toggle heights across views
- Tighter navigation spacing
- Better dark mode contrast

Both dark and light themes updated.

**Testing:**
```bash
cd ui && pnpm run build
# Verify spacing consistency, toggle between themes
```

---

## PR 3: Logs & Debug Views Overhaul
**Branch:** `refactor/ui-logs-debug`  
**Base:** `feat/ui-design-tokens`  
**Title:** `refactor(ui): redesign logs and debug views with detail panels`

**Description:**
Part 3/11 of comprehensive UI overhaul. Depends on #PR2.

Complete redesign of logs and debug views:

**Logs view:**
- Compact toolbar with toggle-style level chips
- Fixed-width level badges, sortable columns
- Fixed-height rows (36px) with selection
- Click-to-expand detail panel
- Raw/structured JSON toggle
- Inline level+subsystem display
- Glow-ring filter chips

**Debug view:**
- Snapshot table with detail panel
- RPC panel as inline bar
- Event log in log-table format
- RPC method autocomplete with param templates
- Lucide icons replace emoji

**Shared:**
- New `renderJsonBlock` utility for consistent JSON display

**Testing:**
```bash
cd ui && pnpm run build
# Navigate to Logs & Debug tabs, test filtering and detail panels
```

---

## PR 4: Icon Consistency - Replace Emoji with Lucide
**Branch:** `refactor/ui-lucide-icons`  
**Base:** `refactor/ui-logs-debug`  
**Title:** `refactor(ui): replace all emoji with Lucide icons`

**Description:**
Part 4/11 of comprehensive UI overhaul. Depends on #PR3.

Replaces all hardcoded emoji with professional Lucide SVG icons:
- Add `icon-sm` utility class for consistent sizing (14-18px)
- Replace emoji in debug, skills, and all views
- Ensures accessibility and consistent rendering across platforms

Icons used: `wrench`, `puzzle`, `smartphone`, `monitor`, `zap`, etc.

**Testing:**
```bash
cd ui && pnpm run build
# Verify no emoji remain, all icons render consistently
```

---

## PR 5: Core Views Consistency (Overview, Sessions, Skills)
**Branch:** `refactor/ui-core-views`  
**Base:** `refactor/ui-lucide-icons`  
**Title:** `refactor(ui): apply consistent log-table patterns to core views`

**Description:**
Part 5/11 of comprehensive UI overhaul. Depends on #PR4.

Applies consistent styling patterns to core views:

**Skills:**
- Log-table layout with detail panel
- Lucide puzzle icons (properly sized)

**Sessions:**
- Log-table layout with compact filters
- `.field` wrappers for inputs/selects

**Nodes:**
- Fixed 36px rows
- Card-with-header pattern
- Lucide smartphone icons

**Cron:**
- Log-table for jobs and runs
- Lucide zap icons

**Instances:**
- Log-table with 36px rows
- Lucide monitor icons
- Oversized icon fixes

**Overview:**
- Tighter stat card padding (12px)
- `.field` wrappers

**Navigation:**
- Larger sidebar items
- Stronger active state

**Testing:**
```bash
cd ui && pnpm run build
# Navigate through all core views, verify consistent layout
```

---

## PR 6: Channel Views Consistency
**Branch:** `refactor/ui-channel-views`  
**Base:** `refactor/ui-core-views`  
**Title:** `refactor(ui): apply consistent patterns to all channel views`

**Description:**
Part 6/11 of comprehensive UI overhaul. Depends on #PR5.

Applies consistent UI patterns to all channel provider views:
- Main channels overview
- WhatsApp
- Telegram
- Discord
- Signal
- Slack
- Google Chat
- iMessage
- Nostr

Changes:
- Fixed-width status chips (Connected/Enabled/YES in green)
- Log-level badge styling
- `.field` wrappers for inputs/selects
- Consistent padding and spacing
- Card-with-header pattern

**Testing:**
```bash
cd ui && pnpm run build
# Navigate to Channels tab, verify all providers look consistent
```

---

## PR 7: Autocomplete & Input Enhancements
**Branch:** `feat/ui-autocomplete`  
**Base:** `refactor/ui-channel-views`  
**Title:** `feat(ui): add autocomplete for RPC methods and model selection`

**Description:**
Part 7/11 of comprehensive UI overhaul. Depends on #PR6.

Adds intelligent autocomplete to input fields:
- RPC method autocomplete with parameter templates (debug view)
- Model autocomplete on agents fallbacks input
- Tab key completion for all autocomplete menus
- JSON block renderer for config view

Improves UX by reducing typos and providing helpful templates.

**Testing:**
```bash
cd ui && pnpm run build
# Debug: type in RPC input, press Tab to complete
# Agents: type in fallback models, see autocomplete
```

---

## PR 8: Chat UI - Session Tabs & Input Layout
**Branch:** `feat/ui-chat-session-tabs`  
**Base:** `feat/ui-autocomplete`  
**Title:** `feat(ui/chat): add session tabs and improve input layout`

**Description:**
Part 8/11 of comprehensive UI overhaul. Depends on #PR7.

Major chat UI improvements:

**Session tabs:**
- "Recent" chip bar showing last 7 active sessions
- Main session always pinned first
- Sorted by `updatedAt` descending
- Smart display names (truncated UUIDs, uses label/displayName)
- Hover shows full session key

**Input layout:**
- Stacked Send/Stop buttons (vertical, 80px wide)
- Send/Queue on top, Stop/New Session on bottom

**Autocomplete:**
- Slash commands: `/status`, `/clear`, `/model`, `/thinking`, `/verbose`, `/reasoning`, `/help`
- @ mentions: autocomplete sub-agents
- Tab key completion, Escape to close

**Icon cleanup:**
- Tool avatar uses Lucide wrench icon

**Testing:**
```bash
cd ui && pnpm run build
# Chat: type `/` or `@` to see autocomplete
# Create sub-agents, verify session tabs appear
```

---

## PR 9: Chat UI - Queue & Tool Cards
**Branch:** `feat/ui-chat-queue-tools`  
**Base:** `feat/ui-chat-session-tabs`  
**Title:** `feat(ui/chat): compact queue tab and improved tool cards`

**Description:**
Part 9/11 of comprehensive UI overhaul. Depends on #PR8.

Chat queue and tool card improvements:

**Queue:**
- Compact collapsible tab instead of big block
- Shows "Queued (N)" count
- Click to expand/collapse panel
- Max height 120px with scroll
- Flush to input area (no gap)
- Black background, taller tab

**Tool cards:**
- All tool results render as compact cards
- No inline output (always show "View" button)
- View button opens sidebar with full output
- Consistent card styling

**Testing:**
```bash
cd ui && pnpm run build
# Queue multiple messages, verify compact tab
# Run tool commands, verify cards render cleanly
```

---

## PR 10: Chat UI - Visual Polish
**Branch:** `fix/ui-chat-polish`  
**Base:** `feat/ui-chat-queue-tools`  
**Title:** `fix(ui/chat): visual polish and system event dividers`

**Description:**
Part 10/11 of comprehensive UI overhaul. Depends on #PR9.

Visual polish and UX improvements:

**Message layout:**
- Top-align avatar with first message in group

**System events:**
- Dividers for: new session, heartbeat, model change, etc.
- Clear visual separation of session boundaries

**Status chips:**
- Green chips for positive states (YES/Connected/Enabled)
- Consistent with rest of UI

**Mode:**
- Default to Advanced for new and existing users
- 3-state mode (simple/advanced/configure) with per-tab toggles

**Testing:**
```bash
cd ui && pnpm run build
# Start new session, verify divider appears
# Check avatar alignment in message groups
```

---

## PR 11: Tooling - Patch Script
**Branch:** `feat/patch-ui-script`  
**Base:** `fix/ui-chat-polish`  
**Title:** `feat(ui): add patch script for rapid UI development`

**Description:**
Part 11/11 of comprehensive UI overhaul. Depends on #PR10.

Adds `patch-ui.sh` script for rapid UI iteration:
- Builds UI from local dev repo
- Patches globally installed openclaw package
- Restarts live gateway
- Creates backup on first run

**Improvements:**
- Dynamic openclaw path detection (no hardcoded paths)
- Works with npm, pnpm, nvm installations
- Added `pnpm run patch` command to ui/package.json

**Usage:**
```bash
# From atomicbot repo root:
./patch-ui.sh

# Or from ui/:
pnpm run patch
```

**Testing:**
```bash
# Verify script detects openclaw install location
./patch-ui.sh
# Check UI updates at http://127.0.0.1:18789
```

---

## Submission Order

1. Submit PR 1 (base: upstream/main)
2. After PR 1 merged, rebase PR 2 onto main and submit
3. Continue sequentially through PR 11

Or submit all PRs immediately as stacked PRs (each based on previous branch).
