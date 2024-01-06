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

<form class="md-search__form" name="value-search">
      <input id="value-search" type="text" class="md-search__input value-search__input" aria-label="Search for value" placeholder="Search for value">
      <label class="md-search__icon md-icon value-search__icon" for="__search">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M9.5 3A6.5 6.5 0 0 1 16 9.5c0 1.61-.59 3.09-1.56 4.23l.27.27h.79l5 5-1.5 1.5-5-5v-.79l-.27-.27A6.516 6.516 0 0 1 9.5 16 6.5 6.5 0 0 1 3 9.5 6.5 6.5 0 0 1 9.5 3m0 2C7 5 5 7 5 9.5S7 14 9.5 14 14 12 14 9.5 12 5 9.5 5Z"></path></svg>
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M20 11v2H8l5.5 5.5-1.42 1.42L4.16 12l7.92-7.92L13.5 5.5 8 11h12Z"></path></svg>
      </label>

    </form>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| [:fontawesome-solid-book:  additionalContainers](../start/values/additionalcontainers.md) | object | see subvalues | [additionalContainers](https://kubernetes.io/docs/concepts/workloads/pods/#how-pods-manage-multiple-containers) settings |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } additionalContainers.containers | list | see subvalues | Sequential list of additionalContainers. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } additionalContainers.containers[0].args | optional | `[]` | Define custom arguments for additionalContainer |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } additionalContainers.containers[0].command | optional | `["sh","-c","while true; do sleep 30; done;"]` | Define custom command for additionalContainer |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } additionalContainers.containers[0].healthcheck | optional | see subvalues | Define healthcheck probes for additionalContainer |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } additionalContainers.containers[0].healthcheck.enabled | bool | `false` | Enable custom healthcheck probes for additionalContainer |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } additionalContainers.containers[0].healthcheck.probes.livenessProbe | object | `{}` | Define [livenessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } additionalContainers.containers[0].healthcheck.probes.readinessProbe | object | `{}` | Define [readinessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } additionalContainers.containers[0].healthcheck.probes.startupProbe | object | `{}` | Define [startupProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-startup-probes) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } additionalContainers.containers[0].ports | optional | `[]` | Define additionalContainer exposed ports see: [containerPort](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#containerport-v1-core) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } additionalContainers.containers[0].repository | required | `"busybox"` | Define additionalContainer repository |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } additionalContainers.containers[0].resources | optional | `{}` | Define custom resources for this specific additionalContainer. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } additionalContainers.containers[0].tag | optional | `"latest"` | Define additionalContainer image tag |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } additionalContainers.enabled | bool | `false` | Define if additionalContainers are enabled |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } additionalContainers.pullPolicy | optional | `"IfNotPresent"` | additionalContainers image pull policy |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } additionalContainers.resources | optional | `{}` | Define additionalContainers global resource requests and limits. Will be applied to all additionalContainers if more specific (per container) resource requests and limits are not defined |
| [:fontawesome-solid-book:  affinity](../start/values/affinity.md) | object | `{}` | Define Pod [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) disables automatic podAntiAffinity rules if defined. |
| [:fontawesome-solid-book:  autoscaling](../start/values/autoscaling.md) | object | see subvalues | Autoscaling settings |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } autoscaling.behavior | object | `{}` | HPA configurable scaling behavior see [ref](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#configurable-scaling-behavior) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } autoscaling.enabled | bool | `false` | Enable autoscaling. Works only with deploymentMode=**Deployment** |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } autoscaling.maxReplicas | int | `10` | Maximum number of Pod replicas |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } autoscaling.minReplicas | int | `1` | Minimum number of Pod replicas |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } autoscaling.targetCPUUtilizationPercentage | int | `80` | Scaling target CPU utilization as percentage of resources.requests.cpu |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } autoscaling.targetMemoryUtilizationPercentage | int | `nil` | Scaling target memory utilization as percentage of resources.requests.mem |
| [:fontawesome-solid-book:  configMaps](../start/values/configmaps.md) | list | `[]` | Define a list of extra ConfigMap objects. See values.yaml or chart documentation for examples on syntax |
| [:fontawesome-solid-book:  configMapsHash](../start/values/configmapshash.md) | bool | `false` | Redeploy Deployments and Statefulsets if deployed ConfigMaps content change. |
| [:fontawesome-solid-book:  cronjobspec](../start/values/cronjobspec.md) | object | see subvalues | Cronjobspec settings |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } cronjobspec.args | list | `[]` | Define args for cronjob  Starting from Kubedeploy version 1.2 you should start using `image.args` instead of `cronjobspec.args`. Values will be available as failsafe up to Kubedeploy 2.0 when they will be removed. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } cronjobspec.backoffLimit | int | `3` | Define job backoff limit, see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/job/#pod-backoff-failure-policy) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } cronjobspec.command | list | `[]` | Define command for cronjob  Starting from Kubedeploy version 1.2 you should start using `image.command` instead of `cronjobspec.command`. Values will be available as failsafe up to Kubedeploy 2.0 when they will be removed. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } cronjobspec.concurrencyPolicy | string | `""` | Define concurrency policy options: Allow (default), Forbid or Replace, see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#concurrency-policy) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } cronjobspec.failedJobsHistoryLimit | int | `1` | Define number of failed Job logs to keep |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } cronjobspec.schedule | string | `"0 * * * *"` | Define cronjob schedule, for details see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#writing-a-cronjob-spec) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } cronjobspec.startingDeadlineSeconds | optional | `180` | Define deadline for starting the job, see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#starting-deadline) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } cronjobspec.successfulJobsHistoryLimit | int | `3` | Define number of successful Job logs to keep |
| [:fontawesome-solid-book:  deploymentMode](../start/values/deploymentmode.md) | string | `"Deployment"` | Available deployment modes, currently supported:   <ul><li>**Deployment**</li>   <li>**Statefulset**</li>   <li>**Job**</li>   <li>**Cronjob**</li>   <li>**None**</li></ul> |
| [:fontawesome-solid-book:  env](../start/values/env.md) | list | `[]` | Define environment variables for all containers in Pod. For reference see: [env](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#envvar-v1-core). |
| [:fontawesome-solid-book:  envFrom](../start/values/envfrom.md) | list | `[]` | Define environment variables from ConfigMap or Secret objects for all containers in Pod. For reference see [envFrom secret example](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#configure-all-key-value-pairs-in-a-secret-as-container-environment-variables) or [envFrom configmap example](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#configure-all-key-value-pairs-in-a-configmap-as-container-environment-variables) |
| [:fontawesome-solid-book:  extraIngress](../start/values/extraingress.md) | list | `[]` | list of extra Ingress objects to deploy. extraIngress requires additional name: parametar. see ingress values for required spec or values example. |
| [:fontawesome-solid-book:  extraObjects](../start/values/extraobjects.md) | list | `[]` | Create dynamic manifest via values (templated). See values.yaml or chart documentation for examples: |
| [:fontawesome-solid-book:  extraSecrets](../start/values/extrasecrets.md) | list | `[]` | Define a list of extra Secrets objects. See values.yaml or chart documentation for examples on syntax |
| [:fontawesome-solid-book:  extraVolumeMounts](../start/values/extravolumemounts.md) | list | `[]` | Define extra volume mounts for containers See values.yaml or chart documentation for examples on syntax |
| [:fontawesome-solid-book:  fullnameOverride](../start/values/fullnameoverride.md) | string | `""` | Override full resource names instead of using calculated "releasename-chartname" default naming convention |
| [:fontawesome-solid-book:  healthcheck](../start/values/healthcheck.md) | object | see subvalues | Healthcheck settings |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } healthcheck.disableAutomatic | bool | `false` | Disable automatic healthcheck probes. Automatic probes will always create a HTTP healthcheck probe if container has port named http, |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } healthcheck.enabled | bool | `false` | Define custom healthcheck probes for container. Overrides automatic probes. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } healthcheck.probes.livenessProbe | object | `{}` | Define [livenessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } healthcheck.probes.readinessProbe | object | `{}` | Define [readinessProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } healthcheck.probes.startupProbe | object | `{}` | Define [startupProbe](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-startup-probes) |
| [:fontawesome-solid-book:  image](../start/values/image.md) | object | see subvalues | Container image settings |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } image.args | list | `[]` | Define container custom arguments. [Reference](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } image.command | list | `[]` | Define container custom command. [Reference](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } image.lifecycle | object | `{}` | Define container custom [lifecycle hooks](https://kubernetes.io/docs/tasks/configure-pod-container/attach-handler-lifecycle-event/). [More info](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } image.pullPolicy | string | `"IfNotPresent"` | Default container pull policy |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } image.repository | string | `"nginx"` | Define container repository |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } image.tag | string | `"latest"` | Define container image tag |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } image.terminationGracePeriodSeconds | int | `30` | Define Pod [terminationGracePeriodSeconds](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#hook-handler-execution). Should be greater then expected run time of lifecycle hooks |
| [:fontawesome-solid-book:  imagePullSecrets](../start/values/imagepullsecrets.md) | list | `[]` | Define [ImagePullSecrets](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#podspec-v1-core) |
| [:fontawesome-solid-book:  ingress](../start/values/ingress.md) | object | see subvalues | [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) object settings. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } ingress.annotations | object | `{"cert-manager.io/cluster-issuer":"letsencrypt"}` | Additional Ingress annotations |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } ingress.className | string | `"haproxy"` | Ingress class name |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } ingress.enabled | bool | `false` | Enable Ingres for release |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } ingress.hosts | list | see subvalues | Ingress host list. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } ingress.hosts[0].host | string, required | `""` | Define Ingress hostname |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } ingress.hosts[0].paths | list | `[]` | Ingress host paths see values.yaml or chart documentation for examples |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } ingress.pathType | string | `"ImplementationSpecific"` | Default Ingress pathType |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } ingress.svcPort | string | first port from service.ports | Define default Service port that will be targeted by Ingress. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } ingress.tls | list | `[]` | Ingress TLS list. **overrides any auto configured tls config created by withSSL**.  Allows for custom secretName and host list to be defined. For cases where you have pre-configured SSL stored as Kubernetes secret. If secret does not exist, new one will be created by cert-manager. see values.yaml or chart documentation for examples: |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } ingress.withSSL | bool | `true` | Deploy Ingress object with SSL support. Automatically configures the Ingress tls spec with all the configured ingress.hosts in one Secret. |
| [:fontawesome-solid-book:  initContainers](../start/values/initcontainers.md) | object | see subvalues | [initContainers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/) settings |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } initContainers.containers | list | see subvalues | Sequential list of initContainers. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } initContainers.containers[0].args | optional | `[]` | Define custom arguments for initContainer |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } initContainers.containers[0].command | optional | `["sh","-c","exit 0"]` | Define custom command for initContainer |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } initContainers.containers[0].name | required | busybox-init | Define initContainer name |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } initContainers.containers[0].repository | required | `"busybox"` | Define initContainer repository |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } initContainers.containers[0].resources | optional | `{}` | Define custom resources for this specific initContainer. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } initContainers.containers[0].tag | optional | `"latest"` | Define initContainer image tag |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } initContainers.enabled | bool | `false` | Define if initContainers are enabled. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } initContainers.pullPolicy | optional | `"IfNotPresent"` | initContainers image pull policy |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } initContainers.resources | optional | `{}` | Define initContainers global resource requests and limits. Will be applied to all initContainers if more specific (per container) resource requests and limits are not defined |
| [:fontawesome-solid-book:  jobspec](../start/values/jobspec.md) | object | see subvalues | jobspec settings |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } jobspec.args | list | `[]` | Define args for Job  Starting from Kubedeploy version 1.2 you should start using `image.args` instead of `jobspec.args`. Values will be available as failsafe up to Kubedeploy 2.0 when they will be removed. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } jobspec.backoffLimit | int | `3` | Define Job backoff limit, see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/job/#pod-backoff-failure-policy) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } jobspec.command | list | `[]` | Define command for Job  Starting from Kubedeploy version 1.2 you should start using `image.command` instead of `jobspec.command`. Values will be available as failsafe up to Kubedeploy 2.0 when they will be removed. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } jobspec.parallelism | int | `1` | Define Job paralelisam, see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/job/#controlling-parallelism) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } jobspec.restartPolicy | string | `"OnFailure"` | Define restart policy for jobs if deploymentMode=**Job**, see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/job/#handling-pod-and-container-failures) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } jobspec.ttlSecondsAfterFinished | string | `"300"` | Define [Automatic Cleanup for Finished Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/ttlafterfinished/) |
| [:fontawesome-solid-book:  keda](../start/values/keda.md) | object | see subvalues | Keda settings |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } keda.behavior | object | `{}` | HPA configurable scaling behavior see [ref](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#configurable-scaling-behavior) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } keda.cooldownPeriod | int | `300` | The period to wait after the last trigger reported active before scaling the resource back to 0 [ref](https://keda.sh/docs/2.10/concepts/scaling-deployments/#cooldownperiod) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } keda.enabled | bool | `false` | Kubernetes Event-driven Autoscaling: KEDA 2.x [ref](https://keda.sh/docs/2.3/concepts/scaling-deployments/) **Note:** mutually exclusive with HPA, enabling KEDA disables HPA |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } keda.maxReplicas | int | `10` | Number of maximum replicas for KEDA autoscaling |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } keda.minReplicas | int | `1` | Number of minimum replicas for KEDA autoscaling |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } keda.pollingInterval | int | `30` | Interval for checking each trigger [ref](https://keda.sh/docs/2.10/concepts/scaling-deployments/#pollinginterval) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } keda.restoreToOriginalReplicaCount | bool | `false` | After scaled object is deleted return workload to initial replica count [ref](https://keda.sh/docs/2.10/concepts/scaling-deployments/#advanced) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } keda.scaledObject.annotations | object | `{}` | Scaled object annotations, can be used to pause scaling [ref](https://keda.sh/docs/2.10/concepts/scaling-deployments/#pause-autoscaling) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } keda.triggers | list | `[]` | Keda triggers [ref](https://keda.sh/docs/2.10/concepts/scaling-deployments/#triggers) see values for prometheus example |
| [:fontawesome-solid-book:  kubeVersionOverride](../start/values/kubeversionoverride.md) | string | `""` | Allow override of auto-detected Kubernetes version |
| [:fontawesome-solid-book:  minReadySeconds](../start/values/minreadyseconds.md) | int | `10` | Define [minReadySeconds](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#min-ready-seconds) for deployments and statefulsets |
| [:fontawesome-solid-book:  monitoring](../start/values/monitoring.md) | object | see subvalues | Monitoring settings. Will define Prometheus [ServiceMonitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.ServiceMonitor) or [PodMonitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.PodMonitor) objects. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } monitoring.enabled | bool | `false` | Enable monitoring. If service.enabled=True chart will generate ServiceMonitor object, otherwise PodMonitor will be used. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } monitoring.labels | object | `{}` | Provide additional labels to the ServiceMonitor metadata |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } monitoring.metricRelabelings | list | `[]` | Provide additional metricRelabelings to apply to samples before ingestion. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } monitoring.relabelings | list | `[]` | Provide additional relabelings to apply to samples before scraping |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } monitoring.scheme | string | `"http"` | HTTP scheme to use for scraping. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } monitoring.scrapeInterval | string | `"20s"` | Provide interval at which metrics should be scraped |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } monitoring.scrapePath | string | `"/metrics"` | Provide HTTP path to scrape for metrics. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } monitoring.scrapePort | string | `"metrics"` | Provide named service port used for scraping |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } monitoring.scrapeTimeout | string | `"15s"` | Timeout after which the scrape is ended (must be less than scrapeInterval) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } monitoring.targetLabels | list | `[]` | Additional metric labels |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } monitoring.tlsConfig | object | `{}` | TLS configuration to use when scraping the endpoint |
| [:fontawesome-solid-book:  nameOverride](../start/values/nameoverride.md) | string | `""` | Override release name used in calculated "releasename-chartname" default naming convention |
| [:fontawesome-solid-book:  networkPolicy](../start/values/networkpolicy.md) | object | see subvalues | networkPolicy settings |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } networkPolicy.egress | list | `[]` | Define spec.egress for [NetowkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/) rules |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } networkPolicy.enabled | bool | `false` | Enables Pod based [NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } networkPolicy.ingress | list | `[]` | Define spec.ingress for [NetowkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/) rules |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } networkPolicy.ingressNamespace | string | `"ingress"` | Define Namespace where Ingress controller is deployed. Used to generate automatic policy to enable ingress access when .Values.ingress is enabled |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } networkPolicy.monitoringNamespace | string | `"monitoring"` | Define namespace where monitoring stack is deployed Used to generate automatic policy to enable monitoring access when .Values.monitoring is enabled |
| [:fontawesome-solid-book:  nodeSelector](../start/values/nodeselector.md) | object | `{}` | Define custom [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector) for Pod |
| [:fontawesome-solid-book:  persistency](../start/values/persistency.md) | object | see subvalues | persistency settings |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } persistency.accessModes | list | `["ReadWriteOnce"]` | Define storage [access modes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes). Must be supported by available storageClass |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } persistency.capacity.storage | string | `"5Gi"` | Define storage capacity |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } persistency.enabled | bool | `false` | Enable support for persistent volumes. Supported only if deploymentMode=Statefulset. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } persistency.mountPath | string | `"/data"` | Define where persistent volume will be mounted in containers. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } persistency.storageClassName | string | uses cluster default storageClassName | Define custom name for persistent storage class name |
| [:fontawesome-solid-book:  podAnnotations](../start/values/podannotations.md) | object | `{}` | Define Pod [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/) |
| [:fontawesome-solid-book:  podAntiAffinity](../start/values/podantiaffinity.md) | string | `""` | Pod anti-affinity can prevent the scheduler from placing application replicas on the same node. The default value "soft" means that the scheduler should *prefer* to not schedule two replica pods  onto the same node but no guarantee is provided. The value "hard" means that the scheduler is *required* to not schedule two replica pods onto the same node. The value "" will disable pod anti-affinity so that no anti-affinity rules will be configured. |
| [:fontawesome-solid-book:  podAntiAffinityTopologyKey](../start/values/podantiaffinitytopologykey.md) | string | `"kubernetes.io/hostname"` | If anti-affinity is enabled sets the topologyKey to use for anti-affinity. This can be changed to, for example, failure-domain.beta.kubernetes.io/zone |
| [:fontawesome-solid-book:  podDisruptionBudget](../start/values/poddisruptionbudget.md) | object | see subvalues | podDisruptionBudget settings |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } podDisruptionBudget.enabled | bool | `false` | Enable Pod disruption budget see: [podDisruptionBudget](https://kubernetes.io/docs/tasks/run-application/configure-pdb/) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } podDisruptionBudget.maxUnavailable | int | `nil` | Maximum unavailable replicas |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } podDisruptionBudget.minAvailable | int | `1` | Minimum available replicas |
| [:fontawesome-solid-book:  podExtraLabels](../start/values/podextralabels.md) | object | `{}` | Define Pod extra [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) |
| [:fontawesome-solid-book:  podSecurityContext](../start/values/podsecuritycontext.md) | object | `{}` | Define Pod [securityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) |
| [:fontawesome-solid-book:  ports](../start/values/ports.md) | list | `[]` | Define container exposed ports see: [containerPort](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#containerport-v1-core) |
| [:fontawesome-solid-book:  replicaCount](../start/values/replicacount.md) | int | `1` | Number of Pod replicas to be deployed. Applicable to Deployment and Statefulset deploymentMode |
| [:fontawesome-solid-book:  resources](../start/values/resources.md) | object | `{}` | Container resource requests and limits. Resource requests and limits are left as a conscious choice for the user. This also increases chances charts run on environments with little resources, such as Minikube. See [resources](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for syntax |
| [:fontawesome-solid-book:  securityContext](../start/values/securitycontext.md) | object | `{}` | Define container [securityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container) |
| [:fontawesome-solid-book:  service](../start/values/service.md) | object | see subvalues | Service object settings |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } service.enabled | bool | `true` | Enable Service provisioning for release. |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } service.headless | bool | `false` | Create a headless service. See [reference](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services) |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } service.ports | list | `[]` | Define listening ports for Service. If unspecified, chart will automatically generate ports list based on main container exposed ports. see values.yaml or chart documentation for syntax examples |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } service.type | string | `"ClusterIP"` | Set Service type. See [Service](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) for available options. |
| [:fontawesome-solid-book:  serviceAccount](../start/values/serviceaccount.md) | object | see subvalues | serviceAccount settings |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| :fontawesome-solid-arrow-turn-up:{ .rotate-90 } serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| [:fontawesome-solid-book:  tolerations](../start/values/tolerations.md) | list | `[]` | Define Pod [tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) |
| [:fontawesome-solid-book:  topologySpreadConstraints](../start/values/topologyspreadconstraints.md) | list | `[]` | Define custom [topologySpreadConstraings](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/) for Pod |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.12.0](https://github.com/norwoodj/helm-docs/releases/v1.12.0)
