FROM registry.access.redhat.com/rhel7/rhel:latest 

USER root

#COPY bin/ /usr/bin/
COPY tmp/ /tmp

RUN chmod +x /tmp/*.sh

#RUN /usr/bin/fix-permissions.sh /tmp
#
#USER 1001
