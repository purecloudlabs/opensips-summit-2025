#!/bin/bash

set -ex

iptables  -t mangle -I PREROUTING -m mark     --mark 123 -j CONNMARK --save-mark
iptables  -t mangle -I OUTPUT     -m connmark --mark 123 -j CONNMARK --restore-mark
ip rule add fwmark 123 lookup 100
ip route add local 0.0.0.0/0 dev lo table 100
sysctl -w net.ipv4.conf.eth0.route_localnet=1

sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A OUTPUT     -p tcp   -m owner     --uid-owner envoy -j RETURN
iptables -t nat -A OUTPUT     -p tcp   -m mark      --mark 42         -j REDIRECT --to-port 22222
iptables -t nat -A PREROUTING -p tcp ! -d 127.0.0.1 --dport 5061      -j REDIRECT --to-port 11111

chown -R envoy:envoy /etc/envoy/certs/*

su - envoy -s /bin/bash -c 'envoy -c /etc/envoy/envoy.yaml --log-level debug 2>&1 | grep -E "Marking with"' &
exec su - opensips -s /bin/bash -c '/usr/local/sbin/opensips -F -f /etc/opensips/opensips.cfg'
