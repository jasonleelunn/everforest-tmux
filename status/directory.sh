show_directory() {
  local index=$1
  local icon=$(get_tmux_option "@everforest_directory_icon" "")
  local color=$(get_tmux_option "@everforest_directory_color" "$thm_aqua")
  local text=$(get_tmux_option "@everforest_directory_text" "#{s|$HOME|~|:pane_current_path}")

  local module=$(build_status_module "$index" "$icon" "$color" "$text")

  echo "$module"
}
