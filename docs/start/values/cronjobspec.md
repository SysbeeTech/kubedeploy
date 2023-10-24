# cronjobspec

`cronjobspec` value in Kubedeploy defines [CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) specific parameters.

!!! note

    `cronjobspec` will be only taken into account if the `deploymetMode` is set to `Cronjob`.

Available values for `cronjobspec` in Kubedeploy:

```yaml
cronjobspec:
  schedule: "0 * * * *" # (1)
  restartPolicy: OnFailure # (2)
  command: [] # (3)
  args: [] # (4)
  backoffLimit: 3 # (5)
  startingDeadlineSeconds: 180 # (6)
  successfulJobsHistoryLimit: 3 # (7)
  failedJobsHistoryLimit: 1 # (8)
  concurrencyPolicy: "" # (9)

```

1. Define cronjob schedule, for details see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#writing-a-cronjob-spec)
2. Define restart policy for cronjob if deploymentMode=**Cronjob**.
3. Define command for cronjob
4. Define args for cronjob
5. Define job backoff limit, see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/job/#pod-backoff-failure-policy)
6. (optional) Define deadline for starting the job, see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#starting-deadline)
7. Define number of successful Job logs to keep
8. Define number of failed Job logs to keep
9. Define concurrency policy options: Allow (default), Forbid or Replace, see [reference](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/#concurrency-policy)


!!! danger "Deprecation Warning"

    Starting from Kubedeploy version 1.2, you should begin using image.command and image.args instead of cronjobspec.command and cronjobspec.args. These values will remain available as failsafe options until Kubedeploy 2.0, at which point they will be removed.


!!! example "Define cronjob"

    ```yaml title="values.yaml" linenums="1" hl_lines="7-9"
    nameOverride: my-cronjob
    deploymentMode: Cronjob
    image:
      repository: busybox
      tag: latest

    cronjobspec:
      schedule: "*/10 * * * *"
      command: ["sh", "-c", "echo hello from cronjob" ]

    ```

    ```bash title="Deploy command"
    helm install hello sysbee/kubedeploy -f values.yaml
    ```

The above example will create a CronJob that will run every 10 minutes and echo a hello message.

See also:

- [deploymentMode](deploymentmode.md)
- [jobspec](jobspec.md)
