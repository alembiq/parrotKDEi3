#!/usr/bin/env bash
# allow passwordless sudo for current user

su -c "echo '$(whoami) ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers.d/passwordless"
