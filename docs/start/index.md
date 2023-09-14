# Examples by Values

This section lists all the Kubedeploy's top level configurable values, as well as their subvalues with examples on how to use them.

Where applicable, documentation page will list the defaults, and explain behind the scenes  to gain better understanding what will happen when you modify those values.

All the values are documented in chart's default `values.yaml` file as well which can be good starting point for exploring.

!!! example "Retrieving default values.yaml file"

    ```bash
    helm show values sysbee/kubedeploy
    ```

If you would like to experiment with the configurable values and see their output on rendered manifests you can use Helm's template ability

!!! example "Previewing changes"

    ```bash
    helm template my-release sysbee/kubedeploy -f values.yaml
    ```

To get an insights into all the values with configurable subvalues please visit the [Reference](../reference/values.md) page.
