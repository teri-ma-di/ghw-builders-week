# The Privacy-Aware RAG Bot — Auth0 FGA

MLH Global Hack Week: Builders Week challenge. Live demo: https://teri-ma-di.github.io/ghw-builders-week/privacy-rag-bot/

## What it does

An internal HR / Legal knowledge assistant that answers questions from a document database (RAG) — with document-level access enforced by an Auth0 FGA authorization model:

- **RAG index (5 documents):** Employee Handbook, PTO policy, Q4 budget, Salary bands, Legal NDA. Retrieval is real keyword scoring over the index.
- **FGA check first:** before any candidate document can enter the answer, the demo checks `user:<signed-in user> can view document:<id>` against the authorization model (tuples listed in the demo: handbook and PTO are viewable by everyone; budget_Q4 and salary_bands only by user:alice, HR Manager; legal_nda only by user:carol, Legal Counsel).
- **The key test:** sign in as Bob (general employee, Engineering) and ask "What are the salary bands?" — the salary document matches the query and is in the index, but the FGA check denies it, so the bot refuses to use it. Sign in as Alice (HR Manager) and ask the same question — she gets the answer.

## Honest scope

Static, no-backend demo. The FGA engine is a small in-page implementation of the stated authorization model (no live Auth0 FGA store is called); the retrieval over the document index is real. The companion Auth0 tenant dev-kcit4n6rij20q4zi powers the separate Auth0 login demo in this repo.

## Try it

Open the live demo, sign in as Bob, ask about salary bands (denied), then sign in as Alice and ask again (answered). Also try the PTO policy as anyone (answered) and the NDA as Carol (answered) vs Bob (denied).
