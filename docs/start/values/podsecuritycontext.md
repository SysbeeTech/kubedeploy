# podSecurityContext

`podSecurityContext` value in Kubedeploy can be used to define raw Pod level [securityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).

!!! note
    By default `podSecurityContext` is undefined.


!!! example "Define podSecurityContext"

    ```yaml title="values.yaml" linenums="1" hl_lines="6-7"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    podSecurityContext:
      fsGroup: 2000
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

See also:

- [securityContext](securitycontext.md)
- [Best practices](../best-practices.md#pod-security-context)
