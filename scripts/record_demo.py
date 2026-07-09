import asyncio
from playwright.async_api import async_playwright

APP_URL = "http://localhost:8080"
VIDEO_DIR = "C:/Users/Vidhi/Flushion-EcommerceApp/demo"


async def main():
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context(
            viewport={"width": 390, "height": 844},
            record_video_dir=VIDEO_DIR,
            record_video_size={"width": 390, "height": 844},
        )
        page = await context.new_page()

        async def pause(ms):
            await page.wait_for_timeout(ms)

        await page.goto(APP_URL)
        await pause(4000)

        # --- Login ---
        await page.mouse.click(195, 291)
        await page.keyboard.type("demo.reviewer@flushion.test", delay=25)
        await page.mouse.click(195, 356)
        await page.keyboard.type("DemoPass123!", delay=25)
        await page.mouse.click(195, 410)
        await pause(2500)

        # --- Browse home, look at categories/products ---
        await pause(1500)

        # --- Open a product ---
        await page.mouse.click(290, 550)  # Red dress
        await pause(2000)

        # --- Add to favourites, then add to cart ---
        await page.mouse.click(370, 404)  # heart icon
        await pause(1200)
        await page.mouse.click(155, 404)  # Add to Cart
        await pause(1500)

        # --- Go back, open another product, add to cart too ---
        await page.mouse.click(28, 28)
        await pause(1000)
        await page.mouse.click(100, 550)  # Blazer for men
        await pause(1800)
        await page.mouse.click(155, 404)  # Add to Cart
        await pause(1500)

        # --- View cart via the small cart icon next to Add to Cart ---
        await page.mouse.click(330, 404)
        await pause(1800)

        # --- Bump quantity with + button on first item ---
        await page.mouse.click(198, 130)
        await pause(1000)

        # --- Checkout ---
        await page.mouse.click(100, 826)
        await pause(2500)

        # --- Shop more -> back home ---
        await page.mouse.click(195, 818)
        await pause(1500)

        # --- Open drawer, visit My Orders ---
        await page.mouse.click(28, 28)
        await pause(1000)
        await page.mouse.click(150, 289)
        await pause(1800)
        await page.mouse.click(195, 95)  # expand latest order
        await pause(1500)

        # --- Back, drawer, My Account ---
        await page.mouse.click(28, 28)
        await pause(1000)
        await page.mouse.click(28, 28)
        await pause(800)
        await page.mouse.click(150, 241)
        await pause(1800)

        # --- Back, drawer, Favourites ---
        await page.mouse.click(28, 28)
        await pause(1000)
        await page.mouse.click(28, 28)
        await pause(800)
        await page.mouse.click(150, 384)
        await pause(1800)

        # --- Back, drawer, Settings ---
        await page.mouse.click(28, 28)
        await pause(1000)
        await page.mouse.click(28, 28)
        await pause(800)
        await page.mouse.click(150, 496)
        await pause(1500)
        await page.mouse.click(336, 152)  # toggle dark mode switch
        await pause(1000)

        # --- Back, drawer, About ---
        await page.mouse.click(28, 28)
        await pause(1000)
        await page.mouse.click(28, 28)
        await pause(800)
        await page.mouse.click(150, 544)
        await pause(1800)

        # --- Back, drawer, Admin ---
        await page.mouse.click(28, 28)
        await pause(1000)
        await page.mouse.click(28, 28)
        await pause(800)
        await page.mouse.click(150, 592)
        await pause(1200)
        await page.mouse.click(195, 419)
        await page.keyboard.type("@dm1n1234", delay=30)
        await page.mouse.click(271, 482)
        await pause(2000)

        # --- Back, drawer, Log Out ---
        await page.mouse.click(28, 28)
        await pause(1000)
        await page.mouse.click(28, 28)
        await pause(800)
        await page.mouse.click(82, 448)
        await pause(2500)

        await context.close()
        await browser.close()
        print("DONE")


asyncio.run(main())
