# securityContext

`securityContext` value in Kubedeploy can be used to define raw main containers [securityContext](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container).

!!! note
    By default `securityContext` is undefined.


!!! example "Define securityContext"

    ```yaml title="values.yaml" linenums="1" hl_lines="6-7"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    securityContext:
      capabilities:
        drop:
        - ALL
      readOnlyRootFilesystem: true
      runAsNonRoot: true
      runAsUser: 1000
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```
!!! note

    Unlike `podSecurityContext`, defining `securityContext` will be applied only to main container.


See also:

- [podSecurityContext](podsecuritycontext.md)
- [Best practices](../best-practices.md#pod-security-context)
