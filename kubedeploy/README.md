# kubedeploy

Generalized chart for deploying single containerized application into k8s clusters

![Version: 0.7.0](https://img.shields.io/badge/Version-0.7.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

## Additional Information

This is a simple chart created to deploy any generic containerized application to kubernetes cluster.

Idea behind this is having a framework for deploying built docker images by changing charts
**image.repository** and **image.tag** values.

This chart supports modifying following values:
 - creating Deployment, Statefulset, Job
 - defining replica counts
 - defining persistent volumes and it's mount point
 - defining a container within pod
 - defining multiple initContainers
 - defining custom container ports
 - defining custom health checks for container ports
 - default health check for container ports named http
 - defining service ports
 - defining container env variables
 - defining autoscaling configuration
 - defining pod disruption budgets
 - defining node selector
 - defining toleratoins
 - defining affinity
 - defining custom pod resource requirements
 - enabling ingress
 - defining custom pod annotatoins
 - defining image pull secrets
 - name override
 - enabling service and pod monitoring

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
| autoscaling.enabled | bool | `false` | enable deployment autoscaling feature, available only with Deployment deploymentMode |
| autoscaling.maxReplicas | int | `10` | number of max replicas for autoscaling |
| autoscaling.minReplicas | int | `1` | number of minimum replicas for autoscaling |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | target cpu utilization as percentage of resource.requests.cpu |
| autoscaling.targetMemoryUtilizationPercentage | int | `nil` | target memory utilization as percentage of resource.requests.mem |
| deploymentMode | string | `"Deployment"` | available deployment modes currently supported: Deployment Job Statefulset |
| env | list | `[]` | Define environment variables for container see: [env](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#envvar-v1-core) |
| fullnameOverride | string | `""` | Override full resource names instead of using calculated "releasename-chartname" naming |
| healthcheck.enabled | bool | `false` | define custom healthcheck probes for container, otherwise try to use automatic http probes if http port detected |
| healthcheck.probes.livenessProbe | object | `{}` | define livenessProbe |
| healthcheck.probes.readinessProbe | object | `{}` | define readinessProbe |
| image.args | list | `[]` | Define custom command for image to run |
| image.command | list | `[]` | Define custom command for image to run |
| image.pullPolicy | string | `"IfNotPresent"` | default container pull policy |
| image.repository | string | `"nginx"` | define container repositor |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | define [ImagePullSecrets](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#podspec-v1-core) |
| ingress | object | see object values | define [ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) object |
| ingress.annotations | object | defaults to haproxy ingress and letsencrypt issuer | additional ingress annotations |
| ingress.className | string | `""` | ingress class name |
| ingress.enabled | bool | `false` | enable ingres for deployment |
| ingress.hosts | list | see list values | Ingress host list. |
| ingress.hosts[0].host | string, required | chart-example.local | define ingress hostname |
| ingress.hosts[0].paths | list | `[{"path":"/"}]` | ingress host paths |
| ingress.pathType | string | `"ImplementationSpecific"` | default ingress pathType |
| ingress.tls | list | see list values | Ingress TLS list |
| ingress.tls[0].hosts | list | `["chart-example.local"]` | list of TLS enabled ingress hosts |
| ingress.tls[0].secretName | string, required | `"chart-example-tls"` | name of the secret to use for storing ssl certificate @ default -- chart-example-tls |
| initContainers.containers | list | see below | sequential list of init containers. Each init container must complete successfully before the next one starts |
| initContainers.containers[0].args | list | `[]` | Define custom arguments for initContainer |
| initContainers.containers[0].command | list | `["exit","0"]` | Define custom command for initContainer to run |
| initContainers.containers[0].name | required | busybox-init | define init container name |
| initContainers.containers[0].repository | required | `"busybox"` | define initContainer repository |
| initContainers.containers[0].tag | string | `"latest"` | Overrides the image tag whose default is latest |
| initContainers.enabled | bool | `false` | define if we should deploy init container within a pod see https://kubernetes.io/docs/concepts/workloads/pods/init-containers/ |
| initContainers.pullPolicy | string | `"IfNotPresent"` | default initContainers pull policy |
| initContainers.resources | object | `{}` | Define init containers resources |
| jobspec.args | list | `[]` | define args for job |
| jobspec.backoffLimit | int | `3` | define job backoff limit, see: https://kubernetes.io/docs/concepts/workloads/controllers/job/#pod-backoff-failure-policy |
| jobspec.command | list | `[]` | define command for job |
| jobspec.parallelism | int | `1` | define job paralelisam see: https://kubernetes.io/docs/concepts/workloads/controllers/job/#controlling-parallelism |
| jobspec.restartPolicy | string | `"OnFailure"` | define restart policy for jobs if deploymentMode is: Job. Please see https://kubernetes.io/docs/concepts/workloads/controllers/job/#handling-pod-and-container-failures |
| kubeVersionOverride | string | `""` | Allow override of kubernetes version by default this will be automatically detected and requires no modification |
| monitoring | object | see below | Parameters for the Prometheus [ServiceMonitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.ServiceMonitor) or [PodMonitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.PodMonitor) objects. |
| monitoring.enabled | bool | `false` | Enable Monitoring if service is enabled it will default to ServiceMonitor otherwise PodMonitor will be used |
| monitoring.labels | object | `{}` | Provide additional labels to the ServiceMonitor metadata |
| monitoring.metricRelabelings | list | `[]` | Provide additional metricRelabelings to apply to samples before ingestion. |
| monitoring.relabelings | list | `[]` | Provide additional relabelings to apply to samples before scraping |
| monitoring.scheme | string | `"http"` | HTTP scheme to use for scraping. |
| monitoring.scrapeInterval | string | `"20s"` | Provide interval at which metrics should be scraped |
| monitoring.scrapePath | string | `"/metrics"` | Provide HTTP path to scrape for metrics. |
| monitoring.scrapePort | string | `"metrics"` | Provide named service port used for scraping |
| monitoring.scrapeTimeout | string | `"30s"` | Timeout after which the scrape is ended If not specified |
| monitoring.targetLabels | list | `[]` | Additional metric labels |
| monitoring.tlsConfig | object | `{}` | TLS configuration to use when scraping the endpoint |
| nameOverride | string | `""` | Override release name used in calculated "releasename-chartname" naming |
| nodeSelector | object | `{}` | define custom [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) |
| persistency.accessModes[0] | string | `"ReadWriteOnce"` |  |
| persistency.capacity.storage | string | `"5Gi"` | define storage capacity |
| persistency.enabled | bool | `false` | Enable support for persistent volumes on deployments. Currently supported only in deploymentMode Deployment with replicaCount = 1 Or in Statefulset deploymentMode with any number of replicas |
| persistency.mountPath | string | `"/data"` | where will the persistent volume will be mounted in container |
| persistency.storageClassName | string | `nil` | define custom name for persistent storage class name @default - uses cluster default storageClassName |
| podAnnotations | object | `{}` | define pod [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) |
| podDisruptionBudget.enabled | bool | `false` | enable and define pod disruption budget default (off) see: [podDisruptionBudget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) |
| podDisruptionBudget.maxUnavailable | int | `nil` | maximum unavailable replicas |
| podDisruptionBudget.minAvailable | int | `1` | minimum available replicas |
| podSecurityContext | object | `{}` |  |
| ports | list | `[]` | Define ports that container will listen on see: [containerPort](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#containerport-v1-core) |
| replicaCount | int | `1` | Number of pods to load balance across |
| resources | object | `{}` | We usually recommend not to specify default resources and to leave this as a conscious choice for the user. This also increases chances charts run on environments with little resources, such as Minikube. See [resources](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for syntax |
| securityContext | object | `{}` |  |
| service.enabled | bool | `true` | controls if the service object should be deployed to cluster |
| service.ports | list | see list values | define port for service see: [servicePort](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#serviceport-v1-core) |
| service.ports[0].name | string, required | `"http"` | Name of the service port, should match container port name |
| service.ports[0].protocol | required | `"TCP"` | Define service protocol. [Supported protocols](https://kubernetes.io/docs/concepts/services-networking/service/#protocol-support) |
| service.ports[0].targetPort | string, required | `"http"` | Define name of the port exposed by the container |
| service.type | string | `"ClusterIP"` | Service type see [Reference](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | define pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

## Changelog

### 0.7.0
- added support for enabling monitoring via prometheus operator.
- cleaned up helmchart documentation for easier readability

### 0.6.0
- added support for overriding healthcheck probes

### 0.5.1
- added support for multiple init containers in Job, Deployment and Statefulset deployment mode

### 0.5.0
- added support for init container in Job, Deployment and Statefulset deployment mode

### 0.4.4
- don't set port 80 on containers by default
- deploy liveness and readiness probes only when http port name is defined

### 0.4.3
- fix ingress backend port targeting

### 0.4.2
- fixed wrongly nested command option in deployment and statefulset

### 0.4.1
- added support for image commands

### 0.4.0
- added support for job workloads
- added support for statefulset workloads
- minor bug fixes

### 0.3.2
- fixed container name to full name instead of chart name

### 0.3.1
- added public docs and chart home url

### 0.3.0
- added support for defining container and service ports
- added podDisruptionBudget support
- added container env varialbes support
- updated chart metadata

### 0.2.1
Initial release

