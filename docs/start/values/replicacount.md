# replicaCount

`replicaCount` value in Kubedeploy will adjust number of Pod replicas for your application in the cluster, enhancing the application's resiliency and throughput, if other complimentary configurations are properly set.

By default `replicaCount` is set to `1`.

!!! example "Application with 3 replicas"

    ```yaml linenums="1" title="values.yaml" hl_lines="5"
    image:
      repository: nginx
      tag: 1.25.2

    replicaCount: 3

    ```

    ```bash title="Deploy command"
    helm install webserver sysbee/kubedeploy -f values.yaml
    ```

!!! note "replicaCount != High Availability"

    It's important to note that increasing the replicaCount does not automatically guarantee high availability.
    The Kubernets scheduler might place all the Pod replicas on single node if Pod `AntiAffinity` is not configured, resulting in downtime if that specific Kubernetes node goes offline.


See also:

- [podAntiAffinity](podantiaffinity.md)
- [affinity](affinity.md)
- [topologySpreadConstraints](topologyspreadconstraints.md)
