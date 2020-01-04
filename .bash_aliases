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
alias scratchpadmutt='konsole -p tabtitle='neomuttScratchpad' -e neomutt &'
alias scratchpadkonsole='konsole -p tabtitle='konsoleScratchpad' &'

if [ -f /usr/bin/docker ]; then
	alias docker-cleanup='echo "cleaning sys images"; docker system prune -a -f; echo "cleaning volumes"; docker volume prune -f' 
	alias docker-cleanup-volumes='docker volume prune -f'
	alias docker-cleanup-images='docker system prune -a -f'
	alias docker-killall='for i in $(docker ps|cut -d\  -f1|grep -v CON); do docker kill ${i} ; done'
fi


