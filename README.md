<!--
このファイルはリポジトリの概要、目的、利用方法を記述するドキュメントです。
-->

# Gemini CLI 開発ルールリポジトリ

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 概要

このリポジトリは、Gemini CLI に読み込ませるための開発ルールとカスタムコマンドを管理します。
各プロジェクトでは、必要なファイルをコピーして利用してください。

## ファイル構成

| パス | 説明 | コピー先 |
| :--- | :--- | :--- |
| `GEMINI.md` | コミット規約・ブランチ戦略・コード品質など全体ルール | プロジェクトルート |
| `styleguide.md` | 言語別コーディングスタイルガイド | プロジェクトルート（任意） |
| `commit-types.yaml` | Conventional Commits の type 定義 | プロジェクトルート（任意） |
| `commands/*.toml` | Gemini CLI カスタムコマンド | `<プロジェクトルート>/.gemini/commands/` |
| `config.yaml` | Gemini CLI の ignore_patterns 設定例 | 参考用 |

## 使い方

### 1. リポジトリをクローン

```bash
git clone https://github.com/your-username/gemini-rules.git
```

### 2. 必要なファイルをプロジェクトにコピー

#### GEMINI.md（開発ルール）

プロジェクトルートに `GEMINI.md` をコピーします。
既存の `GEMINI.md` がある場合は、内容を追記してください。

```bash
cp gemini-rules/GEMINI.md <your-project>/GEMINI.md
```

#### カスタムコマンド

`.gemini/commands/` ディレクトリにコマンドファイルをコピーします。

```bash
mkdir -p <your-project>/.gemini/commands
cp gemini-rules/commands/*.toml <your-project>/.gemini/commands/
```

必要なコマンドだけを選んでコピーしても構いません。

#### スタイルガイド（任意）

```bash
cp gemini-rules/styleguide.md <your-project>/styleguide.md
```

### 3. プロジェクト固有の内容にカスタマイズ

コピー後、プロジェクトの技術スタックや規約に合わせて内容を編集してください。

## カスタムコマンド一覧

コマンドファイルは `commands/` ディレクトリに `.toml` 形式で管理されています。

| コマンド | ファイル | 説明 |
| :--- | :--- | :--- |
| `/new-feature` | `commands/new-feature.toml` | 新しい機能ブランチと定型ファイルを作成 |
| `/lint-check` | `commands/lint-check.toml` | リンターエラーのチェックと自動修正 |
| `/security-check` | `commands/security-check.toml` | 依存関係のセキュリティ監査 |

### コマンドの使用例

```
/new-feature user-authentication
/lint-check
/security-check
```

## このリポジトリへの貢献

ルールやコマンドの改善提案は Issue または PR でお気軽にどうぞ。

## 変更履歴

詳細は [CHANGELOG.md](./CHANGELOG.md) を参照してください。

