#!/bin/bash
# install-commands.sh
#
# サブモジュールのカスタムコマンドをプロジェクトの .gemini/commands/ にインストールします。
#
# 使い方（プロジェクトルートから実行）:
#   ./development-rules/install-commands.sh [オプション]
#
# オプション:
#   --copy     シンボリックリンクの代わりにファイルをコピーする（デフォルト: シンボリックリンク）
#   --help     このヘルプを表示する

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
GEMINI_COMMANDS_DIR="${PROJECT_ROOT}/.gemini/commands"
COMMANDS_SRC="${SCRIPT_DIR}/commands"

USE_COPY=false

for arg in "$@"; do
  case "${arg}" in
    --copy) USE_COPY=true ;;
    --help)
      echo "使い方: $(basename "$0") [--copy] [--help]"
      echo ""
      echo "  --copy    シンボリックリンクの代わりにファイルをコピーします"
      echo "            (サブモジュール更新後に再実行が必要になります)"
      echo "  --help    このヘルプを表示します"
      echo ""
      echo "デフォルトではシンボリックリンクを作成します。"
      echo "サブモジュールを更新すると自動的に最新のコマンドが反映されます。"
      exit 0
      ;;
    *)
      echo "エラー: 不明なオプション '${arg}'" >&2
      echo "使い方: $(basename "$0") [--copy] [--help]" >&2
      exit 1
      ;;
  esac
done

if [ ! -d "${COMMANDS_SRC}" ]; then
  echo "エラー: commands ディレクトリが見つかりません: ${COMMANDS_SRC}" >&2
  exit 1
fi

mkdir -p "${GEMINI_COMMANDS_DIR}"

INSTALLED=0
UPDATED=0
SKIPPED=0

shopt -s nullglob
toml_files=("${COMMANDS_SRC}"/*.toml "${COMMANDS_SRC}"/**/*.toml)
shopt -u nullglob

for toml_file in "${toml_files[@]}"; do
  [ -f "${toml_file}" ] || continue

  # commands/ からの相対パスでサブディレクトリ構造を保持
  relative_path="${toml_file#${COMMANDS_SRC}/}"
  target="${GEMINI_COMMANDS_DIR}/${relative_path}"
  target_dir="$(dirname "${target}")"

  mkdir -p "${target_dir}"

  if "${USE_COPY}"; then
    if [ -f "${target}" ] && [ ! -L "${target}" ]; then
      cp "${toml_file}" "${target}"
      echo "↻ 更新 (copy): ${relative_path}"
      ((UPDATED++)) || true
    else
      cp "${toml_file}" "${target}"
      echo "✓ インストール (copy): ${relative_path}"
      ((INSTALLED++)) || true
    fi
  else
    # シンボリックリンクを作成（既存のリンクは上書き）
    if [ -L "${target}" ]; then
      ln -sf "${toml_file}" "${target}"
      echo "↻ 更新 (symlink): ${relative_path}"
      ((UPDATED++)) || true
    elif [ -f "${target}" ]; then
      echo "⚠ スキップ (コピーされたファイルが存在します): ${relative_path}"
      echo "  上書きするには --copy オプションを使うか、手動で削除してください"
      ((SKIPPED++)) || true
    else
      ln -s "${toml_file}" "${target}"
      echo "✓ インストール (symlink): ${relative_path}"
      ((INSTALLED++)) || true
    fi
  fi
done

echo ""
echo "インストール先: ${GEMINI_COMMANDS_DIR}"
echo "結果: ${INSTALLED}個インストール, ${UPDATED}個更新, ${SKIPPED}個スキップ"

if ! "${USE_COPY}"; then
  echo ""
  echo "ヒント: サブモジュール更新後もシンボリックリンク経由で自動的に最新版が反映されます。"
  echo "       コピーが必要な場合は --copy オプションを使用してください。"
fi
