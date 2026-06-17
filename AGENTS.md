# AGENTS — Project Conventions for AI Assistants

## Stack & Conventions

- **Rails 8.1.3**, **Ruby 4.0.5**, **PostgreSQL**
- **Tailwind CSS** — use utility classes; avoid custom CSS files
- **Hotwire** (Turbo + Stimulus) — prefer over raw JS
- **Testing** — standard Rails Minitest (model + controller tests under `test/`)
- **No comments in code** — keep implementation clean and self-documenting

## Database Schema

| Table | Purpose | Key columns |
|---|---|---|
| `farms` | Poultry farms | `name`, `location`, `status` (enum) |
| `sheds` | Buildings within a farm | `farm_id`, `name` |
| `zones` | Sections within a shed | `shed_id`, `name`, `status` (enum) |
| `sensors` | Physical devices | `zone_id`, `sensor_type` (enum), `label`, `status` (enum) |
| `readings` | Time-series sensor values | `sensor_id`, `value`, `unit`, `recorded_at` |
| `thresholds` | Limits per sensor type | `sensor_type` (enum), `warning_min/max`, `critical_min/max` |
| `alerts` | Triggered warnings/alerts | `farm_id`, `zone_id`, `sensor_id`, `severity` (enum), `alert_type`, `message`, `value`, `status` (enum), `resolved_at` |

## Enums

| Model | Enum field | Values |
|---|---|---|
| `Farm`, `Zone` | `status` | `normal` (0), `warning` (1), `critical` (2) |
| `Sensor` | `sensor_type` | `temperature` (0), `humidity` (1), `ammonia` (2), `fan` (3), `generator` (4) |
| `Sensor` | `status` | `online` (0), `offline` (1) |
| `Alert` | `severity` | `warning` (0), `critical` (1) |
| `Alert` | `status` | `active` (0), `resolved` (1) |

## Routes

```ruby
root "farms#index"
resources :farms, only: [:index, :show]
resources :zones, only: [:show]
resources :alerts, only: [:index]
```

## Key Patterns

- **Location-first UX**: Design around physical locations (farm → shed → zone), not sensor IDs or raw values. Alerts say "Zone C is overheating" not "34.2°C detected".
- **Priority order**: Ammonia (highest concern), then Temperature/Fan, then Humidity, then Generator. This ordering applies to metric cards, alert chips, and sensor lists.
- **SVG icons**: All UI icons use Heroicons-style inline SVGs via `IconsHelper#icon(name)`. Available icons: `:thermometer`, `:droplet`, `:bolt`, `:fan`, `:cog`, `:bell`, `:home`, `:chevron_left`, `:check`, `:x_mark`, `:exclamation_triangle`, `:exclamation_circle`, `:arrow_trending_up`. Never use emoji icons.
- **Health status**: `Farm#status` and `Zone#status` are stored enum columns set based on thresholds/comparisons in seed data or callbacks.
- **Latest reading**: `Sensor#latest_reading` returns the most recent `Reading` via `readings.order(recorded_at: :desc).first`.
- **Fake data**: All seed data in `db/seeds.rb` — run `bin/rails db:seed` to regenerate.
- **Views**: ERB templates in `app/views/{farms,zones,alerts}/` — 4 screens matching `demo.html`.
- **No comment lines** in source code; keep implementation readable through clear naming.

## When Making Changes

1. Update this file to reflect new conventions, tables, or patterns.
2. Update `DEVLOG.md` with the rationale for significant decisions.
3. Run `bin/rails test` before finishing.
4. Run `bin/rails db:migrate` if you add/modify migrations.
