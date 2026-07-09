import asyncio
from playwright.async_api import async_playwright

APP_URL = "http://localhost:8080"
VIDEO_DIR = "C:/Users/Vidhi/Flushion-EcommerceApp/demo"


async def main():
    playwright = await async_playwright().start()
    browser = await playwright.chromium.launch(
        headless=True, args=["--remote-debugging-port=9222"]
    )
    context = await browser.new_context(
        viewport={"width": 390, "height": 844},
        record_video_dir=VIDEO_DIR,
        record_video_size={"width": 390, "height": 844},
    )
    page = await context.new_page()
    await page.goto(APP_URL)
    print("READY", flush=True)
    # Keep the process (and browser/context) alive so other scripts can
    # connect over CDP and reuse the same recording context.
    await asyncio.sleep(3600)


asyncio.run(main())
