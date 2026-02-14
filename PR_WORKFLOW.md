# UI Overhaul PR Workflow

## Summary

The massive UI overhaul has been split into **11 focused PRs** for easier review and merge:

1. **feat/ui-mode-system** - Basic/Advanced mode foundation (14 commits)
2. **feat/ui-design-tokens** - Design tokens & spacing (3 commits)
3. **refactor/ui-logs-debug** - Logs & debug redesign (15 commits)
4. **refactor/ui-lucide-icons** - Icon consistency (3 commits)
5. **refactor/ui-core-views** - Core views styling (8 commits)
6. **refactor/ui-channel-views** - Channel views styling (6 commits)
7. **feat/ui-autocomplete** - Autocomplete enhancements (3 commits)
8. **feat/ui-chat-session-tabs** - Chat session tabs & input (2 commits)
9. **feat/ui-chat-queue-tools** - Chat queue & tool cards (5 commits)
10. **fix/ui-chat-polish** - Chat visual polish (5 commits)
11. **feat/patch-ui-script** - Patch script tooling (2 commits)

**Total:** 67 commits across all PRs

---

## Path Issues Fixed

✅ **patch-ui.sh** now uses dynamic openclaw path detection:
- Detects global openclaw installation automatically
- Works with npm, pnpm, nvm
- No hardcoded user paths

---

## Files Created

- ✅ `PR_PLAN.md` - Detailed PR breakdown
- ✅ `PR_DESCRIPTIONS.md` - Full PR descriptions & testing instructions
- ✅ `PR_WORKFLOW.md` - This file
- ✅ `create-prs-v2.sh` - Script to create all 11 branches
- ✅ `push-all-prs.sh` - Script to push all branches to your fork
- ✅ `create-github-prs.sh` - Script to create PRs via GitHub CLI

---

## Quick Start

### 1. Verify All Branches Created
```bash
git branch | grep -E "feat|refactor|fix" | wc -l
# Should show 11
```

### 2. Test a Branch
```bash
git checkout feat/ui-mode-system
cd ui && pnpm run build
# Verify build succeeds
```

### 3. Push All Branches
```bash
./push-all-prs.sh
```

### 4. Create PRs on GitHub

**Option A: Manual (Web UI)**
1. Go to your fork on GitHub
2. Create PR for each branch using descriptions from `PR_DESCRIPTIONS.md`
3. Set base branch:
   - PR 1: base = `upstream/main`
   - PR 2-11: base = `main` (update after each merge)

**Option B: GitHub CLI (Automated)**
```bash
# Install gh if needed: brew install gh
gh auth login

./create-github-prs.sh
```

---

## PR Submission Strategy

### Approach 1: Sequential (Recommended)
1. Submit PR 1
2. After PR 1 merged, rebase PR 2 onto main and submit
3. Continue through PR 11

**Pros:** Clean history, easy to review  
**Cons:** Slower (wait for each merge)

### Approach 2: Stacked PRs (Faster)
1. Submit all 11 PRs immediately
2. Each PR notes dependency on previous (e.g., "Depends on #XXXX")
3. Merge in order (PR 1 → 11)
4. GitHub auto-updates base as each merges

**Pros:** Parallel review, faster overall  
**Cons:** More complex, reviewers see full stack

---

## Handling PR #16414

The existing PR #16414 contains similar changes. Options:

1. **Close #16414** and submit these 11 smaller PRs
2. **Merge #16414 first**, then submit these as follow-ups
3. **Cherry-pick from #16414** into these branches (avoid conflicts)

**Recommendation:** Close #16414 in favor of these focused PRs (easier to review).

---

## Commit Stats by PR

| PR | Branch | Commits | Lines Changed |
|----|--------|---------|---------------|
| 1  | feat/ui-mode-system | 14 | ~800 |
| 2  | feat/ui-design-tokens | 3 | ~300 |
| 3  | refactor/ui-logs-debug | 15 | ~1200 |
| 4  | refactor/ui-lucide-icons | 3 | ~150 |
| 5  | refactor/ui-core-views | 8 | ~600 |
| 6  | refactor/ui-channel-views | 6 | ~500 |
| 7  | feat/ui-autocomplete | 3 | ~200 |
| 8  | feat/ui-chat-session-tabs | 2 | ~250 |
| 9  | feat/ui-chat-queue-tools | 5 | ~300 |
| 10 | fix/ui-chat-polish | 5 | ~200 |
| 11 | feat/patch-ui-script | 2 | ~100 |

---

## Testing Checklist

For each PR:
- [ ] Build succeeds: `cd ui && pnpm run build`
- [ ] No TypeScript errors
- [ ] UI renders correctly in browser
- [ ] Dark/light theme both work
- [ ] No console errors

For mode-specific PRs (1-7):
- [ ] Basic mode shows simplified view
- [ ] Advanced mode shows full features
- [ ] Mode toggle works

For chat PRs (8-10):
- [ ] Session tabs appear with sub-agents
- [ ] Autocomplete works (/, @)
- [ ] Queue tab collapses/expands
- [ ] Tool cards render correctly

---

## Rollback Plan

If issues arise after merge:
```bash
# Restore from backup (patch script creates .bak)
cp -R ~/.nvm/.../openclaw/dist/control-ui.bak \
      ~/.nvm/.../openclaw/dist/control-ui

# Or git revert the merge commits
git revert <merge-commit-sha>
```

---

## Questions?

- **Merge conflicts?** Rebase on latest main: `git rebase upstream/main`
- **Build fails?** Check Node version: `node -v` (should be v22.14+)
- **PR order?** Follow 1→11 strictly (dependencies exist)
- **Skip a PR?** Not recommended (PRs build on each other)

---

## Next Steps

1. ✅ Path issues fixed
2. ✅ 11 branches created
3. ⏳ Push branches: `./push-all-prs.sh`
4. ⏳ Create PRs: `./create-github-prs.sh` or manually
5. ⏳ Address reviews
6. ⏳ Merge sequentially

Good luck! 🚀
