# tolerations

Nodes can be grouped for provisioning, isolating workloads from one another. For example, Kubernetes cluster might have a dedicated node group solely for database services.
To achieve this, nodes can be configured with specific node taints. Pods that lack specified tolerations for those taints will avoid scheduling on such node groups.

For more information on toleration and taints, please follow the official [documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).

Kubedeploy offers the ability to define custom tolerations for Pods with `tolerations` value configuration.

!!! note
    By default `tolerations` is undefined.

Let's assume we have a specific node group running the `c6` instance family, intended only for database workloads. Nodes have a specific label set: `workload-type: database`.

Additionally, there's a taint  named `workload-type` with the value `database` and the effect `NoSchedule`. If we wish to target this specific node group, we can't rely solely on Karpenter's known labels. Using those labels would provision new nodes of the desired instance family, where other workloads could be scheduled if free capacity is available.

> To target this specific group, we need to use a `nodeSelector` with `tolerations`.

!!! example "Define custom tolerations"

    ```yaml title="values.yaml" linenums="1" hl_lines="6-11"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    nodeSelector:
      workload-type: database
    tolerations:
      - key: workload-type
        value: database
        effect: NoSchedule
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

    This configuration targets the specific `workload-type: database` node group. Kubernets cluster administrators can then control which instance family is required for this workload on a system level, rather than defining the desired instance family in each deployment. The toleration key ensures that our Pods will tolerate the taints set on the node group.

See also:

- [podAntiAffinity](podantiaffinity.md)
- [podAntiAffinityTopologyKey](podantiaffinitytopologykey.md)
- [affinity](affinity.md)
- [nodeSelector](nodeselector.md)
- [topologySpreadConstraints](topologyspreadconstraints.md)
- [Best practices](../best-practices.md#assigning-pod-to-nodes)
