if status is-interactive
  cat ~/.cache/wal/sequences 
end


starship init fish | source

set -gx EDITOR emacs

#!/usr/bin/env bash

export XDG_RUNTIME_DIR="/run/user/$(id -u)"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# xrandr
function display-update; xrandr --output HDMI-1 --auto --right-of eDP-1; end
function display-hdmi-only; xrandr --output HDMI-1 --auto --primary --output eDP-1 --off; end

# DWM
# function cdwm; emacs ~/dwm-flexipatch/config.def.h; end
# function mdwm; cd ~/dwm-flexipatch; sudo make clean install; cd -; end
# function xrdb-merge; xrdb -merge ~/.cache/wal/Xresources; end


# abbreviations
# cd
abbr cdw cd ~/Pictures/wallpapers
abbr cdb cd ~/Documents/books
abbr cdc cd ~/.config

# git
abbr ga git add
abbr gc git commit
abbr gco git checkout

# ff
abbr ff fastfetch

# pnpm
set -gx PNPM_HOME "/home/gabriel/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

function get_battery_status
  switch $(acpi -b | awk '{print $3}' | tr -d ',')
    case default
      echo ''
    case "Discharging"
      set_color red
      echo " $(acpi -b | awk '{print $4}' | tr -d ',') "
    case "Charging"
      set_color green
      echo " $(acpi -b | awk '{print $4}' | tr -d ',') "
  end
end

# function fish_prompt
#   set -l last_status $status
#   if test $last_status -ne 0
#     set stat (set_color red)" [$last_status]"(set_color normal)
#   end
#   string join '' -- (set_color blue) 󰣇\  $(date '+%H:%M ') (set_color yellow) (prompt_pwd --full-length-dirs 1) (set_color normal) $stat (set_color cyan)'  '
# end

# function fish_right_prompt
#  echo 'hi'
#   # string join '' -- git (fish_git_prompt)
# end

# function fish_mode_prompt
#   switch $fish_bind_mode
#     case default
#       set_color --bold brwhite
#       echo '󰰔 '
#     case insert
#       echo ''
#     case replace_one
#       set_color --bold cyan
#       echo '󰰠 '
#     case visual
#       set_color --bold brmagenta
#       echo '󰰬 '
#     case '*'
#       set_color --bold red
#       echo '󰰠 '
#   end
#   set_color normal
# end
