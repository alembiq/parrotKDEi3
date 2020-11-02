#!/usr/bin/env bash
if [ "$#" -ne 2 ]; then
        echo "GitLab Runner installation"
        echo
        echo "missing parameters: $0 http://gitlab.url gitlab-token" >&2
        exit 1
fi


sudo apt install -y docker.io apt-transport-https ca-certificates curl gnupg2 software-properties-common
sudo usermod -aG docker $(whoami)
#docker stop gitlab-runner && docker rm gitlab-runner
docker run -d --name gitlab-runner --restart always  \
	-v /srv/gitlab-runner/config:/etc/gitlab-runner \
	-v /var/run/docker.sock:/var/run/docker.sock \
	gitlab/gitlab-runner:latest
# --add-host=pi4:10.7.12.2
docker run --rm -v /srv/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register \
  --non-interactive \
  --executor "docker" \
  --docker-image alpine:latest \
  --url "$1" \
  --registration-token "$2" \
  --description "$(hostname)" \
  --tag-list "docker" \
  --run-untagged="true" \
  --locked="false" \
  --access-level="not_protected" \
  --docker-privileged
docker restart gitlab-runner
