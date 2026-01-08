show_window_current_format() {
  local number="#I"
  local color="$thm_orange"
  local background="$thm_bg_dim"
  local text="$(get_tmux_option "@everforest_window_current_text" "#W")"
  local fill="$(get_tmux_option "@everforest_window_current_fill" "number")" # number, all, none

  local current_window_format=$(build_window_format "$number" "$color" "$background" "$text" "$fill")

  echo "$current_window_format"
}
