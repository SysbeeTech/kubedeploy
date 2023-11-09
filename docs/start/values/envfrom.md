# envFrom

Feature state: [:material-tag-outline: 1.1.0](../changelog.md#110 "Minimum version")

`envFrom` value in Kubedeploy can be used to define environment variables that will be configured on all containers in a Pod.


For reference see [envFrom secret example](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#configure-all-key-value-pairs-in-a-secret-as-container-environment-variables)
or [envFrom configmap example](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#configure-all-key-value-pairs-in-a-configmap-as-container-environment-variables)


!!! note
    By default containers `envFrom` is undefined.


!!! example "Define simple envFrom for containers"

    ```yaml title="values.yaml" linenums="1" hl_lines="6-12"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    envFrom:
      #env from ConfigMap
      - configMapRef:
          name: special-config
      # env from Secret
      - secretRef:
          name: test-secret
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

In above example, envFrom will automatically define environment variables for all containers in a Pod by extracting all the ConfigMap/Secret keys as env var names, and their values as env var values.


See also:

- [env](env.md)
- [extraSecrets](extrasecrets.md)
- [configMaps](configmaps.md)
