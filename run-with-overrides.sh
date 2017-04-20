#!/bin/sh

# see http://stackoverflow.com/questions/37555281/create-kubernetes-pod-with-volume-using-kubectl-run
randpw(){ < /dev/urandom tr -dc a-z-0-9 | head -c${1:-8};echo;}

podname=$( randpw )

# oc create configmap mounted-config \
#     --from-literal=animals.cats=love \
#     --from-literal=animals.dogs=meh
jsonPatch=$(echo '
{
  "kind": "Pod",
  "apiVersion": "v1",
  "spec": {
    "containers": [
      {
      	"name": "whatever",
      	"image": "172.30.1.1:5000/myproject/simple-ocp-docker:latest",
      	"command": ["/bin/bash", "/tmp/true.sh" ],
        "volumeMounts": [{
          "mountPath": "/var/config",
          "name": "config"
        }]
      }
    ],
    "volumes": [{
      "name":"config",
      "emptyDir":{} 	
    }]
  }
}
' | jq -r --arg PODNAME "$podname" '.spec.containers[0].name = $PODNAME')



date; oc run -i $podname --image=172.30.1.1:5000/myproject/simple-ocp-docker:latest --overrides="$jsonPatch" --restart=Never --command -- /bin/bash -c "/tmp/true.sh"; oc get pods $podname -o json | jq '.status.phase' | grep "Succeeded" ; exitcode=$(echo $?) ; date; 

exit $exitcode

# "command": [
#                     "/bin/bash",
#                     "/tmp/true.sh"



# kubectl run -i --rm --tty ubuntu --overrides='
# {
#   "apiVersion": "batch/v1",
#   "spec": {
#     "template": {
#       "spec": {
#         "containers": [
#           {
#             "name": "ubuntu",
#             "image": "ubuntu:14.04",
#             "args": [
#               "bash"
#             ],
#             "stdin": true,
#             "stdinOnce": true,
#             "tty": true,
#             "volumeMounts": [{
#               "mountPath": "/home/store",
#               "name": "store"
#             }]
#           }
#         ],
#         "volumes": [{
#           "name":"store",
#           "emptyDir":{}
#         }]
#       }
#     }
#   }
# }
# '  --image=ubuntu:14.04 --restart=Never -- bash