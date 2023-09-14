# podAntiAffinityTopologyKey


`podAntiAffinityToplologyKey` sets the TopologyKey to use for automatic `podAntiAffinity` rules.


!!! note
    By default `podAntiAffinityTopologyKey` is set to `kubernetes.io/hostname`.


!!! example "Define podAntiAffinity with zone toplogy key"

    ```yaml title="values.yaml" linenums="1" hl_lines="8-9"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    replicaCount: 3

    podAntiAffinity: "soft"
    podAntiAffinityTopologyKey: kubernetes.io/zone
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

In the above example three replicas of application would *prefer* to be scheduled on Kubernetes nodes spread in different availability zones.

For more examples please see the Best practices linked below.

See also:

- [podAntiAffinity](podantiaffinity.md)
- [affinity](affinity.md)
- [nodeSelector](nodeselector.md)
- [topologySpreadConstraints](topologyspreadconstraints.md)
- [Best practices](../best-practices.md#assigning-pod-to-nodes)
