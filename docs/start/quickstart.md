# Quickstart

To deploy with Kubdeploy you will require [Helm](https://helm.sh/docs/intro/install/), and Kubedeploy's Helm repo.

```bash
helm repo add sysbee https://charts.sysbee.io/stable/sysbee
helm repo update
```

This section covers how to deploy and modify the deployment of our containerized application by modifying default Kubedeploy values.

!!! tip "Values overrides"

    Charts values can be customized either by using `--set` on the command line or by using a custom `values.yaml` file and passing it to `helm install` command.
    It is recommended to use a `values.yaml` file as some overrides might be to complex for `--set` on command line

## Deploying simple application

We can easily deploy any containerized application by specifying a custom repository as a configurable value.

=== "Values file"


    ```yaml linenums="1" title="values.yaml"
    image:
      repository: nginx
    ```

    ```bash title="Deploy command"
    helm install nginx sysbee/kubedeploy -f values.yaml
    ```

=== "CLI"


    ```bash title="Deploy command"
    helm install nginx sysbee/kubdeploy --set image.repository=nginx
    ```

## Defining image version

!!! tip "Default application version"

    If unspecified, Kubedeploy will use `latest` as image tag

If we don't want to run our deployment from the latest tag, we can easily specify desired app version as well:

=== "Values file"


    ```yaml linenums="1" title="values.yaml" hl_lines="3"
    image:
      repository: nginx
      tag: 1.25.2
    ```

    ```bash title="Deploy command"
    helm install nginx sysbee/kubedeploy -f values.yaml
    ```

=== "CLI"

    ```bash title="Deploy command" linenums="1" hl_lines="3"
    helm upgrade --install nginx sysbee/kubedeploy \
    --set image.repository=nginx \
    --set image.tag=1.25.2
    ```

## Changing deployment modes

!!! tip "DeploymentModes"

    By default, Kubedeploy will create Kubernetes [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) for your container image.

We can also deploy our image as [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/):

=== "Values file"


    ```yaml linenums="1" title="values.yaml" hl_lines="5"
    image:
      repository: nginx
      tag: 1.25.2

    deploymentMode: Statefulset
    ```

    ```bash title="Deploy command"
    helm install nginx sysbee/kubedeploy -f values.yaml
    ```

=== "CLI"

    ```bash title="Deploy command" linenums="1" hl_lines="4"
    helm upgrade --install nginx sysbee/kubedeploy \
    --set image.repository=nginx \
    --set image.tag=1.25.2 \
    --set deploymentMode=Statefulset
    ```

## Persistence

!!! tip "Persistence support"

    Changing `deploymentMode` to Statefulset will not enable persistence by default


We can define persistent storage and its size by adjusting `persistency` values:

=== "Values file"


    ```yaml linenums="1" title="values.yaml" hl_lines="7-10"
    image:
      repository: nginx
      tag: 1.25.2

    deploymentMode: Statefulset

    persistency:
      enabled: true
      capacity:
        storage: 10Gi
    ```

    ```bash title="Deploy command"
    helm install nginx sysbee/kubedeploy -f values.yaml
    ```

=== "CLI"

    ```bash title="Deploy command" linenums="1" hl_lines="5"
    helm upgrade --install nginx sysbee/kubedeploy \
    --set image.repository=nginx \
    --set image.tag=1.25.2 \
    --set deploymentMode=Statefulset \
    --set persistency.enabled=true --set persistency.capacity.storage=10Gi
    ```

??? question "Can I use persistence with Deployments?"

    Kubedeploy supports persistency only for StetefulSets. However, you will learn in advanced examples how to enable persistent volumes even for Deployments.

## Exposing the application

Up until now, we have added Nginx as an application in our Kubernetes cluster. It's time to expose it on public domain:

=== "Values file"


    ```yaml linenums="1" title="values.yaml" hl_lines="12-18"
    image:
      repository: nginx
      tag: 1.25.2

    deploymentMode: Statefulset

    persistency:
      enabled: true
      capacity:
        storage: 10Gi

    ingress:
      enabled: true
      hosts:
        - mydomain.com

    ports:
      - containerPort: 80 # (1)

    ```

    1.  Opens port `80` for container. Ingress will automatically use first container port for routing traffic.

    ```bash title="Deploy command"
    helm install nginx sysbee/kubedeploy -f values.yaml
    ```

=== "CLI"

    ```bash title="Deploy command" linenums="1" hl_lines="6-7"
    helm upgrade --install nginx sysbee/kubedeploy \
    --set image.repository=nginx \
    --set image.tag=1.25.2 \
    --set deploymentMode=Statefulset \
    --set persistency.enabled=true --set persistency.capacity.storage=10Gi \
    --set ingress.enabled=true --set ingress.hosts[0].host=mydomain.com \
    --set ports[0].containerPort=80 #(1)
    ```

    1. Opens port `80` for container. Ingress will automatically use first container port for routing traffic.

## What's next?

Check out [Best practices](best-practices.md) and [Examples by Values](index.md) sections for more currated examples on customizable values in Kubedeploy chart.

Look into **Reference** section for Kubedeploy [Changelog](changelog.md) or [Values](../reference/values.md) for more information.
