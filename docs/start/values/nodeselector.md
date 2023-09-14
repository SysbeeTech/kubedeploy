# nodeSelector

Each node in the cluster is assigned a predefined set of common labels. Node labels can be utilized in Pod scheduling decisions by defining node selectors.

Kubedeploy offers this functionality via the `nodeSelector` value config option, enabling you to specifically target a particular node or group of nodes.


!!! note
    By default `nodeSelector` is undefined.


!!! example "Define custom nodeSelector"

    ```yaml title="values.yaml" linenums="1" hl_lines="6-7"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    nodeSelector:
      karpenter.sh/capacity-type: on-demand
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

In the above example, Kubernetes scheduler will only consider nodes containing the `karpenter.sh/capacity-type: on-demand` label. If no nodes in the cluster have that label Pod will be stuck in `Pending` state.

!!! tip

    When using cluster automatic scaling software like `Karpenter` or `Cluster autoscaler`, node selectors can be used to influence which types of nodes will be added to the cluster. Please see Best pracices linked below for more info.

See also:

- [podAntiAffinity](podantiaffinity.md)
- [podAntiAffinityTopologyKey](podantiaffinitytopologykey.md)
- [affinity](affinity.md)
- [topologySpreadConstraints](topologyspreadconstraints.md)
- [Best practices](../best-practices.md#assigning-pod-to-nodes)
