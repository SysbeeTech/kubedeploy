# podExtraLabels

`podExtraLabels` value in Kubedeploy can be used to define additional Pod [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)

!!! note
    By default no extra `podExtraLabels` are defined.


!!! example "Define podExtraLabels"

    ```yaml title="values.yaml" linenums="1" hl_lines="6-7"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    podExtraLabels:
      my-component: "user-app"
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

In the above example all deployed objects will get extra label `my-component: "user-app"`.

See also:

- [podAnnotations](podannotations.md)
