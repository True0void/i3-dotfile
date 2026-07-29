#!/usr/bin/env bash
#Power Menu

shutdown='⏻ Shutdown'
reboot='🔄 Reboot'
lock='🔒 Lock'
suspend='💤 Suspend'
logout='🚪 Logout'
yes='✅ Yes'
no='❌ No'

# uptime
uptime=$(uptime -p | sed -e 's/up //g')

# Rofi
rofi_cmd() {
    rofi -dmenu \
        -p "Uptime: $uptime" \
        -mesg "Select an action"
}

# Confirmation command
confirm_cmd() {
    rofi -dmenu -p "Are you sure?" -mesg "Confirmation"
}

# confirmation
confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

run_rofi() {
    echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" | rofi_cmd
}
run_cmd() {
    selected=$(confirm_exit)
    if [[ "$selected" == "$yes" ]]; then
        case $1 in
            shutdown) systemctl poweroff ;;
            reboot) systemctl reboot ;;
            suspend) systemctl suspend ;;
            logout)
                if [[ "$DESKTOP_SESSION" == "openbox" ]]; then
                    openbox --exit
                elif [[ "$DESKTOP_SESSION" == "bspwm" ]]; then
                    bspc quit
                elif [[ "$DESKTOP_SESSION" == "i3" ]]; then
                    i3-msg exit
                elif [[ "$DESKTOP_SESSION" == "plasma" ]]; then
                    qdbus org.kde.ksmserver /KSMServer logout 0 0 0
                fi
                ;;
        esac
    else
        exit 0
    fi
}
chosen=$(run_rofi)
case $chosen in
    $shutdown) run_cmd shutdown ;;
    $reboot) run_cmd reboot ;;
    $lock)
        if [[ -x "/usr/local/bin/betterlockscreen" ]]; then
            betterlockscreen -l blur
        elif [[ -x "/usr/bin/i3lock" ]]; then
            i3lock
        fi
        ;;
    $suspend) run_cmd suspend ;;
    $logout) run_cmd logout ;;
esac

