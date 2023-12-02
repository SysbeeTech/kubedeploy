# extraSecrets

Feature state: [:material-tag-outline: 1.1.0](../changelog.md#110 "Minimum version")

`extraSecrets` value in Kubedeploy allow for deploying multiple custom [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/) objects.

It also allows automatic mounting of Secretes in all containers of a Pod by definig cusom mount parametars.

!!! note

    By default `extraSecrets` in Kubedeploy will not deploy any Secrets objects.

    However, when defining them under this value, chart will automatically prepend `kubedeploy.fullname` to any defined Secret object to prevent collisions with other releases.


!!! example "Define custom extraSecrets"

    ```yaml title="values.yaml" linenums="1" hl_lines="6-31"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    extraSecrets:
      - name: opaque-secret
        type: Opaque # (optional) - Default: Opaque if unspecified
        mount: True # (optional) - should this sercret be mounted as volume in containers
        mountPath: /mnt/secret-vol0 # (required if mount=True) - define mount path for this secret
        data:
          key: value # value will be automatically base64 encoded by chart template

      - name: tls-secret
        type: kubernetes.io/tls
        data:
          tls.crt: |
            --------BEGIN CERTIFICATE-----
            MIIC2DCCAcCgAwIBAgIBATANBgkqh ...
          tls.key: |
            -----BEGIN RSA PRIVATE KEY-----
            MIIEpgIBAAKCAQEA7yn3bRHQ5FHMQ ...
          tls.ca: |
            --------BEGIN CERTIFICATE-----
            MIIC2DCCAcCgAwIBAgIBATANBgkqh ...

      - name: ssh-key-secret
        type: kubernetes.io/ssh-auth
        data:
          ssh-privatekey: |
            MIIEpQIBAAKCAQEAulqb/Y ...
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

As a result of the above example, Kubdeploy will create three extra Secrets objects named:
`webapp-my-app-opaque-secret`,  `webapp-my-app-tls-secret` and `webapp-my-app-ssh-key-secret`.

First Secret will also be mounted inside all of the Pod's containers at `/mnt/secret-vol0` path exposing `key` as file on `/data/configmap/key`.

!!! warning

    Secret `type` parametar can be any of the [Kubernetes Types of Secret](https://kubernetes.io/docs/concepts/configuration/secret/#secret-types). However, it is up to the end user to define required keys in the `data` parametar for the Secret type being deployed.

    If `type` is omitted, Secret type will default to `Opaque`

!!! tip

    Common usecase in the above scenario would be creating and automatically mounting any configuration files or secretes your application might need during its runtime.

See also:

- [configMaps](configmaps.md)
