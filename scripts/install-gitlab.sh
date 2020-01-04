#!/usr/bin/env bash
# https://docs.gitlab.com/ce/install/installation.html

apt-get install -y build-essential zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libre2-dev \
  libreadline-dev libncurses5-dev libffi-dev curl openssh-server libxml2-dev \
  libxslt1-dev libcurl4-openssl-dev libicu-dev logrotate rsync python-docutils pkg-config cmake \
  runit postfix gettext # checkinstall

apt-get remove git-core
apt-get install -y libcurl4-openssl-dev libexpat1-dev gettext libz-dev libssl-dev build-essential
cd /tmp
curl --silent --show-error --location https://ftp.pcre.org/pub/pcre/pcre2-10.33.tar.gz --output pcre2.tar.gz
tar -xzf pcre2.tar.gz
cd pcre2-10.33
chmod +x configure
./configure --prefix=/usr --enable-jit
make
make install
cd /tmp
curl --remote-name --location --progress https://www.kernel.org/pub/software/scm/git/git-2.22.0.tar.gz
echo 'a4b7e4365bee43caa12a38d646d2c93743d755d1cea5eab448ffb40906c9da0b  git-2.22.0.tar.gz' | shasum -a256 -c - && tar -xzf git-2.22.0.tar.gz
cd git-2.22.0/
./configure --with-libpcre
make prefix=/usr/local all
sudo make prefix=/usr/local install


## RUBY
mkdir /tmp/ruby && cd /tmp/ruby
curl --remote-name --progress https://cache.ruby-lang.org/pub/ruby/2.6/ruby-2.6.3.tar.gz
echo '2347ed6ca5490a104ebd5684d2b9b5eefa6cd33c  ruby-2.6.3.tar.gz' | shasum -c - && tar xzf ruby-2.6.3.tar.gz
cd ruby-2.6.3
./configure --disable-install-rdoc
make
make install
gem install bundler --no-document --version '< 2'

## GO
curl --remote-name --progress https://dl.google.com/go/go1.11.10.linux-amd64.tar.gz
echo 'aefaa228b68641e266d1f23f1d95dba33f17552ba132878b65bb798ffa37e6d0  go1.11.10.linux-amd64.tar.gz' | shasum -a256 -c - && \
  tar -C /usr/local -xzf go1.11.10.linux-amd64.tar.gz
ln -sf /usr/local/go/bin/{go,godoc,gofmt} /usr/local/bin/
rm go1.11.10.linux-amd64.tar.gz

## NODE
curl --location https://deb.nodesource.com/setup_12.x | bash -
apt-get install -y nodejs
curl --silent --show-error https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-get update
apt-get install -y yarn

## USER
adduser --disabled-login --gecos 'GitLab' git

## DATABASE
apt-get install -y postgresql postgresql-client libpq-dev postgresql-contrib
sudo systemctl enable postgresql
sudo service postgresql start
sudo -u postgres psql -d template1 -c "CREATE USER git CREATEDB;"
sudo -u postgres psql -d template1 -c "CREATE EXTENSION IF NOT EXISTS pg_trgm;"
sudo -u postgres psql -d template1 -c "CREATE DATABASE gitlabhq_production OWNER git;"
sudo -u postgres psql -c "ALTER USER git WITH PASSWORD 'password';"


## REDIS
apt-get install -y redis-server
cp /etc/redis/redis.conf /etc/redis/redis.conf.orig
sed 's/^port .*/port 0/' /etc/redis/redis.conf.orig | tee /etc/redis/redis.conf￼
echo 'unixsocket /var/run/redis/redis.sock' | tee -a /etc/redis/redis.conf
echo 'unixsocketperm 770' | tee -a /etc/redis/redis.conf
mkdir -p /var/run/redis
chown redis:redis /var/run/redis
chmod 755 /var/run/redis
if [ -d /etc/tmpfiles.d ]; then
  echo 'd  /var/run/redis  0755  redis  redis  10d  -' | tee -a /etc/tmpfiles.d/redis.conf
fi
service redis-server restart
usermod -aG redis git

## GITLAB
cd /home/git
sudo -u git -H git clone https://gitlab.com/gitlab-org/gitlab-foss.git -b 12-5-stable gitlab
cd /home/git/gitlab
sudo -u git -H cp config/gitlab.yml.example config/gitlab.yml
sudo -u git -H editor config/gitlab.yml
sudo -u git -H cp config/secrets.yml.example config/secrets.yml
sudo -u git -H chmod 0600 config/secrets.yml
chown -R git log/
chown -R git tmp/
chmod -R u+rwX,go-w log/
chmod -R u+rwX tmp/
chmod -R u+rwX tmp/pids/
chmod -R u+rwX tmp/sockets/
sudo -u git -H mkdir -p public/uploads/
chmod 0700 public/uploads
chmod -R u+rwX builds/
chmod -R u+rwX shared/artifacts/
chmod -R ug+rwX shared/pages/
sudo -u git -H cp config/unicorn.rb.example config/unicorn.rb
sudo -u git -H cp config/initializers/rack_attack.rb.example config/initializers/rack_attack.rb
sudo -u git -H git config --global core.autocrlf input
sudo -u git -H git config --global gc.auto 0
sudo -u git -H git config --global repack.writeBitmaps true
sudo -u git -H git config --global receive.advertisePushOptions true
sudo -u git -H git config --global core.fsyncObjectFiles true
sudo -u git -H cp config/resque.yml.example config/resque.yml
#sudo -u git -H editor config/resque.yml
mv config/database.yml.postgresql config/database.yml
sudo -u git -H editor config/database.yml
sudo -u git -H chmod o-rwx config/database.yml

## BUNDLE
sudo -u git -H bundle install --deployment --without development test mysql aws kerberos
￼
## GITLAB SHELL
sudo -u git -H bundle exec rake gitlab:shell:install REDIS_URL=unix:/var/run/redis/redis.sock RAILS_ENV=production SKIP_STORAGE_VALIDATION=true
#sudo -u git -H editor /home/git/gitlab-shell/config.yml

##GITLAB WORKHORSE
sudo -u git -H bundle exec rake "gitlab:workhorse:install[/home/git/gitlab-workhorse]" RAILS_ENV=production

##GITLAB ELASTICSEARCH INDEXER
#sudo -u git -H bundle exec rake "gitlab:indexer:install[/home/git/gitlab-elasticsearch-indexer]" RAILS_ENV=production

##GITLAB PAGES
#cd /home/git
#sudo -u git -H git clone https://gitlab.com/gitlab-org/gitlab-pages.git
#cd gitlab-pages
#sudo -u git -H git checkout v$(</home/git/gitlab/GITLAB_PAGES_VERSION)
#sudo -u git -H make

## GITALY
cd /home/git/gitlab
sudo -u git -H bundle exec rake "gitlab:gitaly:install[/home/git/gitaly,/home/git/repositories]" RAILS_ENV=production
chmod 0700 /home/git/gitlab/tmp/sockets/private
chown git /home/git/gitlab/tmp/sockets/private
cd /home/git/gitaly
#bugfix tomas
cp -r _build/bin/ .

sudo -u git -H editor config.toml
gitlab_path=/home/git/gitlab
gitaly_path=/home/git/gitaly
sudo -u git -H sh -c "$gitlab_path/bin/daemon_with_pidfile $gitlab_path/tmp/pids/gitaly.pid \
  $gitaly_path/gitaly $gitaly_path/config.toml >> $gitlab_path/log/gitaly.log 2>&1 &"

## INITIALIZE
cd /home/git/gitlab
sudo -u git -H bundle exec rake gitlab:setup RAILS_ENV=production force=yes
cp lib/support/init.d/gitlab /etc/init.d/gitlab
update-rc.d gitlab defaults 21
cp lib/support/logrotate/gitlab /etc/logrotate.d/gitlab
sudo -u git -H bundle exec rake gitlab:env:info RAILS_ENV=production
sudo -u git -H bundle exec rake gettext:compile RAILS_ENV=production
sudo -u git -H yarn install --production --pure-lockfile
sudo -u git -H bundle exec rake gitlab:assets:compile RAILS_ENV=production NODE_ENV=production NO_SOURCEMAPS=true
service gitlab restart

## NGINX
# up to date version http://nginx.org/en/linux_packages.html#Debian
apt-get install -y nginx
cp lib/support/nginx/gitlab /etc/nginx/sites-available/gitlab
ln -s /etc/nginx/sites-available/gitlab /etc/nginx/sites-enabled/gitlab￼
sudo editor /etc/nginx/sites-available/gitlab
rm /etc/nginx/sites-enabled/default
nginx -t
service nginx restart

## APACHE
# https://gist.github.com/steve-todorov/4758707

# OMNIBUS
#curl -Lo gitlab-ce_12.5.1-ce.0_armhf.deb https://packages.gitlab.com/gitlab/raspberry-pi2/packages/raspbian/stretch/gitlab-ce_12.5.1-ce.0_armhf.deb/download.deb
#sudo apt install ./gitlab-ce_12.5.1-ce.0_armhf.deb
#echo " gitlab_rails['time_zone'] = 'Europe/Prague' "
#echo " external_url='gitlab.alembiq.net', "
#echo " git_data_dirs({ "default" => { "path" => "/home/gitlab" } }) "
#read -n 1 -s -r -p "Press any key to continue"
#sudo nano /etc/gitlab/gitlab.rb
#sudo gitlab-ctl reconfigure
