# topologySpreadConstraints

`topologySpreadConstraints` value enables defining of raw [topologySpreadConstraings](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/) for Pod.


!!! note
    By default `topologySpreadConstraints` is undefined.

In essence, these constraints provide a flexible alternative to Pod Affinity/Anti-Affinity.
Topology spread constraints let you separate nodes into groups and assign Pods using a label selector. They also allow you to instruct the scheduler on how (un)evenly to distribute those Pods.

Topology spread constraints can overlap with other scheduling policies like Node Selector or taints.


!!! example "Define custom topologySpreadConstraints rules"

    ```yaml title="values.yaml" linenums="1" hl_lines="8-14"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    replicaCount: 5

    toplologySpreadConstraints:
      - maxSkew: 1
        topologyKey: kubernetes.io/zone
        whenUnsatisfiable: DoNotSchedule
        labelSelector:
            matchLabels:
                app.kubernetes.io/name=my-app
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

In the example above, with cluster deployed in only two availability zones, three Pods would be deployed in zone `A` and two Pods in zone `B`.
See the Best practices link below for more info.

For more examples on custom topologySpreadCOnstraints, please read the [official documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/).

See also:

- [podAntiAffinity](podantiaffinity.md)
- [podAntiAffinityTopologyKey](podantiaffinitytopologykey.md)
- [affinity](affinity.md)
- [nodeSelector](nodeselector.md)
- [Best practices](../best-practices.md#assigning-pod-to-nodes)
