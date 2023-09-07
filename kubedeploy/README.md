# kubedeploy

Generalized chart for deploying single containerized application into Kubernetes clusters

![Version: 1.1.0](https://img.shields.io/badge/Version-1.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.1.0](https://img.shields.io/badge/AppVersion-1.1.0-informational?style=flat-square)

**Homepage:** <https://charts.sysbee.io/kubedeploy/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Branko Toic | <branko@sysbee.net> | <https://www.sysbee.net> |

## Contributors
| Name | Email | Url |
| ---- | ------ | --- |
| Sasa Tekovic | <sasa@sysbee.net> | <https://www.sysbee.net> |
| Sinisa Dukaric | <sinisa.dukaric@gmail.com> | |

## Additional Information

This simple chart is created to deploy any generic containerized application to kubernetes cluster.
Main idea behind this chart is having a simple framework for deploying docker images by changing just few charts values, like
**image.repository** and **image.tag**. Chart is generalized as it aims to be compatible with as many possible deployment scenarios.
As such it might not be the perfect fit for every workload, however it will allow you to run most of generic applications.

If you have multiple different containers it is recommended to install each container in its own release.
Using [helmfile](https://github.com/roboll/helmfile) is strongly encouraged when dealing with multiple releases.

List of currently available features configurable through chart values.yaml:

 * creating Deployment, Statefulset, Job, CronJob releases
 * controlling release replica count
 * support for persistent volumes on Statefulsets
 * defining multiple ConfigMap objects with support for mounting them as volumes in pod (main container, additionalContainers, initContainers)
 * support for defining multiple initContainers with fine grained resources
 * support for defining multiple additionalContainers with fine grained resources and custom healthchecks
 * support for custom lifecycle hooks on main container
 * defining exposed container ports
 * defining custom pod resource requirements
 * default http liveness and readiness probes for container ports named http
 * defining custom liveness and readiness probes with ability to disable automatic healthcheck probes
 * defining multiple service ports
 * defining pod env variables (main container, additionalContainers, initContainers)
 * defining built-in deployment auto scaling configuration
 * defining KEDA 2.x scaling configuration
 * defining pod NetworkPolicy objects
 * defining pod disruption budgets
 * defining node selector
 * defining tolerations
 * defining topologySpreadConstraints
 * defining affinity
 * easy podAntiAffinity setup
 * defining ingress objects
 * defining custom pod annotations
 * defining image pull secrets
 * name override
 * enabling service and pod monitoring

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm repo add sysbee https://charts.sysbee.io/stable/sysbee
$ helm install my-release sysbee/kubedeploy
```

## Requirements

Kubernetes: `>=1.20.0-0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalContainers.containers | list | see below | list of additional containers. |
| additionalContainers.containers[0].args | list | `[]` | Define custom arguments for additionalContainer |
| additionalContainers.containers[0].command | list | `["sh","-c","while true; do sleep 30; done;"]` | Define custom command for additionalContainer to run |
| additionalContainers.containers[0].healthcheck.enabled | bool | `false` | Define custom healthcheck probes for container |
| additionalContainers.containers[0].healthcheck.probes.livenessProbe | object | `{}` | Define [livenessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| additionalContainers.containers[0].healthcheck.probes.readinessProbe | object | `{}` | Define [readinessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| additionalContainers.containers[0].ports | list | `[]` | Define container ports that will be exposed see: [containerPort](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#containerport-v1-core) |
| additionalContainers.containers[0].repository | required | `"busybox"` | define additionalContainer repository |
| additionalContainers.containers[0].resources | object | `{}` | Define custom resources for this specific additional container. If not specified default resources from additionalContainer.resources will be used |
| additionalContainers.containers[0].tag | string | `"latest"` | Overrides the image tag whose default is latest |
| additionalContainers.enabled | bool | `false` | define if we should deploy additional containers within a pod see https://kubernetes.io/docs/concepts/workloads/pods/ |
| additionalContainers.pullPolicy | string | `"IfNotPresent"` | default additionalContainers pull policy |
| additionalContainers.resources | object | `{}` | Define default resources for all additional containers |
| affinity | object | `{}` | Define pod [affinity](https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes-using-node-affinity/) disables automatic podAntiAffinity rules if defined. |
| autoscaling.enabled | bool | `false` | Enable autoscaling feature. This will only work when deploymentMode is set to **Deployment** |
| autoscaling.maxReplicas | int | `10` | Number of max replicas for autoscaling |
| autoscaling.minReplicas | int | `1` | Number of minimum replicas for autoscaling |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Target cpu utilization as percentage of resources.requests.cpu |
| autoscaling.targetMemoryUtilizationPercentage | int | `nil` | Target memory utilization as percentage of resources.requests.mem |
| configMaps | list | `[]` | Define a list of hashes containing name and data that will be used in generating additional configmaps please see values.yaml for examples |
| configMapsHash | bool | `false` | Redeploy Deployments and Statefulsets on configmap content change. If set to true, values of configmaps will be calculated as sha256sum and added as annotation to pod. On content change this will trigger pod redeployment/restart |
| cronjobspec.args | list | `[]` | define args for cronjob |
| cronjobspec.backoffLimit | int | `3` | define job backoff limit, see: https://kubernetes.io/docs/concepts/workloads/controllers/job/#pod-backoff-failure-policy |
| cronjobspec.command | list | `[]` | define command for cronjob |
| cronjobspec.concurrencyPolicy | string | `""` | concurrency policy options: Allow (default), Forbid or Replace, see: https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#concurrency-policy |
| cronjobspec.failedJobsHistoryLimit | int | `1` | define number of failed job logs to keep |
| cronjobspec.restartPolicy | string | `"OnFailure"` |  |
| cronjobspec.schedule | string | `"0 * * * *"` | define cronjob schedule, for details see: https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#writing-a-cronjob-spec |
| cronjobspec.startingDeadlineSeconds | optional | `180` | define deadline for starting the job, see: https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#starting-deadline |
| cronjobspec.successfulJobsHistoryLimit | int | `3` | define number of successful job logs to keep |
| deploymentMode | string | `"Deployment"` | available deployment modes currently supported:   <ul><li>**Deployment**</li>   <li>**Job**</li>   <li>**Statefulset**</li>   <li>**Cronjob**</li></ul> |
| env | list | `[]` | Define environment variables for containers for reference see: [env](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#envvar-v1-core). Environment variables set will be exposed both to main container and all of the initContainers |
| envFrom | list | `[]` | Define environment variables for containers from ConfigMap or Secret objects for reference see [envFrom secret example](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#configure-all-key-value-pairs-in-a-secret-as-container-environment-variables) or [envFrom configmap example](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#configure-all-key-value-pairs-in-a-configmap-as-container-environment-variables) |
| extraObjects | list | `[]` | Create dynamic manifest via values (templated). See values for example: |
| extraSecrets | list | `[]` | Define a list of hashes containing name and data that will be used in generating Secret objects please see values.yaml for examples |
| extraVolumeMounts | list | `[]` | Defines extra volume mounts for containers see values for examples |
| fullnameOverride | string | `""` | Override full resource names instead of using calculated "releasename-chartname" default naming convention |
| healthcheck.disableAutomatic | bool | `false` | Disable automatic healthcheck probes. Automatic probes will always create a http healthcheck probe if there is a port named http |
| healthcheck.enabled | bool | `false` | Define custom healthcheck probes for container, overriding any automatic probes |
| healthcheck.probes.livenessProbe | object | `{}` | Define [livenessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| healthcheck.probes.readinessProbe | object | `{}` | Define [readinessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| image.args | list | `[]` | Define custom arguments for image to run. [Reference](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/) |
| image.command | list | `[]` | Define custom command for image to run. [Reference](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/) |
| image.lifecycle | object | `{}` | Define custom [container lifecycle hooks](https://kubernetes.io/docs/tasks/configure-pod-container/attach-handler-lifecycle-event/). [More info](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/) |
| image.pullPolicy | string | `"IfNotPresent"` | Default container pull policy |
| image.repository | string | `"nginx"` | Define container repository |
| image.tag | string | `"latest"` | Define the image tag defaulting to latest. |
| image.terminationGracePeriodSeconds | int | `30` | Define custom [terminationGracePeriodSeconds](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#hook-handler-execution). Should be greater then expected run time of lifecycle hooks |
| imagePullSecrets | list | `[]` | Define [ImagePullSecrets](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#podspec-v1-core) |
| ingress | object | see ingress object values | Define [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) object |
| ingress.annotations | object | defaults to support cert-manager letsencrypt issuer | Additional Ingress annotations |
| ingress.className | string | `"haproxy"` | Ingress class name |
| ingress.enabled | bool | `false` | Enable Ingres for release |
| ingress.hosts | list | see ingress.hosts[0] values | Ingress host list. |
| ingress.hosts[0].host | string, required | `""` | Define Ingress hostname |
| ingress.hosts[0].paths | list | `[]` | Ingress host paths see values.yaml for example |
| ingress.pathType | string | `"ImplementationSpecific"` | Default Ingress pathType |
| ingress.svcPort | string | use first port from service.ports | Define default service port that will be targeted by ingress. |
| ingress.tls | list | `[]` | Ingress TLS list **overrides any auto configured tls config created by withSSL**.  It allows custom secretName and host list to be defined in case you have pre-configured SSL stored as Kubernetes secret. If secret does not exist, new one will be created by cert-manager. see values for example: |
| ingress.withSSL | bool | `true` | Deploy ingress object with SSL support. Automatically configures the ingress tls spec with all the configured ingress.hosts in one secret |
| initContainers.containers | list | see below | sequential list of init containers. Each init container must complete successfully before the next one starts |
| initContainers.containers[0].args | list | `[]` | Define custom arguments for initContainer |
| initContainers.containers[0].command | list | `["sh","-c","exit 0"]` | Define custom command for initContainer to run |
| initContainers.containers[0].name | required | busybox-init | define init container name |
| initContainers.containers[0].repository | required | `"busybox"` | define initContainer repository |
| initContainers.containers[0].resources | object | `{}` | Define custom resources for this specific init container. If not specified default resources from initContainer.resources will be used |
| initContainers.containers[0].tag | string | `"latest"` | Overrides the image tag whose default is latest |
| initContainers.enabled | bool | `false` | define if we should deploy init containers within a pod see https://kubernetes.io/docs/concepts/workloads/pods/init-containers/ |
| initContainers.pullPolicy | string | `"IfNotPresent"` | default initContainers pull policy |
| initContainers.resources | object | `{}` | Define init containers resources |
| jobspec.args | list | `[]` | define args for job |
| jobspec.backoffLimit | int | `3` | define job backoff limit, see: https://kubernetes.io/docs/concepts/workloads/controllers/job/#pod-backoff-failure-policy |
| jobspec.command | list | `[]` | define command for job |
| jobspec.parallelism | int | `1` | define job paralelisam see: https://kubernetes.io/docs/concepts/workloads/controllers/job/#controlling-parallelism |
| jobspec.restartPolicy | string | `"OnFailure"` | define restart policy for jobs if deploymentMode is: Job. Please see https://kubernetes.io/docs/concepts/workloads/controllers/job/#handling-pod-and-container-failures |
| keda.behavior | object | `{}` | HPA configurable scaling behavior see [ref](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#configurable-scaling-behavior) |
| keda.cooldownPeriod | int | `300` | The period to wait after the last trigger reported active before scaling the resource back to 0 [ref](https://keda.sh/docs/2.10/concepts/scaling-deployments/#cooldownperiod) |
| keda.enabled | bool | `false` | Kubernetes Event-driven Autoscaling: KEDA 2.x [ref](https://keda.sh/docs/2.3/concepts/scaling-deployments/) **Note:** mutually exclusive with HPA, enabling KEDA disables HPA |
| keda.maxReplicas | int | `10` | Number of maximum replicas for KEDA autoscaling |
| keda.minReplicas | int | `1` | Number of minimum replicas for KEDA autoscaling |
| keda.pollingInterval | int | `30` | Interval for checking each trigger [ref](https://keda.sh/docs/2.10/concepts/scaling-deployments/#pollinginterval) |
| keda.restoreToOriginalReplicaCount | bool | `false` | After scaled object is deleted return workload to initial replica count [ref](https://keda.sh/docs/2.10/concepts/scaling-deployments/#advanced) |
| keda.scaledObject.annotations | object | `{}` | Scaled object annotations, can be used to pause scaling [ref](https://keda.sh/docs/2.10/concepts/scaling-deployments/#pause-autoscaling) |
| keda.triggers | list | `[]` | Keda triggers [ref](https://keda.sh/docs/2.10/concepts/scaling-deployments/#triggers) see values for prometheus example |
| kubeVersionOverride | string | `""` | Allow override of kubernetes version by default this will be automatically detected and requires no modification |
| minReadySeconds | int | `10` | Define [minReadySeconds](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#min-ready-seconds) for deployments and statefulsets |
| monitoring | object | see below | Parameters for the Prometheus [ServiceMonitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.ServiceMonitor) or [PodMonitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.PodMonitor) objects. |
| monitoring.enabled | bool | `false` | Enable monitoring. If service.enabled is true chart will generate ServiceMonitor object, otherwise PodMonitor will be used. |
| monitoring.labels | object | `{}` | Provide additional labels to the ServiceMonitor metadata |
| monitoring.metricRelabelings | list | `[]` | Provide additional metricRelabelings to apply to samples before ingestion. |
| monitoring.relabelings | list | `[]` | Provide additional relabelings to apply to samples before scraping |
| monitoring.scheme | string | `"http"` | HTTP scheme to use for scraping. |
| monitoring.scrapeInterval | string | `"20s"` | Provide interval at which metrics should be scraped |
| monitoring.scrapePath | string | `"/metrics"` | Provide HTTP path to scrape for metrics. |
| monitoring.scrapePort | string | `"metrics"` | Provide named service port used for scraping |
| monitoring.scrapeTimeout | string | `"15s"` | Timeout after which the scrape is ended (must be less than scrapeInterval) |
| monitoring.targetLabels | list | `[]` | Additional metric labels |
| monitoring.tlsConfig | object | `{}` | TLS configuration to use when scraping the endpoint |
| nameOverride | string | `""` | Override release name used in calculated "releasename-chartname" default naming convention |
| networkPolicy.egress | list | `[]` | Define spec.egress for NetowkPolicy rules |
| networkPolicy.enabled | bool | `false` | Enables pod based [NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/) |
| networkPolicy.ingress | list | `[]` | Define spec.ingress for NetowkPolicy rules |
| networkPolicy.ingressNamespace | string | `"ingress"` | Define namespace where ingress controllers are deployed Used to generate automatic policy to enable ingress access when .Values.ingress is enabled |
| networkPolicy.monitoringNamespace | string | `"monitoring"` | Define namespace where monitoring stack is deployed Used to generate automatic policy to enable monitoring access when .Values.monitoring is enabled |
| nodeSelector | object | `{}` | Define custom [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) |
| persistency.accessModes | list | `["ReadWriteOnce"]` | Define storage [access modes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes). Must be supported by available storageClass |
| persistency.capacity.storage | string | `"5Gi"` | Define storage capacity |
| persistency.enabled | bool | `false` | Enable support for persistent volumes. Supported only in Statefulset deploymentMode with any number of replicas |
| persistency.mountPath | string | `"/data"` | Define path where persistent volume will be mounted in container |
| persistency.storageClassName | string | uses cluster default storageClassName | Define custom name for persistent storage class name |
| podAnnotations | object | `{}` | Define pod's [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) |
| podAntiAffinity | string | `""` | Pod anti-affinity can prevent the scheduler from placing application replicas on the same node. The default value "soft" means that the scheduler should *prefer* to not schedule two replica pods  onto the same node but no guarantee is provided. The value "hard" means that the scheduler is *required* to not schedule two replica pods onto the same node. The value "" will disable pod anti-affinity so that no anti-affinity rules will be configured. |
| podAntiAffinityTopologyKey | string | `"kubernetes.io/hostname"` | If anti-affinity is enabled sets the topologyKey to use for anti-affinity. This can be changed to, for example, failure-domain.beta.kubernetes.io/zone |
| podDisruptionBudget.enabled | bool | `false` | Enable and define pod disruption budget default (off) see: [podDisruptionBudget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) |
| podDisruptionBudget.maxUnavailable | int | `nil` | Maximum unavailable replicas |
| podDisruptionBudget.minAvailable | int | `1` | Minimum available replicas |
| podExtraLabels | object | `{}` | Define pod's extra [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) |
| podSecurityContext | object | `{}` | Define pod's [securityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) |
| ports | list | `[]` | Define container ports that will be exposed see: [containerPort](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#containerport-v1-core) |
| replicaCount | int | `1` | Number of pods to load balance across. Applicable to Deployment and Statefulset deploymentMode |
| resources | object | `{}` | We usually recommend not to specify default resources and to leave this as a conscious choice for the user. This also increases chances charts run on environments with little resources, such as Minikube. See [resources](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for syntax |
| securityContext | object | `{}` | Define container's [securityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container) |
| service.enabled | bool | `true` | Controls if the service should be deployed for this release |
| service.headless | bool | `false` | Create a headless service see [ref](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services) |
| service.ports | list | `[]` | Define listening port for service ref: [servicePort](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#serviceport-v1-core) see values.yaml for example |
| service.type | string | `"ClusterIP"` | Service type see [Reference](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) for available options. |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Define pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |
| topologySpreadConstraints | list | `[]` | Define custom [topologySpreadConstraings](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/) |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)

## Changelog

### 1.0.0

#### Breaking changes:
- Persistent volumes are now available only with statefulsets. Previous version of chart allowed for persistent volumes with deploymentMode: Deployment when replicaCount was less than 2. From version 1.0.0 persistent volumes will be supported only for statefulsets.
- configMaps in version 0.8.0 where not generating unique names across releases. Starting from version 1.0.0 defined configmap names will have their final name prefixed using fullname helper function.

#### New Features:
- added support for defining NetworkPolicy objects (https://kubernetes.io/docs/concepts/services-networking/network-policies/) by using .Values.networkPolicy. If networkpolicies are enabled, chart will automatically add ingress rules for monitoring and ingress
- it is now possible to define multiple containers in pods by using .Values.additionalContainers
- extended support for defining fine grained resource options for each container in .Values.additionalContainers and .Values.initContainers
- added support for mounting configmaps as volumes in pods by using .Values.configMaps[].mount: True and defining .Values.configMaps[].mountPath
- added deploymentMode of type Cronjob. See .Values.cronjobspec for more details
- added support for defining minReadySeconds for Deployments and Statefulsets
- added support for defining topologySpreadConstraints
- added .Values.podAntiAffinity and .Values.podAntiAffinityTopologyKey for easier definition of pod antiaffinity rules.
- added support for defining main container lifecycle hooks in .Values.image.lifecycle
- other code improvements and bug fixes

### 0.9.0
- added KEDA 2.x support

### 0.8.2
- add option to disable automatic healthcheck probes

### 0.8.1
*Breaking change*
- Use fullname helper for defining app.kubernetes.io/name. This fixes scenario where app.kubernetes.io/name would always be kubedeploy if nameOverride is not set. In this fix, fullNameOverride will be used first, then nameOverride if present, if none are present, use release name + chart name as app name label
- Use image.tag value if available for app.kubernetes.io/version

### 0.8.0
- added support for defining ConfigMap objects from values

### 0.7.1
- fixed bug with monitoring label matchers
- fixed bug with default scrapeTimeout value

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

