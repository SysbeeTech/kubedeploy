# extraVolumeMounts

Feature state: [:material-tag-outline: 1.1.0](../changelog.md#110 "Minimum version")

`extraVolumeMounts` value in Kubedeploy allow for defining additional mounted volumes for all containers in a Pod.


!!! note

    By default `extraVolumeMounts` in Kubedeploy will not mount any additional volumes.

Allowed volume mounts include:

- `existingClaim` - this can be used to mount any chart external persistent volume claims in any type of [deploymentMode](deploymentmode.md). By chart's design only statefulset will have this ability
- `hostPath` - can be used to mount any filesystem directories directly from Kubernetes node in Pod

    !!! warning

        HostPath volumes present many security risks, and it is a best practice to avoid the use of HostPaths when possible. When a HostPath volume must be used, it should be scoped to only the required file or directory, and mounted as ReadOnly.

- `csi` - allows mounting any volumes exposed with csi drivers, for example [secrets-store-csi-driver](https://secrets-store-csi-driver.sigs.k8s.io/).
- `emptyDir` - temporary empty directories for Pod's container to share (see [emptyDir](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir) for more info).
- `secretName` - allows mounting any Secret objects. If you define secrets in chart you can also use [extraSecrets](extrasecrets.md) mount ability.
- `configMapName` - allows mounting any configMap objects. If you define configmaps in chart you can also use [configMaps](configmaps.md) mount ability.

!!! tip "secret and configmap extra mounts"

    [extraSecret](extrasecrets.md) and [configMaps](configmaps.md) values section will mount entire objects as directories in containers. This might not be deisred when you wish to do items remapping or mount just a single file via subPath. extraVolumeMounts allows for such scenarios.

    `secretName` and `configMapName` parameter in extraVolumeMounts will pass names as is by default. This allows for chart external objects to be referenced. If you are referencing the Secrets or ConfigMaps deployed with this chart consider using `chartName: true` option. `chartName` option will prefix provided name with Chart's `fullname` template, otherwise it is up to the user to define full name of the Secret and ConfigMap object as seen in the K8s cluster.

!!! example "Define extraVolumeMounts"

    ```yaml title="values.yaml" linenums="1" hl_lines="6-32"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    extraVolumeMounts:
      - name: extra-volume-0
        mountPath: /mnt/volume0
        readOnly: true
        existingClaim: volume-claim

      - name: extra-volume-1
        mountPath: /mnt/volume1
        readOnly: true
        hostPath: /usr/shared/

      - name: external-secrets
        mountPath: /mnt/volume2
        csi: true
        data:
          driver: secrets-store.csi.k8s.io
          readOnly: true
          volumeAttributes:
            secretProviderClass: "secret-provider-name"

      - name: empty-dir-vol
        mountPath: /mnt/volume3

      - name: secret-mount
        mountPath: /mnt/volume4
        secretName: my-secret
        optional: true  # If set to true, kubernetes will ignore this mount if secret is not available
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

As a result of the above example, Kubdeploy will mount five additional volumes to all containers in Pod.

1. existing volume claim with name `volume-claim` will be mounted at `/mnt/volume0`
2. `/usr/shared/` from Kubernetes node will be mounted at `/mnt/volume1`
3. `csi` secret would be mounted at `/mnt/volume2`
4. `emptyDir` will be mounted at `/mnt/volume3`
5. `secret` with name `my-secret` will be mounted at `/mnt/volume4`

!!! example "Define extraVolumeMounts with subPath and chart defined Secret / Configmap"

    Feature state: [:material-tag-outline: 1.2.2](../changelog.md#122 "Minimum version")

    While this example is not something that is recommended for production, it will serve its purpose for showcasing several features in play at once.

    We will deploy single configmap with two keys holding configuration data for nginx.
    `nginx.conf` for main config, and second `my-vhost.conf` for vhost config.

    Then we use `extraVolumeMounts` to mount `nginx.conf` as subpath on: `/etc/nginx/nginx.conf` which will mount only the first key preserving all other directory data in `/etc/nginx`.

    Since we include entire /etc/nginx/conf.d/*.conf files we can't simply mount entire configmap to that folder. First ConfigMap key would be picked up again and brake the server configuration. By using `items` we can remap the first config key `nginx.conf` to `disabled-conf` and then mount the entire configmap at `/etc/nginx/conf.d` path.

    !!! tip

        In normal scenario you would create two separate configmaps for vhost data and one for main config. Then you can skip the whole remapping part with items and end up with cleaner config. As mentioned, this example is merely here for demonstration purposes.

    When using subPath, file updates will not be automatically reflected in the pods. They need to be restarted to pick up changes. To accomplish that we define `configMapHash: true` so that the chart will generate new replicaset for deployment whenever `configMaps` is updated.

    ```yaml title="values.yaml" linenums="1" hl_lines="6-32"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    configMaps:
        - name: my-nginx-config
          data:
            nginx.conf: |
              ... config here ...
              include /etc/nginx/conf.d/*.conf
              ...
            my-vhost.conf: |
              ... vhost config here ...

    configMapsHash: true

    extraVolumeMounts:
      - name: nginx-conf
        configMapName: my-nginx-config
        chartName: true
        mountPath: /etc/nginx/nginx.conf
        subPath: nginx.conf

      - name: nginx-conf-d
        configMapName: my-nginx-config
        chartName: true
        mountPath: /etc/nginx/conf.d
        items:
          - key: nginx.conf
            path: disabled-conf
          - key: my-vhost.conf
            path: 00_default.conf
        optional: true  # If set to true, kubernetes will ignore this mount if secret is not available
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

    In the end we will end up with following structure in our pod:

    ```bash
    /etc
    `-- nginx
        |-- conf.d
        |   |-- 00_default.conf -> ..data/00_default.conf
        |   `-- disabled-conf -> ..data/disabled-conf
        `-- nginx.conf

    ```


While the above example is using ConfigMaps, if you have sensitive data, same can be done with Secrets.


See also:

- [configMaps](configmaps.md)
- [configMapsHash](configmapshash.md)
- [extraSecrets](extrasecrets.md)
