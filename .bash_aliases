alias dd='dd status=progress'
if [ -f /usr/bin/htop ]; then alias top='htop'; fi
if [ -f /usr/bin/neomutt ]; then alias mutt="neomutt"; fi
alias sudo-git="sudo SSH_AUTH_SOCK=$SSH_AUTH_SOCK git "
alias ll='ls -alF'
alias df='df -h --exclude-type=tmpfs --exclude-type=devtmpfs | grep -v /snap/'
alias free='free -h'
alias du='du -h'
alias ping='ping -D'
alias disableIPv6='sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1'
alias scratchpad-mutt='cd ~/Downloads && konsole -p tabtitle='neomuttScratchpad' -e neomutt &'
alias scratchpad-konsole='konsole -p tabtitle='konsoleScratchpad' &'
alias update-ttrss='ssh eir "(cd /srv/net.alembiq.reader/tt-rss/ ; git pull)"'
alias mutt-local='sudo mutt -f /var/mail/mail'
if [ -f /usr/bin/highlight ]; then alias cat='highlight --force --out-format=ansi'; fi
alias charge-battery='sudo tlp fullcharge'

if [ -f /usr/bin/docker ]; then
	alias docker-cleanup='echo "cleaning sys images"; docker system prune -a -f; echo "cleaning volumes"; docker volume prune -f' 
	alias docker-cleanup-volumes='docker volume prune -f'
	alias docker-cleanup-images='docker system prune -a -f'
	alias docker-killall='for i in $(docker ps|cut -d\  -f1|grep -v CON); do docker kill ${i} ; done'
fi


