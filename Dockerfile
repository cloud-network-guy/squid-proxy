ARG IMAGE=debian
ARG IMAGE_TAG="trixie-slim"
FROM ${IMAGE}:${IMAGE_TAG}
ARG PACKAGES="squid curl wget net-tools iputils-ping dnsutils"
ARG DEBIAN_FRONTEND=noninteractive
ENV PORT=3128
WORKDIR /tmp
# Install Packages
RUN apt update && apt upgrade -y && apt install -y $PACKAGES && apt clean
# Copy config files
COPY *.conf /etc/squid/conf.d/
# Copy ACL data files
COPY *.txt /etc/squid/conf.d/
# Replace default config file with ours
RUN echo /etc/squid/squid.conf >> /etc/squid/squid.conf.default && mv /etc/squid/conf.d/squid.conf /etc/squid/
# Create Cache directories
RUN mkdir -p /var/spool/squid && /sbin/squid -N -z
# Startup Squid
CMD ["/sbin/squid", "-NYCd 1"]
# Expose the Squid Port
EXPOSE $PORT/tcp
