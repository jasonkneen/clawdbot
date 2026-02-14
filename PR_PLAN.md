# UI Overhaul PR Plan

## PR 1: Foundation - Basic/Advanced Mode System
**Branch:** `feat/ui-mode-system`
**Commits:** 50fe622..fa6e519 (15 commits)
- Add mode preference storage (basic/advanced)
- Add mode state decorator and load/save
- Add mode toggle UI in header
- Add mode-aware tab filtering
- Add navigation guards for advanced-only views
- Update all views with mode-aware rendering

## PR 2: Design Tokens & Base Styling
**Branch:** `feat/ui-design-tokens`
**Commits:** 5dacb45, 5b25916, 1d8835a
- Add AI SDK-inspired color tokens (--ai, --streaming, etc.)
- Add spacing tokens (--space-1 through --space-20)
- Add typography tokens (--text-xs through --text-4xl)
- Fix toggle heights, nav spacing, dark mode contrast

## PR 3: Logs & Debug Views Overhaul
**Branch:** `refactor/ui-logs-debug`
**Commits:** de4035f..72f32af, 3fd76ab
- Logs: compact toolbar, toggle-style chips, sortable columns
- Logs: fixed-height rows, detail panel, JSON toggle
- Debug: snapshot table with detail panel
- Debug: RPC panel, event log, method autocomplete
- Shared JSON renderer utility

## PR 4: Icon Consistency - Replace Emoji with Lucide
**Branch:** `refactor/ui-lucide-icons`
**Commits:** a984ccd, c85eb96, 1b3f85e, 107ec2b, a00e23f
- Replace all hardcoded emoji with Lucide icons
- Add icon-sm utility class for consistent sizing
- Apply to debug, skills, all views

## PR 5: Core Views Consistency (Overview, Sessions, Skills)
**Branch:** `refactor/ui-core-views`
**Commits:** 2fda8bb, 107ec2b..d19083, dfe5842..5e03420
- Skills: log-table layout with detail panel
- Sessions: log-table layout, compact filters, .field wrappers
- Nodes: log-table, Lucide icons, consistent styling
- Cron: consistent styling patterns
- Instances: fix oversized icons, proper log-table
- Overview: consistent styling
- Nav: larger sidebar items, stronger active state

## PR 6: Channel Views Consistency
**Branch:** `refactor/ui-channel-views`
**Commits:** d658d35..54259d9, 1cbaf90
- Apply consistent patterns to main channels view
- WhatsApp, Telegram, Discord, Signal, Slack
- Google Chat, iMessage, Nostr
- Fixed-width status chips across all channel views

## PR 7: Autocomplete & Input Enhancements
**Branch:** `feat/ui-autocomplete`
**Commits:** ff0d907, 053373c, b3e7eb6, 8aecc77
- RPC method autocomplete with param templates
- Model autocomplete on agents fallbacks
- Tab key completion
- JSON block renderer for config view

## PR 8: Chat UI - Session Tabs & Input Layout
**Branch:** `feat/ui-chat-session-tabs`
**Commits:** 4d56c5e, 410c7ad
- Recent session chips with "Recent" label
- Sorted by updatedAt, limited to 7 + main
- Smart display names & truncation
- Stacked Send/Stop buttons (vertical)
- Slash command autocomplete (/status, /help, etc.)
- @ mention autocomplete for sub-agents
- Icon cleanup (tool avatar)

## PR 9: Chat UI - Queue & Tool Cards
**Branch:** `feat/ui-chat-queue-tools`
**Commits:** 7ba5666, ef20b7e, 48eb1a2, 2f20571, fc4e8fa
- Compact collapsible queue tab
- Tighter queue tab flush to input
- Queue drawer styling (black bg, taller tab)
- All tool results as compact cards
- Compact tool cards (View opens sidebar)

## PR 10: Chat UI - Visual Polish
**Branch:** `fix/ui-chat-polish`
**Commits:** 1f53b94, b20735b, 7c0ffa4, 942f7e4, fb2ed95
- Top-align avatar with first message
- System event dividers (new session, heartbeat, model change)
- Green status chips for positive states
- Default mode to advanced
- 3-state mode (simple/advanced/configure) with per-tab toggles

## PR 11: Tooling - Patch Script
**Branch:** `feat/patch-ui-script`
**Commits:** 69fae8c (1 commit)
- Add patch-ui.sh script
- Add pnpm run patch command

---

## Execution Plan

1. Create each branch from upstream/main
2. Cherry-pick relevant commits to each branch
3. Test each branch independently
4. Submit PRs in order (1→11)
5. Address reviews and merge sequentially
