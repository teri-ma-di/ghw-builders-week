# The Veto Agent — Token Vault & Asynchronous Authorization (CIBA)

MLH Global Hack Week: Builders Week challenge. Live demo: https://teri-ma-di.github.io/ghw-builders-week/veto-agent/

## What it does

A small working AI-agent demo connected to a third-party service (GitHub):

1. **Token Vault (simulated)** — an access token you enter is held in a JavaScript variable only: never saved to localStorage, never shown in full (only the last 4 characters), and cleared on Revoke or reload. Public GitHub data needs no token at all.
2. **Low-risk actions run immediately** — "List my GitHub repos" and "Show my GitHub profile" really call the public GitHub API (`api.github.com/users/teri-ma-di/...`).
3. **High-impact actions pause for out-of-band approval (CIBA-style)** — "Delete all unread emails", "Schedule a meeting with the CEO" and "Delete repository ghw-builders-week" create an approval request in the separate Approval Inbox (simulating a push notification / email, outside the chat session). Execution stays halted until you Approve or Veto there. Requests expire after 120 seconds.

## Honest scope

This is a static, no-backend demo. The Token Vault and the CIBA push/email channel are simulated in the page, and high-impact actions are simulated — nothing is ever really deleted or scheduled. The GitHub fetch is real.

## Try it

Open the live demo, click "List my GitHub repos", then click "Delete all unread emails" and watch it halt — then Approve or Veto it in the Approval Inbox.
