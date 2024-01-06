---
hide:
  - navigation
  - toc
---
# kubedeploy

![Version: 1.2.1](https://img.shields.io/badge/Version-1.2.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.2.1](https://img.shields.io/badge/AppVersion-1.2.1-informational?style=flat-square)

**Homepage:** <https://kubedeploy.app/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Branko Toic | <branko@sysbee.net> | <https://www.sysbee.net> |

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
| additionalContainers | object | see subvalues | [additionalContainers](https://kubernetes.io/docs/concepts/workloads/pods/#how-pods-manage-multiple-containers) settings |
| additionalContainers.containers | list | see subvalues | Sequential list of additionalContainers. |
| additionalContainers.containers[0].args | optional | `[]` | Define custom arguments for additionalContainer |
| additionalContainers.containers[0].command | optional | `["sh","-c","while true; do sleep 30; done;"]` | Define custom command for additionalContainer |
| additionalContainers.containers[0].healthcheck | optional | see subvalues | Define healthcheck probes for additionalContainer |
| additionalContainers.containers[0].healthcheck.enabled | bool | `false` | Enable custom healthcheck probes for additionalContainer |
| additionalContainers.containers[0].healthcheck.probes.livenessProbe | object | `{}` | Define [livenessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| additionalContainers.containers[0].healthcheck.probes.readinessProbe | object | `{}` | Define [readinessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| additionalContainers.containers[0].healthcheck.probes.startupProbe | object | `{}` | Define [startupProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-startup-probes) |
| additionalContainers.containers[0].ports | optional | `[]` | Define additionalContainer exposed ports see: [containerPort](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#containerport-v1-core) |
| additionalContainers.containers[0].repository | required | `"busybox"` | Define additionalContainer repository |
| additionalContainers.containers[0].resources | optional | `{}` | Define custom resources for this specific additionalContainer. |
| additionalContainers.containers[0].tag | optional | `"latest"` | Define additionalContainer image tag |
| additionalContainers.enabled | bool | `false` | Define if additionalContainers are enabled |
| additionalContainers.pullPolicy | optional | `"IfNotPresent"` | additionalContainers image pull policy |
| additionalContainers.resources | optional | `{}` | Define additionalContainers global resource requests and limits. Will be applied to all additionalContainers if more specific (per container) resource requests and limits are not defined |
| affinity | object | `{}` | Define Pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) disables automatic podAntiAffinity rules if defined. |
| autoscaling | object | see subvalues | Autoscaling settings |
| autoscaling.behavior | object | `{}` | HPA configurable scaling behavior see [ref](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#configurable-scaling-behavior) |
| autoscaling.enabled | bool | `false` | Enable autoscaling. Works only with deploymentMode=**Deployment** |
| autoscaling.maxReplicas | int | `10` | Maximum number of Pod replicas |
| autoscaling.minReplicas | int | `1` | Minimum number of Pod replicas |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | Scaling target CPU utilization as percentage of resources.requests.cpu |
| autoscaling.targetMemoryUtilizationPercentage | int | `nil` | Scaling target memory utilization as percentage of resources.requests.mem |
| configMaps | list | `[]` | Define a list of extra ConfigMap objects. See values.yaml or chart documentation for examples on syntax |
| configMapsHash | bool | `false` | Redeploy Deployments and Statefulsets if deployed ConfigMaps content change. |
| cronjobspec | object | see subvalues | Cronjobspec settings |
| cronjobspec.args | list | `[]` | Define args for cronjob  Starting from Kubedeploy version 1.2 you should start using `image.args` instead of `cronjobspec.args`. Values will be available as failsafe up to Kubedeploy 2.0 when they will be removed. |
| cronjobspec.backoffLimit | int | `3` | Define job backoff limit, see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/job/#pod-backoff-failure-policy) |
| cronjobspec.command | list | `[]` | Define command for cronjob  Starting from Kubedeploy version 1.2 you should start using `image.command` instead of `cronjobspec.command`. Values will be available as failsafe up to Kubedeploy 2.0 when they will be removed. |
| cronjobspec.concurrencyPolicy | string | `""` | Define concurrency policy options: Allow (default), Forbid or Replace, see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#concurrency-policy) |
| cronjobspec.failedJobsHistoryLimit | int | `1` | Define number of failed Job logs to keep |
| cronjobspec.schedule | string | `"0 * * * *"` | Define cronjob schedule, for details see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#writing-a-cronjob-spec) |
| cronjobspec.startingDeadlineSeconds | optional | `180` | Define deadline for starting the job, see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#starting-deadline) |
| cronjobspec.successfulJobsHistoryLimit | int | `3` | Define number of successful Job logs to keep |
| deploymentMode | string | `"Deployment"` | Available deployment modes, currently supported:   <ul><li>**Deployment**</li>   <li>**Statefulset**</li>   <li>**Job**</li>   <li>**Cronjob**</li>   <li>**None**</li></ul> |
| env | list | `[]` | Define environment variables for all containers in Pod. For reference see: [env](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#envvar-v1-core). |
| envFrom | list | `[]` | Define environment variables from ConfigMap or Secret objects for all containers in Pod. For reference see [envFrom secret example](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#configure-all-key-value-pairs-in-a-secret-as-container-environment-variables) or [envFrom configmap example](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#configure-all-key-value-pairs-in-a-configmap-as-container-environment-variables) |
| extraIngress | list | `[]` | list of extra Ingress objects to deploy. extraIngress requires additional name: parametar. see ingress values for required spec or values example. |
| extraObjects | list | `[]` | Create dynamic manifest via values (templated). See values.yaml or chart documentation for examples: |
| extraSecrets | list | `[]` | Define a list of extra Secrets objects. See values.yaml or chart documentation for examples on syntax |
| extraVolumeMounts | list | `[]` | Define extra volume mounts for containers See values.yaml or chart documentation for examples on syntax |
| fullnameOverride | string | `""` | Override full resource names instead of using calculated "releasename-chartname" default naming convention |
| healthcheck | object | see subvalues | Healthcheck settings |
| healthcheck.disableAutomatic | bool | `false` | Disable automatic healthcheck probes. Automatic probes will always create a HTTP healthcheck probe if container has port named http, |
| healthcheck.enabled | bool | `false` | Define custom healthcheck probes for container. Overrides automatic probes. |
| healthcheck.probes.livenessProbe | object | `{}` | Define [livenessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| healthcheck.probes.readinessProbe | object | `{}` | Define [readinessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| healthcheck.probes.startupProbe | object | `{}` | Define [startupProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-startup-probes) |
| image | object | see subvalues | Container image settings |
| image.args | list | `[]` | Define container custom arguments. [Reference](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/) |
| image.command | list | `[]` | Define container custom command. [Reference](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/) |
| image.lifecycle | object | `{}` | Define container custom [lifecycle hooks](https://kubernetes.io/docs/tasks/configure-pod-container/attach-handler-lifecycle-event/). [More info](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/) |
| image.pullPolicy | string | `"IfNotPresent"` | Default container pull policy |
| image.repository | string | `"nginx"` | Define container repository |
| image.tag | string | `"latest"` | Define container image tag |
| image.terminationGracePeriodSeconds | int | `30` | Define Pod [terminationGracePeriodSeconds](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#hook-handler-execution). Should be greater then expected run time of lifecycle hooks |
| imagePullSecrets | list | `[]` | Define [ImagePullSecrets](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#podspec-v1-core) |
| ingress | object | see subvalues | [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) object settings. |
| ingress.annotations | object | `{"cert-manager.io/cluster-issuer":"letsencrypt"}` | Additional Ingress annotations |
| ingress.className | string | `"haproxy"` | Ingress class name |
| ingress.enabled | bool | `false` | Enable Ingres for release |
| ingress.hosts | list | see subvalues | Ingress host list. |
| ingress.hosts[0].host | string, required | `""` | Define Ingress hostname |
| ingress.hosts[0].paths | list | `[]` | Ingress host paths see values.yaml or chart documentation for examples |
| ingress.pathType | string | `"ImplementationSpecific"` | Default Ingress pathType |
| ingress.svcPort | string | first port from service.ports | Define default Service port that will be targeted by Ingress. |
| ingress.tls | list | `[]` | Ingress TLS list. **overrides any auto configured tls config created by withSSL**.  Allows for custom secretName and host list to be defined. For cases where you have pre-configured SSL stored as Kubernetes secret. If secret does not exist, new one will be created by cert-manager. see values.yaml or chart documentation for examples: |
| ingress.withSSL | bool | `true` | Deploy Ingress object with SSL support. Automatically configures the Ingress tls spec with all the configured ingress.hosts in one Secret. |
| initContainers | object | see subvalues | [initContainers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) settings |
| initContainers.containers | list | see subvalues | Sequential list of initContainers. |
| initContainers.containers[0].args | optional | `[]` | Define custom arguments for initContainer |
| initContainers.containers[0].command | optional | `["sh","-c","exit 0"]` | Define custom command for initContainer |
| initContainers.containers[0].name | required | busybox-init | Define initContainer name |
| initContainers.containers[0].repository | required | `"busybox"` | Define initContainer repository |
| initContainers.containers[0].resources | optional | `{}` | Define custom resources for this specific initContainer. |
| initContainers.containers[0].tag | optional | `"latest"` | Define initContainer image tag |
| initContainers.enabled | bool | `false` | Define if initContainers are enabled. |
| initContainers.pullPolicy | optional | `"IfNotPresent"` | initContainers image pull policy |
| initContainers.resources | optional | `{}` | Define initContainers global resource requests and limits. Will be applied to all initContainers if more specific (per container) resource requests and limits are not defined |
| jobspec | object | see subvalues | jobspec settings |
| jobspec.args | list | `[]` | Define args for Job  Starting from Kubedeploy version 1.2 you should start using `image.args` instead of `jobspec.args`. Values will be available as failsafe up to Kubedeploy 2.0 when they will be removed. |
| jobspec.backoffLimit | int | `3` | Define Job backoff limit, see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/job/#pod-backoff-failure-policy) |
| jobspec.command | list | `[]` | Define command for Job  Starting from Kubedeploy version 1.2 you should start using `image.command` instead of `jobspec.command`. Values will be available as failsafe up to Kubedeploy 2.0 when they will be removed. |
| jobspec.parallelism | int | `1` | Define Job paralelisam, see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/job/#controlling-parallelism) |
| jobspec.restartPolicy | string | `"OnFailure"` | Define restart policy for jobs if deploymentMode=**Job**, see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/job/#handling-pod-and-container-failures) |
| jobspec.ttlSecondsAfterFinished | string | `"300"` | Define [Automatic Cleanup for Finished Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/ttlafterfinished/) |
| keda | object | see subvalues | Keda settings |
| keda.behavior | object | `{}` | HPA configurable scaling behavior see [ref](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#configurable-scaling-behavior) |
| keda.cooldownPeriod | int | `300` | The period to wait after the last trigger reported active before scaling the resource back to 0 [ref](https://keda.sh/docs/2.10/concepts/scaling-deployments/#cooldownperiod) |
| keda.enabled | bool | `false` | Kubernetes Event-driven Autoscaling: KEDA 2.x [ref](https://keda.sh/docs/2.3/concepts/scaling-deployments/) **Note:** mutually exclusive with HPA, enabling KEDA disables HPA |
| keda.maxReplicas | int | `10` | Number of maximum replicas for KEDA autoscaling |
| keda.minReplicas | int | `1` | Number of minimum replicas for KEDA autoscaling |
| keda.pollingInterval | int | `30` | Interval for checking each trigger [ref](https://keda.sh/docs/2.10/concepts/scaling-deployments/#pollinginterval) |
| keda.restoreToOriginalReplicaCount | bool | `false` | After scaled object is deleted return workload to initial replica count [ref](https://keda.sh/docs/2.10/concepts/scaling-deployments/#advanced) |
| keda.scaledObject.annotations | object | `{}` | Scaled object annotations, can be used to pause scaling [ref](https://keda.sh/docs/2.10/concepts/scaling-deployments/#pause-autoscaling) |
| keda.triggers | list | `[]` | Keda triggers [ref](https://keda.sh/docs/2.10/concepts/scaling-deployments/#triggers) see values for prometheus example |
| kubeVersionOverride | string | `""` | Allow override of auto-detected Kubernetes version |
| minReadySeconds | int | `10` | Define [minReadySeconds](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#min-ready-seconds) for deployments and statefulsets |
| monitoring | object | see subvalues | Monitoring settings. Will define Prometheus [ServiceMonitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.ServiceMonitor) or [PodMonitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.PodMonitor) objects. |
| monitoring.enabled | bool | `false` | Enable monitoring. If service.enabled=True chart will generate ServiceMonitor object, otherwise PodMonitor will be used. |
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
| networkPolicy | object | see subvalues | networkPolicy settings |
| networkPolicy.egress | list | `[]` | Define spec.egress for [NetowkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/) rules |
| networkPolicy.enabled | bool | `false` | Enables Pod based [NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/) |
| networkPolicy.ingress | list | `[]` | Define spec.ingress for [NetowkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/) rules |
| networkPolicy.ingressNamespace | string | `"ingress"` | Define Namespace where Ingress controller is deployed. Used to generate automatic policy to enable ingress access when .Values.ingress is enabled |
| networkPolicy.monitoringNamespace | string | `"monitoring"` | Define namespace where monitoring stack is deployed Used to generate automatic policy to enable monitoring access when .Values.monitoring is enabled |
| nodeSelector | object | `{}` | Define custom [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) for Pod |
| persistency | object | see subvalues | persistency settings |
| persistency.accessModes | list | `["ReadWriteOnce"]` | Define storage [access modes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes). Must be supported by available storageClass |
| persistency.capacity.storage | string | `"5Gi"` | Define storage capacity |
| persistency.enabled | bool | `false` | Enable support for persistent volumes. Supported only if deploymentMode=Statefulset. |
| persistency.mountPath | string | `"/data"` | Define where persistent volume will be mounted in containers. |
| persistency.storageClassName | string | uses cluster default storageClassName | Define custom name for persistent storage class name |
| podAnnotations | object | `{}` | Define Pod [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) |
| podAntiAffinity | string | `""` | Pod anti-affinity can prevent the scheduler from placing application replicas on the same node. The default value "soft" means that the scheduler should *prefer* to not schedule two replica pods  onto the same node but no guarantee is provided. The value "hard" means that the scheduler is *required* to not schedule two replica pods onto the same node. The value "" will disable pod anti-affinity so that no anti-affinity rules will be configured. |
| podAntiAffinityTopologyKey | string | `"kubernetes.io/hostname"` | If anti-affinity is enabled sets the topologyKey to use for anti-affinity. This can be changed to, for example, failure-domain.beta.kubernetes.io/zone |
| podDisruptionBudget | object | see subvalues | podDisruptionBudget settings |
| podDisruptionBudget.enabled | bool | `false` | Enable Pod disruption budget see: [podDisruptionBudget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) |
| podDisruptionBudget.maxUnavailable | int | `nil` | Maximum unavailable replicas |
| podDisruptionBudget.minAvailable | int | `1` | Minimum available replicas |
| podExtraLabels | object | `{}` | Define Pod extra [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) |
| podSecurityContext | object | `{}` | Define Pod [securityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) |
| ports | list | `[]` | Define container exposed ports see: [containerPort](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#containerport-v1-core) |
| replicaCount | int | `1` | Number of Pod replicas to be deployed. Applicable to Deployment and Statefulset deploymentMode |
| resources | object | `{}` | Container resource requests and limits. Resource requests and limits are left as a conscious choice for the user. This also increases chances charts run on environments with little resources, such as Minikube. See [resources](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for syntax |
| securityContext | object | `{}` | Define container [securityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container) |
| service | object | see subvalues | Service object settings |
| service.enabled | bool | `true` | Enable Service provisioning for release. |
| service.headless | bool | `false` | Create a headless service. See [reference](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services) |
| service.ports | list | `[]` | Define listening ports for Service. If unspecified, chart will automatically generate ports list based on main container exposed ports. see values.yaml or chart documentation for syntax examples |
| service.type | string | `"ClusterIP"` | Set Service type. See [Service](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) for available options. |
| serviceAccount | object | see subvalues | serviceAccount settings |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| tolerations | list | `[]` | Define Pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |
| topologySpreadConstraints | list | `[]` | Define custom [topologySpreadConstraings](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/) for Pod |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.12.0](https://github.com/norwoodj/helm-docs/releases/v1.12.0)
