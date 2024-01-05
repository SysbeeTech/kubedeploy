# configMaps

Feature state: [:material-tag-outline: 0.8.0](../changelog.md#080 "Minimum version")

`configMaps` value in Kubedeploy allow for deploying multiple custom [configMaps](https://kubernetes.io/docs/concepts/configuration/configmap/) objects.

It is also possible to automatically mount ConfigMaps in all containers of a Pod by definig custom mount parametars. (Feature state: [:material-tag-outline: 1.0.0](../changelog.md#100 "Minimum version"))


!!! note

    By default `configMaps` in Kubedeploy will not deploy any ConfigMap objects.

    However, when defining them under this value, chart will automatically prepend `kubedeploy.fullname` to any defined configmap object to prevent collisions with other releases.


!!! example "Define custom configMaps"

    ```yaml title="values.yaml" linenums="1" hl_lines="6-17"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    configMaps:
      - name: configmap1
        mount: True # (optional) Should this configmap be mounted as volume in containers?
        mountPath: /data/confmap # (required if mount=True) Define mount path for this configmap
        data:
          kubedeploy.txt: |+
            configmap values

      - name: configmap1
        mount: True
        mountPath: /data/confmap/kubedeploy2.txt # (required if mount=True) Define single-file mount path for this configmap
        subPath: kubedeploy2.txt # (required if mountPath is a file path) Define which configmap data key to use to mount a single file
        data:
          kubedeploy2.txt: |+
            configmap values

      - name: configmap3
        data:
          config: |+
            config3
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

As a result of the above example, Kubdeploy will create three extra ConfigMap objects named:
`webapp-my-app-configmap1`, `webapp-my-app-configmap2` and `webapp-my-app-configmap3`.

First configmap will also be mounted inside all of the Pod's containers at `/data/configmap` path exposing `kubedeploy.txt` as file on `/data/configmap/kubedeploy.txt`.
Similarly, second configmap will be mounted inside all of the Pod's containers at `/data/configmap/kubedeploy2.txt` path. However, only `kubedeploy2.txt` file will be mounted, while existing directory contents will be preserved.

!!! tip

    Common usecase in the above scenario would be creating and automatically mounting any configuration files your application might need during its runtime.

    `subPath` is useful when a single file needs to be modified. For example, a default configuration file might reside inside a directory which contains multiple files and subdirectories. If the configmap is defined without a single-file `mountPath` and `subPath` fields, the entire directory will be cleared before mounting, which is undesirable.

See also:

- [configMapsHash](configmapshash.md)
- [extraSecretes](extrasecrets.md)
