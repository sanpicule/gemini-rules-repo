<!--
このファイルは、言語ごとの具体的なコーディングスタイルを定義するガイドです。
命名規則、インデント、フォーマットなどの詳細な規約を記述し、
コードの一貫性を保つための基準となります。
-->

# コーディングスタイルガイド

このドキュメントは、さまざまな言語に関する詳細なコーディングスタイルガイドラインを提供します。
これらのルールは、可能な限りリンターやフォーマッターによって強制されるべきです。

## JavaScript / TypeScript

- **命名規則**:
  - 変数と関数には `camelCase` を使用します。
  - クラスとコンポーネントには `PascalCase` を使用します。
  - 定数には `UPPER_CASE_SNAKE` を使用します。
- **インデント**: 2スペース。
- **行の長さ**: 最大120文字。
- **クォート**: テンプレートリテラルが必要な場合を除き、文字列にはシングルクォート (`'`) を使用します。
- **セミコロン**: ステートメントの末尾には常にセミコロンを使用します。
- **Import順序**: `eslint-plugin-import` と `eslint-plugin-simple-import-sort` を使用してimport文を自動ソートします。
  - **設定例** (`.eslintrc.js`):
    ```javascript
    module.exports = {
      plugins: ['import', 'simple-import-sort', 'unused-imports'],
      rules: {
        'simple-import-sort/imports': 'error',
        'simple-import-sort/exports': 'error',
        'import/first': 'error',
        'import/newline-after-import': 'error',
        'import/no-duplicates': 'error',
        'unused-imports/no-unused-imports': 'error',
        'unused-imports/no-unused-vars': [
          'warn',
          {
            vars: 'all',
            varsIgnorePattern: '^_',
            args: 'after-used',
            argsIgnorePattern: '^_',
          },
        ],
      },
    };
    ```
  - **Import順序**:
    1. Node.jsのビルトインモジュール
    2. 外部ライブラリ（npmパッケージ）
    3. 内部モジュール（相対パス）
    4. 型定義（TypeScriptの場合）
  - **良い例**:
    ```javascript
    import fs from 'fs';
    import path from 'path';
    
    import React from 'react';
    import { useState } from 'react';
    import axios from 'axios';
    
    import { Button } from '../components/Button';
    import { UserService } from './services/UserService';
    
    import type { User } from '../types/User';
    ```
- **未使用コードの削除**: `eslint-plugin-unused-imports` を使用して未使用のimport、変数、関数を自動削除します。
  - **自動削除されるもの**:
    - 未使用のimport文
    - 未使用の変数（`_`で始まる変数は除外）
    - 未使用の関数パラメータ（`_`で始まるパラメータは除外）
  - **設定例**:
    ```javascript
    // 未使用のimportが自動削除される
    import React from 'react'; // 使用されていない場合は削除
    import { useState } from 'react'; // 使用されている場合は残る
    
    // 未使用の変数が警告される
    const unusedVariable = 'test'; // 警告: 未使用の変数
    const _ignoredVariable = 'test'; // 警告されない（_で始まる）
    
    // 未使用の関数パラメータが警告される
    function example(used, _unused) {
      return used; // _unusedは警告されない
    }
    ```

## Python

- **標準**: PEP 8 に従います。
- **インデント**: 4スペース。
- **行の長さ**: 最大119文字。
- **クォート**: 文字列にはダブルクォート (`"`) を使用します。
- **型ヒント**: すべての関数シグネチャに型ヒントを使用します。

## CSS / Tailwind CSS

- **Tailwind CSSクラス**: クラス名をアルファベット順に記載します。
  - **良い例**: `className="bg-blue-500 flex items-center justify-center p-4 text-white"`
  - **悪い例**: `className="flex bg-blue-500 p-4 text-white items-center justify-center"`
- **複数行の場合**: 各クラスを1行に1つずつ記載し、アルファベット順に並べます。
  ```jsx
  className="
    bg-blue-500
    flex
    items-center
    justify-center
    p-4
    text-white
  "
  ```
- **カスタムCSS**: プロパティをアルファベット順に記載します。
- **インデント**: 2スペース。
- **行の長さ**: 最大120文字。
