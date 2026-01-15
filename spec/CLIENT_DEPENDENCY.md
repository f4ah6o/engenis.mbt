# Client Dependency Policy

## Current State

### HTMX Usage

counter example (`examples/counter`) では、MoonBit実装の `htmx.mbt` を
ローカル配布したランタイム（`assets/htmx.js`）を読み込んで使用しています。

```moonbit
@html.script()
  .attr("src", @html.AttrValue::Str("/assets/htmx.js"))
  .empty(),
```

ランタイムは `examples/client_poc/cmd/main` で `@htmx.htmx_init()` を呼び出す
JSバンドルとして生成します（`make client-runtime`）。

## Policy: 依存最小化

### Why Minimize Client Dependencies?

1. **型安全性** - 外部のJavaScriptライブラリは文字列ベースの属性を使用するため、コンパイル時のチェックができません
2. **デプロイの簡素化** - 外部CDNへの依存は、オフライン環境やプライベートネットワークで問題になります
3. **バイナリサイズ** - 将来的には単一バイナリで完結させたい

### What We Already Have

* **サーバーサイド** - Pure MoonBit + `moonbitlang/async` のみで動作
* **HTML DSL** - 型安全なHTMLビルダー（`src/html/html.mbt`）
* **HDA属性** - 型安全なHTMX互換属性（`src/hda/hda.mbt`）

これらはすでに型安全性を提供しており、クライアントランタイムへの移行が容易な設計になっています。

## Future Work: DOM非依存クライアントコア

### Design Goals

* HTMXと同じ属性形式（`hx-get`, `hx-post` など）をサポート
* DOM依存部をアダプタ化し、JS/Wasm/Native への展開余地を作る
* サーバーサイドのHTML DSLと完全な互換性

### Planned Features

* **属性パース** - `hx-*` 属性の読み取りと解釈
* **イベントハンドリング** - click, change などのイベント検知
* **HTTP通信** - fetch APIによるサーバーとの通信
* **DOM操作** - Swap戦略（`innerHTML`, `outerHTML` など）の実装
* **ターゲット選択** - CSSセレクタによる要素の特定

### Migration Path

1. HTMX属性はすでに型安全に実装されている（変更不要）
2. 将来的には同じ属性をPure MoonBitランタイムで処理
3. API互換性を維持したまま移行可能

## Implementation Notes

### Current Limitations

* `htmx.mbt` ランタイムはJSターゲット前提
* DOM非依存コアは未設計

### Next Steps

1. `htmx.mbt` ランタイムの運用とHDA属性との整合維持
2. DOM非依存コア + アダプタ設計の検討（far future）

## References

* [spec/DEEPRESEARCH.md](DEEPRESEARCH.md) - HDAおよび "Beyond HTMX" に関する研究
* [spec/AGENTS.md](AGENTS.md) - 開発方針
