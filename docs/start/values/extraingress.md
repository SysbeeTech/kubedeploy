# extraIngress


Feature state: [:material-tag-outline: 1.2.0](../changelog.md#120 "Minimum version")

extraIngress allows defining a list of one or multiple Ingress API objects, when there is need for more than one Ingress object per deployment.

!!! note

    If you require just one Ingress object please see [ingress](ingress.md) configuration option.

    extraIngress mostly follows the confifg options present in [ingress](ingress.md) config with exception of name/enabled parametar as showcased below.

`extraIngress` value in Kubedeploy allows you to control parameters for [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) object that would be created by the chart.


!!! note

    By default `extraIngress` is disabled.

Available values for `extraIngress` in Kubedeploy:

```yaml
extraIngress:
  - name: ingress2 #(1)
    className: "haproxy" # (2)
    pathType: ImplementationSpecific # (3)
    withSSL: true # (4)
    svcPort: "" # (5)
    annotations: # (6)
      cert-manager.io/cluster-issuer: letsencrypt
    hosts: # (7)
      - host: "" # (8)
        paths: [] # (9)
    tls: [] # (10)
```

1. **(required)** Name of extraIngress object
2. *(optional)* Ingress class name. In case you have multiple Ingress controllers you can specifically target desired one. Defaults to "haproxy"
3. *(optional)* Default Ingress [pathType](https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types)
4. *(optional)* Deploy Ingress object with SSL support. Automatically configures the Ingress `tls` spec.
5. *(optional)* Define default Service port that will be targeted by Ingress. If left undefined Ingress will use first port from `service.ports` (or first port from `ports`) to route traffic to.
6. *(optional)* Additional Ingress annotations, can be used to define custom Ingress controller configuration. By default, it sets the cert-manager annotation to use `letsencrypt` cluster-issuer for issuing SSL certificates for configured ingress domain.
7. **(required)** (list) Ingress host list.
8. **(required)** (string) Define Ingress hostname
9. *(optional)* (list) Ingress host paths.
    example usage:

    !!! example

        ```yaml
        extraIngress:
          - name: ingress2
            hosts:
              - host: "my-domain.com"
                paths:
                  - path: /api # (optional) defaults to /
                    svcPort: 8080 # (optional) defaults to `ingress.svcPort`
                    pathType: Prefix # (optional) defaults to `ingress.pathType`
        ```

10. *(optional)* (list) Ingress TLS list.
    **overrides any auto configured tls config created by withSSL**.

    Allows for custom secretName and host list to be defined. In case when you have
    pre-configured SSL stored in Kubernetes Secret.
    If secret does not exist, new one will be created by cert-manager.

    example usage:

    !!! example

        ```yaml
        extraIngress:
          - name: ingress2
            hosts:
              - host: "my-domain.com"
            tls:
              - hosts: # (required) list of hosts covered by ssl in secret
                - my-domain.com
                secretName: my-domain-ssl # name of secret where SSL is configured
        ```

See also:

- [ingress](ingress.md)
- [ports](ports.md)
- [service](service.md)
- [additionalContainers](additionalcontainers.md)
- [extraSecrets](extrasecrets.md)
