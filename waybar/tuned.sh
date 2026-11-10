#!/usr/bin/env bash
# Waybar custom module for tuned.
#   tuned.sh          print current profile as waybar JSON
#   tuned.sh cycle    cycle through the profiles in CYCLE
#   tuned.sh menu     pick any tuned profile from a wofi menu
#   tuned.sh set NAME switch to NAME
# The waybar module listens on SIGRTMIN+8, so after a switch we poke it to refresh.

CYCLE=(powersave balanced throughput-performance)
SIGNAL=8

current() { tuned-adm active 2>/dev/null | sed -n 's/^Current active profile: //p'; }

refresh() { pkill -RTMIN+"$SIGNAL" -x waybar; }

set_profile() {
    tuned-adm profile "$1" && refresh
}

case "$1" in
    cycle)
        cur=$(current)
        next=${CYCLE[0]}
        for i in "${!CYCLE[@]}"; do
            if [[ ${CYCLE[$i]} == "$cur" ]]; then
                next=${CYCLE[$(( (i + 1) % ${#CYCLE[@]} ))]}
                break
            fi
        done
        set_profile "$next"
        ;;
    menu)
        choice=$(tuned-adm list 2>/dev/null \
            | sed -n 's/^- \([^ ]*\).*/\1/p' \
            | wofi --dmenu --insensitive --prompt "tuned profile ($(current))")
        [[ -n $choice ]] && set_profile "$choice"
        ;;
    set)
        set_profile "$2"
        ;;
    *)
        cur=$(current)
        case "$cur" in
            powersave|*battery*|*powersave*) icon=$''; class=power-saver ;;  # leaf
            balanced|desktop)                icon=$''; class=balanced ;;     # scale
            *performance*)                   icon=$''; class=performance ;;  # bolt
            "")                              icon=$''; class=off; cur="off" ;; # warning
            *)                               icon=$''; class=other ;;        # chip
        esac
        printf '{"text":"%s","alt":"%s","class":"%s","tooltip":"tuned: %s\\nClick: cycle  Right-click: choose"}\n' \
            "$icon" "$cur" "$class" "$cur"
        ;;
esac
