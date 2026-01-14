# Additional plan

./DEEPRESEARCH.md よりもこちらを優先する

1. Pure MoonBit
2. dependency near 0
  * MoonbitHTTPは利用する場合Fork
  * 必要かつ下記にないものは自前
  * 例外: moonbitlang and mizchi
3. Full HTML Swap but type safe

## 依存最小化の方針

クライアント側の依存関係を最小限に抑えることを目指します。

### 現状

* counter exampleではHTMXをCDNから使用
* これは一時的な依存関係（詳細: [CLIENT_DEPENDENCY.md](CLIENT_DEPENDENCY.md)）

### 将来

* Pure MoonBitクライアントランタイムの実装
* HTMX属性はすでに型安全に実装済みのため、移行は容易
