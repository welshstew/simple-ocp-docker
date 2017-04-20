FROM registry.access.redhat.com/rhel7/rhel:latest 

USER root

COPY tmp/ /tmp

RUN chmod +x /tmp/*.sh

