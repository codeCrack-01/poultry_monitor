# Poultry Monitor

Real-time poultry farm monitoring dashboard. Tracks temperature, humidity, ammonia levels, fan status, and generator status across multiple farms and zones.

## Tech Stack

- **Ruby** 4.0.5 / **Rails** 8.1.3
- **PostgreSQL** — primary database
- **Tailwind CSS** — styling
- **Hotwire** (Turbo + Stimulus) — front-end interactivity

## Setup

```bash
bin/setup
```

Sets up gems, creates DB, runs migrations, and seeds fake data.

## Commands

| Action | Command |
|---|---|
| Start server | `bin/dev` |
| Run tests | `bin/rails test` |
| Seed data | `bin/rails db:seed` |
| Lint | `bin/rubocop` |

## Architecture (Data Hierarchy)

```
Farm → Shed → Zone → Sensor → Reading
  └── Alert (via farm/zone/sensor)
  └── Threshold (configurable limits per sensor type)
```

See [AGENTS.md](AGENTS.md) for conventions and [DEVLOG.md](DEVLOG.md) for development history.
