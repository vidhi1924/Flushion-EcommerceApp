import sys
import json
import asyncio
from playwright.async_api import async_playwright

# Usage: python act.py <actions_json_file> <screenshot_out>
# actions_json_file contains a JSON list of actions:
#   {"type": "click", "x": 100, "y": 200}
#   {"type": "type", "text": "hello"}
#   {"type": "wait", "ms": 500}
#   {"type": "key", "key": "Tab"}

ACTIONS_FILE = sys.argv[1]
OUT = sys.argv[2] if len(sys.argv) > 2 else None


async def main():
    with open(ACTIONS_FILE) as f:
        actions = json.load(f)

    playwright = await async_playwright().start()
    browser = await playwright.chromium.connect_over_cdp("http://localhost:9222")
    context = browser.contexts[0]
    page = context.pages[0]

    for a in actions:
        t = a["type"]
        if t == "click":
            await page.mouse.click(a["x"], a["y"])
        elif t == "type":
            await page.keyboard.type(a["text"], delay=30)
        elif t == "wait":
            await page.wait_for_timeout(a["ms"])
        elif t == "key":
            await page.keyboard.press(a["key"])
        else:
            raise ValueError(f"unknown action {t}")

    if OUT:
        await page.wait_for_timeout(400)
        await page.screenshot(path=OUT)
        print(f"saved {OUT}")

    await browser.close()


asyncio.run(main())
