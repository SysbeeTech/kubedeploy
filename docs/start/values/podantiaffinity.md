# podAntiAffinity

Feature state: [:material-tag-outline: 1.0.0](../changelog.md#100 "Minimum version")

`podAntiAffinity` can prevent the scheduler from placing application replicas on the same node.

The value `soft` means that the scheduler should **prefer** to not schedule two replica pods onto the same node but no guarantee is provided.

The value `hard` means that the scheduler is **required** to not schedule two replica pods onto the same node.

The default value `""` will disable pod anti-affinity so that no anti-affinity rules will be configured.


!!! note
    By default `podAntiAffinity` is undefined.


!!! example "Define podAntiAffinity"

    ```yaml title="values.yaml" linenums="1" hl_lines="8"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    replicaCount: 3

    podAntiAffinity: "soft"
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

In the above example three replicas of application would *prefer* to be scheduled on different Kubernetes nodes.

For more examples please see the Best practices linked below.

See also:

- [podAntiAffinityTopologyKey](podantiaffinitytopologykey.md)
- [affinity](affinity.md)
- [nodeSelector](nodeselector.md)
- [topologySpreadConstraints](topologyspreadconstraints.md)
- [Best practices](../best-practices.md#assigning-pod-to-nodes)
