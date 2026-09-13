# Dotfiles checks. Run from the repo root.

set shell := ["bash", "-cu"]

default:
    @just --list

# stow dry-run, GPG inventory, script syntax
check: check-stow check-gnupg check-scripts

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

# gnupg package must contain only the two conf files
check-gnupg:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{ justfile_directory() }}"
    failed=0
    while IFS= read -r f; do
      base="${f##*/}"
      if [[ "$base" != gpg.conf && "$base" != gpg-agent.conf ]]; then
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
        if [[ "$base" != gpg.conf && "$base" != gpg-agent.conf ]]; then
          printf 'leftover stow link: %s -> %s\n' "$link" "$(readlink "$link")" >&2
          failed=1
        fi
      done < <(find "${HOME}/.gnupg" -type l -print0)
    fi
    if (( failed )); then
      exit 1
    fi
    echo "gnupg inventory: ok"

# bash -n on bin scripts; shellcheck when installed
check-scripts:
    #!/usr/bin/env bash
    set -euo pipefail
    cd "{{ justfile_directory() }}"
    shopt -s nullglob
    scripts=(bin/.local/bin/* hypr/.config/hypr/scripts/*)
    if (( ${#scripts[@]} == 0 )); then
      echo "no scripts" >&2
      exit 1
    fi
    for f in "${scripts[@]}"; do
      bash -n "$f"
    done
    echo "bash -n: ok"
    if command -v shellcheck >/dev/null; then
      shellcheck "${scripts[@]}"
      echo "shellcheck: ok"
    else
      echo "note: shellcheck not installed; ran bash -n only"
    fi

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
