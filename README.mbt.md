# Engenis

Pure MoonBit Hypermedia Driven Application (HDA) framework

## Philosophy

### Pure MoonBit

可能な限り純粋なMoonBitコードで実装されています。外部の巨大なライブラリへの依存を避け、コンパイル時の型チェックを最大限に活用します。

### 依存最小化 (Minimize Dependencies)

クライアント側の依存関係を最小限に抑えることを目指しています。現在、counter exampleではHTMXをCDNから読み込んでいますが、これは開発中の一時的な措置です。詳細は [spec/CLIENT_DEPENDENCY.md](spec/CLIENT_DEPENDENCY.md) を参照してください。

### Full HTML Swap but Type Safe

HTML DSLを通じて型安全なハイパーメディアアプリケーションを構築できます。HTMXのような属性ベースの相互作用を、MoonBitの型システムの安全性と組み合わせて実現します。

## Features

* **型安全なHTML DSL** - 文字列結合ではなく、型付きビルダーでHTMLを構築
* **HDA属性** - `hx_get`, `hx_post`, `hx_swap_safe` などの型安全な属性
* **HTTPサーバー** - Pure MoonBit + `moonbitlang/async` による実装

## Typed Link Relations

```mbt nocheck
let inc_link = @hda.LinkRel::new(
  @hda.Rel::namespaced("counter", "inc"),
  @router.Route::post("/counter/inc"),
)
  .target("#counter")
  .swap(@html.Swap::InnerHTML)

@html.button()
  .attrs(inc_link.to_attrs())
  .text("+")
```

## Current Status

* [x] Type-safe HTML DSL
* [x] Type-safe HDA attributes
* [x] HTTP server (Pure MoonBit + moonbitlang/async)
* [ ] Pure MoonBit client runtime (planned)

## Quick Start

```bash
# Counter exampleを実行
./examples/counter/cmd/main/main
```

ブラウザで `http://127.0.0.1:8080` にアクセスしてください。

## Documentation

* [spec/AGENTS.md](spec/AGENTS.md) - 開発方針
* [spec/CLIENT_DEPENDENCY.md](spec/CLIENT_DEPENDENCY.md) - クライアント依存ポリシー
* [spec/DEEPRESEARCH.md](spec/DEEPRESEARCH.md) - HDAに関する研究ドキュメント
