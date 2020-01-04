#!/usr/bin/env bash
sudo apt install -y docker.io apt-transport-https ca-certificates curl gnupg2 software-properties-common
sudo usermod -aG docker $(whoami)
#docker stop gitlab-runner && docker rm gitlab-runner
docker run -d --name gitlab-runner --restart always  \
	-v /srv/gitlab-runner/config:/etc/gitlab-runner \
	-v /var/run/docker.sock:/var/run/docker.sock \
	gitlab/gitlab-runner:alpine-v12.6.0
# --add-host=pi4:10.7.12.2
docker run --rm -v /srv/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register \
  --non-interactive \
  --executor "docker" \
  --docker-image alpine:v12.6.0 \
  --url "https://YOUR_GITLAB/" \
  --registration-token "TOKEN" \
  --description "$(hostname)" \
  --tag-list "docker" \
  --run-untagged="true" \
  --locked="false" \
  --access-level="not_protected" \
  --docker-privileged
