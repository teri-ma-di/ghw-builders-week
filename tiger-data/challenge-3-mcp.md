# Challenge 3 — Supercharge AI Agents with Tiger CLI or MCP Server

MLH Global Hack Week: Builders Week.

## Status: BLOCKED in this environment (not submitted as done)

Tiger MCP is bundled with the Tiger CLI. It can only be installed and run on a
local machine with a terminal. This work was done in a browser-only environment
with no terminal, so no CLI install and no MCP server connection could be run
from here. The Tiger Cloud console page that was opened (CLI / MCP tab) confirms
this: both the CLI and the MCP setup require installing Tiger CLI on a local
machine first.

## How to complete it on a local machine (verified steps, from the Tiger docs)

Install the Tiger CLI (Debian/Ubuntu):

```bash
curl -1sLf 'https://dl.cloudsmith.io/public/tigerdata/tiger-cli/setup.deb.sh' | sudo -E bash
sudo apt-get install -y tiger-cli
tiger auth login
```

Then connect the MCP server to an AI client (per the Tiger Cloud console
"Set up MCP" flow and the docs at
https://www.tigerdata.com/docs/get-started/quickstart/mcp-cli):

```bash
tiger mcp install
```

This registers the Tiger MCP server in the client's config. Or add it manually
to the MCP config file (for example `~/.cursor/mcp.json` for Cursor):

```json
{
  "mcpServers": {
    "tiger": {
      "command": "tiger",
      "args": ["mcp", "start"]
    }
  }
}
```

Tiger MCP supports Cursor, Claude Code, VS Code, Cline and other MCP clients.
No credentials are stored in this repo; sign in with `tiger auth login` on the
local machine.

## What was verified here

- Tiger Cloud service `ghw-builders-week` exists and is Ready (PostgreSQL 18.6,
  TimescaleDB v2.31.0, AWS us-east-1, service id `wtdwdw8yd8`).
- The CLI / MCP console page and the Tiger MCP/CLI docs were read and the steps
  above are the documented route. A working connection requires the local
  terminal step, which is a step for the account owner on their own machine.
