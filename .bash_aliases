if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
alias dd='dd status=progress'
if [ -f /usr/bin/htop ]; then alias top='htop'; fi
if [ -f /usr/bin/neomutt ]; then alias mutt="neomutt"; fi
alias sudo-git="sudo SSH_AUTH_SOCK=$SSH_AUTH_SOCK git "
alias ll='ls -alF'
alias mutt='$HOME/.config/env ; neomutt'
alias df='df -h --exclude-type=tmpfs --exclude-type=devtmpfs | grep -v /snap/'
alias free='free -h'
alias diff='diff --color=always'
alias du='du -h'
alias abook='abook -C ~/.config/abook/abookrc --datafile ~/.config/abook/addressbook'
alias ping='ping -D'
alias disableIPv6='sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1'
alias scratchpad-mutt='$HOME/.config/env && konsole -p tabtitle='neomuttScratchpad' --workdir $HOME/Downloads -e neomutt &'
alias scratchpad-konsole='konsole -p tabtitle='konsoleScratchpad' &'
alias update-ttrss='ssh eir "(cd /srv/net.alembiq.reader/tt-rss/ ; git pull)"'
alias mutt-local='sudo mutt -f /var/mail/mail'
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias grep='grep --color=auto'
if [ -f /usr/bin/highlight ]; then alias cat='highlight --force --out-format=ansi'; fi
if [ -f /usr/bin/docker ]; then
	alias docker-cleanup='echo "cleaning sys images"; docker system prune -a -f; echo "cleaning volumes"; docker volume prune -f' 
	alias docker-cleanup-volumes='docker volume prune -f'
	alias docker-cleanup-images='docker system prune -a -f'
	alias docker-killall='for i in $(docker ps|cut -d\  -f1|grep -v CON); do docker kill ${i} ; done'
fi
alias kde-menu="kquitapp5 plasmashell && kstart5 plasmashell"
alias mbsync='mbsync -c $XDG_CONFIG_HOME/mbsyncrc'
alias wget='wget --hsts-file=$XDG_CACHE_HOME/wget-hsts'
alias wwan-online='cd $HOME/.local/lib/xmm7360-pci; make; make load; sudo python3 rpc/open_xdatachannel.py -r --apn internet'
