# healthcheck

Feature state: [:material-tag-outline: 0.6.0](../changelog.md#060 "Minimum version")

`healthcheck` value in Kubedeploy can be used to define custom [liveness, readiness and startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) for main container.

!!! note

    By default `healthcheck` in Kubedeploy is configured with auto-detect. If `ports` have defined a port named `http`, Kubedeploy will automatically define **httpCheck** liveness and readiness probes on base URL.

    ```yaml title="automatic probes on main container"

          livenessProbe:
            httpGet:
              path: /
              port: http
          readinessProbe:
            httpGet:
              path: /
              port: http
    ```


When defining custom `healthcheck` probes any automatic probes will be disabled.


!!! example "Define custom healthcheck probes"

    ```yaml title="values.yaml" linenums="1" hl_lines="11-31"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    ports:
      - name: liveness-port
        containerPort: 8080
        protocol: TCP

    healthcheck:
      enabled: true
      probes:
        livenessProbe:
          httpGet:
            path: /healthz
            port: liveness-port
          failureThreshold: 5
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /healthz
            port: liveness-port
          failureThreshold: 1
          periodSeconds: 10
        startupProbe:
          httpGet:
            path: /healthz
            port: liveness-port
          failureThreshold: 30
          periodSeconds: 10
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

If you wish to disable automatic probes without configuring custom probes (Feature state: [:material-tag-outline: 0.8.2](../changelog.md#082 "Minimum version")):

!!! example "Disable automatic healthcheck probes"

    ```yaml title="values.yaml" linenums="1" hl_lines="7"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    healthcheck:
      disableAutomatic: true
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

!!! note

    For more complete example of configuring healthcheck probes with other configurable values, please see the **Best practices** linked page.


See also:

- [ports](ports.md)
- [Best practices](../best-practices.md#healthchecks-and-pod-lifecycle)
