#!/bin/sh

randpw(){ < /dev/urandom tr -dc a-z-0-9 | head -c${1:-8};echo;}

podname=$( randpw )

date; oc run -i $podname --image=172.30.1.1:5000/myproject/simple-ocp-docker:latest --restart=Never --command -- /bin/bash -c "/tmp/false.sh"; oc get pods $podname -o json | jq '.status.phase' | grep "Succeeded" ; exitcode=$(echo $?) ; date; oc delete pods $podname

exit $exitcode
