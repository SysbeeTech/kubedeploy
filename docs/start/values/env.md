# env

`env` value in Kubedeploy can be used to define environment variables that will be configured on all containers in a Pod.

User can define containers [env](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#envvar-v1-core) variable by passing the supported config.

!!! note
    By default containers `env` is undefined.


!!! example "Define simple env var for container"

    ```yaml title="values.yaml" linenums="1" hl_lines="6-8"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    env:
      - name: NGINX_PORT
        value: 8080
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

We can also use extended version to define environment values from ConfigMap or Secret objects.


!!! example "Define env var from other sources"

    ```yaml title="values.yaml" linenums="1" hl_lines="6-20"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    env:
      # fetch value from ConfigMap
      - name: NGINX_PORT
        valueFrom:
          configMapKeyRef:
            name: configmap-name
            key: nginx-port

      # fetch value from Secret
      - name: NGINX_HOSTNAME
        valueFrom:
          secretKeyRef:
            name: secret-name
            key: nginx-hostname
            optional: true
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```


!!! tip "Defining multiple env vars from other sources"

    While the above example might work for referening couple of secret keys for extracting values, the configuration in values.yaml can be simplified by using `envFrom`

See also:

- [envFrom](envfrom.md)
- [extraSecrets](extrasecrets.md)
- [configMaps](configmaps.md)
