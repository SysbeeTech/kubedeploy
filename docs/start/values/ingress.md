# ingress

Ingress is an API object that manages external access to the services in a cluster, typically HTTP.

Ingress may provide load balancing, SSL termination and name-based virtual hosting.
In short, Ingress is a way to map your application to publicly available domain name.

`ingress` value in Kubedeploy allows you to control parameters for [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) object that would be created by the chart.


!!! note

    By default `ingress` is disabled.

Available values for `ingress` in Kubedeploy:

```yaml
ingress:
  enabled: false # (1)
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

1. Enable Ingres object
2. Ingress class name. In case you have multiple Ingress controllers you can specifically target desired one. Defaults to "haproxy"
3. Default Ingress [pathType](https://kubernetes.io/docs/concepts/services-networking/ingress/#path-types)
4. (Feature state: [:material-tag-outline: 1.1.0](../changelog.md#110 "Minimum version")) Deploy Ingress object with SSL support. Automatically configures the Ingress `tls` spec.
5. (Feature state: [:material-tag-outline: 1.1.0](../changelog.md#110 "Minimum version")) Define default Service port that will be targeted by Ingress. If left undefined Ingress will use first port from `service.ports` (or first port from `ports`) to route traffic to.
6. Additional Ingress annotations, can be used to define custom Ingress controller configuration. By default, it sets the cert-manager annotation to use `letsencrypt` cluster-issuer for issuing SSL certificates for configured ingress domain.
7. (list) Ingress host list.
8. (string, required) Define Ingress hostname
9. (list, optional) Ingress host paths.
    example usage:
    (Feature state: [:material-tag-outline: 1.1.0](../changelog.md#110 "Minimum version"))

    !!! example

        ```yaml
        ingress:
          enabled: true
          hosts:
            - host: "my-domain.com"
              paths:
                - path: /api # (optional) defaults to /
                  svcPort: 8080 # (optional) defaults to `ingress.svcPort`
                  pathType: Prefix # (optional) defaults to `ingress.pathType`
        ```

10. (list, optional) Ingress TLS list.
    **overrides any auto configured tls config created by withSSL**.

    Allows for custom secretName and host list to be defined. In case when you have
    pre-configured SSL stored in Kubernetes Secret.
    If secret does not exist, new one will be created by cert-manager.

    example usage:

    !!! example

        ```yaml
        ingress:
          enabled: true
          hosts:
            - host: "my-domain.com"
          tls:
            - hosts: # (required) list of hosts covered by ssl in secret
              - my-domain.com
              secretName: my-domain-ssl # name of secret where SSL is configured
        ```

`ingress` values might look overwhelming at first. However, it should be fairly simple to expose your app on custom domain.

!!! example "Simple ingress object"

    ```yaml title="values.yaml" linenums="1" hl_lines="8-15"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    replicaCount: 3

    ports:
      - containerPort: 80
        name: http

    ingress:
      enabled: true
      hosts:
        - host: "my-domain.com"
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

    As a result of the above configuration, Ingress object is created using `haproxy` ingressClass. `tls` section is automatically configured enabling SSL coverage for your domain.  `letsencrypt` cluster issuer provided by [cert-manager](https://cert-manager.io/) will be used to issue valid SSL certificate. And finally, all traffic for `my-domain.com` is routed to our Service objects port 80.


A more complex example, would be application with frontend and backend service ports. For that we will use additional containers.
Our additional container will expose static frontend for our website, and our main container will expose backend API that will respond on /api path.

We will also configure our `ingress` to use custom SSL certificate installed as `extraSecret`.

!!! example "Complex ingress object"

    ```yaml title="values.yaml" linenums="1"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    replicaCount: 3

    # define ports for main container (backend)
    ports:
      - containerPort: 80
        name: backend
      - containerPort: 8080
        name: metrics

    # define additional container for frontend
    additionalContainers:
      enabled: true
      containers:
        - name: my-app-frontend
          repository: my-app-frontend
          tag: latest
          # expose frontend ports
          ports:
            - containerPort: 9000
              name: frontend
              protocol: TCP

    # create extra secret containing SSL certificate for my-domain.com
    extraSecrets:
      - name: my-domain-ssl
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

    # create custom service object exposing both frontend and backend ports
    service:
      ports:
        - port: 9000
          targetPort: frontend
          protocol: TCP
          name: frontend
        - port: 80
          targetPort: backend
          protocol: TCP
          name: backend

    # our custom ingress
    ingress:
      enabled: true
      hosts:
        - host: "my-domain.com"
          paths:
            - path: /
              svcPort: 9000 # set explicitly (first port is default anyway)
            - path: /api
              svcPort: 80 # target backend port for /api urls
      tls:
        - hosts:
            - my-domain.com
          # use secret provisioned with extraSecrets
          # remember: name is prefixed with fullname
          secretName: webap-my-app-my-domain-ssl
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

If you require more than one Ingress object per deployment, for example targeting different ingressClasses, please see [extraIngress](extraingress.md) configuration options


See also:

- [extraIngress](extraingress.md)
- [ports](ports.md)
- [service](service.md)
- [additionalContainers](additionalcontainers.md)
- [extraSecrets](extrasecrets.md)
