const puppeteer = require('puppeteer-core');

async function run() {
  // const browser = await puppeteer.launch();
  const browser = await puppeteer.connect({ browserWSEndpoint: "ws://localhost:9222/devtools/page/F41E7FA49F69CA468C89C6E8363A5FC3" });
  const page = await browser.newPage();

  await page.goto('https://github.com');
  await page.screenshot({ path: 'screenshots/github.png' });

  // browser.close();
}

run();
