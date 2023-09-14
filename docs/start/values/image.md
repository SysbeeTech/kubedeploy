# image

`image` value in Kubedeploy controls the main container image settings.

If left unchanged these are the default values that Kubedeploy will work with:

```yaml title="Default image configuration"
image:
  repository: nginx # (1)
  pullPolicy: IfNotPresent # (2)
  tag: "latest" # (3)
  command: [] # (4)
  args: [] # (5)
  lifecycle: {} # (6)
  terminationGracePeriodSeconds: 30 # (7)
```

1. Defines container repository
2. Default container [pull policy](https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy)
3. Defines container image tag
4. Defines container custom command. [Reference](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/)
5. Define container custom arguments. [Reference](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/)
6. Define container custom [lifecycle hooks](https://kubernetes.io/docs/tasks/configure-pod-container/attach-handler-lifecycle-event/). [More info](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/)
7. Define Pod [terminationGracePeriodSeconds](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#hook-handler-execution).

If we wish to deploy different webserver we can do this by simply changing the image repository.

!!! example "Apache webserver"

    ```yaml linenums="1" title="values.yaml" hl_lines="2-4"
    image:
      repository: httpd
      tag: 2.4
      pullPolicy: Always

    replicaCount: 3

    ```

    ```bash title="Deploy command"
    helm install webserver sysbee/kubedeploy -f values.yaml
    ```

!!! note "Configurable container lifecycle"

    Main container is intended to run main application inside a Pod. You can augment it with `additionalContainers` and `initContainers`. Only main container supports defining custom **lifecycle hooks**.
    See the related documentation from Best practices on use cases.

See also:

- [lifecycle hooks](../best-practices.md#lifecycle-hooks)
- [initContainers](initcontainers.md)
- [additionalContainers](additionalcontainers.md)
