# imagePullSecretes

`imagePullSecrets` value in Kubedeploy should contain a list of Secret objects that contains necessary configuration for pulling container images from private registries.

See the [official documentation](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod) on this feature.

By default no `imagePullSecretes` are defined in Kubedeploy.


!!! example "Define extraSecrets and imagePullSecrets"

    We will use Kubedeploys [extraSecrets](extrasecrets.md) value for defining Secret object later used in `imagePullSecretes`.


    ```yaml linenums="1" title="values.yaml" hl_lines="7-8"
    nameOverride: my-app # (1)
    image:
      repository: private-repo/image-name
      tag: latest
      pullPolicy: Always

    imagePullSecrets:
      - webapp-my-app-imagepullsecret # (2)

    extraSecrets:
      - name: imagepullsecret # (3)
        type: kubernetes.io/dockerconfigjson
        data:
          .dockerconfigjson: |
            content of ~/.docker/config.json file # (4)
    ```

    1. define [nameOverride](nameoverride.md) for easier secret reference
    2. secret name deployed with [extraSecrets](extrasecrets.md) is prefixed with `kubedeploy.fullname` templated.
    3. create extra secret named imagepullsecret
    4. content should be replaced with content from `~/.docker/config.json` file

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

!!! note

    Secret objects deployed with extraSecrets are prefixed with deployment full name.


!!! tip

    When deploying multiple applications from same private image registry, it is recommended to create Secret object by hand and then reference it in Kubedeploy.

    !!! example

        Create a secret

        ```bash linenums="1" title="Create my-registry-creds secret"
        kubectl create secret docker-registry my-registry-creds \
        --docker-email=tiger@acme.example \
        --docker-username=tiger \
        --docker-password=pass1234 \
        --docker-server=my-registry.example:5000
        ```

        Reference the manually created secret

        ```yaml linenums="1" title="values.yaml" hl_lines="6-7"
        image:
          repository: my-registry.example/image-name
          tag: latest
          pullPolicy: Always

        imagePullSecrets:
          - my-registry-creds
        ```

        ```bash title="Deploy command"
        helm install webapp sysbee/kubedeploy -f values.yaml
        ```

See also:

- [extraSecretes](extrasecrets.md)
- [nameOverride](nameoverride.md)
