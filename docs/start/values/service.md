# service

`service` value in Kubedeploy allows you to define parametars for [Service](https://kubernetes.io/docs/concepts/services-networking/service/) object that would be created.

In Kubernetes, a Service is a method for exposing a network application that is running as one or more Pods in your cluster.

A key aim of Services in Kubernetes is that you don't need to modify your existing application to use an unfamiliar service discovery mechanism. You can run code in Pods, whether this is a code designed for a cloud-native world, or an older app you've containerized. You use a Service to make that set of Pods available on the network so that clients can interact with it.

!!! note

    By default `service` is enabled without any service ports defined. If `service.ports` is undefined Kubedeploy will generate a ports list based on the exposed main container ports using `ports` value.

    Additional containers ports will not be included in this automatically generated list of service ports.

    !!! info

        To limit exposed ports via Service object, you can define custom `service.ports` list.

Available values for `service` in Kubedeploy:

```yaml
service:
  type: ClusterIP # (1)
  enabled: true # (2)
  headless: false # (3)
  ports: [] # (4)
```

1. Set Service type. See [Service](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types) for available options.
2. Enable Service provisioning for release.
3. Create a headless service. See [reference](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services)

4. (list) Define listening ports for Service.
    If unspecified, chart will automatically generate ports list based on main container exposed ports.
    Example values in ports list:

    !!! example

    ```yaml
    service:
      ports:
        - port: 80 # (required) - port number as integer
          targetPort: http # (required) - name of the exposed container or additionalContainer port as string
          protocol: TCP # (required) Define service protocol. See [Supported protocols](https://kubernetes.io/docs/concepts/services-networking/service/#protocol-support)
          name: http # (required) - name of the Service port as string. This should match container's port name
    ```

Simple configuration exposing all the container ports:

!!! example "Default setup"

    ```yaml title="values.yaml" linenums="1" hl_lines="9-12"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    replicaCount: 3

    ports:
      - containerPort: 80
        name: http
      - containerPort: 8080
        name: metrics
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

    Service is always enabled so there is no need to specifically define any values for it. With the above values, Kubedeploy creates service object named `webapp-myapp` that will be listening on same ports as containerPorts: `80` and `8080`. Service object will load balance requests between three application replicas.

    !!! note "Disabling service object"

        If you don't wish to deploy Service object it only requires adding the

        ```yaml
        service:
          enabled: false
        ```
        to the previous example


Building on the previous example, if we only want to expose http port via Service object and leave the metrics port available only when contacting each pod directly we can simply define custom ports in `service` values


!!! example "Define custom service object"

    ```yaml title="values.yaml" linenums="1" hl_lines="8-19"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    replicaCount: 3

    ports:
      - containerPort: 80
        name: http
      - containerPort: 8080
        name: metrics

    service:
      ports:
        - port: 80
          targetPort: http # (1)
          protocol: TCP
          name: http # (2)
    ```

    1. targetPort is the name given to the containerPorts exposed via `ports` values
    2. name is the port name in Service object, and it should match the `targetPort` name

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

    In this example Service object will only Load balance port `80` between application replicas.


See also:

- [ports](ports.md)
- [ingress](ingress.md)
