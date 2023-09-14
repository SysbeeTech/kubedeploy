# ports

`ports` value in Kubedeploy can be used to define main container exposed ports.
User can define container exposed ports see: [containerPort](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.23/#containerport-v1-core) for example

!!! note
    By default container `ports` are undefined.

As bare minimum, ports should take a list of contarinerPort, however user can name the ports and define port protocol.

!!! example "Define main container exposed ports"

    ```yaml title="values.yaml" linenums="6-12"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    ports:
      # minimal configuration
      - containerPort: 80
      # extended configuration
      - contarinerPort: 8080
        name: extrahttp
        protocol: TCP
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

!!! note

    `additionalContainer` can define their own exposed ports, for more info see the related configuration values

!!! note

    `service` and `ingress` will require at least one exposed port to properly route traffic to your application. For more info see the related configuration values.

See also:

- [additionalContainers](additionalcontainers.md)
- [service](service.md)
- [ingress](ingress.md)
