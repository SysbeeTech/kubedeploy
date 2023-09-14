# monitoring

`monitoring` value in Kubedeploy allows controlling the parameters for deploying [ServiceMonitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.ServiceMonitor) or [PodMonitor](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/api.md#monitoring.coreos.com/v1.PodMonitor) objects.

!!! note

    ServiceMonitor and PodMonitor objects are part of CRD definitions of Prometheus operator. Your cluster must have them installed first. If CRD is detected as missing, chart will skip their deployment.


Available values for `monitoring` in Kubedeploy:

```yaml
monitoring:
  enabled: false # (1)
  labels: {} # (2)
  targetLabels: [] # (3)
  scrapePort: metrics # (4)
  scrapePath: /metrics # (5)
  scrapeInterval: 20s # (6)
  scrapeTimeout: 15s # (7)
  scheme: http # (8)
  tlsConfig: {} # (9)
  metricRelabelings: [] # (10)
  relabelings: [] # (11)
```

1. Enable monitoring.
2. Provide additional labels to the ServiceMonitor metadata
3. Additional metric labels
4. Provide named service port used for scraping
5. Provide HTTP path to scrape for metrics.
6. Provide interval at which metrics should be scraped
7. Timeout after which the scrape is ended (must be less than scrapeInterval)
8. HTTP scheme to use for scraping.
9. TLS configuration to use when scraping the endpoint
10. Provide additional metricRelabelings to apply to samples before ingestion.
11. Provide additional relabelings to apply to samples before scraping

!!! info

  If `service.enabled` is `True`, chart will generate `ServiceMonitor` object, otherwise `PodMonitor` will be used.

!!! example "Enable metrics scraping for exporter container"

    ```yaml title="values.yaml" linenums="1" hl_lines="11-29"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    ports:
      - containerPort: 80
        name: http
        protocol: TCP

    additionalContainers:
      enabled: true
      containers:
        - name: metrics-exporter
          repository: nginx/nginx-prometheus-exporter
          tag: latest
          args:
            - -nginx.scrape-uri=http://localhost:80/stub_status
          ports:
            - containerPort: 9113
              name: metrics
              protocol: TCP

    monitoring:
      enabled: true

    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

    In this simple example our additionalContainer is used as metrics exporter. Since it already exports metrics on port named metrics, all we need to do is enable monitoring and leave all the other values on default.


!!! example "Enable metrics scraping for built-in application metrics"

    ```yaml title="values.yaml" linenums="1" hl_lines="11-29"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    ports:
      - containerPort: 80
        name: http
        protocol: TCP

    monitoring:
      enabled: true
      scrapePort: http
      scrapePath: /custom/metrics/url

    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

    If our application has built in metrics exporter on custom route, we can modify monitoring `scrapePort` and `scrapePath`.



See also:

- [ports](ports.md)
- [service](service.md)
- [additionalContainers](additionalcontainers.md)
