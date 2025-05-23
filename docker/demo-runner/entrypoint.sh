#!/bin/sh

set -e

/usr/local/bin/dockerd-entrypoint.sh &
sleep 5

scripts/init.sh

rm -f data/traffic.pcap
tcpdump -i $(ip link | awk -F': ' '{print $2}' | grep 'br-') -w data/traffic.pcap &

tmux kill-session -t demo || true
tmux new-session -d -s demo
tmux has-session -t demo
tmux split-window -v -t demo
tmux select-pane -t demo:0.1
tmux split-window -h -t demo
tmux send-keys -t demo:0.0 "scripts/run_box.sh" C-m
tmux send-keys -t demo:0.1 "sleep 2; scripts/run_uac.sh" C-m
tmux send-keys -t demo:0.2 "scripts/run_uas.sh" C-m
tmux attach-session -t demo
