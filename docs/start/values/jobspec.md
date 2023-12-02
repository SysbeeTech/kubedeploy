# jobspec

`jobspec` value in Kubedeploy defines [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/) specific parameters.

!!! note

    `jobspec` will be only taken into account if the `deploymetMode` is set to `Job`.

Available values for `jobspec` in Kubedeploy:

```yaml
jobspec:
  restartPolicy: OnFailure # (1)
  command: [] # (2)
  args: [] # (3)
  parallelism: 1 # (4)
  backoffLimit: 3 # (5)
  ttlSecondsAfterFinished: 300 # (6)

```

1. Define restart policy for jobs if deploymentMode=**Job**, see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/job/#handling-pod-and-container-failures)
2. Define command for Job
3. Define args for Job
4. Define Job paralelisam, see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/job/#controlling-parallelism)
5. Define Job backoff limit, see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/job/#pod-backoff-failure-policy)
6. (Feature state: [:material-tag-outline: 1.2.0](../changelog.md#110 "Minimum version")) Define [Automatic Cleanup for Finished Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/ttlafterfinished/)

!!! danger "Deprecation Warning"

    Starting from Kubedeploy version 1.2, you should begin using image.command and image.args instead of cronjobspec.command and cronjobspec.args. These values will remain available as failsafe options until Kubedeploy 2.0, at which point they will be removed.

!!! example "Define job"

    ```yaml title="values.yaml" linenums="1" hl_lines="7-8"
    nameOverride: my-job
    deploymentMode: Job
    image:
      repository: busybox
      tag: latest

    jobspec:
      command: ["sh", "-c", "echo hello from job" ]

    ```

    ```bash title="Deploy command"
    helm install hello sysbee/kubedeploy -f values.yaml
    ```

The above example will create a Job that will run once and echo a hello message.

See also:

- [deploymentMode](deploymentmode.md)
- [cronjobspec](cronjobspec.md)
