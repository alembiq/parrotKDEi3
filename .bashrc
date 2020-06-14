case $- in
    *i*) ;;
      *) return;;
esac

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/share/games:/usr/local/sbin:/usr/sbin:/sbin:~/.local/bin:/snap/bin:$PATH

if [ -f ~/.xinitrc ]; then
       bash ~/.xinitrc
fi

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE= HISTFILESIZE=

prompt_k8s(){
	k8s_current_context=$(kubectl config current-context 2> /dev/null)
	if [[ $? -eq 0 ]] ; then echo -e " [k8s ${k8s_current_context}]"; fi
}
shopt -s checkwinsize
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi
if [[ ${EUID} == 0 ]] ; then #root
	export        PS1='${debian_chroot:+($debian_chroot)}'${PROMPT_datetime}' \[\033[01;31m\]\h\[\033[00m\] '${PROMPT_path}'\[\033[00m\]$(__git_ps1)\[\033[00m\] '${PROMPT_sign}' '
else # user
	export        PS1='${debian_chroot:+($debian_chroot)}'${PROMPT_datetime}' \[\033[01;32m\]\u@\h\[\033[00m\] '${PROMPT_path}'\[\033[00m\]$(__git_ps1)\[\033[00m\] '${PROMPT_sign}' '
fi
if [ "$color_prompt" = yes ]; then
	man() {
	env \
	LESS_TERMCAP_mb=$'\e[01;31m' \
	LESS_TERMCAP_md=$'\e[01;31m' \
	LESS_TERMCAP_me=$'\e[0m' \
	LESS_TERMCAP_se=$'\e[0m' \
	LESS_TERMCAP_so=$'\e[01;44;33m' \
	LESS_TERMCAP_ue=$'\e[0m' \
	LESS_TERMCAP_us=$'\e[01;32m' \
	man "$@"
	}
fi

unset color_prompt force_color_prompt

case "$TERM" in
xterm*|rxvt*)
        PROMPT_datetime="\[\033[01;34m\]\D{%d/%m/%Y} \t"
        PROMPT_path="\[\033[01;37m\]\w"
        PROMPT_sign="\[\033[01;34m\]\$\[\033[00m\]"
               if [[ ${EUID} == 0 ]] ; then #root
                        export        PS1='${debian_chroot:+($debian_chroot)}'${PROMPT_datetime}' \[\033[01;31m\]\h\[\033[00m\] '${PROMPT_path}'\[\033[00m\]$(__git_ps1)\[\033[00m\]$(prompt_k8s) '${PROMPT_sign}' '
                else # user
                        export        PS1='${debian_chroot:+($debian_chroot)}'${PROMPT_datetime}' \[\033[01;32m\]\u@\h\[\033[00m\] '${PROMPT_path}'\[\033[33m\]$(__git_ps1)\[\033[00m\]$(prompt_k8s) '${PROMPT_sign}' '
                fi
    ;;
*)
    ;;
esac

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi


if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -f ./usr/bin/kubectl ]; then
	source <(kubectl completion bash)
fi
