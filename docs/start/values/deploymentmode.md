# deploymentMode

Kubedeploy by default deploys your application in Kubernetes cluster as [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/).

You can also specify different `deplyomentMode` per use-case:

- `Deployment` - default if unspecified
- `Statefulset` - deploy application as [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
- `Job` - deploy application as [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/)
- `Cronjob` - deploy application as [CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)
- `None` - do not deploy application. In this mode Kubedeploy can be used to deploy, ConfigMaps, Secrets, etc.

!!! example "Application as StatefulSets"

    ```yaml linenums="1" title="values.yaml" hl_lines="5"
    image:
      repository: nginx
      tag: 1.25.2

    deploymentMode: Statefulset

    ```

    ```bash title="Deploy command"
    helm install webserver sysbee/kubedeploy -f values.yaml
    ```

!!! note "Additional options"

    Some deployment modes offer additional mode specific customizations or restrictions, see related Kubedeploy values for more info.

See also:

- [cronjobspec](cronjobspec.md)
- [jobspec](jobspec.md)
- [persistency](persistency.md)
