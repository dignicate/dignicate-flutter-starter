# Implementation Policies & Project Notes

このファイルは、開発エージェントや開発者がプロジェクトの方針を共有し、継続的に更新していくためのものです。

## 1. 基本方針 (Core Principles)

- **UI レイヤーの独立性**: `packages/ui` は特定の状態管理ライブラリ（Riverpod等）に依存しないクリーンな構成を維持する。
- **Stateless 優先**: 共通コンポーネントは可能な限り `StatelessWidget` として実装し、外部から必要な情報を注入する設計とする。
- **標準 API の活用**: 状態の伝播には Flutter 標準の `InheritedWidget` を、ナビゲーションには `Navigator` API または `go_router` を使用する。

## 2. アーキテクチャ決定事項 (Architectural Decisions)

### 特定の状態管理ライブラリ（Riverpod）への依存排除
- `packages/ui` から `hooks_riverpod` への依存を完全に排除した。
- **背景と目的**:
    - 特定のライブラリにプロジェクト全体がバインド（結合）されることへの懸念。
    - Riverpod が容易に広範なアクセスを許容するため、ビジネスロジックの混入や予期せぬ依存関係を生み出す（危険な使われ方をされる）可能性がある。
    - UI レイヤーの純粋性を保ち、再利用性とテスト容易性を高めるため。
- 詳細な背景と設計思想については、後日作成予定の独立ドキュメントを参照。

### アプリ設定・情報の管理 (App Configuration)
- `AppConfigScope` (`InheritedWidget`) を導入。
- **一元化された初期化**: アプリのバージョン情報、環境変数 (`.env`)、環境識別子 (`ENV`) は `AppConfig.load()` で一括して取得され、`AppConfig` クラスに保持される。
- **アクセス方法**: `main.dart` で取得した `AppConfig` を `AppConfigScope` に渡し、ツリー全体には `AppConfigScope.of(context)` を通じて配信する。
- **メリット**: `main.dart` の肥大化を防ぎ、UI レイヤーから設定値へのアクセスを型安全かつシンプルにする。

## 3. 実装済みコンポーネント (Key Components)

- **CustomAppBar**:
    - デザイン定義に基づいた共通ヘッダー。
    - 戻るボタン、メニューボタン（ドロワー連動）をプロパティで切り替え可能。
    - プロジェクト固有の `ThemeExtension` を使用。
- **AppDrawer**:
    - アプリ全体の共通サイドメニュー。
    - バージョン情報などは `AppConfig` から動的に取得。

## 4. 今後の課題・予定

- 各画面固有の状態管理が必要な場合、`viewmodel` レイヤーとの連携方法を確立する。
- `AGENTS.md` を随時更新し、実装の意図を明文化していく。
