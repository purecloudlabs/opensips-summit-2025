FROM ubuntu:jammy-20250404

RUN apt-get update && apt-get install --yes \
    git \
    gpg \
    iproute2 \
    iptables \
    wget

RUN update-alternatives --set iptables /usr/sbin/iptables-legacy

RUN git clone --branch 3.4-genesys --single-branch https://github.com/purecloudlabs/opensips.git && \
    cd opensips && \
    git checkout 3d64079f89eba48104de6cebd99f19ade788b64d && \
    BUILD_OS=ubuntu-22.04 COMPILER=gcc \
    scripts/build/install_depends.sh && \
    make && make install

RUN mkdir -p /etc/apt/keyrings && \
    wget -qO- https://apt.envoyproxy.io/signing.key | gpg --dearmor -o /etc/apt/keyrings/envoy-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/envoy-keyring.gpg] \
    https://apt.envoyproxy.io $(grep VERSION_CODENAME /etc/os-release | cut -d= -f2) main" > \
    /etc/apt/sources.list.d/envoy.list && \
    apt-get update && apt-get install --yes envoy

RUN setcap 'cap_net_admin=eip' /usr/local/sbin/opensips && \
    setcap 'cap_net_admin=eip' /usr/bin/envoy

RUN useradd -M -s /sbin/nologin opensips

COPY docker/box/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
