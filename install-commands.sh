#!/bin/bash
# install-commands.sh
#
# サブモジュールのカスタムコマンドをプロジェクトの .gemini/commands/ にインストールします。
#
# 使い方（プロジェクトルートから実行）:
#   ./development-rules/install-commands.sh [オプション]
#
# オプション:
#   --copy          シンボリックリンクの代わりにファイルをコピーする（デフォルト: シンボリックリンク）
#   --setup-hooks   git フックを設定し、サブモジュール更新時に自動でインストールを実行する
#   --help          このヘルプを表示する

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
GEMINI_COMMANDS_DIR="${PROJECT_ROOT}/.gemini/commands"
COMMANDS_SRC="${SCRIPT_DIR}/commands"
SUBMODULE_PATH="${SCRIPT_DIR#${PROJECT_ROOT}/}"

USE_COPY=false
SETUP_HOOKS=false

for arg in "$@"; do
  case "${arg}" in
    --copy) USE_COPY=true ;;
    --setup-hooks) SETUP_HOOKS=true ;;
    --help)
      echo "使い方: $(basename "$0") [--copy] [--setup-hooks] [--help]"
      echo ""
      echo "  --copy          シンボリックリンクの代わりにファイルをコピーします"
      echo "                  (サブモジュール更新後に再実行が必要になります)"
      echo "  --setup-hooks   git フックを設定します"
      echo "                  git pull / git submodule update 後に自動でインストールが実行されます"
      echo "  --help          このヘルプを表示します"
      echo ""
      echo "デフォルトではシンボリックリンクを作成します。"
      echo "サブモジュールを更新すると自動的に最新のコマンドが反映されます。"
      exit 0
      ;;
    *)
      echo "エラー: 不明なオプション '${arg}'" >&2
      echo "使い方: $(basename "$0") [--copy] [--setup-hooks] [--help]" >&2
      exit 1
      ;;
  esac
done

if [ ! -d "${COMMANDS_SRC}" ]; then
  echo "エラー: commands ディレクトリが見つかりません: ${COMMANDS_SRC}" >&2
  exit 1
fi

# ── コマンドのインストール ────────────────────────────────────────

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
  echo "ヒント: サブモジュール更新後もシンボリックリンク経由で自動的に最新版が反映されます。"
fi

# ── git フックの設定 ──────────────────────────────────────────────

if "${SETUP_HOOKS}"; then
  GIT_DIR="${PROJECT_ROOT}/.git"

  if [ ! -d "${GIT_DIR}" ]; then
    echo "" >&2
    echo "警告: .git ディレクトリが見つかりません。git フックの設定をスキップします。" >&2
  else
    HOOKS_DIR="${GIT_DIR}/hooks"
    mkdir -p "${HOOKS_DIR}"

    HOOK_MARKER="# gemini-rules: install-commands"
    HOOK_CMD="./${SUBMODULE_PATH}/install-commands.sh --copy 2>/dev/null || true"

    setup_hook() {
      local hook_file="${HOOKS_DIR}/$1"
      if [ -f "${hook_file}" ]; then
        if grep -qF "${HOOK_MARKER}" "${hook_file}"; then
          echo "↻ git hook 更新済み: $1"
        else
          # 既存フックに追記
          printf '\n%s\n%s\n' "${HOOK_MARKER}" "${HOOK_CMD}" >> "${hook_file}"
          echo "✓ git hook に追記: $1"
        fi
      else
        # 新規作成
        printf '#!/bin/bash\n%s\n%s\n' "${HOOK_MARKER}" "${HOOK_CMD}" > "${hook_file}"
        chmod +x "${hook_file}"
        echo "✓ git hook を作成: $1"
      fi
    }

    echo ""
    echo "git フックを設定しています..."
    setup_hook "post-merge"    # git pull 後に実行
    setup_hook "post-checkout" # git checkout / submodule update 後に実行
    echo "完了: git pull または git submodule update 後に自動でコマンドがインストールされます。"
  fi
fi

