# Keycloak Cluster

This project documents changes done to Keycloak to support cluster deployment. 

## Dockerfile

As you may notice, this worked well with 8.0.1 but it may have issues with the latest version

Line 7-8: If you need to add a custom SPI to your keycloak setup, you will need these lines. Or else, you may delete it. SPIs are a way of extending Keycloak to support additional functionalities. 

Line 13-14: If you wish to add elastic APM, you may do so as shown here. 

Line 16-17: If you wish to modify the Keycloak theme to that of your organization, you can do so as shown here.

Line 19-20: Keycloak supports JDBC_PING, DNS_PING and KUBE_PING. This configuration is about JDBC_PING. Due to this file addition: 
* Keycloak brings up an embedded server
* does the CLI configuration as per this file (JDBC_PING.cli)
* re-writes your ha-config.xml file
* shuts down the embedded server

Keycloak is built on top of JBOSS Wildfly and this is how one configures Jboss servers. 

Line 29: Start the Keycloak server in HA mode. This is important for cluster support.

## JDBC_PING.cli

Line 10-14: Configure Keycloak to use the datasource configuration called KeycloakDS.

Line 16-17: Setup JGROUPSPING table. This table will be used by each instance of your Keycloak server to discover other instances. When an instance comes up, it will make an entry into this table.

Line 36: Each of the Keycloak instance talks to other instances by finding out it's IP from JGROUPSPING table. Once the IP is found, the instance attempts to communicate with the other instance. This is likely done at the Infinispan cache level although I haven't explored much into it. This line informs Keycloak to delete an instance's entry from JGROUPSPING table (essentially it's existence) when the instance is no longer reachable. 

Line 37: We decided not to use this configuration. But when this configuration is enabled, each instance of Keycloak aggressively removes other instances when it comes up. Other instances will then be forced to make a new entry in JGROUPSPING table. 