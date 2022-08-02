# kubedeploy

Generalized chart for deploying single containerized application into k8s clusters

![Version: 0.3.1](https://img.shields.io/badge/Version-0.3.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

## Additional Information

This is a simple chart created to deploy any generic containerized application to kubernetes cluster.

Idea behind this is having a framework for deploying built docker images by changing charts
**image.repository** and **image.tag** values.

This chart supports modifying following values:
 - creating Deployment
 - defining persistent volumes (only if replica 1) and it's mount point
 - single container within pod
 - defining custom container ports
 - defining service ports
 - defining container env variables
 - autoscaling configuration
 - pod disruption budgets
 - node selector
 - toleratoins
 - affinity
 - configuring resources
 - ingress
 - pod annotatoins
 - image pull secrets
 - name override

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add sysbee https://charts.sysbee.io/stable/sysbee
$ helm install my-release sysbee/kubedeploy
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | define pod [affinity](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/) |
| autoscaling.enabled | bool | `false` | enable autoscaling |
| autoscaling.maxReplicas | int | `10` | number of max replicas for autoscaling |
| autoscaling.minReplicas | int | `1` | number of minimum replicas for autoscaling |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | target cpu utilization as percentage of resource.requests.cpu |
| deploymentMode | string | `"Deployment"` | available deployment modes currently supported: Deployment |
| env | list | `[]` | Define environment variables for container see: [env](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#envvar-v1-core) |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` | default container pull policy |
| image.repository | string | `"nginx"` | define container repositor |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | define [ImagePullSecrets](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#podspec-v1-core) |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/"}]}],"pathType":"ImplementationSpecific","tls":[]}` | define [ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) object |
| kubeVersionOverride | string | `""` | Allow override of kubernetes version by default this will be automatically detected and requires no modification |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` | define custom [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) |
| persistency.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistency.capacity.storage | string | `"5Gi"` | define storage capacity |
| persistency.enabled | bool | `false` | Enable support for persistent volumes on deployments. Currently supported only in deploymentMode Deployment with replicaCount = 1 |
| persistency.mountPath | string | `"/data"` | where will the persistent volume will be mounted in container |
| podAnnotations | object | `{}` | define pod [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) |
| podDisruptionBudget.enabled | bool | `false` | enable and define pod disruption budget default (off) see: [podDisruptionBudget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) |
| podDisruptionBudget.minAvailable | int | `1` |  |
| podSecurityContext | object | `{}` |  |
| ports | list | `[{"containerPort":80,"name":"http","protocol":"TCP"}]` | Define ports that container will listen on see: [containerport](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#containerport-v1-core) |
| replicaCount | int | `1` | Number of pods to load balance across |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.ports | list | `[{"name":"http","port":80,"protocol":"TCP","targetPort":"http"}]` | define port for service see: https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#serviceport-v1-core |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | define pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

## Changelog

### 0.3.0
- added support for defining container and service ports
- added podDisruptionBudget support
- added container env varialbes support
- updated chart metadata

### 0.2.1
Initial release

