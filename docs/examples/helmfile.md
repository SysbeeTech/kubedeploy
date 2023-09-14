# Helmfile

[Helmfile](https://helmfile.readthedocs.io/en/latest/) is a declarative spec for deploying Helm charts. It lets you…

- Keep a directory of chart value files and maintain changes in version control.
- Apply CI/CD to configuration changes.
- Periodically sync to avoid skew in environments.

To avoid upgrades for each iteration of Helm, the Helmfile executable delegates to Helm - as a result, Helm must be installed.

This page will offer some usage examples of deplying Kubedeploy chart with Helmfile. It's by no means a replacement for Helmfile documentation, for full reference of configuration values and Helmfile options, please visit the official [Helmfile](https://helmfile.readthedocs.io/en/latest/) page.

## Quick start

1. [Install Helmfile](https://helmfile.readthedocs.io/en/latest/#installation) or use it from container

2. Create helmfile.yaml configuration

```yaml title="helmfile.yaml" linenums="1"
---
repositories:
  - name: sysbee
    url: https://charts.sysbee.io/stable/sysbee

releases:
  - name: my-webserver
    namespace: apps
    chart: sysbee/kubedeploy
    disableValidationOnInstall: true
    version: 1.1.0
    installed: true

    values:
      - image:
          repository: nginx
          tag: latest
```

3. Deploy with helmfile

```bash
helmfile --file helmfile.yaml apply
```

## Deploying multiple releases

From quickstart we might not get really great benefits while handling single deploymet. Where Helmfile shines is the managing multiple releases, and their dependencies, while helping you template repetitive values.


!!! example "Deploy multiple applications with dependencies"

    ```yaml title="helmfile.yaml" linenums="1"
    ---
    repositories:
      - name: sysbee
        url: https://charts.sysbee.io/stable/sysbee

    releases:
      - name: my-webserver
        namespace: apps
        chart: sysbee/kubedeploy
        version: 1.1.0
        installed: true

        values:
          - image:
              repository: nginx
              tag: latest

      - name: my-app
        namespace: apps
        chart: sysbee/kubedeploy
        version: 1.1.0
        installed: true

        needs:
          - my-webserver

        values:
          - image:
              repository: my-app
              tag: latest
    ```

    Deploy command

    ```bash
    helmfile --file helmfile.yaml apply --skip-needs=false
    ```


When making modification to our release values we can also do preview of changes prior to applying them directly to the cluster

!!! example

    ```bash
    helmfile --file helmfile.yaml diff
    ```

    Will output any changes in our releases

## Templating releases

If we wish to follow the [Best practices](../start/best-practices.md) for multiple releases managed with Helmfile we can easily define all the best practices in release template, and reuse it in all our releases:

!!! example "Release templating"

    ```yaml title="helmfile.yaml" linenums="1"
    ---
    repositories:
      - name: sysbee
        url: https://charts.sysbee.io/stable/sysbee

    templates:
      default: &default
        namespace: apps
        chart: sysbee/kubedeploy
        version: 1.1.0
        installed: true
        valuesTemplate:
          - nameOverride: '{{`{{ .Release.Name }}`}}'
          - replicaCount: 3
          - podDisruptionBudget:
              enabled: true
          - topologySpreadConstraints:
            - maxSkew: 1
              topologyKey: host
              whenUnsatisfiable: ScheduleAnyway
              labelSelector:
                matchLabels:
                  app.kubernetes.io/instance: '{{`{{ .Release.Name }}`}}'

    releases:
      - name: my-webserver
        <<: *default
        values:
          - replicaCount: 2
          - image:
              repository: nginx
              tag: latest

      - name: my-app
        <<: *default
        needs:
          - my-webserver
        values:
          - image:
              repository: my-app
              tag: latest
    ```

    All releases referencing the `default` anchor will inherit settings from default template. We can then easily keep common configuration values in one place, and override them per release if we need to.


## Using environment variables

Helmfile can use environment variables as inputs for chart values which can be pretty useful in defining variable values via CI/CD pipelines.

Users can define variables or secrets in CI/CD settings on GitHub or GitLab projects and then reference them in `helmfile.yaml`

!!! example "Using environment variables"

    ```yaml title="helmfile.yaml" linenums="1"
    ---
    repositories:
      - name: sysbee
        url: https://charts.sysbee.io/stable/sysbee

    releases:
      - name: my-webserver
        namespace: apps
        chart: sysbee/kubedeploy
        disableValidationOnInstall: true
        version: 1.1.0
        installed: true

        values:
          - image:
              repository: nginx
              tag: latest
          - extraSecrets:
              - name: app-secret
                type: Opaque
                data:
                  username: {{ requiredEnv "NGINX_USERNAME" }}
                  password: {{ requiredENV "NGINX_PASSWORD" }}
    ```

    Let's export the env vars before running helmfile

    ```bash title="export env vars"
    export NGINX_USERNAME=user
    export NGINX_PASSWORD=supersecret
    ```

    Deploy command

    ```bash
    hemfile --file helmfile.yaml apply
    ```
