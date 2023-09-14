# configMaps

`configMaps` value in Kubedeploy allow for deploying multiple custom [configMaps](https://kubernetes.io/docs/concepts/configuration/configmap/) objects.

It also allows automatic mounting of ConfigMaps in all containers of a Pod by definig cusom mount parametars.

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

      - name: configmap2
        data:
          config: |+
            config2
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

As a result of the above example, Kubdeploy will create two extra ConfigMap objects named:
`webapp-my-app-configmap1` and `webapp-my-app-configmap2`.

First configmap will also be mounted inside all of the Pod's containers at `/data/configmap` path exposing `kubedeploy.txt` as file on `/data/configmap/kubedeploy.txt`.

!!! tip

    Common usecase in the above scenario would be creating and automatically mounting any configuration files your application might need during its runtime.

See also:

- [configMapsHash](configmapshash.md)
- [extraSecretes](extrasecrets.md)
