#!/bin/sh

if [ "$#" -ne 4 ]; then
  echo "missing parameters: $0 git@gitolite.xyz gitlab.xyz gitlabUserToken gitlabUsername" >&2
  exit 1
fi

GITOLITE=$1
GITLAB_URL=$2
API_TOKEN=$3
GITLAB_USER=$4

ssh $GITOLITE info | awk '/^[ @]*R/{print $NF}' | while read REPO_NAME
do
	git clone --mirror $GITOLITE:$REPO_NAME.git
	REPO__NAME=$(echo $REPO_NAME | sed 's/\./\_/g')
	curl -v -H "Content-Type:application/json" $GITLAB_URL/api/v4/projects?private_token=$API_TOKEN -d "{ \"name\": \"$REPO__NAME\" }"
	cd $REPO_NAME.git
	git remote add gitlab git@$GITLAB_URL:$GITLAB_USER/$REPO__NAME.git
	git push -f --tags gitlab refs/heads/*:refs/heads/*
	cd ..
done
