# fullnameOverride

Kubedeploy generates object names in templates based on `kubedeploy.fullname` helper template. By default all objects will have names calculated from Helm `release name` suffixed by `kubedeploy`.

!!! example "Default name for Deployment"

    ```yaml linenums="1" title="values.yaml"
    image:
      repository: nginx
      tag: 1.25.2

    deploymentMode: Deployment

    ```

    ```bash title="Deploy command"
    helm install webserver sysbee/kubedeploy -f values.yaml
    ```

    Will result in deployment name: `webserver-kubedeploy`


`fullnameOverride` value can be used to change the default deployed resource names by changing the full deployment name.

!!! question "When to use fullnameOverride?"

    Kubedeploy is a generic chart, as such its chart name does not reflect on application being deployed.
    `fullnameOverride` should be used when you don't plan to install multiple instances of your application, and you want a shorter deployment names.


!!! example "fullnameOverride for Deployment"

    ```yaml linenums="1" title="values.yaml" hl_lines="1"
    fullnameOverride: nginx

    image:
      repository: nginx
      tag: 1.25.2

    deploymentMode: Deployment

    ```

    ```bash title="Deploy command"
    helm install webserver sysbee/kubedeploy -f values.yaml
    ```

    Will result in deployment name: `nginx`


See also: [nameOverride](nameoverride.md)
