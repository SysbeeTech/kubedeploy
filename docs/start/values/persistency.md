# persistency

`persistency` value in Kubedeploy defines [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) persistent volume claims parameters.

!!! note

    `persistency` will be only taken into account if the `deploymetMode` is set to `Statefulset`.

Available values for `persistency` in Kubedeploy:

```yaml
persistency:
  storageClassName: # (1)
  enabled: false # (2)
  capacity:
    storage: 5Gi # (3)
  accessModes: # (4)
    - ReadWriteOnce
  mountPath: "/data" # (5)

```

1. (string) Define custom name for persistent storage class name
    @default -- uses cluster default storageClassName
2.  Enable support for persistent volumes.
    Supported only if deploymentMode=Statefulset.
3. Define storage capacity
4. Define storage [access modes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes). Must be supported by available storageClass
5. Define where persistent volume will be mounted in containers.

!!! example "Define persistent volume for statefulsets"

    ```yaml title="values.yaml" linenums="1" hl_lines="17-27"
    nameOverride: my-app
    deploymentMode: Statefulset
    image:
      repository: nginx
      tag: 1.25.2

    persistency:
      enabled: true
      capacity:
        storage: 20Gi
      mountPath: /var/www/data
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

The above example will create a StatefulSet with 20Gi persistent volume mounted at `/var/www/data`.

See also:

- [deploymentMode](deploymentmode.md)
