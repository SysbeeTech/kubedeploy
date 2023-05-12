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
