#!/usr/bin/env bash

show_git_changes() {
  local index=$1
  local icon=$(get_tmux_option "@everforest_git_changes_icon" "")
  local color=$(get_tmux_option "@everforest_git_changes_color" "$thm_blue")
  local text=$(get_tmux_option "@everforest_git_changes_text" "#[fg=$thm_green]+{added} #[fg=$thm_red]-{removed}")

  local module=$(build_status_module "$index" "$icon" "$color" "$text")

  # build and store the shell command tmux will run to invoke the rest of the script
  local command
  printf -v command 'bash %q #{q:pane_current_path} %q' \
    "$PLUGIN_DIR/status/git_changes.sh" \
    "$module"

  # return the tmux command which will invoke the rest of the script
  printf '#(%s)\n' "$command"
}

# only run the rest of the script when invoked directly
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  return 0
fi

untracked_changes() {
  local file diff_exit_code

  # loop over all untracked files
  git ls-files --others --exclude-standard -z |
    while IFS= read -r -d '' file; do
      git diff --no-index --numstat --no-ext-diff --no-textconv -- /dev/null "$file"
      diff_exit_code=$?
      # fail if git diff returns something other than 0 or 1 (git diff returns 1 when files differ)
      ((diff_exit_code <= 1)) || return "$diff_exit_code"
    done
}

working_tree_changes() {
  git diff --numstat --no-relative --no-ext-diff --no-textconv -- || return 1

  untracked_changes
}

set -o pipefail

repo=$(git -C "$1" rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$repo" 2>/dev/null || exit 0

counts=$(
  working_tree_changes 2>/dev/null |
    # sum up the counts from stdin in the form:
    # 2    1    tracked.txt
    # 3    0    new-file.txt
    awk '
        $1 ~ /^[0-9]+$/ && $2 ~ /^[0-9]+$/ {
          added += $1
          removed += $2
        }
        END { printf "%d %d\n", added, removed }
      '
) || exit 0

read -r added removed <<<"$counts"
((added || removed)) || exit 0

# replace the placeholders with the real counts
module=${2//\{added\}/$added}
module=${module//\{removed\}/$removed}

printf '%s' "$module"
