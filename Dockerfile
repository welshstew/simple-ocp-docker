FROM registry.access.redhat.com/rhel7/rhel:latest 

COPY bin/ /usr/bin/
COPY tmp/ /tmp

RUN /usr/bin/fix-permissions.sh /tmp
