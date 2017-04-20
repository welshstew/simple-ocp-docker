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
You'll [need jq](https://stedolan.github.io/jq/)

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

## Using oc run with a volume mount

Bit of a pain - you need to patch it...  Below is the output of ./run-with-overrides.sh proving that you can mount a configmap on an oc run command

```
[user@localhost simple-ocp-docker]$ ./run-with-overrides.sh 
Thu 20 Apr 18:37:57 BST 2017
Waiting for pod myproject/zncyb3mk to be running, status is Pending, pod ready: false
Waiting for pod myproject/zncyb3mk to be running, status is Pending, pod ready: false
Waiting for pod myproject/zncyb3mk to be running, status is Pending, pod ready: false
THIS is SUCCESS - STROUT
THIS is SUCCESS - STDERR
"Succeeded"
Thu 20 Apr 18:38:01 BST 2017
[user@localhost simple-ocp-docker]$ oc get pods
NAME       READY     STATUS      RESTARTS   AGE
zncyb3mk   0/1       Completed   0          8s
[user@localhost simple-ocp-docker]$ oc describe pods/zncyb3mk
Name:			zncyb3mk
Namespace:		myproject
Security Policy:	anyuid
Node:			192.168.42.76/192.168.42.76
Start Time:		Thu, 20 Apr 2017 18:37:57 +0100
Labels:			<none>
Status:			Succeeded
IP:			172.17.0.2
Controllers:		<none>
Containers:
  zncyb3mk:
    Container ID:	docker://5e2ab3288b079b58a3d3cfea6fa05e20ee9b58fc1b8c9316b494eb167cb4cb4c
    Image:		172.30.1.1:5000/myproject/simple-ocp-docker:latest
    Image ID:		docker-pullable://172.30.1.1:5000/myproject/simple-ocp-docker@sha256:0f11f15d7a3f1e1df04820ae546be3c02e48db040475b294371678e4dc8a7a76
    Port:		
    Command:
      /bin/bash
      /tmp/true.sh
    State:		Terminated
      Reason:		Completed
      Exit Code:	0
      Started:		Thu, 20 Apr 2017 18:38:01 +0100
      Finished:		Thu, 20 Apr 2017 18:38:01 +0100
    Ready:		False
    Restart Count:	0
    Volume Mounts:
      /var/config from config (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-6ympy (ro)
    Environment Variables:	<none>
Conditions:
  Type		Status
  Initialized 	True 
  Ready 	False 
  PodScheduled 	True 
Volumes:
  config:
    Type:	ConfigMap (a volume populated by a ConfigMap)
    Name:	mounted-config
  default-token-6ympy:
    Type:	Secret (a volume populated by a Secret)
    SecretName:	default-token-6ympy
QoS Class:	BestEffort
Tolerations:	<none>
Events:
  FirstSeen	LastSeen	Count	From			SubobjectPath	Type		Reason		Message
  ---------	--------	-----	----			-------------	--------	------		-------
  20s		20s		1	{default-scheduler }			Normal		Scheduled	Successfully assigned zncyb3mk to 192.168.42.76
  18s		18s		1	{kubelet 192.168.42.76}			Warning		FailedSync	Error syncing pod, skipping: failed to "StartContainer" for "POD" with RunContainerError: "addNDotsOption: ResolvConfPath \"/mnt/sda1/var/lib/docker/containers/bca9dbd7a76ee227a87814ab21a9b3578bf47c7591a7110881e82bd52bc0b24e/resolv.conf\" does not exist"

  17s	17s	1	{kubelet 192.168.42.76}	spec.containers{zncyb3mk}	Normal	Pulling	pulling image "172.30.1.1:5000/myproject/simple-ocp-docker:latest"
  17s	17s	1	{kubelet 192.168.42.76}	spec.containers{zncyb3mk}	Normal	Pulled	Successfully pulled image "172.30.1.1:5000/myproject/simple-ocp-docker:latest"
  16s	16s	1	{kubelet 192.168.42.76}	spec.containers{zncyb3mk}	Normal	Created	Created container with docker id 5e2ab3288b07; Security:[seccomp=unconfined]
  16s	16s	1	{kubelet 192.168.42.76}	spec.containers{zncyb3mk}	Normal	Started	Started container with docker id 5e2ab3288b07


```


