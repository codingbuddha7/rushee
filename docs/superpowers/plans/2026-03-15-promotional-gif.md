# Rushee Promotional GIF Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build two self-contained HTML animations and export them as animated GIFs — a short 7s loop for the GitHub README and a longer 16s demo for social launch posts.

**Architecture:** Two standalone HTML files in `demo/` with all CSS and JS inlined. No build step, no dependencies. JS drives a scene sequencer (async/await + setTimeout) that types commands, reveals output lines, and crossfades between scenes. GIFs are captured by opening each HTML file in Chrome, starting the gif recorder, taking screenshots at ~700ms intervals throughout the animation, then exporting.

**Tech Stack:** Vanilla HTML/CSS/JS (no frameworks), `mcp__Claude_Preview__preview_start` to serve, `mcp__Claude_in_Chrome__gif_creator` + `mcp__Claude_in_Chrome__computer` to capture GIFs.

**Spec:** `docs/superpowers/specs/2026-03-15-promotional-gif-design.md`

---

## Chunk 1: rushee-readme.html — short loop animation

### Task 1: Build `demo/rushee-readme.html`

**Files:**
- Create: `demo/rushee-readme.html`

- [ ] **Step 1: Confirm demo/ directory exists**

```bash
ls /Users/turing/Develop/rushee/demo/
```
Expected: lists `FDD-001.md`, `order-api.yaml`, `FDD-001-place-order.feature` etc.

- [ ] **Step 2: Write `demo/rushee-readme.html`**

Write the following complete file. It contains three scenes (session banner → Feature Card/OpenAPI → RED→GREEN) that loop forever. All CSS and JS are inlined. Typing speed is **25ms/char** (intentionally faster than the spec's 30ms default — the 7s loop budget requires shorter per-character delay to fit all three scenes).

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Rushee — README Demo</title>
<style>
* { margin:0; padding:0; box-sizing:border-box; }
body {
  width:900px; height:500px; overflow:hidden;
  background:#0d1117;
  font-family:'SF Mono','Cascadia Code','Consolas',monospace;
  font-size:12px; color:#e6edf3;
}
#stage { width:900px; height:500px; position:relative; }
.scene {
  position:absolute; top:0; left:0; width:900px; height:500px;
  display:flex; flex-direction:column; opacity:0;
}
.winbar {
  height:32px; background:#161b22; border-bottom:1px solid #30363d;
  display:flex; align-items:center; padding:0 14px; gap:6px; flex-shrink:0;
}
.dot { width:10px; height:10px; border-radius:50%; }
.dot-r { background:#f85149; }
.dot-y { background:#e3b341; }
.dot-g { background:#3fb950; }
.wintitle { margin-left:auto; color:#8b949e; font-size:10px; letter-spacing:1px; }
.panels { display:flex; flex:1; overflow:hidden; }
.panel { flex:1; padding:18px 20px; overflow:hidden; }
.panel-l { border-right:1px solid #30363d; }
.c-blue { color:#58a6ff; }
.c-green { color:#3fb950; }
.c-red { color:#f85149; }
.c-yellow { color:#e3b341; }
.c-purple { color:#a78bfa; }
.c-muted { color:#8b949e; }
.c-dim { color:#484f58; }
.c-kw { color:#79c0ff; }
.ln { line-height:1.9; white-space:pre; }
.hidden { opacity:0; }
.cur {
  display:inline-block; width:7px; height:13px;
  background:#e6edf3; vertical-align:text-bottom;
  animation:blink 1s step-end infinite;
}
@keyframes blink { 50% { opacity:0; } }
.pl-label { color:#a78bfa; font-size:10px; letter-spacing:2px; margin-bottom:14px; }
.counter { display:flex; flex-direction:column; align-items:center; justify-content:center; height:100%; gap:10px; }
.count-val { font-size:28px; font-weight:600; }
.count-arrow { color:#8b949e; font-size:20px; opacity:0; }
</style>
</head>
<body>
<div id="stage">

<!-- SCENE 1: Session Banner -->
<div class="scene" id="s1">
  <div class="winbar">
    <div class="dot dot-r"></div><div class="dot dot-y"></div><div class="dot dot-g"></div>
    <div class="wintitle">TERMINAL</div>
  </div>
  <div class="panels">
    <div class="panel panel-l">
      <div class="ln"><span class="c-blue" id="s1c"></span><span class="cur" id="s1k"></span></div>
      <div class="ln c-green hidden" id="s1a">✔ Rushee loaded</div>
      <div class="ln c-muted hidden" id="s1b">Scanning repo…</div>
      <div class="ln c-yellow hidden" id="s1d">▸ Next step: /rushee:feature</div>
    </div>
    <div class="panel">
      <div class="pl-label">RUSHEE PIPELINE</div>
      <div class="ln"><span class="c-green">✔</span>  UX Discovery</div>
      <div class="ln"><span class="c-green">✔</span>  Event Storm</div>
      <div class="ln"><span class="c-green">✔</span>  DDD Model</div>
      <div class="ln"><b>▶  Feature Card</b>  <span class="c-muted" style="font-size:10px">← you are here</span></div>
      <div class="ln c-dim">○  API Design</div>
      <div class="ln c-dim">○  BDD · ATDD · TDD</div>
      <div class="ln c-dim">○  Frontend · Security</div>
    </div>
  </div>
</div>

<!-- SCENE 2: Feature Card → OpenAPI -->
<div class="scene" id="s2">
  <div class="winbar">
    <div class="dot dot-r"></div><div class="dot dot-y"></div><div class="dot dot-g"></div>
    <div class="wintitle">TERMINAL</div>
  </div>
  <div class="panels">
    <div class="panel panel-l">
      <div class="ln"><span class="c-blue" id="s2c1"></span><span class="cur" id="s2k1"></span></div>
      <div class="ln c-green hidden" id="s2a">✔ FDD-001.md written</div>
      <div class="ln" style="margin-top:10px"><span class="c-blue" id="s2c2"></span><span class="cur hidden" id="s2k2"></span></div>
      <div class="ln c-green hidden" id="s2b">✔ order-api.yaml written</div>
    </div>
    <div class="panel" style="position:relative">
      <div id="s2fdd" style="transition:opacity 0.3s">
        <div class="ln c-yellow" style="margin-bottom:10px">FDD-001.md</div>
        <div class="ln"><span class="c-kw">ID:</span>                FDD-001</div>
        <div class="ln"><span class="c-kw">Actor:</span>             Amara (Shopper)</div>
        <div class="ln"><span class="c-kw">Feature Statement:</span> Place an order from the</div>
        <div class="ln">                   current cart so the shopper</div>
        <div class="ln">                   can complete their purchase.</div>
      </div>
      <div id="s2api" style="position:absolute;top:0;left:0;right:0;padding:18px 20px;opacity:0;transition:opacity 0.3s">
        <div class="ln c-yellow" style="margin-bottom:10px">order-api.yaml</div>
        <div class="ln c-muted"># order-api.yaml  (2 more endpoints omitted)</div>
        <div class="ln" style="margin-top:8px"><span class="c-kw">POST</span> /api/v1/orders</div>
        <div class="ln">  → <span class="c-green">201</span>  OrderConfirmed</div>
        <div class="ln">  → <span class="c-red">422</span>  Unprocessable</div>
      </div>
    </div>
  </div>
</div>

<!-- SCENE 3: RED → GREEN -->
<div class="scene" id="s3">
  <div class="winbar">
    <div class="dot dot-r"></div><div class="dot dot-y"></div><div class="dot dot-g"></div>
    <div class="wintitle">TERMINAL</div>
  </div>
  <div class="panels">
    <div class="panel panel-l">
      <div class="ln"><span class="c-blue" id="s3c1"></span><span class="cur" id="s3k1"></span></div>
      <div class="ln c-red hidden" id="s3a">● 3 scenarios FAILED</div>
      <div class="ln c-muted hidden" id="s3b">✔ Tests confirmed RED</div>
      <div class="ln" style="margin-top:10px"><span class="c-blue" id="s3c2"></span><span class="cur hidden" id="s3k2"></span></div>
      <div class="ln c-green hidden" id="s3d">✔ 3 scenarios PASSED</div>
    </div>
    <div class="panel">
      <div class="counter">
        <div class="count-val c-red" id="s3fail">● 3 failed</div>
        <div class="count-arrow" id="s3arr">↓</div>
        <div class="count-val c-green hidden" id="s3pass">✔ 3 passed</div>
      </div>
    </div>
  </div>
</div>

</div><!-- #stage -->
<script>
const $ = id => document.getElementById(id);
const wait = ms => new Promise(r => setTimeout(r, ms));

async function type(elId, text, spd) {
  const el = $(elId);
  el.textContent = '';
  for (const ch of text) { el.textContent += ch; await wait(spd); }
}

async function appear(elId, delay) {
  if (delay) await wait(delay);
  $(elId).classList.remove('hidden');
  $(elId).style.opacity = '1';
}

function reset1() {
  $('s1c').textContent = ''; $('s1k').style.display = 'inline-block';
  ['s1a','s1b','s1d'].forEach(id => { $(id).classList.add('hidden'); $(id).style.opacity='0'; });
}
function reset2() {
  $('s2c1').textContent = ''; $('s2c2').textContent = '';
  $('s2k1').style.display = 'inline-block'; $('s2k2').classList.add('hidden');
  ['s2a','s2b'].forEach(id => { $(id).classList.add('hidden'); $(id).style.opacity='0'; });
  $('s2fdd').style.opacity = '1'; $('s2api').style.opacity = '0';
}
function reset3() {
  $('s3c1').textContent = ''; $('s3c2').textContent = '';
  $('s3k1').style.display = 'inline-block'; $('s3k2').classList.add('hidden');
  ['s3a','s3b','s3d'].forEach(id => { $(id).classList.add('hidden'); $(id).style.opacity='0'; });
  $('s3arr').style.opacity = '0';
  $('s3pass').classList.add('hidden'); $('s3pass').style.opacity = '0';
}

async function fadeIn(id) {
  const el = $(id);
  el.style.transition = 'opacity 0.3s';
  el.style.opacity = '1';
  await wait(300);
}
async function fadeOut(id) {
  const el = $(id);
  el.style.transition = 'opacity 0.3s';
  el.style.opacity = '0';
  await wait(300);
}

async function runScene1(spd) {
  await type('s1c', '$ claude', spd);
  $('s1k').style.display = 'none';
  await appear('s1a', 100);
  await appear('s1b', 200);
  await appear('s1d', 200);
  await wait(750);
}

async function runScene2(spd) {
  await type('s2c1', '/rushee:feature "Place order"', spd);
  $('s2k1').style.display = 'none';
  await appear('s2a', 200);
  await wait(300);
  $('s2fdd').style.transition = 'opacity 0.3s'; $('s2fdd').style.opacity = '0';
  await wait(150); $('s2api').style.opacity = '1'; await wait(150);
  $('s2k2').classList.remove('hidden');
  await type('s2c2', '/rushee:api-design FDD-001', spd);
  $('s2k2').classList.add('hidden');
  await appear('s2b', 200);
  await wait(400);
}

async function runScene3(spd) {
  await type('s3c1', '/rushee:atdd-run FDD-001', spd);
  $('s3k1').style.display = 'none';
  await appear('s3a', 200);
  await appear('s3b', 200);
  await wait(300);
  $('s3k2').classList.remove('hidden');
  await type('s3c2', '/rushee:tdd-cycle FDD-001', spd);
  $('s3k2').classList.add('hidden');
  await appear('s3d', 200);
  await wait(200);
  $('s3arr').style.transition = 'opacity 0.3s'; $('s3arr').style.opacity = '1';
  await wait(400);
  $('s3pass').classList.remove('hidden');
  $('s3pass').style.transition = 'opacity 0.3s'; $('s3pass').style.opacity = '1';
  await wait(500);
}

async function main() {
  const SPD = 25;
  while (true) {
    reset1(); await fadeIn('s1'); await runScene1(SPD); await fadeOut('s1');
    reset2(); await fadeIn('s2'); await runScene2(SPD); await fadeOut('s2');
    reset3(); await fadeIn('s3'); await runScene3(SPD); await fadeOut('s3');
  }
}
main();
</script>
</body>
</html>
```

- [ ] **Step 3: Open in preview server and verify visually**

```bash
# Start a simple server in the demo/ directory
cd /Users/turing/Develop/rushee && python3 -m http.server 8900 --directory demo &
```

Open `http://localhost:8900/rushee-readme.html` in a browser. Expected:
- 900×500 dark terminal window with macOS traffic-light dots
- Scene 1: `$ claude` types in character by character, then three output lines appear, right panel shows pipeline checklist with "▶ Feature Card" highlighted white and remaining phases in dim grey
- Scene 2: `/rushee:feature "Place order"` types in → FDD-001.md appears → fades to order-api.yaml → second command types in
- Scene 3: atdd command → `● 3 scenarios FAILED` in red → tdd command → `✔ 3 scenarios PASSED` in green → counter flips
- After ~7s, loops back to Scene 1 smoothly

Kill the server after verification: `kill $(lsof -ti:8900)`

- [ ] **Step 4: Commit**

```bash
cd /Users/turing/Develop/rushee
git add demo/rushee-readme.html
git commit -m "feat: add rushee-readme.html short loop animation (7s)"
```

---

## Chunk 2: rushee-social.html — long social animation

### Task 2: Build `demo/rushee-social.html`

**Files:**
- Create: `demo/rushee-social.html`

- [ ] **Step 1: Write `demo/rushee-social.html`**

Five scenes: session banner → Feature Card/OpenAPI → BDD Gherkin → RED→GREEN → end card. Plays once (no loop). Typing speed is 40ms/char to fill the longer per-scene time budgets.

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Rushee — Social Demo</title>
<style>
* { margin:0; padding:0; box-sizing:border-box; }
body {
  width:900px; height:500px; overflow:hidden;
  background:#0d1117;
  font-family:'SF Mono','Cascadia Code','Consolas',monospace;
  font-size:12px; color:#e6edf3;
}
#stage { width:900px; height:500px; position:relative; }
.scene {
  position:absolute; top:0; left:0; width:900px; height:500px;
  display:flex; flex-direction:column; opacity:0;
}
.winbar {
  height:32px; background:#161b22; border-bottom:1px solid #30363d;
  display:flex; align-items:center; padding:0 14px; gap:6px; flex-shrink:0;
}
.dot { width:10px; height:10px; border-radius:50%; }
.dot-r { background:#f85149; }
.dot-y { background:#e3b341; }
.dot-g { background:#3fb950; }
.wintitle { margin-left:auto; color:#8b949e; font-size:10px; letter-spacing:1px; }
.panels { display:flex; flex:1; overflow:hidden; }
.panel { flex:1; padding:18px 20px; overflow:hidden; }
.panel-l { border-right:1px solid #30363d; }
.c-blue { color:#58a6ff; }
.c-green { color:#3fb950; }
.c-red { color:#f85149; }
.c-yellow { color:#e3b341; }
.c-purple { color:#a78bfa; }
.c-muted { color:#8b949e; }
.c-dim { color:#484f58; }
.c-kw { color:#79c0ff; }
.ln { line-height:1.9; white-space:pre; }
.hidden { opacity:0; }
.cur {
  display:inline-block; width:7px; height:13px;
  background:#e6edf3; vertical-align:text-bottom;
  animation:blink 1s step-end infinite;
}
@keyframes blink { 50% { opacity:0; } }
.pl-label { color:#a78bfa; font-size:10px; letter-spacing:2px; margin-bottom:14px; }
.counter { display:flex; flex-direction:column; align-items:center; justify-content:center; height:100%; gap:10px; }
.count-val { font-size:28px; font-weight:600; }
.count-arrow { color:#8b949e; font-size:20px; opacity:0; }
/* End card */
.endcard {
  width:900px; height:500px; display:flex;
  align-items:center; justify-content:center;
  background:#0d1117;
}
.endcard-inner { text-align:center; }
.endcard-title {
  color:#a78bfa; font-size:22px; letter-spacing:4px;
  font-family:'SF Mono','Cascadia Code','Consolas',monospace;
  margin-bottom:16px;
}
.endcard-rule {
  width:200px; height:1px; background:#30363d; margin:0 auto 16px;
}
.endcard-tagline {
  color:#e6edf3; font-size:14px; line-height:1.8;
  font-family:'SF Mono','Cascadia Code','Consolas',monospace;
}
</style>
</head>
<body>
<div id="stage">

<!-- SCENE 1: Session Banner -->
<div class="scene" id="s1">
  <div class="winbar">
    <div class="dot dot-r"></div><div class="dot dot-y"></div><div class="dot dot-g"></div>
    <div class="wintitle">TERMINAL</div>
  </div>
  <div class="panels">
    <div class="panel panel-l">
      <div class="ln"><span class="c-blue" id="s1c"></span><span class="cur" id="s1k"></span></div>
      <div class="ln c-green hidden" id="s1a">✔ Rushee loaded</div>
      <div class="ln c-muted hidden" id="s1b">Scanning repo…</div>
      <div class="ln c-yellow hidden" id="s1d">▸ Next step: /rushee:feature</div>
    </div>
    <div class="panel">
      <div class="pl-label">RUSHEE PIPELINE</div>
      <div class="ln"><span class="c-green">✔</span>  UX Discovery</div>
      <div class="ln"><span class="c-green">✔</span>  Event Storm</div>
      <div class="ln"><span class="c-green">✔</span>  DDD Model</div>
      <div class="ln"><b>▶  Feature Card</b>  <span class="c-muted" style="font-size:10px">← you are here</span></div>
      <div class="ln c-dim">○  API Design</div>
      <div class="ln c-dim">○  BDD · ATDD · TDD</div>
      <div class="ln c-dim">○  Frontend · Security</div>
    </div>
  </div>
</div>

<!-- SCENE 2: Feature Card → OpenAPI -->
<div class="scene" id="s2">
  <div class="winbar">
    <div class="dot dot-r"></div><div class="dot dot-y"></div><div class="dot dot-g"></div>
    <div class="wintitle">TERMINAL</div>
  </div>
  <div class="panels">
    <div class="panel panel-l">
      <div class="ln"><span class="c-blue" id="s2c1"></span><span class="cur" id="s2k1"></span></div>
      <div class="ln c-green hidden" id="s2a">✔ FDD-001.md written</div>
      <div class="ln" style="margin-top:10px"><span class="c-blue" id="s2c2"></span><span class="cur hidden" id="s2k2"></span></div>
      <div class="ln c-green hidden" id="s2b">✔ order-api.yaml written</div>
    </div>
    <div class="panel" style="position:relative">
      <div id="s2fdd" style="transition:opacity 0.3s">
        <div class="ln c-yellow" style="margin-bottom:10px">FDD-001.md</div>
        <div class="ln"><span class="c-kw">ID:</span>                FDD-001</div>
        <div class="ln"><span class="c-kw">Actor:</span>             Amara (Shopper)</div>
        <div class="ln"><span class="c-kw">Feature Statement:</span> Place an order from the</div>
        <div class="ln">                   current cart so the shopper</div>
        <div class="ln">                   can complete their purchase.</div>
      </div>
      <div id="s2api" style="position:absolute;top:0;left:0;right:0;padding:18px 20px;opacity:0;transition:opacity 0.3s">
        <div class="ln c-yellow" style="margin-bottom:10px">order-api.yaml</div>
        <div class="ln c-muted"># order-api.yaml  (2 more endpoints omitted)</div>
        <div class="ln" style="margin-top:8px"><span class="c-kw">POST</span> /api/v1/orders</div>
        <div class="ln">  → <span class="c-green">201</span>  OrderConfirmed</div>
        <div class="ln">  → <span class="c-red">422</span>  Unprocessable</div>
      </div>
    </div>
  </div>
</div>

<!-- SCENE 3: BDD Gherkin -->
<div class="scene" id="s3">
  <div class="winbar">
    <div class="dot dot-r"></div><div class="dot dot-y"></div><div class="dot dot-g"></div>
    <div class="wintitle">TERMINAL</div>
  </div>
  <div class="panels">
    <div class="panel panel-l">
      <div class="ln"><span class="c-blue" id="s3c"></span><span class="cur" id="s3k"></span></div>
      <div class="ln c-muted hidden" id="s3a">No HTTP. No URLs. No SQL.</div>
      <div class="ln c-green hidden" id="s3b">✔ FDD-001-place-order.feature written</div>
    </div>
    <div class="panel" style="font-size:11px">
      <div class="ln c-yellow" style="margin-bottom:8px">FDD-001-place-order.feature</div>
      <div class="ln"><span class="c-purple">Background:</span></div>
      <div class="ln c-muted">  Given the product catalogue contains:</div>
      <div class="ln c-yellow">    | name         | price |</div>
      <div class="ln c-muted">    | Laptop Stand | 49.99 |</div>
      <div class="ln c-muted">    | USB-C Hub    | 29.99 |</div>
      <div class="ln" style="margin-top:6px"><span class="c-purple">Scenario:</span><span class="c-muted"> Shopper places a successful order</span></div>
      <div class="ln c-muted">  Given Amara has added 1 <span class="c-green">"Laptop Stand"</span> to her cart</div>
      <div class="ln c-muted">  And Amara has added 2 <span class="c-green">"USB-C Hub"</span> units to her cart</div>
      <div class="ln c-muted">  When Amara places her order</div>
      <div class="ln c-muted">  Then an order is created with status <span class="c-green">"PENDING"</span></div>
      <div class="ln c-muted">  And the order total is <span class="c-green">109.97</span></div>
      <div class="ln c-muted" style="font-size:10px">  # … (1 more step omitted for display)</div>
    </div>
  </div>
</div>

<!-- SCENE 4: RED → GREEN -->
<div class="scene" id="s4">
  <div class="winbar">
    <div class="dot dot-r"></div><div class="dot dot-y"></div><div class="dot dot-g"></div>
    <div class="wintitle">TERMINAL</div>
  </div>
  <div class="panels">
    <div class="panel panel-l">
      <div class="ln"><span class="c-blue" id="s4c1"></span><span class="cur" id="s4k1"></span></div>
      <div class="ln c-red hidden" id="s4a">● 3 scenarios FAILED</div>
      <div class="ln c-muted hidden" id="s4b">✔ Tests confirmed RED</div>
      <div class="ln" style="margin-top:10px"><span class="c-blue" id="s4c2"></span><span class="cur hidden" id="s4k2"></span></div>
      <div class="ln c-green hidden" id="s4d">✔ 3 scenarios PASSED</div>
    </div>
    <div class="panel">
      <div class="counter">
        <div class="count-val c-red" id="s4fail">● 3 failed</div>
        <div class="count-arrow" id="s4arr">↓</div>
        <div class="count-val c-green hidden" id="s4pass">✔ 3 passed</div>
      </div>
    </div>
  </div>
</div>

<!-- SCENE 5: End Card -->
<div class="scene" id="s5">
  <div class="endcard">
    <div class="endcard-inner">
      <div class="endcard-title">RUSHEE</div>
      <div class="endcard-rule"></div>
      <div class="endcard-tagline">
        Every phase guided.<br>
        Shortcuts caught.<br>
        Any stack supported.
      </div>
    </div>
  </div>
</div>

</div><!-- #stage -->
<script>
const $ = id => document.getElementById(id);
const wait = ms => new Promise(r => setTimeout(r, ms));

async function type(elId, text, spd) {
  const el = $(elId);
  el.textContent = '';
  for (const ch of text) { el.textContent += ch; await wait(spd); }
}
async function appear(elId, delay) {
  if (delay) await wait(delay);
  $(elId).classList.remove('hidden');
  $(elId).style.opacity = '1';
}
async function fadeIn(id) {
  const el = $(id);
  el.style.transition = 'opacity 0.3s'; el.style.opacity = '1'; await wait(300);
}
async function fadeOut(id) {
  const el = $(id);
  el.style.transition = 'opacity 0.3s'; el.style.opacity = '0'; await wait(300);
}

async function runScene1(spd) {
  await type('s1c', '$ claude', spd);
  $('s1k').style.display = 'none';
  await appear('s1a', 100); await appear('s1b', 200); await appear('s1d', 200);
  await wait(1700);
}
async function runScene2(spd) {
  await type('s2c1', '/rushee:feature "Place order"', spd);
  $('s2k1').style.display = 'none';
  await appear('s2a', 200); await wait(400);
  $('s2fdd').style.transition='opacity 0.3s'; $('s2fdd').style.opacity='0';
  await wait(150); $('s2api').style.opacity='1'; await wait(150);
  $('s2k2').classList.remove('hidden');
  await type('s2c2', '/rushee:api-design FDD-001', spd);
  $('s2k2').classList.add('hidden');
  await appear('s2b', 200); await wait(600);
}
async function runScene3(spd) {
  await type('s3c', '/rushee:bdd-spec FDD-001', spd);
  $('s3k').style.display = 'none';
  await appear('s3a', 200); await appear('s3b', 300); await wait(2400);
}
async function runScene4(spd) {
  await type('s4c1', '/rushee:atdd-run FDD-001', spd);
  $('s4k1').style.display = 'none';
  await appear('s4a', 200); await appear('s4b', 200); await wait(400);
  $('s4k2').classList.remove('hidden');
  await type('s4c2', '/rushee:tdd-cycle FDD-001', spd);
  $('s4k2').classList.add('hidden');
  await appear('s4d', 200); await wait(200);
  $('s4arr').style.transition='opacity 0.3s'; $('s4arr').style.opacity='1'; await wait(400);
  $('s4pass').classList.remove('hidden');
  $('s4pass').style.transition='opacity 0.3s'; $('s4pass').style.opacity='1';
  await wait(1200);
}

async function main() {
  const SPD = 40;
  // Scene 1
  await fadeIn('s1'); await runScene1(SPD); await fadeOut('s1');
  // Scene 2
  $('s2c1').textContent=''; $('s2c2').textContent='';
  $('s2k1').style.display='inline-block'; $('s2k2').classList.add('hidden');
  ['s2a','s2b'].forEach(id=>{$(id).classList.add('hidden');$(id).style.opacity='0';});
  $('s2fdd').style.opacity='1'; $('s2api').style.opacity='0';
  await fadeIn('s2'); await runScene2(SPD); await fadeOut('s2');
  // Scene 3
  $('s3c').textContent=''; $('s3k').style.display='inline-block';
  ['s3a','s3b'].forEach(id=>{$(id).classList.add('hidden');$(id).style.opacity='0';});
  await fadeIn('s3'); await runScene3(SPD); await fadeOut('s3');
  // Scene 4
  $('s4c1').textContent=''; $('s4c2').textContent='';
  $('s4k1').style.display='inline-block'; $('s4k2').classList.add('hidden');
  ['s4a','s4b','s4d'].forEach(id=>{$(id).classList.add('hidden');$(id).style.opacity='0';});
  $('s4arr').style.opacity='0';
  $('s4pass').classList.add('hidden'); $('s4pass').style.opacity='0';
  await fadeIn('s4'); await runScene4(SPD); await fadeOut('s4');
  // Scene 5: end card — holds for 2s then freezes
  await fadeIn('s5');
  await wait(2000);
  // GIF ends here (animation is done)
}
main();
</script>
</body>
</html>
```

- [ ] **Step 2: Open in preview server and verify visually**

```bash
cd /Users/turing/Develop/rushee && python3 -m http.server 8900 --directory demo &
```

Open `http://localhost:8900/rushee-social.html`. Expected:
- Scene 1 (3s): session banner with pipeline checklist
- Scene 2 (4s): feature command → FDD panel → fades to API panel → api-design command
- Scene 3 (4s): bdd-spec command → "No HTTP. No URLs. No SQL." → Gherkin file shown statically on right
- Scene 4 (5s): atdd RED → tdd GREEN, counter flips
- Scene 5 (2s): full-width end card with `RUSHEE` in purple + tagline, then animation stops

Kill the server: `kill $(lsof -ti:8900)`

- [ ] **Step 3: Commit**

```bash
cd /Users/turing/Develop/rushee
git add demo/rushee-social.html
git commit -m "feat: add rushee-social.html long-form animation (16s)"
```

---

## Chunk 3: Export GIFs + Update README

### Task 3: Export `demo/rushee-readme.gif`

**Files:**
- Generate: `demo/rushee-readme.gif`

- [ ] **Step 1: Start the preview server**

Use `mcp__Claude_Preview__preview_start`. First check whether `.claude/launch.json` already exists:

```bash
cat /Users/turing/Develop/rushee/.claude/launch.json 2>/dev/null || echo "NOT FOUND"
```

If NOT FOUND, create it. If it already exists, add the `rushee-demo` configuration to its `configurations` array without overwriting other entries. The configuration to add:

```json
{
  "version": "0.0.1",
  "configurations": [
    {
      "name": "rushee-demo",
      "runtimeExecutable": "python3",
      "runtimeArgs": ["-m", "http.server", "8900", "--directory", "demo"],
      "port": 8900
    }
  ]
}
```

Then call `preview_start` with name `"rushee-demo"`.

- [ ] **Step 2: Get Chrome tab context**

Call `mcp__Claude_in_Chrome__tabs_context_mcp` with `createIfEmpty: true`. Save the tab ID.

- [ ] **Step 3: Resize the Chrome window to exactly 900×500**

Call `mcp__Claude_in_Chrome__resize_window` with `width: 900, height: 500` and the tab ID.

- [ ] **Step 4: Navigate to the README animation**

Call `mcp__Claude_in_Chrome__navigate` with `url: "http://localhost:8900/rushee-readme.html"`.

- [ ] **Step 5: Start GIF recording + capture initial frame**

Call `mcp__Claude_in_Chrome__gif_creator` with `action: "start_recording"` and the tab ID.
Immediately after, call `mcp__Claude_in_Chrome__computer` with `action: "screenshot"` to capture the initial state as the first frame.

- [ ] **Step 6: Capture frames throughout the 7s animation**

Take a screenshot every 700ms for ~8 seconds. Between each screenshot, wait using `mcp__Claude_in_Chrome__computer` with `action: "wait", duration: 0.7`.

Pattern (repeat 11 times):
1. `computer wait 0.7`
2. `computer screenshot`

This produces 11 additional frames. Combined with the initial frame (Step 5) and the final frame (Step 7), the total is **13 frames** spanning ~8.4s — enough to capture the full 7s loop with a little margin.

- [ ] **Step 7: Take final screenshot and stop recording**

Call `computer screenshot` once more (final frame).
Call `gif_creator` with `action: "stop_recording"`.

- [ ] **Step 8: Export the GIF**

Call `gif_creator` with `action: "export"`, `download: true`, `filename: "rushee-readme.gif"`, and options:
```json
{
  "showClickIndicators": false,
  "showDragPaths": false,
  "showActionLabels": false,
  "showProgressBar": false,
  "showWatermark": false,
  "quality": 5
}
```

- [ ] **Step 9: Move the downloaded GIF to `demo/`**

The GIF downloads to the browser's default download folder (typically `~/Downloads/rushee-readme.gif`). Move it:

```bash
mv ~/Downloads/rushee-readme.gif /Users/turing/Develop/rushee/demo/rushee-readme.gif
```

Expected: file exists at `demo/rushee-readme.gif`, size > 0.

- [ ] **Step 10: Commit**

```bash
cd /Users/turing/Develop/rushee
git add demo/rushee-readme.gif
git commit -m "feat: add rushee-readme.gif short loop GIF (7s)"
```

---

### Task 4: Export `demo/rushee-social.gif`

**Files:**
- Generate: `demo/rushee-social.gif`

- [ ] **Step 1: Navigate to the social animation**

(Preview server from Task 3 is still running.)
Call `mcp__Claude_in_Chrome__navigate` with `url: "http://localhost:8900/rushee-social.html"`.

- [ ] **Step 2: Start recording + initial frame**

Call `gif_creator` with `action: "start_recording"`.
Immediately call `computer screenshot` for the initial frame.

- [ ] **Step 3: Capture frames throughout the 16s animation**

Take a screenshot every 700ms for ~17 seconds (24 screenshots). Pattern (repeat 24 times):
1. `computer wait 0.7`
2. `computer screenshot`

- [ ] **Step 4: Final screenshot and stop recording**

Call `computer screenshot` once more.
Call `gif_creator` with `action: "stop_recording"`.

- [ ] **Step 5: Export the GIF**

Call `gif_creator` with `action: "export"`, `download: true`, `filename: "rushee-social.gif"`, and options:
```json
{
  "showClickIndicators": false,
  "showDragPaths": false,
  "showActionLabels": false,
  "showProgressBar": false,
  "showWatermark": false,
  "quality": 5
}
```

- [ ] **Step 6: Move to `demo/`**

```bash
mv ~/Downloads/rushee-social.gif /Users/turing/Develop/rushee/demo/rushee-social.gif
```

Expected: file exists at `demo/rushee-social.gif`, size > 0.

- [ ] **Step 7: Commit**

```bash
cd /Users/turing/Develop/rushee
git add demo/rushee-social.gif
git commit -m "feat: add rushee-social.gif long-form demo GIF (16s)"
```

---

### Task 5: Add GIF to README

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Read the current README**

Read `/Users/turing/Develop/rushee/README.md` and locate the tagline line (line 2):
```
> Every phase guided. Shortcuts caught. Any stack supported.
```

- [ ] **Step 2: Insert the GIF tag immediately below the tagline**

The README already has a blank line between the tagline (line 2) and the `**Rushee** is a Claude Code plugin…` paragraph. Insert the img tag after that existing blank line (current line 3), so the img tag becomes the new line 4:

Use the Edit tool with:
- `old_string`: the blank line + the opening of the `**Rushee**` paragraph
- `new_string`: a blank line + the img tag + another blank line + the `**Rushee**` paragraph

Result should look like:
```markdown
> Every phase guided. Shortcuts caught. Any stack supported.

![Rushee in action](demo/rushee-readme.gif)

**Rushee** is a Claude Code plugin that enforces…
```

- [ ] **Step 3: Commit**

```bash
cd /Users/turing/Develop/rushee
git add README.md
git commit -m "docs: add promotional GIF to README header"
```

---

### Task 6: Stop preview server

- [ ] **Step 1: Stop the server**

Call `mcp__Claude_Preview__preview_stop` with the server ID from Task 3 Step 1.

- [ ] **Step 2: Final verification**

```bash
ls -lh /Users/turing/Develop/rushee/demo/rushee-readme.gif /Users/turing/Develop/rushee/demo/rushee-social.gif
```

Expected: both files exist. Typical sizes: readme GIF > 50KB, social GIF > 100KB.
