# 1.1.0

Public [chart documentation](https://kubedeploy.app) is now available, featuring Quickstart guide, full documentation per each configuration value,  as well as deployment examples.


## New features

- added: extraObjects
- added: envFrom
- added: headless service support
- added: configMapsHash
- added: ingress - svcPort for targeting backends
- added: ingress - per path overrides for svcPort and pathType
- added: ingress - withSSL support (automatic tls spec configuration)
- added: podExtraLabels
- added: unit tests for each top-level values.yaml configuration key
- added: extraVolumeMounts
- added: extraSecrets


## Changes

- change: split deployment tests
- fixed: empty lines in volumeMounts
- change: ingress - make path in host optional
- change: statefulsets template will use kubedeploy.kubeVersion function when checking for Kubernetes version
- change: ingress - host in hosts list is now required.
- change: ingress - removed default dummy domain from ingress hosts
- change: ingress - ingress.tls is now empty and optional in favor of withSSL. If defined by user it will override withSSL configuration.
- change: ingress - template will use kubedeploy.kubeVersion function when checking for Kubernetes version
- change: service - default ports are now empty and optional. Template will try to autodetect container ports if service.ports are unspecified

## Fixes

- bugfix: use standardized label selectors for chart managed NetworkPolicy objects
- bugfix: set default value (healthcheck.enabled: false) for additoinalContainers healthcheck if unspecified
- bugfix: autoscaling HPA object spec bug
- bugfix: ingress - will now respect path under hosts list (previusly always defaulted to /)
- bugfix: affinity will now disable automatic podAntiAffinity rules reducing possibility of rule collisions.
