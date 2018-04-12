#! /bin/bash

# Run Commands to better secure docker
auditctl -w /usr/bin/docker -p rwxa -k docker-daemon
auditctl -w /var/lib/docker -p wa
auditctl -w /etc/docker -p wa
auditctl -w /etc/default/docker -p wa
auditctl -w /usr/bin/docker-containerd -p wa
auditctl -w /usr/bin/docker-runc -p wa
auditctl -w /lib/systemd/system/docker.service -p wa
auditctl -w /lib/systemd/system/docker.socket -p wa
