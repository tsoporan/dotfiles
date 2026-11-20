# Dotfiles checks. Run from the repo root.

set shell := ["bash", "-cu"]

default:
    @just --list

# stow dry-run, GPG/Claude inventory, script checks, tldraw typecheck
check: check-stow check-gnupg check-claude check-scripts check-tldraw

# Every package must stow without conflicts
check-stow:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{ justfile_directory() }}"
    failed=0
    for pkg in */; do
      pkg="${pkg%/}"
      if ! output=$(stow -n "$pkg" 2>&1); then
        printf 'FAIL %s\n%s\n' "$pkg" "$output" >&2
        failed=1
      fi
    done
    if (( failed )); then
      exit 1
    fi
    echo "stow -n: ok"

# gnupg package must contain only the conf files
check-gnupg:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{ justfile_directory() }}"
    failed=0
    allowed='gpg.conf|gpg-agent.conf'
    while IFS= read -r f; do
      base="${f##*/}"
      if [[ ! $base =~ ^($allowed)$ ]]; then
        printf 'unexpected in gnupg package: %s\n' "$f" >&2
        failed=1
      fi
    done < <(find gnupg/.gnupg -mindepth 1 -print | sort)
    # Leftover stow links in ~/.gnupg write runtime files back into the package.
    if [[ -d "${HOME}/.gnupg" ]]; then
      pkg_abs=$(realpath gnupg/.gnupg)
      while IFS= read -r -d '' link; do
        dest=$(realpath -s -m "$(dirname "$link")/$(readlink "$link")")
        case "$dest" in
          "$pkg_abs"|"$pkg_abs"/*) ;;
          *) continue ;;
        esac
        base="${link##*/}"
        if [[ ! $base =~ ^($allowed)$ ]]; then
          printf 'leftover stow link: %s -> %s\n' "$link" "$(readlink "$link")" >&2
          failed=1
        fi
      done < <(find "${HOME}/.gnupg" -type l -print0)
    fi
    if (( failed )); then
      exit 1
    fi
    echo "gnupg inventory: ok"

# tldraw/.claude must contain only the tldraw skill, and ~/.claude must not fold into it
check-claude:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{ justfile_directory() }}"
    failed=0
    while IFS= read -r f; do
      case "$f" in
        tldraw/.claude/skills|tldraw/.claude/skills/tldraw|tldraw/.claude/skills/tldraw/*) ;;
        *)
          printf 'unexpected in tldraw/.claude: %s\n' "$f" >&2
          failed=1
          ;;
      esac
    done < <(find tldraw/.claude -mindepth 1 -print | sort)
    if [[ -L "${HOME}/.claude" ]]; then
      printf '~/.claude is a symlink (%s); must be a real directory\n' "$(readlink "${HOME}/.claude")" >&2
      failed=1
    elif [[ -d "${HOME}/.claude" ]]; then
      pkg_abs=$(realpath tldraw/.claude)
      while IFS= read -r -d '' link; do
        dest=$(realpath -s -m "$(dirname "$link")/$(readlink "$link")")
        case "$dest" in
          "$pkg_abs"|"$pkg_abs"/*) ;;
          *) continue ;;
        esac
        case "$link" in
          "${HOME}/.claude/skills/tldraw"|"${HOME}/.claude/skills/tldraw"/*) ;;
          *)
            printf 'unexpected stow link under ~/.claude: %s -> %s\n' "$link" "$(readlink "$link")" >&2
            failed=1
            ;;
        esac
      done < <(find "${HOME}/.claude" -type l -print0)
    fi
    if (( failed )); then
      exit 1
    fi
    echo "claude inventory: ok"

# Shell scripts: bash -n, then shellcheck. Python scripts: syntax, then ruff.
check-scripts:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{ justfile_directory() }}"
    shopt -s nullglob
    shell=() python=()
    for f in bin/.local/bin/* hypr/.config/hypr/scripts/*; do
      if [[ $(head -n1 "$f") == *python* ]]; then python+=("$f"); else shell+=("$f"); fi
    done
    if (( ${#shell[@]} == 0 )); then
      echo "no scripts" >&2
      exit 1
    fi
    for f in "${shell[@]}"; do
      bash -n "$f"
    done
    echo "bash -n: ok"
    if command -v shellcheck >/dev/null; then
      shellcheck "${shell[@]}"
      echo "shellcheck: ok"
    else
      echo "note: shellcheck not installed; ran bash -n only"
    fi
    if (( ${#python[@]} )); then
      for f in "${python[@]}"; do
        python3 -c 'import ast, sys; ast.parse(open(sys.argv[1]).read(), sys.argv[1])' "$f"
      done
      echo "python syntax: ok"
      if command -v ruff >/dev/null; then
        ruff check "${python[@]}"
        ruff format --check "${python[@]}"
      else
        echo "note: ruff not installed; checked python syntax only"
      fi
    fi

# tldraw board app: install from the lockfile, then typecheck
check-tldraw:
    #!/usr/bin/env bash
    set -euo pipefail
    if ! command -v bun >/dev/null; then
      echo "note: bun not installed; skipped tldraw typecheck"
      exit 0
    fi
    cd "{{ justfile_directory() }}/tldraw/.local/share/tldraw"
    bun install --frozen-lockfile --silent
    bun run --silent typecheck
    echo "tldraw typecheck: ok"

# Pending antidote + plugin git pulls. No changes.
zsh-plugins-outdated:
    #!/usr/bin/env zsh
    set -e
    # nounset breaks antidote.zsh, which probes $BASH_VERSION to refuse bash.
    source "${ZDOTDIR:-$HOME}/.antidote/antidote.zsh"
    antidote update --dry-run

# Pull antidote and plugins. Saves a SHA snapshot.
zsh-plugins-update:
    #!/usr/bin/env zsh
    set -e
    source "${ZDOTDIR:-$HOME}/.antidote/antidote.zsh"
    antidote update
