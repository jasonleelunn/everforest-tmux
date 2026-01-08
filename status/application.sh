show_application() {
  local index=$1
  local icon=$(get_tmux_option "@everforest_application_icon" "")
  local color=$(get_tmux_option "@everforest_application_color" "$thm_aqua")
  local text=$(get_tmux_option "@everforest_application_text" "#W")

  local module=$(build_status_module "$index" "$icon" "$color" "$text")

  echo "$module"
}
