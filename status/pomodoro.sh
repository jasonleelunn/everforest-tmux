#!/usr/bin/env bash

# integration with https://github.com/open-pomodoro/openpomodoro-cli

show_pomodoro() {
  local index=$1
  local icon color text module script command
  local quote="'\\''"
  icon=$(get_tmux_option "@everforest_pomodoro_icon" "󰔛")
  color=$(get_tmux_option "@everforest_pomodoro_color" "$thm_red")
  text=$(get_tmux_option "@everforest_pomodoro_text" "{status}")

  module=$(build_status_module "$index" "$icon" "$color" "$text")

  # build and store the shell command tmux will run to invoke the rest of the script
  script="$PLUGIN_DIR/status/pomodoro.sh"
  printf -v command "bash '%s' '%s'" "${script//\'/$quote}" "${module//\'/$quote}"

  # return the tmux command which will invoke the rest of the script
  printf '#(%s)\n' "$command"
}

# only run the rest of the script when invoked directly
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  return 0
fi

# NOTE: !R is the remaining minutes, or an exclamation mark when finished
status=$(pomodoro status --format '%!R' 2>/dev/null) || exit 0
[[ -n "$status" ]] || exit 0

module=${1//\{status\}/$status}
printf '%s' "$module"
