show_host() {
  local index=$1
  local icon=$(get_tmux_option "@everforest_host_icon" "󰒋")
  local color=$(get_tmux_option "@everforest_host_color" "$thm_statusline1")
  local text=$(get_tmux_option "@everforest_host_text" "#H")

  local module=$(build_status_module "$index" "$icon" "$color" "$text")

  echo "$module"
}
