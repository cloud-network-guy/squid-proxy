ARG IMAGE=debian
ARG IMAGE_TAG="trixie-20260406-slim"
FROM ${IMAGE}:${IMAGE_TAG}
ARG PACKAGES="squid curl wget net-tools iputils-ping dnsutils cron"
ARG DEBIAN_FRONTEND=noninteractive
ENV PORT=3128
ENV GCP_BUCKET="mybucket/squid-proxy"
WORKDIR /tmp
# Install Packages
RUN apt update && apt upgrade -y && apt install -y $PACKAGES && apt clean
# Copy config files
COPY *.conf /etc/squid/conf.d/
# Setup Cron Job
RUN touch /var/log/cron.log
# Copy ACL data files
COPY *.txt /etc/squid/conf.d/
# Replace default config file with ours
RUN mv /etc/squid/squid.conf /etc/squid/squid.conf.default
RUN mv /etc/squid/conf.d/squid.conf /etc/squid/
# Create Cache directories
RUN mkdir -p /var/spool/squid && /sbin/squid -N -z
# Startup Squid
CMD ["/sbin/squid", "-NYCd 1"]
# Expose the Squid Port
EXPOSE $PORT/tcp
