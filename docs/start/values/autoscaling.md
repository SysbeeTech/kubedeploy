# autoscaling

`autoscaling` value in Kubedeploy allows controlling the parameters for [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) object.

Autoscaling can aid in maintaining low resource and platform cost utilization while retaining the capability to automatically enhance application throughput based on various scaling triggers.

!!! warning

    For HPA to function correctly, pods must define at least resource requests, as they are used in calculating utilization based on the CPU and memory utilization of the pods. While HPA can be deployed for deployments without defined resource requests, scaling will remain disabled until resource requests are defined.


Available values for `autoscaling` in Kubedeploy:

```yaml
autoscaling:
  enabled: false # (1)
  minReplicas: 1 # (2)
  maxReplicas: 10 # (3)
  targetCPUUtilizationPercentage: 80 # (4)
  targetMemoryUtilizationPercentage: # (5)
  behavior: {} # (6)
```

1. Enable autoscaling. Works only with **Deployment** and **Statefulset** deploymentMode
2. Minimum number of Pod replicas
3. Maximum number of Pod replicas
4. (int) Scaling target CPU utilization as percentage of resources.requests.cpu
5. (int) Scaling target memory utilization as percentage of resources.requests.mem
6. (Feature state: [:material-tag-outline: 1.2.0](../changelog.md#110 "Minimum version")) (map) Define custom scaling [behavior](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#configurable-scaling-behavior)

!!! example "Define simple autoscaling policy"

    ```yaml title="values.yaml" linenums="1" hl_lines="11-15"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    resources:
      requests:
        cpu: 0.5
        memory: 128Mi

    autoscaling:
      enabled: true
      minReplicas: 2
      maxReplicas: 10
      targetCPUUtilizationPercentage: 80
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

    In the above example we are defining deployment with resource requirements of 1/2 of CPU core.

    HPA is then configured to watch the CPU utilization of this workload.
    If it hits 80% of requested CPU resources it will increase the number of replicas by one until average deployment CPU utilization either drops below `80%` or `maxReplicas` is reached.

    HPA will attempt to downscale underutilized deployments every 5 minutes if the average CPU utilization is below 80%.


!!! imporant
    It's important to note that the utilization percentage is always calculated from resource requests, not limits. If you have higher limits, you can, for example, define a percentage of 200%, which would allow pods to burst beyond their resource requests before triggering scaling.

See also:

- [resources](ports.md)
