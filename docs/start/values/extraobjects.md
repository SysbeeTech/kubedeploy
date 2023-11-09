# extraObjects

Feature state: [:material-tag-outline: 1.1.0](../changelog.md#110 "Minimum version")

`extraObjects` value in Kubedeploy accepts a list of raw Kubernetes manifests to be deployed.

!!! note

    `extraObjects` can be used to define any other Kubernetes object type or configuration that is not directly supported by Kubedeploy.

!!! warning

    Object names deployed with `extraObjects` will not be prefixed with `kubedeploy.fullname` template. Extra care should be taken when deploying extraObjects with multiple releases to avoid Object name collisions.

!!! example "Define csi SecretProvider with extraObjects"

    ```yaml title="values.yaml" linenums="1" hl_lines="6-25"
    nameOverride: my-app
    image:
      repository: nginx
      tag: 1.25.2

    extraObjects:
      - apiVersion: secrets-store.csi.x-k8s.io/v1
        kind: SecretProviderClass
        metadata:
          name: aws-secrets-manager-secrets
        spec:
          provider: aws
          parameters:
            objects: |
              - objectName: "name-of-aws-secret"
                objectType: "secretsmanager"
                jmesPath:
                    - path: db_username
                      objectAlias: db_username
                    - path: db_password
                      objectAlias: db_password
                    - path: db_hostname
                      objectAlias: db_hostname
                    - path: database
                      objectAlias: database

    extraVolumeMounts:
      - name: external-secrets
        readOnly: true
        mountPath: /etc/aws-secrets
        csi:
          driver: secrets-store.csi.k8s.io
          readOnly: true
          volumeAtributes:
            secretProviderClass: "aws-secretes-manager-secrets"
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

The above example will create a SecretProviderClass object which can be referenced later in `extraVolumeMounts`.

See also:

- [extraVolumeMounts](extravolumemounts.md)
