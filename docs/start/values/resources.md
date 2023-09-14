# resources

`resources` value in Kubedeploy can be used to define main container resource requirements.

By default `resources` are intentionally left undefined in Kubedeploy, as this should be a
conscious choice for the user.
For guide on how to properly select resource requirements, see the Best practices [Resource requirements](../best-practices.md#resource-requirements) section


!!! example "Define resource requirements for the main container"

    ```yaml title="values.yaml" linenums="6-12"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    resources:
      requests:
        cpu: 0.1
        memory: 128Mi
      limits:
        cpu: 1
        memory: 512Mi
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

!!! note

    `initContainers` and `additionalContainer` define their own resource requirements, for more info see the related configuration values

See also:

- [initContainers](initcontainers.md)
- [additionalContainers](additionalcontainers.md)
