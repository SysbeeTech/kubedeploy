# initContainers

`initContainers` value in Kubedeploy allow for defining one or more [initContainers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/).

Init containers are specialized containers that run before app containers in a Pod. Init containers can contain utilities or setup scripts not present in an app image.

A Pod can have multiple containers running apps within it, but it can also have one or more init containers, which are run before the app containers are started.

Init containers are exactly like regular containers, except:

- Init containers always run to completion.
- Each init container must complete successfully before the next one starts.

If a Pod's init container fails, the kubelet repeatedly restarts that init container until it succeeds. However, if the Pod has a restartPolicy of Never, and an init container fails during startup of that Pod, Kubernetes treats the overall Pod as failed.

If you specify multiple init containers for a Pod, kubelet runs each init container sequentially. Each init container must succeed before the next can run. When all of the init containers have run to completion, kubelet initializes the application containers for the Pod and runs them as usual.


!!! note

    By default, Kubedeploy does not specify any `initContainers`


Supported `initContainers` values in Kubedeploy (click on the plus sign for more info):

```yaml linenums="1"
initContainers:
  enabled: false # (1)
  pullPolicy: IfNotPresent # (2)
  resources: {} # (3)
  containers: # (4)
    - name: "busybox-init" # (5)
      repository: busybox # (6)
      tag: "latest" #(7)
      command: ["sh", "-c", "exit 0"] # (8)
      args: [] # (9)
      resources: {} # (10)
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
10. (optional) Define custom resources for this specific initContainer


Init containers can be used to delay application startup until external resource is ready, initialize the application, or run database migrations if nececary.

!!! note "Shared values/volumes"

    `initContainers` will automatically inherit all the environment values set in `env`, `envFrom` and volume mounts defined in `configMaps`, `extraSecrets` and `extraVoumeMounts` just as the main container would.

!!! example "Define initContainers that waits for mydb service"

    ```yaml title="values.yaml" linenums="1" hl_lines="6-21"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    initContainers:
      enabled: true
      resources:
        requests:
          cpu: 0.1
          memory: 128Mi
        limits:
          cpu: 0.2
          memory: 256Mi
      containers:
        - name: wait-for-db
          repository: busybox
          command:
            - sh
            - -c
            - "until nslookup mydb; do echo waiting for mydb; sleep 2; done"
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
