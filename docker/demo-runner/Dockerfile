FROM docker:28.1.1-dind

RUN apk add --no-cache tmux tcpdump

COPY docker/demo-runner/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
