# Screenshot / demo tooling

Small Playwright-based helpers used to generate the phone-sized mockups in
`../mockups/` and the walkthrough video in `../demo/`. Not part of the app
itself — just the tooling used to capture it running.

Requires: `pip install playwright && playwright install chromium`, and a
release web build served locally (`flutter build web --release` then
`python -m http.server 8080` from `build/web`).

- `launch_browser.py` — starts a Chromium instance with a remote debugging
  port open and a video-recording context, navigates to the app, and stays
  alive so other scripts can attach to the same session.
- `shot.py <output.png> [wait_ms]` — connects to the running instance and
  saves a screenshot.
- `act.py <actions.json> [output.png]` — connects to the running instance
  and replays a list of `{type: click|type|wait|key, ...}` steps (coordinate
  clicks, since Flutter web's CanvasKit renderer has no DOM for
  text-based selectors), optionally screenshotting the result.
- `record_demo.py` — a single self-contained script that drives the full
  login → browse → cart → checkout → account/orders/admin → logout flow
  in one continuous recorded session.
