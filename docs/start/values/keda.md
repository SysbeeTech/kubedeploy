# keda

Feature state: [:material-tag-outline: 0.9.0](../changelog.md#090 "Minimum version")

`keda` value in Kubedeploy allows controlling the parameters for [Kubernetes Event-driven Autoscaling: KEDA 2.x](https://keda.sh/docs/2.3/concepts/scaling-deployments/)

!!! note

    To use `keda`, your cluster must have KEDA operator installed first. If CRD is not detected, chart will skip rendering keda maifests.

!!! warning

    `keda` and `autoscaler` can't be used at the same time


Available values for `keda` in Kubedeploy:

```yaml
keda:
  enabled: false # (1)
  minReplicas: 1 # (2)
  maxReplicas: 10 # (3)
  pollingInterval: 30 # (4)
  cooldownPeriod: 300 # (5)
  restoreToOriginalReplicaCount: false # (6)
  scaledObject:
    annotations: {} # (7)
  behavior: {} # (8)
  triggers: [] # (9)

```

1. enables keda, **Note:** mutually exclusive with HPA, enabling KEDA disables HPA
2. Number of minimum replicas for KEDA autoscaling
3. Number of maximum replicas for KEDA autoscaling
4.Interval for checking each trigger [ref](https://keda.sh/docs/2.10/concepts/scaling-deployments/#pollinginterval)
5. The period to wait after the last trigger reported active before scaling the resource back to 0 [ref](https://keda.sh/docs/2.10/concepts/scaling-deployments/#cooldownperiod)
6. After scaled object is deleted return workload to initial replica count [ref](https://keda.sh/docs/2.10/concepts/scaling-deployments/#advanced)
7. Scaled object annotations, can be used to pause scaling [ref](https://keda.sh/docs/2.10/concepts/scaling-deployments/#pause-autoscaling)
8. HPA configurable scaling behavior see [ref](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/#configurable-scaling-behavior)
9. Keda triggers [ref](https://keda.sh/docs/2.10/concepts/scaling-deployments/#triggers)


Keda allows for more precise triggers on when the application will be scaled out. It does require external metrics system and access to it. In the example below we will configure haproxy application and keda scaling triggers based on application provided metrics collected by Prometheus.

!!! example "Define keda scaling triggers"

    ```yaml title="values.yaml" linenums="1" hl_lines="17-27"
    nameOverride: my-lb
    image:
      repository: haproxy
      tag: latest

    ports:
      - contaierPort: 80
        name: http
      - containerPort: 443
        name: https
      - containerPort: 1024
        name: metrics

    monitoring:
      enabled: true

    keda:
      enabled: true
      minReplicas: 2
      maxReplicas: 10
      triggers:
        - type: prometheus
          metadata:
            serverAddress: http://<prometheus-host>:9090
            metricName: haproxy_process_idle_time_percent
            threshold: '50'
            query: avg(100-avg_over_time(haproxy_process_idle_time_percent{container="kubernetes-ingress-controller",service="mytest-kubernetes-ingress"}[2m]))

    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

See also:

- [resources](ports.md)
- [autoscaling](autoscaling.md)
