# The Context-Preserving Assistant

MLH Global Hack Week: Builders Week challenge — Focus: Full-Stack Identity & API Access.

A full-stack personal assistant that uses the user's authenticated identity to call a first-party API and a public third-party API, keeping the user's context through one conversation.

## How it works

1. Authenticate the user with Auth0 Universal Login. The app is a Single Page Application registered in the Auth0 tenant `dev-kcit4n6rij20q4zi` (domain `dev-kcit4n6rij20q4zi.us.auth0.com`) — the same SPA used by `auth0-demo/`. It uses the Auth0 SPA SDK from the CDN, exactly like `auth0-demo/index.html`.
2. First-party API: after login, the app fetches `settings.json` from its own origin with the user's Auth0 ID token as a Bearer token. The file is the first-party settings service — it stores saved settings keyed by Auth0 user id, and the app reads the entry for the signed-in user's `sub`. Gary's saved settings: home city Woodbridge, Ontario, Canada (43.68, -79.59) and temperature unit Celsius.
3. Third-party API: the assistant calls the public Open-Meteo weather API (no key needed) for the user's saved home city and reads the current temperature.
4. Single conversation: in the chat UI, the user asks "What is the weather where I live?" The assistant replies in the same conversation, referencing the user-specific setting from the first-party API (home city and Celsius preference) and the live weather from Open-Meteo.

## Files

- `index.html` — the assistant app (Auth0 login, settings fetch, Open-Meteo call, chat UI, step-by-step trace).
- `settings.json` — the first-party settings service data, keyed by Auth0 user id.

## Run it

The app is a static site and is hosted on GitHub Pages at `https://teri-ma-di.github.io/ghw-builders-week/context-assistant/`. Sign in with Auth0 (Google), then ask the weather question in the chat.
