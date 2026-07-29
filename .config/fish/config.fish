
# =============================================================================
# Fish Shell Configuration
# Main config file — loaded on every interactive shell startup.
# Location: ~/.config/fish/config.fish
# Last reviewed: 2026-07-29
# =============================================================================

# --- Private / Local Configuration ---
# (ssh IPs, secrets, machine-specific values)

if test -f ~/.config/fish/private.fish
    source ~/.config/fish/private.fish
end

# set caps lock as escape

# setxkbmap -option caps:escape

# --- Audio / PipeWire ---
# export fzf settigns
# export FZF_DEFAULT_OPTS="--height=90% --layout=reverse --info=inline --border --margin=1 --padding=1 --preview 'bat --style=plain --color=always {}' --preview-window=right:55%"

export PIPEWIRE_LATENCY="128/48000"  # Adjust buffer size if needed
export JACK_NO_AUDIO_RESERVATION=1    # Prevents JACK from hogging audio


# --- Bob the Fish Theme ---
# ⚠ NOTE: oh-my-fish is loaded via conf.d/omf.fish; Tide is the active prompt
#   but these bobthefish theme vars remain — verify if still needed.
set -g theme_color_scheme dark
set -g theme_display_git_untracked no
set -g theme_display_git_ahead_verbose yes
set -g theme_display_hg yes
set -g theme_display_virtualenv yes
set -g theme_display_ruby no
set -g theme_display_user yes
set -g theme_title_display_process yes
set -g theme_title_display_path no
set -g theme_date_format "+%a %H:%M"
set -g theme_avoid_ambiguous_glyphs yes
set -g default_user zach

# --- PATH (early additions) ---
set -gx PATH $HOME/.cargo/bin $PATH
set -Ux fish_user_paths $HOME/.config/emacs/bin $fish_user_paths



# --- Interactive Shell Guard ---
# Only configure interactive features when running as an interactive shell.

# If not running interactively, don't do anything
if status is-interactive


    # --- Environment Variables ---
    # Set environment variables
    # set -gx EDITOR "emacsclient -c"
    set -gx EDITOR "nvim"
    set -gx PAGER less
    set -g fish_greeting ""


    # --- PATH Additions ---
    set -gx PATH /usr/local/bin/ $PATH
    set -gx PATH $HOME/.local/bin $PATH
    set -gx PATH $HOME/usr/bin $PATH
    set -gx PATH $HOME/Apps $PATH
    set -Ux PATH $PATH (npm bin -g)
    set -gx PATH $HOME/Desktop/ $PATH
    set -gx PROTON "/usr/share/steam/compatibilitytools.d/proton_tkg_makepkg/proton"

    # --- Abbreviations / Aliases ---

    abbr sshmac 'ssh -p 32767 zach@$SSH_MAC_IP'
    abbr gcc 'gcc -Wall -g'
    abbr et 'emacsclient -c -nw'
    abbr clip "xclip -selection clipboard | xclip -o"
    abbr pdf 'zathura'
    abbr audiorecord 'ffmpeg -f pulse -i default -ac 2'
    abbr backlinks 'python /home/zach/scripts/backlink_obsidian_tui.py'
    abbr endcord '~/Apps/endcordApp/endcord'
    abbr dd 'caligula'
    abbr ce '~/scripts/clean_emacs.sh'
    abbr cp '/usr/local/bin/advcp -g'
    abbr mv '/usr/local/bin/advmv -g'
    abbr debian 'sudo systemd-nspawn -D ~/debian-root -u isen'
    abbr ors 'rclone sync --filter-from ~/.rclone-org-roam-filter /home/zach/Documents/Emacs/org-roam/ org-roam-webdav:org-roam-webdav/'
    abbr tdca 'tod l c -t todoist --project'
    abbr tdl 'tod l v -t todoist --project'
    abbr tdla 'tod l v -t todoist --filter all'
    abbr tdc 'tod l c --filter today'
    abbr tdt 'tod t c'
    abbr tdd 'tod list view -t todoist -f today'
    abbr td 'tod'
    abbr grep 'grep --color=auto'
    abbr shutit 'shutdown -h 0'
    abbr lq 'exa --icons --group-directories-first --sort=extension'
    abbr lqa 'exa --icons -1 -T -R --color=always -L 9'
    abbr ytdl 'yt-dlp -P /home/zach/Videos/youtube --convert-subs srt --remux-video mp4 --write-auto-subs -u SAMCOUCAIL -p aaa -i'
    abbr ytdla 'yt-dlp -P /home/zach/Music/musicSamples/Perso/youtube/ -x --audio-format wav'
    abbr nv 'nvim'
    abbr weather 'curl wttr.in/14530'
    abbr removebg 'source ~/scripts/rm_bg/bin/activate; python ~/scripts/remove_bg.py; deactivate'
    abbr javacall 'javac *.java'
    abbr clock 'peaclock blue'
    abbr tt 'tt -notheme -showwpm -n'
    abbr pipe 'bash /home/zach/Apps/pipes.sh/pipes.sh -t 0'
    abbr texclean 'find . -maxdepth 1 -type f ! -name "*.tex" ! -name "*.pdf" -exec rm -f {} \;'
    abbr checkra1n 'sudo ~/Apps/checkra1n'
    abbr beeper '~/Apps/beeper-3.106.2x86_64.AppImage'
    abbr timer 'uairctl'
    abbr term 'bash /home/zach/scripts/termdown.sh'
    abbr mail 'cmdg'
    abbr edex 'cd /home/zach/Apps/; ./eDEX-UI-Linux-x86_64.AppImage; cd'
    abbr yt 'gophertube'
    abbr rmt 'trash'
    abbr trash-empty 'sudo trash-empty'
    abbr shitpost 'bash ~/scripts/shitpost.sh'
    abbr p 'sudo pacman'
    abbr sus 'bash ~/scripts/suspend.sh'
    abbr balena './Apps/balenaEtcher-linux-x64/balena-etcher'
    abbr llc './Apps/LosslessCut-linux-x86_64.AppImage'
    abbr osu './Apps/osu.AppImage'
    abbr h './Apps/habitctl/target/release/habitctl'
    abbr bt 'bluetuith'
    abbr cal 'gcalcli'
    abbr mvn-new 'mvn archetype:generate -DgroupId=com.example -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false -DartifactId='
    abbr fastfetch 'fastfetch --logo-type none'
    # abbr config '/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
    abbr gpom 'git push origin main'
    abbr gp 'sudo gopro webcam -a -r 1080 -f linear'
    abbr wifi 'nmtui'
    abbr rsync 'rsync --progress'
    abbr landscape 'bash ~/scripts/landscape-gif.sh'
    abbr remind 'bash /home/zach/scripts/reminder.sh'
    abbr commit 'git commit -m'
    abbr nf 'nvim (fzf --tmux --height=90%)'
    # abbr fzf 'fzf --tmux --height=90%'
    abbr color 'bash -c "$(wget -qO- https://git.io/vQgMr)"'
    abbr com 'for cmd in (ls /usr/bin /bin /usr/local/bin); echo $cmd; end | fzf'
    # abbr nn '~/scripts/new_note.sh'
	abbr sn 'cd "/home/zach/Documents/Obsidian/schoolNotes/" ; set selected_file (fzf --tmux --height=90%) ; nvim $selected_file'
	abbr hn 'clx -n'
    abbr nvo 'cd "/home/zach/Documents/Obsidian/mainVault/" ; set selected_file (find . -type f -name "*.md" | fzf --tmux --height=90%) ; nvim $selected_file'
    abbr ts 'cd /home/zach/scripts/tmux-sessions/ && bash (fzf --tmux --height=90%)'
    abbr pk 'fzf-kill'
    abbr rm 'rm -I'
    # abbr tm 'timew'
    abbr tx 'tmux'
    # abbr tms 'timew summary :ids'
    abbr globe 'globe -sc5 -g20'
    abbr fl 'wine "/home/zach/.wine/dosdevices/c:/Program\ Files/Image-Line/FL\ Studio\ 20/FL.exe"'
    abbr ableton 'wine start /unix "/home/zach/.wine/dosdevices/c:/ProgramData/Ableton/Live 11 Suite/Program/Ableton Live 11 Suite.exe"'
    abbr orb 'bash /home/zach/scripts/org-roam-backup.sh '

end

# =============================================================================
# Custom Functions
# =============================================================================

# --- Environment File Loader ---
# Loads variables from ~/dotfiles/.env into the shell environment.
function loadenv
    if test -f ~/dotfiles/.env
        while read -la line
            if string match -qr '^[A-Z_]' -- $line
                set -l var (string split -m1 = -- $line)
                set -gx $var[1] $var[2]
            end
        end < ~/dotfiles/.env
    end
end

function __auto_loadenv --on-variable PWD
    if test -f ~/dotfiles/.env
        loadenv
    end
end


# --- Zoxide (Smart Directory Jumper) ---
# ⚠ NOTE: This appears to be a hand-written/inlined version rather than
#   using `zoxide init fish | source`. Consider migrating to the official init.
#
# Utility functions for zoxide.
#

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd
    builtin pwd -L
end

# A copy of fish's internal cd function. This makes it possible to use
# `alias cd=z` without causing an infinite loop.
if ! builtin functions --query __zoxide_cd_internal
    if builtin functions --query cd
        builtin functions --copy cd __zoxide_cd_internal
    else
        alias __zoxide_cd_internal='builtin cd'
    end
end

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd
    __zoxide_cd_internal $argv
end

# =============================================================================
#
# Hook configuration for zoxide.
#

# Initialize hook to add new entries to the database.
function __zoxide_hook --on-variable PWD
    test -z "$fish_private_mode"
    and command zoxide add -- (__zoxide_pwd)
end

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

if test -z $__zoxide_z_prefix
    set __zoxide_z_prefix 'z!'
end
set __zoxide_z_prefix_regex ^(string escape --style=regex $__zoxide_z_prefix)

# Jump to a directory using only keywords.
function __zoxide_z
    set -l argc (count $argv)
    if test $argc -eq 0
        __zoxide_cd $HOME
    else if test "$argv" = -
        __zoxide_cd -
    else if test $argc -eq 1 -a -d $argv[1]
        __zoxide_cd $argv[1]
    else if set -l result (string replace --regex $__zoxide_z_prefix_regex '' $argv[-1]); and test -n $result
        __zoxide_cd $result
    else
        set -l result (command zoxide query --exclude (__zoxide_pwd) -- $argv)
        and __zoxide_cd $result
    end
end

# Completions.
function __zoxide_z_complete
    set -l tokens (commandline --current-process --tokenize)
    set -l curr_tokens (commandline --cut-at-cursor --current-process --tokenize)

    if test (count $tokens) -le 2 -a (count $curr_tokens) -eq 1
        # If there are < 2 arguments, use `cd` completions.
        complete --do-complete "'' "(commandline --cut-at-cursor --current-token) | string match --regex '.*/$'
    else if test (count $tokens) -eq (count $curr_tokens); and ! string match --quiet --regex $__zoxide_z_prefix_regex. $tokens[-1]
        # If the last argument is empty and the one before doesn't start with
        # $__zoxide_z_prefix, use interactive selection.
        set -l query $tokens[2..-1]
        set -l result (zoxide query --exclude (__zoxide_pwd) --interactive -- $query)
        and echo $__zoxide_z_prefix$result
        commandline --function repaint
    end
end
complete --command __zoxide_z --no-files --arguments '(__zoxide_z_complete)'

# Jump to a directory using interactive search.
function __zoxide_zi
    set -l result (command zoxide query --interactive -- $argv)
    and __zoxide_cd $result
end

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

abbr --erase cd &>/dev/null
alias cd=__zoxide_z

abbr --erase cdi &>/dev/null
alias cdi=__zoxide_zi

# =============================================================================
#
# To initialize zoxide, add this to your configuration (usually
# ~/.config/fish/config.fish):
#
#   zoxide init fish | source



# --- The Fuck (Command Correction) ---
thefuck --alias | source
# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.

# --- Tod CLI — Completion Helpers ---
# ⚠ DUPLICATE: __fish_tod_needs_command and __fish_tod_global_optspecs are also
#   defined in completions/tod.fish (which also defines __fish_tod_using_subcommand).
#   Consider removing these from config.fish and relying on the completions file.
function __fish_tod_global_optspecs
	string join \n v/verbose c/config= t/timeout= h/help V/version
end

function __fish_tod_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_tod_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

# --- Atuin Shell History ---
# Provides fuzzy history search (Ctrl+R), history sync, and stats.
set -gx ATUIN_SESSION (atuin uuid)
set --erase ATUIN_HISTORY_ID

function _atuin_preexec --on-event fish_preexec
    if not test -n "$fish_private_mode"
        set -g ATUIN_HISTORY_ID (atuin history start -- "$argv[1]")
    end
end

function _atuin_postexec --on-event fish_postexec
    set -l s $status

    if test -n "$ATUIN_HISTORY_ID"
        ATUIN_LOG=error atuin history end --exit $s -- $ATUIN_HISTORY_ID &>/dev/null &
        disown
    end

    set --erase ATUIN_HISTORY_ID
end

function _atuin_search
    set -l keymap_mode
    switch $fish_key_bindings
        case fish_vi_key_bindings
            switch $fish_bind_mode
                case default
                    set keymap_mode vim-normal
                case insert
                    set keymap_mode vim-insert
            end
        case '*'
            set keymap_mode emacs
    end

    # In fish 3.4 and above we can use `"$(some command)"` to keep multiple lines separate;
    # but to support fish 3.3 we need to use `(some command | string collect)`.
    # https://fishshell.com/docs/current/relnotes.html#id24 (fish 3.4 "Notable improvements and fixes")
    set -l ATUIN_H (ATUIN_SHELL_FISH=t ATUIN_LOG=error ATUIN_QUERY=(commandline -b) atuin search --keymap-mode=$keymap_mode $argv -i 3>&1 1>&2 2>&3 | string collect)

    if test -n "$ATUIN_H"
        if string match --quiet '__atuin_accept__:*' "$ATUIN_H"
          set -l ATUIN_HIST (string replace "__atuin_accept__:" "" -- "$ATUIN_H" | string collect)
          commandline -r "$ATUIN_HIST"
          commandline -f repaint
          commandline -f execute
          return
        else if string match --quiet '__atuin_chain_command__:*' "$ATUIN_H"
          set -l new_command (string replace "__atuin_chain_command__:" "" -- "$ATUIN_H" | string collect)
          set -l current_command (commandline -b)
          commandline -r "$current_command $new_command"
        else
          commandline -r "$ATUIN_H"
        end
    end

    commandline -f repaint
end

function _atuin_bind_up
    # Fallback to fish's builtin up-or-search if we're in search or paging mode
    if commandline --search-mode; or commandline --paging-mode
        up-or-search
        return
    end

    # Only invoke atuin if we're on the top line of the command
    set -l lineno (commandline --line)

    switch $lineno
        case 1
            _atuin_search --shell-up-key-binding
        case '*'
            up-or-search
    end
end

bind \cr _atuin_search
if bind -M insert > /dev/null 2>&1
bind -M insert \cr _atuin_search
end

# --- Instagram CLI — Completions (auto-generated) ---
complete --command instagram --no-files --arguments "(env _INSTAGRAM_COMPLETE=complete_fish _TYPER_COMPLETE_FISH_ACTION=get-args _TYPER_COMPLETE_ARGS=(commandline -cp) instagram)" --condition "env _INSTAGRAM_COMPLETE=complete_fish _TYPER_COMPLETE_FISH_ACTION=is-args _TYPER_COMPLETE_ARGS=(commandline -cp) instagram"
# --- Hyprdynamicmonitors — Completions (auto-generated) ---


function __hyprdynamicmonitors_debug
    set -l file "$BASH_COMP_DEBUG_FILE"
    if test -n "$file"
        echo "$argv" >> $file
    end
end

function __hyprdynamicmonitors_perform_completion
    __hyprdynamicmonitors_debug "Starting __hyprdynamicmonitors_perform_completion"

    # Extract all args except the last one
    set -l args (commandline -opc)
    # Extract the last arg and escape it in case it is a space
    set -l lastArg (string escape -- (commandline -ct))

    __hyprdynamicmonitors_debug "args: $args"
    __hyprdynamicmonitors_debug "last arg: $lastArg"

    # Disable ActiveHelp which is not supported for fish shell
    set -l requestComp "HYPRDYNAMICMONITORS_ACTIVE_HELP=0 $args[1] __complete $args[2..-1] $lastArg"

    __hyprdynamicmonitors_debug "Calling $requestComp"
    set -l results (eval $requestComp 2> /dev/null)

    # Some programs may output extra empty lines after the directive.
    # Let's ignore them or else it will break completion.
    # Ref: https://github.com/spf13/cobra/issues/1279
    for line in $results[-1..1]
        if test (string trim -- $line) = ""
            # Found an empty line, remove it
            set results $results[1..-2]
        else
            # Found non-empty line, we have our proper output
            break
        end
    end

    set -l comps $results[1..-2]
    set -l directiveLine $results[-1]

    # For Fish, when completing a flag with an = (e.g., <program> -n=<TAB>)
    # completions must be prefixed with the flag
    set -l flagPrefix (string match -r -- '-.*=' "$lastArg")

    __hyprdynamicmonitors_debug "Comps: $comps"
    __hyprdynamicmonitors_debug "DirectiveLine: $directiveLine"
    __hyprdynamicmonitors_debug "flagPrefix: $flagPrefix"

    for comp in $comps
        printf "%s%s\n" "$flagPrefix" "$comp"
    end

    printf "%s\n" "$directiveLine"
end

# this function limits calls to __hyprdynamicmonitors_perform_completion, by caching the result behind $__hyprdynamicmonitors_perform_completion_once_result
function __hyprdynamicmonitors_perform_completion_once
    __hyprdynamicmonitors_debug "Starting __hyprdynamicmonitors_perform_completion_once"

    if test -n "$__hyprdynamicmonitors_perform_completion_once_result"
        __hyprdynamicmonitors_debug "Seems like a valid result already exists, skipping __hyprdynamicmonitors_perform_completion"
        return 0
    end

    set --global __hyprdynamicmonitors_perform_completion_once_result (__hyprdynamicmonitors_perform_completion)
    if test -z "$__hyprdynamicmonitors_perform_completion_once_result"
        __hyprdynamicmonitors_debug "No completions, probably due to a failure"
        return 1
    end

    __hyprdynamicmonitors_debug "Performed completions and set __hyprdynamicmonitors_perform_completion_once_result"
    return 0
end

# this function is used to clear the $__hyprdynamicmonitors_perform_completion_once_result variable after completions are run
function __hyprdynamicmonitors_clear_perform_completion_once_result
    __hyprdynamicmonitors_debug ""
    __hyprdynamicmonitors_debug "========= clearing previously set __hyprdynamicmonitors_perform_completion_once_result variable =========="
    set --erase __hyprdynamicmonitors_perform_completion_once_result
    __hyprdynamicmonitors_debug "Successfully erased the variable __hyprdynamicmonitors_perform_completion_once_result"
end

function __hyprdynamicmonitors_requires_order_preservation
    __hyprdynamicmonitors_debug ""
    __hyprdynamicmonitors_debug "========= checking if order preservation is required =========="

    __hyprdynamicmonitors_perform_completion_once
    if test -z "$__hyprdynamicmonitors_perform_completion_once_result"
        __hyprdynamicmonitors_debug "Error determining if order preservation is required"
        return 1
    end

    set -l directive (string sub --start 2 $__hyprdynamicmonitors_perform_completion_once_result[-1])
    __hyprdynamicmonitors_debug "Directive is: $directive"

    set -l shellCompDirectiveKeepOrder 32
    set -l keeporder (math (math --scale 0 $directive / $shellCompDirectiveKeepOrder) % 2)
    __hyprdynamicmonitors_debug "Keeporder is: $keeporder"

    if test $keeporder -ne 0
        __hyprdynamicmonitors_debug "This does require order preservation"
        return 0
    end

    __hyprdynamicmonitors_debug "This doesn't require order preservation"
    return 1
end


# This function does two things:
# - Obtain the completions and store them in the global __hyprdynamicmonitors_comp_results
# - Return false if file completion should be performed
function __hyprdynamicmonitors_prepare_completions
    __hyprdynamicmonitors_debug ""
    __hyprdynamicmonitors_debug "========= starting completion logic =========="

    # Start fresh
    set --erase __hyprdynamicmonitors_comp_results

    __hyprdynamicmonitors_perform_completion_once
    __hyprdynamicmonitors_debug "Completion results: $__hyprdynamicmonitors_perform_completion_once_result"

    if test -z "$__hyprdynamicmonitors_perform_completion_once_result"
        __hyprdynamicmonitors_debug "No completion, probably due to a failure"
        # Might as well do file completion, in case it helps
        return 1
    end

    set -l directive (string sub --start 2 $__hyprdynamicmonitors_perform_completion_once_result[-1])
    set --global __hyprdynamicmonitors_comp_results $__hyprdynamicmonitors_perform_completion_once_result[1..-2]

    __hyprdynamicmonitors_debug "Completions are: $__hyprdynamicmonitors_comp_results"
    __hyprdynamicmonitors_debug "Directive is: $directive"

    set -l shellCompDirectiveError 1
    set -l shellCompDirectiveNoSpace 2
    set -l shellCompDirectiveNoFileComp 4
    set -l shellCompDirectiveFilterFileExt 8
    set -l shellCompDirectiveFilterDirs 16

    if test -z "$directive"
        set directive 0
    end

    set -l compErr (math (math --scale 0 $directive / $shellCompDirectiveError) % 2)
    if test $compErr -eq 1
        __hyprdynamicmonitors_debug "Received error directive: aborting."
        # Might as well do file completion, in case it helps
        return 1
    end

    set -l filefilter (math (math --scale 0 $directive / $shellCompDirectiveFilterFileExt) % 2)
    set -l dirfilter (math (math --scale 0 $directive / $shellCompDirectiveFilterDirs) % 2)
    if test $filefilter -eq 1; or test $dirfilter -eq 1
        __hyprdynamicmonitors_debug "File extension filtering or directory filtering not supported"
        # Do full file completion instead
        return 1
    end

    set -l nospace (math (math --scale 0 $directive / $shellCompDirectiveNoSpace) % 2)
    set -l nofiles (math (math --scale 0 $directive / $shellCompDirectiveNoFileComp) % 2)

    __hyprdynamicmonitors_debug "nospace: $nospace, nofiles: $nofiles"

    # If we want to prevent a space, or if file completion is NOT disabled,
    # we need to count the number of valid completions.
    # To do so, we will filter on prefix as the completions we have received
    # may not already be filtered so as to allow fish to match on different
    # criteria than the prefix.
    if test $nospace -ne 0; or test $nofiles -eq 0
        set -l prefix (commandline -t | string escape --style=regex)
        __hyprdynamicmonitors_debug "prefix: $prefix"

        set -l completions (string match -r -- "^$prefix.*" $__hyprdynamicmonitors_comp_results)
        set --global __hyprdynamicmonitors_comp_results $completions
        __hyprdynamicmonitors_debug "Filtered completions are: $__hyprdynamicmonitors_comp_results"

        # Important not to quote the variable for count to work
        set -l numComps (count $__hyprdynamicmonitors_comp_results)
        __hyprdynamicmonitors_debug "numComps: $numComps"

        if test $numComps -eq 1; and test $nospace -ne 0
            # We must first split on \t to get rid of the descriptions to be
            # able to check what the actual completion will be.
            # We don't need descriptions anyway since there is only a single
            # real completion which the shell will expand immediately.
            set -l split (string split --max 1 \t $__hyprdynamicmonitors_comp_results[1])

            # Fish won't add a space if the completion ends with any
            # of the following characters: @=/:.,
            set -l lastChar (string sub -s -1 -- $split)
            if not string match -r -q "[@=/:.,]" -- "$lastChar"
                # In other cases, to support the "nospace" directive we trick the shell
                # by outputting an extra, longer completion.
                __hyprdynamicmonitors_debug "Adding second completion to perform nospace directive"
                set --global __hyprdynamicmonitors_comp_results $split[1] $split[1].
                __hyprdynamicmonitors_debug "Completions are now: $__hyprdynamicmonitors_comp_results"
            end
        end

        if test $numComps -eq 0; and test $nofiles -eq 0
            # To be consistent with bash and zsh, we only trigger file
            # completion when there are no other completions
            __hyprdynamicmonitors_debug "Requesting file completion"
            return 1
        end
    end

    return 0
end

# Since Fish completions are only loaded once the user triggers them, we trigger them ourselves
# so we can properly delete any completions provided by another script.
# Only do this if the program can be found, or else fish may print some errors; besides,
# the existing completions will only be loaded if the program can be found.
if type -q "hyprdynamicmonitors"
    # The space after the program name is essential to trigger completion for the program
    # and not completion of the program name itself.
    # Also, we use '> /dev/null 2>&1' since '&>' is not supported in older versions of fish.
    complete --do-complete "hyprdynamicmonitors " > /dev/null 2>&1
end

# Remove any pre-existing completions for the program since we will be handling all of them.
complete -c hyprdynamicmonitors -e

# this will get called after the two calls below and clear the $__hyprdynamicmonitors_perform_completion_once_result global
complete -c hyprdynamicmonitors -n '__hyprdynamicmonitors_clear_perform_completion_once_result'
# The call to __hyprdynamicmonitors_prepare_completions will setup __hyprdynamicmonitors_comp_results
# which provides the program's completion choices.
# If this doesn't require order preservation, we don't use the -k flag
complete -c hyprdynamicmonitors -n 'not __hyprdynamicmonitors_requires_order_preservation && __hyprdynamicmonitors_prepare_completions' -f -a '$__hyprdynamicmonitors_comp_results'
# otherwise we use the -k flag
complete -k -c hyprdynamicmonitors -n '__hyprdynamicmonitors_requires_order_preservation && __hyprdynamicmonitors_prepare_completions' -f -a '$__hyprdynamicmonitors_comp_results'


# --- Load Environment from .env ---
loadenv


# --- Timetrace — Completions (auto-generated) ---

function __timetrace_debug
    set -l file "$BASH_COMP_DEBUG_FILE"
    if test -n "$file"
        echo "$argv" >> $file
    end
end

function __timetrace_perform_completion
    __timetrace_debug "Starting __timetrace_perform_completion"

    # Extract all args except the last one
    set -l args (commandline -opc)
    # Extract the last arg and escape it in case it is a space
    set -l lastArg (string escape -- (commandline -ct))

    __timetrace_debug "args: $args"
    __timetrace_debug "last arg: $lastArg"

    set -l requestComp "$args[1] __complete $args[2..-1] $lastArg"

    __timetrace_debug "Calling $requestComp"
    set -l results (eval $requestComp 2> /dev/null)

    # Some programs may output extra empty lines after the directive.
    # Let's ignore them or else it will break completion.
    # Ref: https://github.com/spf13/cobra/issues/1279
    for line in $results[-1..1]
        if test (string trim -- $line) = ""
            # Found an empty line, remove it
            set results $results[1..-2]
        else
            # Found non-empty line, we have our proper output
            break
        end
    end

    set -l comps $results[1..-2]
    set -l directiveLine $results[-1]

    # For Fish, when completing a flag with an = (e.g., <program> -n=<TAB>)
    # completions must be prefixed with the flag
    set -l flagPrefix (string match -r -- '-.*=' "$lastArg")

    __timetrace_debug "Comps: $comps"
    __timetrace_debug "DirectiveLine: $directiveLine"
    __timetrace_debug "flagPrefix: $flagPrefix"

    for comp in $comps
        printf "%s%s\n" "$flagPrefix" "$comp"
    end

    printf "%s\n" "$directiveLine"
end

# This function does two things:
# - Obtain the completions and store them in the global __timetrace_comp_results
# - Return false if file completion should be performed
function __timetrace_prepare_completions
    __timetrace_debug ""
    __timetrace_debug "========= starting completion logic =========="

    # Start fresh
    set --erase __timetrace_comp_results

    set -l results (__timetrace_perform_completion)
    __timetrace_debug "Completion results: $results"

    if test -z "$results"
        __timetrace_debug "No completion, probably due to a failure"
        # Might as well do file completion, in case it helps
        return 1
    end

    set -l directive (string sub --start 2 $results[-1])
    set --global __timetrace_comp_results $results[1..-2]

    __timetrace_debug "Completions are: $__timetrace_comp_results"
    __timetrace_debug "Directive is: $directive"

    set -l shellCompDirectiveError 1
    set -l shellCompDirectiveNoSpace 2
    set -l shellCompDirectiveNoFileComp 4
    set -l shellCompDirectiveFilterFileExt 8
    set -l shellCompDirectiveFilterDirs 16

    if test -z "$directive"
        set directive 0
    end

    set -l compErr (math (math --scale 0 $directive / $shellCompDirectiveError) % 2)
    if test $compErr -eq 1
        __timetrace_debug "Received error directive: aborting."
        # Might as well do file completion, in case it helps
        return 1
    end

    set -l filefilter (math (math --scale 0 $directive / $shellCompDirectiveFilterFileExt) % 2)
    set -l dirfilter (math (math --scale 0 $directive / $shellCompDirectiveFilterDirs) % 2)
    if test $filefilter -eq 1; or test $dirfilter -eq 1
        __timetrace_debug "File extension filtering or directory filtering not supported"
        # Do full file completion instead
        return 1
    end

    set -l nospace (math (math --scale 0 $directive / $shellCompDirectiveNoSpace) % 2)
    set -l nofiles (math (math --scale 0 $directive / $shellCompDirectiveNoFileComp) % 2)

    __timetrace_debug "nospace: $nospace, nofiles: $nofiles"

    # If we want to prevent a space, or if file completion is NOT disabled,
    # we need to count the number of valid completions.
    # To do so, we will filter on prefix as the completions we have received
    # may not already be filtered so as to allow fish to match on different
    # criteria than the prefix.
    if test $nospace -ne 0; or test $nofiles -eq 0
        set -l prefix (commandline -t | string escape --style=regex)
        __timetrace_debug "prefix: $prefix"

        set -l completions (string match -r -- "^$prefix.*" $__timetrace_comp_results)
        set --global __timetrace_comp_results $completions
        __timetrace_debug "Filtered completions are: $__timetrace_comp_results"

        # Important not to quote the variable for count to work
        set -l numComps (count $__timetrace_comp_results)
        __timetrace_debug "numComps: $numComps"

        if test $numComps -eq 1; and test $nospace -ne 0
            # We must first split on \t to get rid of the descriptions to be
            # able to check what the actual completion will be.
            # We don't need descriptions anyway since there is only a single
            # real completion which the shell will expand immediately.
            set -l split (string split --max 1 \t $__timetrace_comp_results[1])

            # Fish won't add a space if the completion ends with any
            # of the following characters: @=/:.,
            set -l lastChar (string sub -s -1 -- $split)
            if not string match -r -q "[@=/:.,]" -- "$lastChar"
                # In other cases, to support the "nospace" directive we trick the shell
                # by outputting an extra, longer completion.
                __timetrace_debug "Adding second completion to perform nospace directive"
                set --global __timetrace_comp_results $split[1] $split[1].
                __timetrace_debug "Completions are now: $__timetrace_comp_results"
            end
        end

        if test $numComps -eq 0; and test $nofiles -eq 0
            # To be consistent with bash and zsh, we only trigger file
            # completion when there are no other completions
            __timetrace_debug "Requesting file completion"
            return 1
        end
    end

    return 0
end

# Since Fish completions are only loaded once the user triggers them, we trigger them ourselves
# so we can properly delete any completions provided by another script.
# Only do this if the program can be found, or else fish may print some errors; besides,
# the existing completions will only be loaded if the program can be found.
if type -q "timetrace"
    # The space after the program name is essential to trigger completion for the program
    # and not completion of the program name itself.
    # Also, we use '> /dev/null 2>&1' since '&>' is not supported in older versions of fish.
    complete --do-complete "timetrace " > /dev/null 2>&1
end

# Remove any pre-existing completions for the program since we will be handling all of them.
complete -c timetrace -e

# The call to __timetrace_prepare_completions will setup __timetrace_comp_results
# which provides the program's completion choices.
complete -c timetrace -n '__timetrace_prepare_completions' -f -a '$__timetrace_comp_results'



complete -c yt-x --no-files --arguments "completions" --condition 'not __fish_contains_opt sort-by S e edit-config s preferred-selector  E generate-desktop-entry rofi-theme'
# --- yt-x — Completions (auto-generated) ---

complete -c yt-x --no-files --short-option h --long-option help --description 'Print a short help text and exit'
complete -c yt-x --no-files --short-option v --long-option version --description 'Print a short version string and exit' --condition 'not __fish_seen_subcommand_from completions'

complete -c yt-x --no-files --short-option e --long-option edit-config --description 'Edit yt-x config file' --condition 'not __fish_seen_subcommand_from completions'
complete -c yt-x --no-files --short-option U --long-option update --description 'update the script' --condition 'not __fish_seen_subcommand_from completions'
complete -c yt-x --no-files --short-option p --long-option player --description 'the video player to use' --condition 'not __fish_seen_subcommand_from completions' --exclusive --arguments 'mpv vlc'
complete -c yt-x --no-files --short-option x --long-option extension --description 'The extension to use' --condition 'not __fish_seen_subcommand_from completions' --exclusive --arguments "(command ls /home/zach/.config/yt-x/extensions)"
complete -c yt-x --no-files --short-option s --long-option preferred-selector --description 'your preferred selector' --condition 'not __fish_seen_subcommand_from completions' --exclusive --arguments 'fzf rofi'
complete -c yt-x --no-files --short-option E --long-option generate-desktop-entry --description 'generate desktop entry info' --condition 'not __fish_seen_subcommand_from completions' 

complete -c yt-x --no-files --long-option preview --description 'enable preview window' --condition 'not __fish_seen_subcommand_from completions' 
complete -c yt-x --no-files --long-option no-preview --description 'disable preview window' --condition 'not __fish_seen_subcommand_from completions' 

complete -c yt-x --force-files --long-option rofi-theme --description 'the path to your rofi config file' --condition 'not __fish_seen_subcommand_from completions' 

complete -c yt-x --no-files --short-option S --long-option search --description 'the terms you want to search' --condition 'not __fish_seen_subcommand_from completions' 

complete -c yt-x --no-files --short-option z --long-option zsh --description 'print zsh completions' --condition '__fish_seen_subcommand_from completions'
complete -c yt-x --no-files --short-option b --long-option bash --description 'print bash completions' --condition '__fish_seen_subcommand_from completions'
complete -c yt-x --no-files --short-option f --long-option fish --description 'print fish completions' --condition '__fish_seen_subcommand_from completions'
# --- Fish Behavior Tweaks ---
# Disable autosuggestions (set universally, persists across sessions)
set -U fish_autosuggestion_enabled 0

