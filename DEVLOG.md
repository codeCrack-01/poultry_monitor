# DEVLOG — Development History

## 2026-06-17 — Initial scaffold

- Generated Rails 8.1.3 app with PostgreSQL (`poultry_monitor`).
- Added `DashboardController#index` as placeholder root route.
- Minimal placeholder view created.

## 2026-06-17 — Schema design & full MVP build

- Designed 7-table schema: `farms`, `sheds`, `zones`, `sensors`, `readings`, `thresholds`, `alerts`.
- Hierarchy: Farm → Shed → Zone → Sensor → Reading.
- Decision: separate RESTful controllers (Farms, Zones, Alerts) rather than monolithic DashboardController.
- Decision: thresholds stored in DB (`thresholds` table) for run-time configurability.
- Decision: build all 4 screens (farm overview, farm dashboard, zone detail, alerts) for MVP.
- Decision: all data fake/seeded; no real sensor integration yet.
- Referenced `demo.html` as visual design spec for all screens.
- Created `AGENTS.md` and `DEVLOG.md` for agent/human context handoff.

## 2026-06-17 — UX shift: location-first, priority order, SVG icons

- Added `IconsHelper#icon` with 13 Heroicons-style inline SVG icons; all emoji icons replaced.
- Root route changed from `dashboard#index` to `farms#index` — no landing page.
- Alert messages rewritten to be location-aware: "Zone C has high ammonia" not "28 ppm detected".
- Priority order established: Ammonia → Temperature/Fan → Humidity → Generator.
  - Applied to alert chip ordering, metric card layout, and sensor list.
- Farm show view rebalanced: zone grid promoted above metric cards (Level 3 prominence per design brief).
- Metric cards now show which zone is affected rather than just raw values.
- Created `demo.txt` UX design brief to guide all future UI decisions.
