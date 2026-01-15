///|
/// Showcase demo for Engenis.
priv struct CardSeed {
  id : Int
  title : String
  summary : String
  stage : Int
  tone : Int
}

///|
priv struct Card {
  id : Int
  title : String
  summary : String
  mut stage : Int
  mut tone : Int
}

///|
priv struct Board {
  mut pulses : Int
  mut cards : Array[Card]
  mut story_open : Bool
}

///|
let stage_labels : Array[String] = ["Sketch", "Forge", "Launch"]

///|
let tone_labels : Array[String] = ["Calm", "Charged", "Wild"]

///|
let card_seeds : Array[CardSeed] = [
  {
    id: 1,
    title: "Orbit Map",
    summary: "Typed HTML as a living surface.",
    stage: 0,
    tone: 0,
  },
  {
    id: 2,
    title: "Relay Loom",
    summary: "Link relations describe intent, not JS.",
    stage: 1,
    tone: 1,
  },
  {
    id: 3,
    title: "Signal Atlas",
    summary: "Server sends fragments, client swaps.",
    stage: 2,
    tone: 2,
  },
  {
    id: 4,
    title: "Delta Patch",
    summary: "HDA responses steer swap and target.",
    stage: 1,
    tone: 0,
  },
]

///|
fn build_cards() -> Array[Card] {
  card_seeds.map(seed => {
    id: seed.id,
    title: seed.title,
    summary: seed.summary,
    stage: seed.stage,
    tone: seed.tone,
  })
}

///|
let board : Board = { pulses: 0, cards: build_cards(), story_open: false }

///|
fn stage_index(stage : Int) -> Int {
  stage % stage_labels.length()
}

///|
fn tone_index(tone : Int) -> Int {
  tone % tone_labels.length()
}

///|
fn stage_label(stage : Int) -> String {
  stage_labels[stage_index(stage)]
}

///|
fn tone_label(tone : Int) -> String {
  tone_labels[tone_index(tone)]
}

///|
fn story_toggle_label() -> String {
  if board.story_open {
    "Close field notes"
  } else {
    "Open field notes"
  }
}

///|
fn story_toggle_note() -> String {
  if board.story_open {
    "loaded via LinkRel"
  } else {
    "click to load"
  }
}

///|
fn toggle_story() -> Unit {
  board.story_open = !board.story_open
}

///|
fn stage_class(stage : Int) -> String {
  "stage-" + stage_index(stage).to_string()
}

///|
fn find_card_index(id : Int) -> Int? {
  for i = 0; i < board.cards.length(); i = i + 1 {
    if board.cards[i].id == id {
      return Some(i)
    }
  }
  None
}

///|
fn advance_card(id : Int) -> (Card, Int)? {
  match find_card_index(id) {
    Some(idx) => {
      let card = board.cards[idx]
      card.stage = (card.stage + 1) % stage_labels.length()
      card.tone = (card.tone + 1) % tone_labels.length()
      Some((card, idx))
    }
    None => None
  }
}

///|
fn reset_board() -> Unit {
  board.cards = build_cards()
  board.pulses = 0
}

///|
fn bump_pulse() -> Int {
  board.pulses = board.pulses + 1
  board.pulses
}

///|
fn parse_card_id(path : String) -> Int? {
  let parts = path.split("/").to_array().map(part => part.to_string())
  if parts.length() == 4 && parts[1] == "cards" && parts[3] == "advance" {
    let parsed = try? @strconv.parse_int(parts[2][:], base=10)
    match parsed {
      Ok(id) => Some(id)
      Err(_) => None
    }
  } else {
    None
  }
}

///|
fn render_css() -> String {
  let css =
    #|@import url("https://fonts.googleapis.com/css2?family=Fraunces:wght@600;700&family=Space+Grotesk:wght@400;500;600&display=swap");
    #|
    #|:root {
    #|  --paper: #fbf4e9;
    #|  --panel: #fffaf0;
    #|  --ink: #2a1d0a;
    #|  --ink-soft: rgba(42, 29, 10, 0.7);
    #|  --accent: #e76f51;
    #|  --accent-2: #2a9d8f;
    #|  --accent-3: #264653;
    #|  --sun: #f4a261;
    #|  --stroke: rgba(42, 29, 10, 0.12);
    #|  --shadow: rgba(42, 29, 10, 0.14);
    #|}
    #|
    #|* {
    #|  box-sizing: border-box;
    #|}
    #|
    #|body {
    #|  margin: 0;
    #|  min-height: 100vh;
    #|  color: var(--ink);
    #|  font-family: "Space Grotesk", "Segoe UI", sans-serif;
    #|  background:
    #|    radial-gradient(circle at 15% 10%, rgba(244, 162, 97, 0.25), transparent 45%),
    #|    radial-gradient(circle at 85% 15%, rgba(42, 157, 143, 0.18), transparent 40%),
    #|    linear-gradient(130deg, #fff6ea, #f8f0e1 35%, #eef7f3 75%);
    #|}
    #|
    #|body::before {
    #|  content: "";
    #|  position: fixed;
    #|  inset: 0;
    #|  background-image:
    #|    radial-gradient(circle at 20% 30%, rgba(231, 111, 81, 0.08), transparent 40%),
    #|    repeating-linear-gradient(45deg, rgba(42, 29, 10, 0.06), rgba(42, 29, 10, 0.06) 1px, transparent 1px, transparent 8px);
    #|  opacity: 0.35;
    #|  pointer-events: none;
    #|}
    #|
    #|a {
    #|  color: inherit;
    #|  text-decoration: none;
    #|}
    #|
    #|.shell {
    #|  max-width: 1200px;
    #|  margin: 0 auto;
    #|  padding: 48px 24px 72px;
    #|  position: relative;
    #|}
    #|
    #|.hero {
    #|  background: var(--panel);
    #|  border: 1px solid var(--stroke);
    #|  border-radius: 32px;
    #|  padding: 28px 32px;
    #|  display: grid;
    #|  gap: 24px;
    #|  box-shadow: 0 20px 60px var(--shadow);
    #|  animation: floatIn 0.6s ease both;
    #|}
    #|
    #|.hero-top {
    #|  display: flex;
    #|  align-items: center;
    #|  justify-content: space-between;
    #|  gap: 16px;
    #|  flex-wrap: wrap;
    #|}
    #|
    #|.brand {
    #|  display: flex;
    #|  gap: 12px;
    #|  align-items: center;
    #|}
    #|
    #|.badge {
    #|  text-transform: uppercase;
    #|  font-size: 12px;
    #|  letter-spacing: 0.2em;
    #|  background: var(--ink);
    #|  color: var(--paper);
    #|  padding: 6px 10px;
    #|  border-radius: 999px;
    #|}
    #|
    #|.badge.alt {
    #|  background: var(--accent);
    #|  color: #fff;
    #|}
    #|
    #|.hero-body h1 {
    #|  font-family: "Fraunces", serif;
    #|  font-size: 48px;
    #|  margin: 0;
    #|}
    #|
    #|.lead {
    #|  font-size: 18px;
    #|  color: var(--ink-soft);
    #|  max-width: 620px;
    #|  margin: 8px 0 0;
    #|}
    #|
    #|.hero-actions {
    #|  display: flex;
    #|  gap: 12px;
    #|  flex-wrap: wrap;
    #|}
    #|
    #|.hero-meta {
    #|  display: flex;
    #|  gap: 12px;
    #|  flex-wrap: wrap;
    #|  margin-top: 16px;
    #|}
    #|
    #|.chip {
    #|  border: 1px solid var(--stroke);
    #|  border-radius: 999px;
    #|  padding: 6px 12px;
    #|  font-size: 13px;
    #|  background: #fff;
    #|}
    #|
    #|.grid {
    #|  display: grid;
    #|  grid-template-columns: 1.6fr 1fr;
    #|  gap: 24px;
    #|  margin-top: 32px;
    #|}
    #|
    #|.side {
    #|  display: grid;
    #|  gap: 24px;
    #|}
    #|
    #|.panel {
    #|  background: var(--panel);
    #|  border: 1px solid var(--stroke);
    #|  border-radius: 24px;
    #|  padding: 20px 22px;
    #|  box-shadow: 0 18px 40px var(--shadow);
    #|}
    #|
    #|.panel.board {
    #|  padding: 26px;
    #|}
    #|
    #|.panel-head {
    #|  display: flex;
    #|  justify-content: space-between;
    #|  align-items: flex-start;
    #|  gap: 16px;
    #|  margin-bottom: 18px;
    #|  flex-wrap: wrap;
    #|}
    #|
    #|.panel-title h2,
    #|.panel-head h2 {
    #|  margin: 0 0 6px 0;
    #|  font-size: 22px;
    #|}
    #|
    #|.panel-title p {
    #|  margin: 0;
    #|}
    #|
    #|.panel-actions {
    #|  display: flex;
    #|  flex-direction: column;
    #|  align-items: flex-end;
    #|  gap: 12px;
    #|}
    #|
    #|.legend {
    #|  display: flex;
    #|  gap: 8px;
    #|  flex-wrap: wrap;
    #|}
    #|
    #|.mode-toggles {
    #|  display: flex;
    #|  gap: 8px;
    #|  flex-wrap: wrap;
    #|}
    #|
    #|.mode-btn {
    #|  padding: 6px 12px;
    #|  border-radius: 999px;
    #|  border: 1px solid var(--stroke);
    #|  background: #fff;
    #|  font-size: 12px;
    #|  letter-spacing: 0.08em;
    #|  text-transform: uppercase;
    #|  cursor: pointer;
    #|}
    #|
    #|.mode-btn.active {
    #|  background: var(--accent-3);
    #|  color: #fff;
    #|  border-color: var(--accent-3);
    #|}
    #|
    #|.muted {
    #|  color: var(--ink-soft);
    #|}
    #|
    #|.card-grid {
    #|  display: grid;
    #|  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    #|  gap: 18px;
    #|}
    #|
    #|.card {
    #|  background: #fffdf7;
    #|  border: 1px solid var(--stroke);
    #|  border-radius: 20px;
    #|  padding: 18px;
    #|  display: grid;
    #|  gap: 12px;
    #|  position: relative;
    #|  overflow: hidden;
    #|}
    #|
    #|.card::after {
    #|  content: "";
    #|  position: absolute;
    #|  inset: 0;
    #|  background: linear-gradient(120deg, rgba(244, 162, 97, 0.18), transparent 45%);
    #|  opacity: 0.6;
    #|  pointer-events: none;
    #|}
    #|
    #|.card-top {
    #|  display: flex;
    #|  justify-content: space-between;
    #|  align-items: center;
    #|  gap: 8px;
    #|}
    #|
    #|.card h3 {
    #|  margin: 0;
    #|  font-size: 20px;
    #|  font-family: "Fraunces", serif;
    #|}
    #|
    #|.card-text {
    #|  margin: 0;
    #|  color: var(--ink-soft);
    #|  font-size: 14px;
    #|  line-height: 1.4;
    #|}
    #|
    #|.card-bottom {
    #|  display: flex;
    #|  justify-content: space-between;
    #|  align-items: center;
    #|  gap: 12px;
    #|  flex-wrap: wrap;
    #|}
    #|
    #|.stage {
    #|  font-size: 12px;
    #|  padding: 4px 10px;
    #|  border-radius: 999px;
    #|  letter-spacing: 0.08em;
    #|  text-transform: uppercase;
    #|}
    #|
    #|.stage-0 {
    #|  background: rgba(38, 70, 83, 0.12);
    #|  color: #264653;
    #|}
    #|
    #|.stage-1 {
    #|  background: rgba(42, 157, 143, 0.16);
    #|  color: #2a9d8f;
    #|}
    #|
    #|.stage-2 {
    #|  background: rgba(231, 111, 81, 0.18);
    #|  color: #e76f51;
    #|}
    #|
    #|.tone {
    #|  font-size: 13px;
    #|  color: var(--ink-soft);
    #|}
    #|
    #|.banner {
    #|  background: var(--accent-2);
    #|  color: #fff;
    #|  padding: 6px 10px;
    #|  border-radius: 12px;
    #|  font-size: 12px;
    #|  text-transform: uppercase;
    #|  letter-spacing: 0.1em;
    #|  justify-self: start;
    #|}
    #|
    #|.metrics-grid {
    #|  display: grid;
    #|  grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
    #|  gap: 12px;
    #|}
    #|
    #|.metric {
    #|  background: #fffefb;
    #|  border: 1px solid var(--stroke);
    #|  border-radius: 16px;
    #|  padding: 12px;
    #|  display: grid;
    #|  gap: 6px;
    #|}
    #|
    #|.metric-label {
    #|  font-size: 12px;
    #|  letter-spacing: 0.12em;
    #|  text-transform: uppercase;
    #|  color: var(--ink-soft);
    #|}
    #|
    #|.metric-value {
    #|  font-size: 26px;
    #|  font-family: "Fraunces", serif;
    #|}
    #|
    #|.metric-note {
    #|  font-size: 12px;
    #|  color: var(--ink-soft);
    #|}
    #|
    #|.story-body {
    #|  display: grid;
    #|  gap: 12px;
    #|  font-size: 14px;
    #|  line-height: 1.5;
    #|}
    #|
    #|.snippet {
    #|  background: #0f1c21;
    #|  color: #f4f1ea;
    #|  padding: 12px;
    #|  border-radius: 14px;
    #|  overflow-x: auto;
    #|  font-size: 12px;
    #|}
    #|
    #|.pulse-panel {
    #|  display: grid;
    #|  gap: 12px;
    #|}
    #|
    #|.pulse-readout {
    #|  display: grid;
    #|  gap: 6px;
    #|  padding: 12px 14px;
    #|  border-radius: 16px;
    #|  background: #fffdf7;
    #|  border: 1px solid var(--stroke);
    #|}
    #|
    #|.pulse-count {
    #|  font-size: 32px;
    #|  font-family: "Fraunces", serif;
    #|  color: var(--accent-3);
    #|}
    #|
    #|.pulse-label {
    #|  text-transform: uppercase;
    #|  letter-spacing: 0.2em;
    #|  font-size: 11px;
    #|  color: var(--ink-soft);
    #|}
    #|
    #|.pulse-note {
    #|  font-size: 13px;
    #|  color: var(--ink-soft);
    #|}
    #|
    #|.btn {
    #|  display: inline-flex;
    #|  align-items: center;
    #|  gap: 8px;
    #|  padding: 10px 16px;
    #|  border-radius: 999px;
    #|  border: 1px solid var(--ink);
    #|  background: var(--ink);
    #|  color: #fff;
    #|  font-size: 14px;
    #|  font-family: inherit;
    #|  cursor: pointer;
    #|  transition: transform 0.2s ease, box-shadow 0.2s ease;
    #|}
    #|
    #|.btn:hover {
    #|  transform: translateY(-1px);
    #|  box-shadow: 0 8px 16px rgba(42, 29, 10, 0.2);
    #|}
    #|
    #|.btn.ghost {
    #|  background: transparent;
    #|  color: var(--ink);
    #|  border-color: var(--stroke);
    #|}
    #|
    #|.btn.accent {
    #|  background: var(--accent);
    #|  border-color: var(--accent);
    #|}
    #|
    #|.footer {
    #|  margin-top: 32px;
    #|  text-align: center;
    #|  font-size: 13px;
    #|}
    #|
    #|.stagger {
    #|  animation: floatIn 0.6s ease both;
    #|  animation-delay: var(--delay, 0s);
    #|}
    #|
    #|@keyframes floatIn {
    #|  from {
    #|    opacity: 0;
    #|    transform: translateY(16px);
    #|  }
    #|  to {
    #|    opacity: 1;
    #|    transform: translateY(0);
    #|  }
    #|}
    #|
    #|@media (max-width: 900px) {
    #|  .grid {
    #|    grid-template-columns: 1fr;
    #|  }
    #|  .hero-body h1 {
    #|    font-size: 38px;
    #|  }
    #|  .panel-actions {
    #|    align-items: flex-start;
    #|  }
    #|}
    #|
  css
}

///|
fn metric_tile(label : String, value : String, note : String) -> @html.Html {
  @html.div()
  .class("metric")
  .children([
    @html.span().class("metric-label").text(label),
    @html.span().class("metric-value").text(value),
    @html.small().class("metric-note").text(note),
  ])
}

///|
fn render_metrics() -> @html.Html {
  let counts = Array::make(stage_labels.length(), 0)
  for i = 0; i < board.cards.length(); i = i + 1 {
    let idx = stage_index(board.cards[i].stage)
    counts[idx] = counts[idx] + 1
  }
  @html.div()
  .class("metrics-grid")
  .children([
    metric_tile(
      "Total cards",
      board.cards.length().to_string(),
      "Active signals",
    ),
    metric_tile(stage_labels[0], counts[0].to_string(), "Stage 1"),
    metric_tile(stage_labels[1], counts[1].to_string(), "Stage 2"),
    metric_tile(stage_labels[2], counts[2].to_string(), "Stage 3"),
    metric_tile("Pulses", board.pulses.to_string(), "Manual heartbeat"),
  ])
}

///|
fn render_metrics_panel() -> @html.Html {
  @html.section()
  .id("metrics-panel")
  .class("panel metrics")
  .children([
    @html.div()
    .class("panel-head")
    .children([
      @html.div()
      .class("panel-title")
      .children([
        @html.h2().text("Metrics"),
        @html.small()
        .class("muted")
        .text("Refresh mode: Manual (click metrics)"),
      ]),
    ]),
    @html.div()
    .id("metrics")
    .hx_get("/metrics")
    .hx_trigger("click")
    .hx_target("#metrics")
    .hx_swap_safe(@html.Swap::InnerHTML)
    .children([render_metrics()]),
  ])
}

///|
fn render_pulse() -> @html.Html {
  let note = if board.pulses == 0 {
    "Awaiting signal"
  } else {
    "Pulse captured"
  }
  @html.div()
  .class("pulse-readout")
  .children([
    @html.div().class("pulse-count").text(board.pulses.to_string()),
    @html.div().class("pulse-label").text("pulses logged"),
    @html.div().class("pulse-note").text(note),
  ])
}

///|
fn render_story() -> @html.Html {
  @html.div()
  .class("story-body")
  .children([
    @html.p().text(
      "Hypermedia is the API. Each control is a typed relation mapped to a typed route.",
    ),
    @html.p().text(
      "The server returns the fragment it wants to swap, not a JSON contract.",
    ),
    @html.pre()
    .class("snippet")
    .child(
      @html.code().text(
        "let link = LinkRel::new(Rel::namespaced(\"card\", \"advance\"), Route::post(\"/cards/1/advance\"))",
      ),
    ),
  ])
}

///|
fn render_story_panel() -> @html.Html {
  let toggle_link = @hda.LinkRel::new(
      @hda.Rel::namespaced("story", "toggle"),
      @router.Route::post("/story/toggle"),
    )
    .target("#story-panel")
    .swap(@html.Swap::OuterHTML)
  let story_body = if board.story_open {
    render_story()
  } else {
    @html.p().class("muted").text("Use the button to open this section.")
  }
  @html.section()
  .id("story-panel")
  .class("panel story")
  .children([
    @html.div()
    .class("panel-head")
    .children([
      @html.div()
      .class("panel-title")
      .children([
        @html.h2().text("Field notes"),
        @html.small().class("muted").text(story_toggle_note()),
      ]),
      @html.div()
      .class("panel-actions")
      .children([
        @html.button()
        .attrs(toggle_link.to_attrs())
        .class("btn ghost")
        .text(story_toggle_label()),
      ]),
    ]),
    @html.div().id("story").children([story_body]),
  ])
}

///|
fn render_card(card : Card, index : Int) -> @html.Html {
  let id_str = card.id.to_string()
  let delay = "0." + (index + 2).to_string() + "s"
  let advance_link = @hda.LinkRel::new(
      @hda.Rel::namespaced("card", "advance"),
      @router.Route::post("/cards/" + id_str + "/advance"),
    )
    .target("#card-" + id_str)
    .swap(@html.Swap::OuterHTML)
  let is_final = stage_index(card.stage) == stage_labels.length() - 1
  @html.article()
  .id("card-" + id_str)
  .class("card stagger")
  .attr("style", @html.AttrValue::Str("--delay: " + delay + ";"))
  .children([
    @html.div()
    .class("card-top")
    .children([
      @html.span().class("chip").text("Signal " + id_str),
      @html.span()
      .class("stage " + stage_class(card.stage))
      .text(stage_label(card.stage)),
    ]),
    @html.h3().text(card.title),
    @html.p().class("card-text").text(card.summary),
    @html.div()
    .class("card-bottom")
    .children([
      @html.span().class("tone").text("Tone: " + tone_label(card.tone)),
      @html.button().attrs(advance_link.to_attrs()).class("btn").text("Advance"),
    ]),
    @html.when(is_final, @html.div().class("banner").text("Ready for launch")),
  ])
}

///|
fn render_board() -> @html.Html {
  let cards = board.cards.mapi((i, card) => render_card(card, i))
  let reset_attrs = @hda.HdaAttrs::new()
    .post("/board/reset")
    .target("#board")
    .swap(@html.Swap::OuterHTML)
    .confirm("Reset the board?")
    .to_html_attrs()
  let legend = stage_labels.mapi((i, label) => @html.span()
    .class("stage " + stage_class(i))
    .text(label))
  @html.section()
  .id("board")
  .class("panel board")
  .children([
    @html.div()
    .class("panel-head")
    .children([
      @html.div()
      .class("panel-title")
      .children([
        @html.h2().text("Signal board"),
        @html.p().class("muted").text("Typed link relations drive every move."),
      ]),
      @html.div()
      .class("panel-actions")
      .children([
        @html.div().class("legend").children(legend),
        @html.button().attrs(reset_attrs).class("btn ghost").text("Reset board"),
      ]),
    ]),
    @html.div().class("card-grid").children(cards),
  ])
}

///|
fn render_page() -> String {
  let pulse_trigger = @html.Trigger::Event("click")
  @html.fragment([
    @html.doctype(),
    @html.html()
    .attr("lang", @html.AttrValue::Str("en"))
    .children([
      @html.head().children([
        @html.meta().attr("charset", @html.AttrValue::Str("UTF-8")).empty(),
        @html.meta()
        .attr("name", @html.AttrValue::Str("viewport"))
        .attr(
          "content",
          @html.AttrValue::Str("width=device-width, initial-scale=1"),
        )
        .empty(),
        @html.title().text("Engenis Showcase"),
        @html.style().child(@html.raw(render_css())),
        @html.script()
        .attr("src", @html.AttrValue::Str("/assets/htmx.js"))
        .empty(),
      ]),
      @html.body().children([
        @html.main_el()
        .class("shell")
        .children([
          @html.header()
          .class("hero")
          .children([
            @html.div()
            .class("hero-top")
            .children([
              @html.div()
              .class("brand")
              .children([
                @html.span().class("badge").text("Engenis demo"),
                @html.span().class("badge alt").text("HDA"),
              ]),
            ]),
            @html.div()
            .class("hero-body")
            .children([
              @html.h1().text("Signal board"),
              @html.p()
              .class("lead")
              .text(
                "Type-safe HTML DSL, typed link relations, and server-driven swaps in one flow.",
              ),
              @html.div()
              .class("hero-meta")
              .children([
                @html.span().class("chip").text("HTML DSL"),
                @html.span().class("chip").text("LinkRel"),
                @html.span().class("chip").text("HDA responses"),
              ]),
            ]),
          ]),
          @html.div()
          .class("grid")
          .children([
            render_board(),
            @html.div()
            .class("side")
            .children([
              render_metrics_panel(),
              render_story_panel(),
              @html.section()
              .class("panel pulse-panel")
              .children([
                @html.div()
                .class("panel-head")
                .children([
                  @html.h2().text("Pulse"),
                  @html.small().class("muted").text("click to pulse"),
                ]),
                @html.div().id("pulse").children([render_pulse()]),
                @html.button()
                .class("btn accent")
                .hx_post("/pulse")
                .hx_trigger_safe(pulse_trigger)
                .hx_target("#pulse")
                .hx_swap_safe(@html.Swap::InnerHTML)
                .text("Ignite pulse"),
              ]),
            ]),
          ]),
          @html.footer()
          .class("footer")
          .children([
            @html.p()
            .class("muted")
            .text("Engenis showcase: hypermedia swaps with typed HTML."),
          ]),
        ]),
      ]),
    ]),
  ]).render()
}

///|
fn handle_dynamic(req : @http.Request) -> @http.Response {
  match parse_card_id(req.path) {
    Some(id) =>
      if req.mthd == @http.Method::Post {
        match advance_card(id) {
          Some((card, idx)) => {
            let id_str = id.to_string()
            @http.hda_response(
              render_card(card, idx).render(),
              swap=@html.Swap::OuterHTML,
              target="#card-" + id_str,
            )
            .trigger_after_swap("card-advanced")
            .build()
          }
          None => @http.Response::not_found().text("Card not found")
        }
      } else {
        @http.Response::bad_request().text("Unsupported method")
      }
    None => @http.Response::not_found().text("404 - Not Found")
  }
}

///|
fn handler(runtime_js : Bytes?, req : @http.Request) -> @http.Response {
  if req.path == "/assets/htmx.js" {
    match runtime_js {
      Some(js) =>
        @http.Response::ok()
        .content_type("application/javascript; charset=utf-8")
        .bytes(js)
      None => @http.Response::not_found().text("Missing assets/htmx.js")
    }
  } else {
    match (req.mthd, req.path) {
      (@http.Method::Get, "/") =>
        @http.Response::ok()
        .content_type("text/html; charset=utf-8")
        .text(render_page())
      (@http.Method::Get, "/metrics") =>
        @http.Response::ok()
        .content_type("text/html; charset=utf-8")
        .text(render_metrics().render())
      (@http.Method::Get, "/story") =>
        @http.Response::ok()
        .content_type("text/html; charset=utf-8")
        .text(render_story().render())
      (@http.Method::Post, "/story/toggle") => {
        toggle_story()
        @http.hda_response(
          render_story_panel().render(),
          swap=@html.Swap::OuterHTML,
          target="#story-panel",
        )
        .trigger("story-toggle")
        .build()
      }
      (@http.Method::Post, "/board/reset") => {
        reset_board()
        @http.hda_response(
          render_board().render(),
          swap=@html.Swap::OuterHTML,
          target="#board",
        )
        .trigger("board-reset")
        .build()
      }
      (@http.Method::Post, "/pulse") => {
        let _ = bump_pulse()
        @http.hda_response(
          render_pulse().render(),
          swap=@html.Swap::InnerHTML,
          target="#pulse",
        )
        .trigger_after_settle("pulse")
        .build()
      }
      (_, _) => handle_dynamic(req)
    }
  }
}

///|
async fn start_showcase_server() -> Unit {
  let runtime_js = @http.load_asset_bytes("assets/htmx.js")
  if runtime_js is None {
    println("Warning: assets/htmx.js not found. Build the client runtime.")
  }
  let server = @http.Server::bind("127.0.0.1:8082", fn(req) {
    handler(runtime_js, req)
  }) catch {
    _err => {
      println("Failed to create server")
      return
    }
  }
  println("========================================")
  println("  Engenis Showcase Server")
  println("========================================")
  println("")
  println("Server running at http://127.0.0.1:8082")
  println("Press Ctrl+C to stop")
  println("")
  server.run_forever()
}

///|
async fn main {
  start_showcase_server()
}
