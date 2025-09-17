FROM debian:bullseye-slim

# Install deps
RUN apt-get update && apt-get install -y wget tar libfontconfig1 musl && rm -rf /var/lib/apt/lists/*

# Set Grafana version
ENV GRAFANA_VERSION=8.5.0

# Download and extract
WORKDIR /opt
RUN wget https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz && \
    tar -zxvf grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz && \
    mv grafana-${GRAFANA_VERSION} grafana && \
    rm grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz

# Create data directory
RUN mkdir -p /var/lib/grafana && chown -R root:root /var/lib/grafana

# Expose Grafana port
EXPOSE 3000

# Start Grafana
WORKDIR /opt/grafana
CMD ["bin/grafana-server", \
     "--homepath=/opt/grafana", \
     "--config=/opt/grafana/conf/defaults.ini", \
     "--packaging=docker", \
     "--http-port=3000"]
