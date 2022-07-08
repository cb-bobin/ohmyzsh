function git_branch {
        git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}


# time [red]
time() {
   echo "%{$fg[red]%}%*%{$reset_color%}"
}

# username [green]
username() {
   echo "%{$fg[green]%}%n%{$reset_color%}"
}

# host name [green]
host() {
   echo "%{$fg[green]%}%m%{$reset_color%}"
}

# current directory, two levels deep
directory() {
   echo "%2~"
}

# returns 👾 if there are errors, nothing otherwise
return_status() {
   echo "%(?..👾)"
}

# current time with milliseconds
current_time() {
   echo "%{$fg[red]%}%*%{$reset_color%}"
}

# prompt right arrow green
green_arrow() {
   echo "%{$fg[green]%}▶ %{$reset_color%}"
}

japanese_secret() {
   echo "%{$fg[cyan]%}㊙%{$reset_color%}"
}

function preexec() {
  cmd_start=$(($(print -P %D{%s%6.}) / 1000))
}

function precmd() {
  if [ $cmd_start ]; then
    local now=$(($(print -P %D{%s%6.}) / 1000))
    local d_ms=$(($now - $cmd_start))
    local d_s=$((d_ms / 1000))
    local ms=$((d_ms % 1000))
    local s=$((d_s % 60))
    local m=$(((d_s / 60) % 60))
    local h=$((d_s / 3600))

    if   ((h > 0)); then cmd_time=${h}h${m}m
    elif ((m > 0)); then cmd_time=${m}m${s}s
    elif ((s > 9)); then cmd_time=${s}.$(printf %03d $ms | cut -c1-2)s # 12.34s
    elif ((s > 0)); then cmd_time=${s}.$(printf %03d $ms)s # 1.234s
    else cmd_time=${ms}ms
    fi

    unset cmd_start
  else
    # Clear previous result when hitting Return with no command to execute
    unset cmd_time
  fi
}

exec_time() {
   echo "%{$fg[cyan]%}$(if [ $cmd_time ]; then echo "$cmd_time"; fi)%{$reset_color%}"
}


PROMPT='$(japanese_secret) %F{003}$(directory) %S$(git_branch)%s %{$reset_color%}
$(green_arrow)'

#RPROMPT='$(return_status) $(current_time) $(username)'
RPROMPT='$(return_status) $(exec_time) $(current_time) $(username)'


#PROMPT='%{$fg[red]%}%*%{$reset_color%} %{$fg[green]%}%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}%F{003} %1~ $(git_branch) %{$reset_color%}
#%{$fg[green]%}▶ %{$reset_color%}'
#RPROMPT='%(?.✔.%{$fg[red]%}✘%f)'
