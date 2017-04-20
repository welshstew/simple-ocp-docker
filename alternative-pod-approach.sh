#!/bin/sh

randpodname(){ < /dev/urandom tr -dc a-z-0-9 | head -c${1:-8};echo;}
podname=$( randpodname )

oc create -f - <<EOF
---
apiVersion: v1
kind: Pod
metadata:
  name: $podname
  labels:
    jobgroup: jobby-job
    script: true.sh
  annotations:
    command: true.sh
spec:
  containers:
  - name: bashers
    image: 172.30.1.1:5000/myproject/simple-ocp-docker:latest
    command: ["/bin/bash", "/tmp/true.sh", "$@"]
  restartPolicy: Never
...
EOF

pod_status=""
time_elapsed=0
has_pod_finished=0
while (( has_pod_finished <= 0 ))
do
    sleep 5
    time_elapsed=$((time_elapsed + 5))
    pod_status=$(oc get pods $podname -o json | jq -r '.status.phase')
    has_pod_finished=$(echo "$pod_status" | grep -c "Succeeded\|Failed")

    echo "in loop $pod_status $has_pod_finished"

    if [[ $time_elapsed -ge 120 ]]; then
        echo "Waited $time_elapsed for pod. Exiting loop."
        break
    fi
done

echo $pod_status
