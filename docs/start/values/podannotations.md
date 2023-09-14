# podAnnotations

`podAnnotations` value in Kubedeploy can be used to define additional Pod [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).

!!! note
    By default no extra `podAnnotations` are defined.


!!! example "Define extra podAnnotations"

    ```yaml title="values.yaml" linenums="1" hl_lines="6-7"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    podAnnotations:
      karpenter.sh/do-not-evict: "true"
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

If your cluster is using Karpenter for cluster scalig, with the above example You can block Karpenter from voluntarily choosing to disrupt certain pods by setting the `karpenter.sh/do-not-evict: "true"` annotation on the pod.

This is useful for pods that you want to run from start to finish without disruption. By opting pods out of this disruption, you are telling Karpenter that it should not voluntarily remove a node containing this pod.

See also:

- [podExtraLabels](podextralabels.md)
