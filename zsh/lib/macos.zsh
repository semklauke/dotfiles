# macOS helpers previously supplied by OMZ's macos plugin.

open_command() { open "$@"; }

ofd() {
    if (( $# )); then
        open "$@"
    else
        open "$PWD"
    fi
}

alias showfiles='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'

btrestart() {
    sudo pkill bluetoothd
}

_zsh_frontmost_app() {
    osascript -e 'tell application "System Events" to name of first process whose frontmost is true' 2>/dev/null
}

tab() {
    local command="cd ${(q)PWD}; clear"
    local app=$(_zsh_frontmost_app)
    (( $# )) && command+="; $*"

    case $app in
        Terminal)
            osascript - "$command" >/dev/null <<'APPLESCRIPT'
on run argv
    tell application "Terminal"
        activate
        tell application "System Events" to keystroke "t" using command down
        do script (item 1 of argv) in front window
    end tell
end run
APPLESCRIPT
            ;;
        iTerm|iTerm2)
            osascript - "$command" >/dev/null <<'APPLESCRIPT'
on run argv
    tell application "iTerm2"
        tell current window
            create tab with default profile
            tell current session to write text (item 1 of argv)
        end tell
    end tell
end run
APPLESCRIPT
            ;;
        Hyper)
            osascript - "$command" >/dev/null <<'APPLESCRIPT'
on run argv
    tell application "System Events"
        tell process "Hyper" to keystroke "t" using command down
        delay 1
        keystroke (item 1 of argv)
        key code 36
    end tell
end run
APPLESCRIPT
            ;;
        Ghostty|ghostty)
            osascript -e 'tell application "System Events" to keystroke "t" using command down'
            ;;
        *)
            print -u2 "tab: unsupported terminal app: $app"
            return 1
            ;;
    esac
}

_zsh_split_tab() {
    local direction=$1 shortcut=d
    shift
    [[ $direction == vertical ]] && shortcut=D

    local command="cd ${(q)PWD}; clear"
    local app=$(_zsh_frontmost_app)
    (( $# )) && command+="; $*"

    case $app in
        iTerm|iTerm2)
            osascript - "$direction" "$command" >/dev/null <<'APPLESCRIPT'
on run argv
    tell application "iTerm2"
        tell current session of current window
            if item 1 of argv is "vertical" then
                set newSession to split vertically with same profile
            else
                set newSession to split horizontally with same profile
            end if
            tell newSession
                write text (item 2 of argv)
                select
            end tell
        end tell
    end tell
end run
APPLESCRIPT
            ;;
        Hyper)
            local menu_item='Split Horizontally'
            [[ $direction == vertical ]] && menu_item='Split Vertically'
            osascript - "$menu_item" "$command" >/dev/null <<'APPLESCRIPT'
on run argv
    tell application "System Events"
        tell process "Hyper" to click menu item (item 1 of argv) of menu "Shell" of menu bar item "Shell" of menu bar 1
        delay 1
        keystroke (item 2 of argv)
        key code 36
    end tell
end run
APPLESCRIPT
            ;;
        Ghostty|ghostty|Tabby)
            osascript -e "tell application \"System Events\" to keystroke \"$shortcut\" using command down"
            ;;
        *)
            print -u2 "split_tab: unsupported terminal app: $app"
            return 1
            ;;
    esac
}

split_tab()  { _zsh_split_tab horizontal "$@"; }
vsplit_tab() { _zsh_split_tab vertical "$@"; }

pfd() {
    osascript -e 'tell application "Finder" to POSIX path of (insertion location as alias)' 2>/dev/null
}

pfs() {
    osascript 2>/dev/null <<'APPLESCRIPT'
tell application "Finder"
    set output to ""
    repeat with selectedItem in selection
        set output to output & POSIX path of (selectedItem as alias) & linefeed
    end repeat
    return output
end tell
APPLESCRIPT
}

cdf()    { cd "$(pfd)"; }
pushdf() { pushd "$(pfd)"; }

pxd() {
    osascript -e 'tell application "Xcode" to path of active workspace document' 2>/dev/null | xargs dirname
}

cdx() { cd "$(pxd)"; }

quick-look() {
    (( $# )) && qlmanage -p "$@" &>/dev/null &
}

man-preview() {
    (( $# )) || { print -u2 'Usage: man-preview command [...]'; return 1; }
    local page
    for page in ${(f)"$(command man -w "$@")"}; do
        command mandoc -Tpdf "$page" | open -f -a Preview
    done
}
compdef _man man-preview

vncviewer() { open "vnc://$*"; }
rmdsstore() { find "${@:-.}" -type f -name .DS_Store -delete; }

freespace() {
    if [[ -z $1 ]]; then
        print 'Usage: freespace <disk>'
        df -h | awk 'NR == 1 || /^\/dev\/disk/'
        return 1
    fi
    diskutil secureErase freespace 0 "$1"
}

# Music.app control. All work is delegated to AppleScript when invoked, so it
# adds no shell-startup process.
music() {
    local action=$1
    shift 2>/dev/null || true

    case $action in
        launch|play|pause|stop|rewind|resume|quit)
            osascript -e "tell application \"Music\" to $action"
            ;;
        next|previous)
            osascript -e "tell application \"Music\" to $action track"
            ;;
        mute)   osascript -e 'tell application "Music" to set mute to true' ;;
        unmute) osascript -e 'tell application "Music" to set mute to false' ;;
        vol)
            if [[ -z $1 ]]; then
                osascript -e 'tell application "Music" to get sound volume'
            elif [[ $1 == up || $1 == down ]]; then
                local delta=10
                [[ $1 == down ]] && delta=-10
                osascript -e "tell application \"Music\" to set sound volume to sound volume + $delta"
            else
                osascript -e "tell application \"Music\" to set sound volume to $1"
            fi
            ;;
        playing|status)
            osascript -e 'tell application "Music" to if player state is playing then return name of current track & " by " & artist of current track'
            ;;
        playlist)
            osascript -e "tell application \"Music\" to play playlist \"$*\""
            ;;
        shuf|shuff|shuffle)
            case ${1:-toggle} in
                on)  osascript -e 'tell application "Music" to set shuffle enabled to true' ;;
                off) osascript -e 'tell application "Music" to set shuffle enabled to false' ;;
                toggle) osascript -e 'tell application "Music" to set shuffle enabled to not shuffle enabled' ;;
                *) print -u2 'Usage: music shuffle [on|off|toggle]'; return 1 ;;
            esac
            ;;
        ''|-h|--help)
            print 'Usage: music {launch|play|pause|stop|next|previous|mute|unmute|vol|status|playlist|shuffle|quit}'
            ;;
        *)
            print -u2 "music: unknown action: $action"
            return 1
            ;;
    esac
}
itunes() { print -u2 "'itunes' is deprecated; using Music.app"; music "$@"; }

# shpotify is the maintained standalone tool from which OMZ's spotify helper
# is derived. The installer keeps it updated independently of shell startup.
spotify() {
    local shpotify="$ZSH_PLUGINS/shpotify/spotify"
    [[ -x $shpotify ]] || { print -u2 'spotify: shpotify is not installed'; return 1; }
    "$shpotify" "$@"
}
