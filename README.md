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
