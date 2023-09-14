# podDisruptionBudget

Pods do not disappear until someone (a person or a controller) destroys them, or there is an unavoidable hardware or system software error.

See [Best Practices](../best-practices.md#pod-disruption-budgets) for more information on voluntary and involuntary disruptions.

`podDisruptionBudget` value in Kubedeploy allows you to define budgets for voluntary disruptions.


!!! note
    By default `podDisruptionBudget` is undefined.


!!! example "Create podDisruptionBudget with multiple replicas"

    ```yaml title="values.yaml" linenums="1" hl_lines="6-10"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    replicaCount: 3

    podDisruptionBudget:
      enabled: true
      minAvailable: 2
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

In the example configuration above, we ensure that our Pod has 3 replicas at normal runtime. Configured PodDisruptionBudget requires that at least 2 replicas are always available during any voluntary disruptions.


!!! info

    To learn more about Pod disruptions and PodDisruptionBudgets, please refer to the official [documentation](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#dealing-with-disruptions).

See also:

- [replicaCount](replicacount.md)
