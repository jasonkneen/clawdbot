# Clawdbot Autonomy Architecture Analysis

## Executive Summary

Clawdbot is **not** an AGI-style autonomous agent system. It is a **personal AI assistant platform** with a sophisticated **tool-augmented LLM** architecture that creates the *illusion* of autonomy through:

1. **Event-driven reactive execution** (message arrives → agent runs → response sent)
2. **Pre-defined tool invocation** (agent calls tools with structured parameters)
3. **Session persistence** (conversation history maintained across interactions)
4. **Scheduled execution** (cron jobs trigger agent runs at specified times)
5. **Multi-channel routing** (messages flow from various platforms to the agent)

The "autonomy" is entirely derived from the underlying LLM's decision-making capability combined with a rich tool palette. **The system does not have goal-directed planning, self-modification, or continuous execution** — it is fundamentally a request-response loop with bells and whistles.

---

## What "Autonomy" Actually Means in Clawdbot

### The Core Loop

```
┌─────────────────────────────────────────────────────────────────────┐
│                         EVENT SOURCES                               │
├─────────────┬───────────┬──────────┬───────────┬───────────────────┤
│  Messaging  │  Cron     │  Webhook │  CLI      │  Heartbeat        │
│  Channels   │  Scheduler│  Events  │  Commands │  Polls            │
└──────┬──────┴─────┬─────┴────┬─────┴─────┬─────┴──────┬────────────┘
       │            │          │           │            │
       └────────────┴──────────┴───────────┴────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │  Message Router │
                    │  (dispatch.ts)  │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │  Agent Runner   │
                    │  (attempt.ts)   │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
        ┌──────────┐  ┌──────────┐  ┌──────────┐
        │ System   │  │   LLM    │  │  Tool    │
        │ Prompt   │  │ (Claude/ │  │ Execution│
        │ Builder  │  │  GPT/etc)│  │ Runtime  │
        └──────────┘  └────┬─────┘  └────┬─────┘
                           │             │
                           │  ◀──────────┘
                           │   (tool calls)
                           ▼
                    ┌─────────────────┐
                    │  Response       │
                    │  Dispatcher     │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │  Channel        │
                    │  Delivery       │
                    └─────────────────┘
```

### What Creates the "Autonomous" Feel

| Capability | Implementation | True Autonomy? |
|------------|---------------|----------------|
| **Responding to messages** | Event-driven dispatch | No - purely reactive |
| **Running shell commands** | `exec` tool | No - requires explicit invocation |
| **Browsing the web** | `browser` tool | No - requires explicit invocation |
| **Managing files** | `read`/`write`/`edit` tools | No - requires explicit invocation |
| **Scheduling tasks** | `cron` tool + Gateway scheduler | Partial - agent sets, system executes |
| **Spawning sub-agents** | `sessions_spawn` tool | No - explicit delegation pattern |
| **Cross-session messaging** | `sessions_send` tool | No - explicit messaging pattern |
| **Remembering context** | Session persistence + memory tools | No - context retrieval, not learning |

**Key insight**: The LLM decides *what* tools to call based on the conversation, but it doesn't have:
- Long-term goals it pursues
- Self-initiated actions (all triggered by external events)
- Learning or self-improvement
- Persistent background processes

---

## Architecture Components

### 1. Agent Execution Engine

**Location**: `src/agents/pi-embedded-runner/run/attempt.ts`

The core execution loop that:
- Loads session context
- Builds system prompt
- Creates tool palette
- Streams LLM responses
- Handles tool calls
- Persists conversation state

**Key code pattern**:
```typescript
// Creates agent session with tools and system prompt
const { session } = await createAgentSession({
  tools: builtInTools,
  customTools: allCustomTools,
  systemPrompt,
  sessionManager,
  // ...
});

// Prompts the model and waits for completion
await activeSession.prompt(effectivePrompt, { images });
```

### 2. Tool Palette System

**Location**: `src/agents/pi-tools.ts`, `src/agents/tool-policy.ts`

A hierarchical tool filtering system that:
- Defines tool groups (`group:fs`, `group:runtime`, `group:messaging`, etc.)
- Applies profile-based policies (`minimal`, `coding`, `messaging`, `full`)
- Filters by provider, agent, group, sandbox context
- Supports per-session tool customization

**Tool Groups**:
```typescript
const TOOL_GROUPS = {
  "group:memory": ["memory_search", "memory_get"],
  "group:web": ["web_search", "web_fetch"],
  "group:fs": ["read", "write", "edit", "apply_patch"],
  "group:runtime": ["exec", "process"],
  "group:sessions": ["sessions_list", "sessions_history", "sessions_send", "sessions_spawn", "session_status"],
  "group:ui": ["browser", "canvas"],
  "group:automation": ["cron", "gateway"],
  "group:messaging": ["message"],
  "group:nodes": ["nodes"],
};
```

### 3. Skills System

**Location**: `src/agents/skills/`, `skills/*/SKILL.md`

A documentation-as-configuration pattern where:
- Skills are SKILL.md files with frontmatter metadata
- The system prompt tells the agent which skills exist
- The agent reads skill files when it determines they're relevant
- Skills can define eligibility rules, invocation policies, and tool dispatch

**Skills are NOT plugins** — they're instruction sets that guide LLM behavior, not executable code.

**Example skill structure**:
```markdown
---
name: coding-agent
description: Run Codex CLI, Claude Code, OpenCode, or Pi Coding Agent
metadata: {"clawdbot":{"emoji":"🧩","requires":{"anyBins":["claude","codex"]}}}
---

# Coding Agent (bash-first)

Use **bash** (with optional background mode) for all coding agent work...
```

### 4. Plugin/Extension System

**Location**: `src/plugins/`, `extensions/`

A true extensibility layer that allows:
- Custom messaging channels (MSTeams, Matrix, etc.)
- Custom tools
- Lifecycle hooks
- Gateway methods
- CLI commands

**Plugin Registration**:
```typescript
export function register(api: PluginApi) {
  api.registerTool({
    name: "my_tool",
    description: "...",
    parameters: schema,
    execute: async (toolCallId, args) => { /* ... */ }
  });

  api.registerHook("before_agent_start", async (event, ctx) => {
    return { prependContext: "Additional context..." };
  });
}
```

### 5. Hook System

**Location**: `src/plugins/hooks.ts`

Lifecycle hooks that allow plugins to intercept and modify agent behavior:

| Hook | When | Can Modify? |
|------|------|-------------|
| `before_agent_start` | Before LLM prompt | System prompt, prepend context |
| `agent_end` | After response complete | No (fire-and-forget) |
| `before_tool_call` | Before tool execution | Parameters, can block |
| `after_tool_call` | After tool execution | No (fire-and-forget) |
| `message_received` | When message arrives | No (fire-and-forget) |
| `message_sending` | Before reply sent | Content, can cancel |
| `session_start`/`session_end` | Session lifecycle | No (fire-and-forget) |
| `gateway_start`/`gateway_stop` | Gateway lifecycle | No (fire-and-forget) |

### 6. Subagent System

**Location**: `src/agents/tools/sessions-spawn-tool.ts`, `src/agents/subagent-registry.ts`

Allows spawning isolated agent sessions for:
- Long-running background tasks
- Parallel workloads
- Task delegation

**Key constraints**:
- Parent must be a "main" session (subagents can't spawn subagents)
- Subagents have reduced tool access (no spawn, limited messaging)
- Results announced back to requester via `sessions_send`

### 7. Cron/Scheduling System

**Location**: `src/agents/tools/cron-tool.ts`, `src/gateway/server-cron.ts`

The closest thing to "autonomous" behavior:
- Agent can schedule future actions via `cron` tool
- Gateway executes scheduled jobs
- Two payload types:
  - `systemEvent`: Injects text into main session (heartbeat style)
  - `agentTurn`: Runs agent with message (isolated session)

**Example**:
```typescript
cron action:add job:{
  schedule: { kind: "at", atMs: futureTimestamp },
  payload: { kind: "systemEvent", text: "Reminder: Check on the build" },
  sessionTarget: "main"
}
```

---

## What Can Be Extracted?

### Extractable as Standalone Components

| Component | Extractability | Notes |
|-----------|---------------|-------|
| **Tool Definitions** | ✅ High | Each tool in `src/agents/tools/` is self-contained |
| **Skill Files** | ✅ High | Pure documentation, portable to any LLM system |
| **Plugin Architecture** | ✅ High | Clean SDK, jiti-based loading |
| **Hook System** | ✅ High | Generic lifecycle pattern |
| **Session Persistence** | ⚠️ Medium | Tied to pi-coding-agent SessionManager |
| **Channel Adapters** | ⚠️ Medium | Gateway-dependent but adaptable |
| **Cron Scheduler** | ⚠️ Medium | Gateway-specific implementation |
| **System Prompt Builder** | ❌ Low | Highly Clawdbot-specific |
| **Agent Runner** | ❌ Low | Deep integration with pi-coding-agent |

### Potential Extraction Patterns

#### 1. **Tools as MCP Servers**

Each tool could be exposed as an MCP (Model Context Protocol) server:

```typescript
// tools/exec-mcp/index.ts
import { McpServer } from "@modelcontextprotocol/sdk";

const server = new McpServer();
server.tool("exec", {
  description: "Execute shell command",
  inputSchema: ExecToolSchema,
  handler: async (params) => { /* exec implementation */ }
});
```

#### 2. **Skills as Prompt Libraries**

Skills could become a shareable prompt library format:

```yaml
# skills/coding-agent.yaml
name: coding-agent
triggers:
  - "run codex"
  - "spawn coding agent"
instructions: |
  Use bash (with optional background mode) for all coding agent work...
tools_required: [exec, process]
```

#### 3. **Plugins as Workflow Steps**

The plugin architecture could be adapted to workflow engines:

```typescript
// workflow-step.ts
export const step: WorkflowStep = {
  name: "fetch-github-issue",
  inputs: { issueUrl: "string" },
  outputs: { title: "string", body: "string" },
  execute: async ({ issueUrl }) => {
    // Implementation
  }
};
```

#### 4. **Hooks as Middleware**

The hook system maps directly to middleware patterns:

```typescript
// middleware.ts
export const contextInjector: AgentMiddleware = {
  phase: "before",
  handler: (ctx, next) => {
    ctx.systemPrompt += "\n\nAdditional context...";
    return next(ctx);
  }
};
```

---

## Honest Assessment

### What Clawdbot Does Well

1. **Rich tool palette** — 30+ tools covering filesystem, web, messaging, scheduling
2. **Multi-channel support** — WhatsApp, Telegram, Discord, Slack, Signal, iMessage, etc.
3. **Session isolation** — Proper per-conversation context management
4. **Extensibility** — Plugin system allows adding channels, tools, hooks
5. **Skill documentation** — SKILL.md pattern is elegant and portable
6. **Subagent delegation** — Clean pattern for parallelizing work

### What Clawdbot Is NOT

1. **Not AGI** — No goal-directed planning or continuous execution
2. **Not autonomous** — All actions triggered by external events
3. **Not learning** — No self-improvement or adaptation beyond context window
4. **Not multi-agent orchestration** — Subagents are isolated, not collaborating
5. **Not workflow automation** — No visual workflow builder or DAG execution

### The Illusion of Autonomy

The "autonomous" feel comes from:

1. **LLM decision-making** — Model chooses which tools to call
2. **Cron scheduling** — Agent can set future triggers
3. **Background processes** — Long-running tasks via `process` tool
4. **Subagent delegation** — Offloading work to other sessions
5. **Persistent memory** — Context maintained across interactions

But fundamentally, **every action is a response to an event** (message, cron tick, webhook). The system has no "idle loop" where it pursues goals independently.

---

## Recommendations for Extraction

### If you want standalone tools:
Extract `src/agents/tools/*.ts` and wrap them as MCP servers or standalone NPM packages.

### If you want the skill pattern:
Copy `skills/*/SKILL.md` files and adapt the frontmatter format for your system.

### If you want the plugin architecture:
Study `src/plugins/` and `src/plugin-sdk/` — this is a clean, jiti-based plugin loader that could be adapted.

### If you want true autonomy:
You'll need to build:
1. A goal/task manager that persists objectives
2. A planning layer that decomposes goals into subtasks
3. A continuous execution loop (not event-driven)
4. Feedback mechanisms that update plans based on outcomes

Clawdbot provides excellent building blocks (tools, sessions, scheduling) but not the orchestration layer for true autonomous behavior.

---

## Appendix: Key Source Files

| Component | Primary Files |
|-----------|--------------|
| Agent Runner | `src/agents/pi-embedded-runner/run/attempt.ts` |
| System Prompt | `src/agents/system-prompt.ts` |
| Tool Creation | `src/agents/pi-tools.ts` |
| Tool Policy | `src/agents/tool-policy.ts` |
| Individual Tools | `src/agents/tools/*.ts` |
| Skills Loader | `src/agents/skills/workspace.ts` |
| Plugin Loader | `src/plugins/loader.ts` |
| Hook Runner | `src/plugins/hooks.ts` |
| Message Dispatch | `src/auto-reply/dispatch.ts`, `src/auto-reply/reply/dispatch-from-config.ts` |
| Subagent Spawn | `src/agents/tools/sessions-spawn-tool.ts` |
| Cron Tool | `src/agents/tools/cron-tool.ts` |
| Channel Adapters | `src/discord/`, `src/telegram/`, `src/slack/`, etc. |
| Extensions | `extensions/msteams/`, `extensions/matrix/`, etc. |
| Bundled Skills | `skills/*/SKILL.md` (52 skills) |

---

## Conclusion

Clawdbot is a well-engineered **personal AI assistant platform** with strong multi-channel support and extensibility. Its "autonomy" is the autonomy of an LLM making tool calls, not the autonomy of a goal-directed agent.

The components most valuable for extraction are:
1. **Tool implementations** (portable with moderate effort)
2. **Skill documentation format** (immediately portable)
3. **Plugin architecture** (adaptable to other systems)
4. **Hook/middleware pattern** (generic and reusable)

True autonomous agent behavior would require building an orchestration layer on top of these primitives.
