# Engenis Roadmap

Pure MoonBit / dependency near 0 を守りつつ、HATEOAS と HDA beyond htmx.js を型安全に実現するための実行計画。

## Inputs (Aufheben)

- `spec/AGENTS.md`: Pure MoonBit, dependency near 0, 例外ルール
- `spec/DEEPRESEARCH.md`: Beyond HTMX, Luna/Sol, native backend, PBT/quickcheck
- `spec/CLIENT_DEPENDENCY.md`: HTMX依存からPure MoonBitクライアントへ移行

## Principles / Constraints

- Pure MoonBit + dependency near 0
  - 例外: moonbitlang と mizchi 系
  - MoonbitHTTP を使う場合は fork を前提
- Type Safe First
  - ルート/リンク/属性/レスポンスの文字列依存を最小化
- HATEOAS & HDA beyond htmx.js
  - Full HTML swap を維持しつつ、型で遷移を保証
- クライアント依存は最小、CDNは排除（ローカル配布）

## Current Snapshot

- 型安全HTML DSL / HDA属性 / Rel + Route が存在
- HTTPサーバーは `moonbitlang/async` のみ
- counter example はローカル htmx.mbt ランタイム
- 未実装/ギャップ
  - Request解析、ルートマッチング/params抽出
  - HdaAttrs の stringly typed
  - HTML/Attr エスケープのテスト無効
  - DOM非依存クライアントコア未実装

## Roadmap

### Phase 0: Baseline (現状の可視化)

- 既存API/例の整理と更新
- 既知バグや不足テストの一覧化
- Done: 現状の強み/弱みが明文化され、改善対象が合意されている

### Phase 1: Core Typed HDA (サーバー基盤の型安全化)

- Request解析の実装（query/header/body）
- ルートマッチング + path params 抽出
- HdaAttrs と html.Attrs の統合 or 相互変換強化
- HDAレスポンスが Html を受け取れるよう拡張
- HTML/Attr エスケープのバグ修正とテスト復活
- Done: 型付きルート/属性/HTMLで1画面フローが完結、テストが通る

### Phase 2: HATEOAS Formalization (遷移の第一級化)

- Rel を拡張し Link/Action/Form の型を導入
- Link header 生成と rel/data-rel の一貫性
- Resource -> Actions 生成API
- Done: 遷移が型で表現でき、文字列依存が消える

### Phase 3: MoonBit Client Runtime (htmx.mbt運用)

- htmx.mbt ランタイムのローカル配布（assets/htmx.js）
- counter example から CDN 削除
- Done: CDN不要で example が動作

### Phase 4: Beyond HTMX (型駆動の拡張)

- 先読み/楽観更新/制約付き遷移などの型付き拡張
- Islands/partial hydration などの高度機能を検討
- Done: HDAを超える価値が示され、互換性が保たれる

## Testing & Quality (from research)

- quickcheck によるプロパティテスト（routing/serialization等）
- In-memory transport を使った統合テスト（必要なら MoonbitHTTP fork）
- snapshotベースの表示テスト

## Risks / Unknowns

- JS/WasmでのDOM/Fetch API成熟度
- typed routing の設計が Link/Action のAPIを左右
