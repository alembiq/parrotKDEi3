#!/usr/bin/env bash
### local hostname
if [ "$#" -ne 1 ]; then
        echo "rename hostname"
        echo "- changes /etc/hostname"
        echo "- changes /etc/hosts"
        echo
        echo "missing parameters: $0 hostname" >&2
        exit 1
fi

echo $1 | sudo tee /etc/hostname
sudo sed -i "s/parrot/$1/g" /etc/hosts
