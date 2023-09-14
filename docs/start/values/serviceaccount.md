# serviceAccount

`serviceAccount` value in Kubedeploy controls if new service account should be created or if the application will use existing one.

!!! note
    By default `serviceAccount` creation is enabled.


!!! example "Annotate created service account with IRSA"

    ```yaml title="values.yaml" linenums="1" hl_lines="6-9"
    nameOverride: my-app
    image:
      repository: nginx
      tag: latest

    serviceAccount:
      create: true
      annotations:
        eks.amazonaws.com/role-arn: arn:aws:iam::111122223333:role/my-role
    ```

    ```bash title="Deploy command"
    helm install webapp sysbee/kubedeploy -f values.yaml
    ```

With the example above created service account will have extra annotatins required to get the IRSA working for your application. Kubdeploy will not however deploy IRSA configuration on your cluster or AWS account.

!!! info

    Find out more about [IRSA](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)
