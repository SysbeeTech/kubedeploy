# nameOverride

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


`nameOverride` value can be used to change the default deployed resource names by changing the chart name as suffix.

!!! question "When to use nameOverride?"

    Kubedeploy is a generic chart, as such its chart name does not reflect on application being deployed.
    If you need to deploy multiple instances of your applciation it is recommended to set the `nameOverride` value to your application name, and assign the `release name` to your specific installation instance.


!!! example "nameOverride for Deployment"

    ```yaml linenums="1" title="values.yaml" hl_lines="1"
    nameOverride: nginx

    image:
      repository: nginx
      tag: 1.25.2

    deploymentMode: Deployment

    ```

    ```bash title="Deploy command"
    helm install webserver sysbee/kubedeploy -f values.yaml
    ```

    Will result in deployment name: `webserver-nginx`

!!! note "shortening the deployed application name"

    In cases where `nameOverride` is equal to `release name`, Kubedeploy will shorten the deplyed resource names to just `release name`.

See also: [fullnameOverride](fullnameoverride.md)
