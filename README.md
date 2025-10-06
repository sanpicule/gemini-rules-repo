<!--
このファイルはリポジトリの概要、目的、利用方法を記述するドキュメントです。
開発者がこのルールリポジトリを理解し、正しくセットアップするための手引きとなります。
-->

# Gemini CLI 開発ルールリポジトリ

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-v1.0.0-blue.svg)](https://github.com/your-username/gemini-rules/releases)

## 概要

このリポジトリは、Gemini CLI に読み込ませるための全社共通の開発ルールを管理します。
各開発プロジェクトでは、このリポジトリをサブモジュールとして利用することを推奨します。

## 特徴

- 🚀 **新機能開発の自動化**: `/new-feature` コマンドでブランチとファイル構造を自動作成
- 🔍 **多言語リンターチェック**: `/lint-check` でJavaScript/TypeScript、Python、Rustに対応
- 🔒 **セキュリティ監査**: `/security-check` で依存関係の脆弱性をチェック
- 📝 **コミット規約**: Conventional Commits仕様に準拠したtype定義
- 🌿 **ブランチ戦略**: GitFlowモデルの標準化
- 🎨 **コーディングスタイル**: 言語別の詳細なスタイルガイド

## ファイル構成

| パス | 目的/ベストプラクティス |
| :--- | :--- |
| `README.md` | **リポジトリの概要、利用方法、更新履歴**<br>必須。このリポジトリの利用方法（サブモジュールとして追加する方法）を明記します。 |
| `GEMINI.md` | **グローバルな開発ルール**<br>Gemini CLIの最重要ファイル。すべてのプロジェクトに共通する基本的なルール（例: コミットメッセージの形式、セキュリティの基本方針、ブランチ戦略、コード品質など）を記述します。 |
| `styleguide.md` | **詳細なコーディングスタイルガイド**<br>Code Assistやレビューコマンドなどで参照されることを想定し、言語ごとの詳細な規約（例: 命名規則、インデント、最大行数、import順序、未使用コード削除など）を記述します。 |
| `commit-types.yaml` | **コミットメッセージのtype定義**<br>Conventional Commits仕様に準拠したtypeの一覧と使用例を定義します。 |
| `CHANGELOG.md` | **変更履歴**<br>各バージョンでの変更内容を詳細に記録します。 |
| `VERSION.md` | **バージョン情報**<br>現在のバージョン、バージョン管理方法、リリースプロセスを説明します。 |
| `config.yaml` | **共通の除外設定**<br>Code Assistなどが共通して無視すべきファイル（例: `node_modules`, `dist`）を`ignore_patterns`として設定します。 |
| `commands/` | **共通のカスタムコマンド**<br>全社的に利用する便利なカスタムコマンドを`.toml`ファイルとして配置します。 |
| `commands/new-feature.toml` | **新機能ブランチ作成コマンド**<br>`/new-feature <機能名>`でfeatureブランチとファイル構造を自動作成します。 |
| `commands/lint-check.toml` | **リンターチェックコマンド**<br>`/lint-check`でプロジェクトの言語に応じたリンターチェックと自動修正を実行します。 |
| `commands/security-check.toml` | **セキュリティチェックコマンド**<br>`/security-check`で依存関係のセキュリティ監査を実行します。 |

## セットアップ方法

### 1. サブモジュールとして追加

各開発プロジェクトのリポジトリルートで、以下のコマンドを実行してこのリポジトリをサブモジュールとして追加します。

```bash
git submodule add https://github.com/your-username/gemini-rules.git development-rules
```

### 2. サブモジュールの更新

プロジェクトをクローンした後や、このルールリポジトリが更新された際には、以下のコマンドでサブモジュールを最新の状態にしてください。

```bash
git submodule update --init --recursive --remote
```

### 3. バージョン管理

バージョン管理の詳細については、[VERSION.md](./VERSION.md)を参照してください。

- **現在のバージョン**: v1.0.0
- **バージョン確認**: `cd development-rules && git describe --tags --always`
- **変更履歴**: [CHANGELOG.md](./CHANGELOG.md)を参照

## 使い方

### 開発ルールの確認

- **`GEMINI.md`**: コミット規約、セキュリティポリシー、ブランチ戦略、コード品質ルールを確認
- **`styleguide.md`**: 言語別のコーディングスタイルガイドを確認
- **`commit-types.yaml`**: コミットメッセージのtype一覧を確認

### カスタムコマンドの使用

#### 新機能開発
```bash
/new-feature user-authentication
```
- `feature/user-authentication`ブランチを作成
- `src/features/user-authentication/`ディレクトリとファイル構造を自動作成

#### リンターチェック
```bash
/lint-check
```
- プロジェクトの言語を自動検出（Node.js/TypeScript、Python、Rust）
- 対応するリンターを実行してエラーチェック
- 自動修正可能なエラーを修正

#### セキュリティチェック
```bash
/security-check
```
- 依存関係のセキュリティ監査を実行
- NPM、Pipenv、Mavenプロジェクトに対応

### 開発ワークフロー

1. **新機能開発開始時**:
   ```bash
   git checkout develop
   git pull origin develop
   /new-feature <機能名>
   ```

2. **コミット前**:
   ```bash
   /lint-check
   # 手動修正が必要なエラーがあれば修正
   /lint-check  # 再実行してエラー0件を確認
   git add .
   git commit -m "feat: <機能の説明>"
   ```

3. **定期的なセキュリティチェック**:
   ```bash
   /security-check
   ```

### 設定ファイルの活用

- **`config.yaml`**: Gemini CLIが無視するファイルパターンを設定
- **`.eslintrc.js`**: `styleguide.md`の設定例を参考にESLint設定を追加

## 変更履歴

詳細な変更履歴については、[CHANGELOG.md](./CHANGELOG.md)を参照してください。

### 主要な機能（v1.0.0）

- **コミットメッセージ規約**: Conventional Commits仕様に準拠
- **新機能開発コマンド**: `/new-feature` でブランチとファイル構造を自動作成
- **リンターチェックコマンド**: `/lint-check` で多言語対応のチェックと自動修正
- **セキュリティチェックコマンド**: `/security-check` で依存関係の監査
- **ブランチ戦略**: GitFlowモデルの標準化
- **コード品質**: リンターエラー0件でのコミット強制
- **多言語対応**: JavaScript/TypeScript、Python、Rust、CSS/Tailwind CSS
