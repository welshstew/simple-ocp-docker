# simple-ocp-docker
Just a sample for demoing docker images on ocp

## Build it on OpenShift

```
oc new-build https://github.com/welshstew/simple-ocp-docker.git --strategy=docker
```

## Run it on Openshift...

Please note, the image will change depending on your environment, so example as below:

```
oc run -i falsetest --image=172.30.1.1:5000/myproject/simple-ocp-docker:latest --restart=Never --command -- /bin/bash -c "/tmp/false.sh"
```


## Generating exit code

Added this in as a workaround..

1. generates a random pod name
2. runs the task
3. saves the exit code
4. deletes the pod
5. exits with the correct exitcode from the container


```
[user@localhost simple-ocp-docker]$ ./generate-success-run.sh 
Thu 20 Apr 16:16:17 BST 2017
Waiting for pod myproject/ojj278dq to be running, status is Pending, pod ready: false
Waiting for pod myproject/ojj278dq to be running, status is Pending, pod ready: false
Waiting for pod myproject/ojj278dq to be running, status is Pending, pod ready: false
THIS is SUCCESS - STROUT
THIS is SUCCESS - STDERR
"Succeeded"
Thu 20 Apr 16:16:22 BST 2017
pod "ojj278dq" deleted
[user@localhost simple-ocp-docker]$ echo $?
0


[user@localhost simple-ocp-docker]$ ./generate-fail-run.sh 
Thu 20 Apr 16:14:13 BST 2017
Waiting for pod myproject/795nqexj to be running, status is Pending, pod ready: false
Waiting for pod myproject/795nqexj to be running, status is Pending, pod ready: false
THIS is FAIL - STROUT
THIS is FAIL - STDERR
Thu 20 Apr 16:14:17 BST 2017
pod "795nqexj" deleted
[user@localhost simple-ocp-docker]$ echo $?
1
```

