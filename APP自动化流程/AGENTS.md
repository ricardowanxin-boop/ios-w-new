# AGENTS.md

## Mission
This repository is an iOS app factory.
Its goal is to take a product from opportunity discovery to App Store launch with structured, reviewable outputs.

## Operating principles
- Always optimize for a narrow, paid, realistic MVP.
- Prefer one painful use case over many weak ones.
- Prefer outputs that can be reviewed, edited, and shipped.
- Avoid vague strategy. Produce files, checklists, specs, and implementation steps.
- Every major phase must leave a written artifact in the correct folder.
- Before making major scope changes, write a decision note first.
- Before coding, ensure the product definition exists.
- Before launch work, ensure QA and App Store checklists exist.

## Product constraints
- Default stack: SwiftUI, local-first where possible, minimal backend.
- Prefer products a solo developer can ship in 2-6 weeks.
- Avoid heavy social, marketplaces, creator ecosystems, moderation-heavy products, and backend-intensive products unless explicitly approved.
- Monetization must be explicit:
  - subscription
  - one-time purchase
  - paid feature unlock
- Every product idea must define:
  - target user
  - painful trigger moment
  - core job to be done
  - why current workaround is insufficient
  - why user would pay
  - why this is feasible for a solo iOS developer

## Output directories
- Research outputs go to /research
- Product outputs go to /product
- UX/UI outputs go to /design
- App implementation docs and code go to /app
- QA outputs go to /qa
- Launch outputs go to /launch

## Decision standards
A product direction is only "approved" when these exist:
- opportunity scorecard
- evidence summary
- competitor matrix
- positioning statement
- PRD
- MVP scope
- screen inventory or flow
- UX copy draft
- implementation plan
- QA checklist
- App Store launch checklist

## Writing standards
- Be concrete and commercially practical.
- Prefer bullets, tables, schemas, and checklists over essays.
- Cut speculative features aggressively.
- Separate facts, assumptions, and open questions.
- When uncertain, state the uncertainty clearly.

## Engineering standards
- Prefer maintainable SwiftUI patterns.
- Prefer simple local persistence first.
- Keep dependencies minimal unless they create clear leverage.
- Build the narrowest version that proves the product.
- Do not build speculative infrastructure.

## QA standards
- Test trust-sensitive flows first:
  - onboarding
  - save/edit/delete
  - reminders/notifications
  - paywall/purchase
  - settings/privacy
- Flag release blockers clearly.
- Distinguish critical issues from improvements.

## Launch standards
- App Store messaging must match the core value proposition.
- Do not use bloated or fake-urgency language.
- Focus on channels realistic for an indie developer.
