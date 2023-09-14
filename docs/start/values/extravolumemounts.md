# extraVolumeMounts

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
- `secretName` - allows mounting any chart external Secret objects. If you define secrets in chart, then it's suggested to use [extraSecrets](extrasecrets.md) mount ability.


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

See also:

- [configMaps](configmaps.md)
- [extraSecrets](extrasecrets.md)
