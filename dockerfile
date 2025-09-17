# Use a slim Linux base
FROM debian:bullseye-slim

# Pick Grafana version (change as needed)
ENV GRAFANA_VERSION=8.5.0
ENV GF_PATHS_DATA=/var/lib/grafana \
    GF_PATHS_LOGS=/var/log/grafana \
    GF_PATHS_PLUGINS=/var/lib/grafana/plugins \
    GF_PATHS_PROVISIONING=/etc/grafana/provisioning

# Install dependencies (wget, tar, libc, adduser)
RUN apt-get update && apt-get install -y wget tar libfontconfig adduser \
    && rm -rf /var/lib/apt/lists/*

# Download and extract Grafana tarball
RUN wget https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz -O /tmp/grafana.tar.gz \
    && tar -zxvf /tmp/grafana.tar.gz -C /opt \
    && mv /opt/grafana-${GRAFANA_VERSION} /opt/grafana \
    && rm /tmp/grafana.tar.gz

# Create data/log/plugin directories
RUN mkdir -p ${GF_PATHS_DATA} ${GF_PATHS_LOGS} ${GF_PATHS_PLUGINS} ${GF_PATHS_PROVISIONING} \
    && adduser --system --home /opt/grafana --no-create-home --group grafana \
    && chown -R grafana:grafana ${GF_PATHS_DATA} ${GF_PATHS_LOGS} ${GF_PATHS_PLUGINS}

# Expose Grafana port
EXPOSE 3000

# Set working directory
WORKDIR /opt/grafana

# Run as grafana user
USER grafana

# Start grafana-server with defaults.ini
CMD ["bin/grafana-server", \
     "--homepath=/opt/grafana", \
     "--config=/opt/grafana/conf/defaults.ini", \
     "--packaging=docker", \
     "--http-port=3000"]

