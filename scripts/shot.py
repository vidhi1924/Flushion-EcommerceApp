import sys
import asyncio
from playwright.async_api import async_playwright

OUT = sys.argv[1] if len(sys.argv) > 1 else "C:/Users/Vidhi/Flushion-EcommerceApp/mockups/shot.png"
WAIT_MS = int(sys.argv[2]) if len(sys.argv) > 2 else 500


async def main():
    playwright = await async_playwright().start()
    browser = await playwright.chromium.connect_over_cdp("http://localhost:9222")
    context = browser.contexts[0]
    page = context.pages[0]
    await page.wait_for_timeout(WAIT_MS)
    await page.screenshot(path=OUT)
    print(f"saved {OUT}")
    await browser.close()


asyncio.run(main())
