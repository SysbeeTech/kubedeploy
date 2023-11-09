# networkPolicy

Feature state: [:material-tag-outline: 1.0.0](../changelog.md#100 "Minimum version")

`networkPolicy` value enables defining of raw [NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/) rules.

In addition, Kubedeploy will create automatic Network Policy rules when `ingress` or `monitoring` values are enabled.


!!! note
    By default `networkPolicy` rules are disabled.

Default values for `networkPolicy` values are:

```yaml
networkPolicy:
  enabled: false # (1)
  ingressNamespace: ingress # (2)
  monitoringNamespace: monitoring # (3)
  ingress: [] # (4)
  egress: [] # (5)
```

1. Enables Pod based [NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

2. Define Namespace where Ingress controller is deployed.
    Used to generate automatic policy to enable ingress access when .Values.ingress is enabled
3. Define namespace where monitoring stack is deployed
    Used to generate automatic policy to enable monitoring access when .Values.monitoring is enabled
4. (list) Define spec.ingress for [NetowkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/) rules
5. (list) Define spec.egress for [NetowkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/) rules


!!! warning

    Enabling networkPolicy without defining any ingres or egress rules will result in cutting off all in/out traffic to the pod. If your Application needs access to or from external applications/services, please make sure you define proper rules in ingress and egress configuration lists.

    !!! info

        Automatic rules will always define allow rules from `ingressNamespace` if `ingress.enabled` is set to `true`. Same goes for `monitoringNamespace` if `monitoring.enabled` is set to `true`.


!!! example "Define custom networkPolicy"

    ```yaml title="values.yaml" linenums="1" hl_lines="8-19"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    replicaCount: 3

    ingres:
      enabled: true
      hosts:
        - host: mydomain.com

    networkPolicy:
      enabled: true
      ingressNamespace: ingress
      egress:
        - to:
            - ipBlock:
                cidr: 0.0.0.0/0
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

In the above example we define ingress object, and enable only `egress` rules in `newtorkPolicy`.

As a result, Pod will be allowed all outbound network traffic. However, inbound traffic to the Pod will only be allowed from `ingressNamespace`.

See also:

- [ingress](ingress.md)
- [monitoring](monitoring.md)
