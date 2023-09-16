# CHANGELOG

## 1.1.0

Public [chart documentation](https://kubedeploy.app) is now available, featuring Quickstart guide, full documentation per each configuration value,  as well as deployment examples.


### New features

- added: extraObjects
- added: envFrom
- added: headless service support
- added: configMapsHash
- added: ingress - svcPort for targeting backends
- added: ingress - per path overrides for svcPort and pathType
- added: ingress - withSSL support (automatic tls spec configuration)
- added: podExtraLabels
- added: extraVolumeMounts
- added: extraSecrets
- added: unit tests for each top-level values.yaml configuration key

### Changes

- change: split deployment tests
- fixed: empty lines in volumeMounts
- change: ingress - make path in host optional
- change: statefulsets template will use kubedeploy.kubeVersion function when checking for Kubernetes version
- change: ingress - host in hosts list is now required.
- change: ingress - removed default dummy domain from ingress hosts
- change: ingress - ingress.tls is now empty and optional in favor of withSSL. If defined by user it will override withSSL configuration.
- change: ingress - template will use kubedeploy.kubeVersion function when checking for Kubernetes version
- change: service - default ports are now empty and optional. Template will try to autodetect container ports if service.ports are unspecified

### Fixes

- bugfix: use standardized label selectors for chart managed NetworkPolicy objects
- bugfix: set default value (healthcheck.enabled: false) for additoinalContainers healthcheck if unspecified
- bugfix: autoscaling HPA object spec bug
- bugfix: ingress - will now respect path under hosts list (previusly always defaulted to /)
- bugfix: affinity will now disable automatic podAntiAffinity rules reducing possibility of rule collisions.


## 1.0.0

### Breaking changes
- Persistent volumes are now available only with statefulsets. Previous version of chart allowed for persistent volumes with deploymentMode: Deployment when replicaCount was less than 2. From version 1.0.0 persistent volumes will be supported only for statefulsets.
- configMaps in version 0.8.0 where not generating unique names across releases. Starting from version 1.0.0 defined configmap names will have their final name prefixed using fullname helper function.

### New Features
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

## 0.9.0
- added KEDA 2.x support

## 0.8.2
- add option to disable automatic healthcheck probes

## 0.8.1
*Breaking change*
- Use fullname helper for defining app.kubernetes.io/name. This fixes scenario where app.kubernetes.io/name would always be kubedeploy if nameOverride is not set. In this fix, fullNameOverride will be used first, then nameOverride if present, if none are present, use release name + chart name as app name label
- Use image.tag value if available for app.kubernetes.io/version

## 0.8.0
- added support for defining ConfigMap objects from values

## 0.7.1
- fixed bug with monitoring label matchers
- fixed bug with default scrapeTimeout value

## 0.7.0
- added support for enabling monitoring via prometheus operator.
- cleaned up helmchart documentation for easier readability

## 0.6.0
- added support for overriding healthcheck probes

## 0.5.1
- added support for multiple init containers in Job, Deployment and Statefulset deployment mode

## 0.5.0
- added support for init container in Job, Deployment and Statefulset deployment mode

## 0.4.4
- don't set port 80 on containers by default
- deploy liveness and readiness probes only when http port name is defined

## 0.4.3
- fix ingress backend port targeting

## 0.4.2
- fixed wrongly nested command option in deployment and statefulset

## 0.4.1
- added support for image commands

## 0.4.0
- added support for job workloads
- added support for statefulset workloads
- minor bug fixes

## 0.3.2
- fixed container name to full name instead of chart name

## 0.3.1
- added public docs and chart home url

## 0.3.0
- added support for defining container and service ports
- added podDisruptionBudget support
- added container env varialbes support
- updated chart metadata

## 0.2.1
Initial release
