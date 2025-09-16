FROM debian:bookworm-slim
ARG DEBIAN_FRONTEND=noninteractive
ARG PACKAGES="squid curl wget net-tools iputils-ping dnsutils"
ENV PORT="3128"
WORKDIR /tmp
RUN apt update && apt upgrade -y && apt install -y $PACKAGES && apt clean
RUN cp /etc/squid/squid.conf /etc/squid/squid.conf.default
COPY squid.conf /etc/squid/
COPY parent_proxies.conf /etc/squid/conf.d/
COPY *.txt /etc/squid/conf.d/
RUN mkdir -p /var/spool/squid
RUN /sbin/squid -N -z
CMD ["/sbin/squid", "-NYCd 1"]
EXPOSE $PORT/tcp
