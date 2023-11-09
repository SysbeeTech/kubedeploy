# configMapsHash

Feature state: [:material-tag-outline: 1.1.0](../changelog.md#110 "Minimum version")


`configMapsHash` value in Kubedeploy enables custom annotation on Deployment and Statefulsets. Hash is automatically calculated based on the contents of deployed ConfigMaps.

!!! note

    `configMapsHash` in Kubedeploy is disabled by default.

    enabling this feature will trigger Pod rolling restarts whenever content of configMaps data or name is changed. This can be useful if the application can't detect any mounted ConfigMap file content changes.

!!! example "Enable configMapsHash"

    ```yaml title="values.yaml" linenums="1" hl_lines="19"
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

    configMapsHash: true
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```


See also:

- [configMaps](configmaps.md)
- [extraSecretes](extrasecrets.md)
