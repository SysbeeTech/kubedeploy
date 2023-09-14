# kubeVersionOverride

When generating Kubernetes manifest files for objects, Kubedeploy will sometimes check the Kubernets API for its version to determine API compatibility.

`kubeVersionOverride` value can be used to change the automatically deteceted Kubernetes version.

!!! question "When to use kubeVersionOverride?"

    If you encounter compatibility issues, or if you are generating templates without the active Kubernetes cluster.


!!! example "kubeVersionOverride"

    ```yaml linenums="1" title="values.yaml" hl_lines="1"
    kubeVersionOverride: "1-22.0-0"
    image:
      repository: nginx
      tag: 1.25.2

    deploymentMode: Deployment

    ```
