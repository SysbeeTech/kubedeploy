# minReadySeconds

`minReadySeconds` value in Kubedeploy can be used to define custom [minReadySeconds](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#min-ready-seconds) for deployments and statefulsets.

!!! note

    By default `minReadySeconds` in Kubedeploy is set to 10 seconds.

!!! example "custom minReadySeconds"

    ```yaml title="values.yaml" linenums="1" hl_lines="6"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    minReadySeconds: 60
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

!!! note

    For more complete example of configuring minReadySeconds with other configurable values, please see the **Best practices** linked page.


See also:

- [Best practices](../best-practices.md#healthchecks-and-pod-lifecycle)
