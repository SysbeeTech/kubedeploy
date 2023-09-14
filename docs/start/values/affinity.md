# affinity

`affinity` value enables defining of raw [affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) rules.

When defined, it disables/overrides automatic podAntiAffinity rules.

!!! note
    By default `affinity` is undefined.


!!! example "Define custom affinity rules"

    ```yaml title="values.yaml" linenums="1" hl_lines="8-17"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    replicaCount: 3

    affinity:
      podAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchExpressions:
            - key: app.kubernetes.io/instance
              operator: In
              values:
              - backend-app
          topologyKey: topology.kubernetes.io/hostname
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

In the above example three replicas of application would *require* to be scheduled on Kubernetes nodes that also host the application with instance name backend-app.

For more examples on custom affinity rules, please read the [official documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity).

See also:

- [podAntiAffinity](podantiaffinity.md)
- [podAntiAffinityTopologyKey](podantiaffinitytopologykey.md)
- [nodeSelector](nodeselector.md)
- [topologySpreadConstraints](topologyspreadconstraints.md)
- [Best practices](../best-practices.md#assigning-pod-to-nodes)
