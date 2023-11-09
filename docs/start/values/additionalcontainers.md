# additionalContainers

Feature state: [:material-tag-outline: 1.0.0](../changelog.md#100 "Minimum version")

A Pod can have multiple containers running apps within it.

Pods are designed to support multiple cooperating processes (as containers) that form a cohesive unit of service. The containers in a Pod are automatically co-located and co-scheduled on the same physical or virtual machine in the cluster. The containers can share resources and dependencies, communicate with one another, and coordinate when and how they are terminated.

`additionalContainers` value in Kubedeploy allow for defining one or more [additionalContainers](https://kubernetes.io/docs/concepts/workloads/pods/#how-pods-manage-multiple-containers) that will run alongside main application container.

!!! note

    By default, Kubedeploy does not specify any `additionalContainers`


Supported `additionalContainers` values in Kubedeploy (click on the plus sign for more info):

```yaml linenums="1"
additionalContainers:
  enabled: false # (1)
  pullPolicy: IfNotPresent # (2)
  resources: {} # (3)
  containers: # (4)
    - name: "busybox-init" # (5)
      repository: busybox # (6)
      tag: "latest" #(7)
      command: ["sh", "-c", "exit 0"] # (8)
      args: [] # (9)
      ports: [] # (10)
      healthcheck:
        enabled: false # (11)
        probes:
          livenessProbe: {}
          readinessProbe: {}
          startupProbe: {}
      resources: {} # (12)
```

1. Define if initContainers are enabled.
2. initContainers image pull policy
3. (optional) Define initContainers global resource requests and limits. Will be applied to all initContainers if more specific (per container) resource requests and limits are not defined.

    !!! example

        ```yaml
        initContainers:
          resources:
            requests:
              cpu: 0.1
              memory: 128Mi
            limits:
              cpu: 0.2
              memory: 256Mi
        ```

4. (list) Sequential list of initContainers
5. (required) Define initContainer name
6. (required) Define initContainer repository
7. (optional) Define initContainer image tag, defaults to `latest` if unspecified
8. (optional) Define custom command for initContainer
9. (optional) Define custom arguments for initContainer
10. (optional) Define additionalContainer exposed ports (see: [containerPort](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#containerport-v1-core))

    !!! example

        ```yaml
        additionalContainers:
          enabled: true
          containers:
            - name: busybox
              repository: busybox
              ports:
                - containerPort: 9080
                  name: extra
                  protocol: TCP
        ```

11. (optional) Enable custom [healthcheck probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) for additionalContainer
12. (optional) Define custom resources for this specific additionalContainer


Additional containers can be used to augment application with additional functionality, for example defining extra container metric exporter, or using reverse authenticaton proxy.

!!! note "Shared values/volumes"

    `additionalContainers` will automatically inherit all the environment values set in `env`, `envFrom` and volume mounts defined in `configMaps`, `extraSecrets` and `extraVoumeMounts` just as the main container would.

!!! example "Define additionalContainers that exports metrics"

    ```yaml title="values.yaml" linenums="1" hl_lines="11-29"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    ports:
      - containerPort: 80
        name: http
        protocol: TCP

    additionalContainers:
      enabled: true
      resources:
        requests:
          cpu: 0.1
          memory: 128Mi
        limits:
          cpu: 0.2
          memory: 256Mi
      containers:
        - name: metrics-exporter
          repository: nginx/nginx-prometheus-exporter
          tag: latest
          args:
            - -nginx.scrape-uri=http://localhost:80/stub_status
          ports:
            - containerPort: 9113
              name: metrics
              protocol: TCP
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

See also:

- [additionalContainers](additionalcontainers.md)
- [env](env.md)
- [envFrom](envfrom.md)
- [configMaps](configmaps.md)
- [extraSecrets](extrasecrets.md)
- [extraVolumeMouts](extravolumemounts.md)
