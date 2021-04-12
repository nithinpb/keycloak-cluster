FROM jboss/keycloak:8.0.1
MAINTAINER somebody

# Temporarily elevate permissions
USER root

# Copy keycloak custom SPI into container
COPY providerJars/keycloak-custom-special-spi.jar /opt/jboss/keycloak/standalone/deployments/

# Copy keycloak metrics into container
COPY providerJars/keycloak-metrics-spi.jar /opt/jboss/keycloak/standalone/deployments/

# Copy elastic apm  into container
COPY providerJars/elastic-apm-agent-1.15.0.jar /opt/jboss/keycloak/standalone/deployments/

# Copy themes into container
ADD . /opt/jboss/keycloak/themes/custom-special-theme

# Copy Cluster Support
ADD JDBC_PING.cli /opt/jboss/tools/cli/jgroups/discovery/

USER 1000

RUN cd /opt/jboss/keycloak && \
rm -rf /opt/jboss/keycloak/standalone/configuration/standalone_xml_history

ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]

CMD ["-b", "0.0.0.0", "--server-config", "standalone-ha.xml"]
