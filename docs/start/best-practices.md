# Best practices

When deploying applications to Kubernetes clusters, consider the following best practices when defining custom Kubedeploy values.

In the following sections, we will cover some of the deployment configuration in the context of Kubedeploy configuration values.
For the sake of simplicity, all of the examples will be provided as values in custom `value.yaml` file which can then be passed to Helm or other Helm chart release management software.


!!! tip

    While it might be acceptable to disregard these best practices in a development environment, production environment should adhere to them. This adherence helps minimize potential application downtime, reduce errors during new application version rollouts, and enhance the application's resilience against resource shortages, among other benefits.

## Replicas

Application replicas play a significant role in ensuring application availability during new version rollouts, underlying infrastructure errors, and other configuration values that we will discuss later on this page.

The Default replica count in Kubedeploy is `1`, meaning only one Pod of your application will run in cluster. As mentioned, this might be suitable for a development environment where the application is under no specific Service Level Objective (SLO) needs to be met.

In the event of a Kubernetes node failure, the application will become unavailable until it is rescheduled on another node. During a new version rollout, a new single pod will be created with the updated version, and the old pod will then be terminated.

Increasing the `replicaCount` value in Kubedeploy will create corresponding number of Pod replicas for your application in the cluster, enhancing the application's resiliency and throughput, if other complimentary configurations are properly set.

!!! note "replicaCount != High Availability"

    However, it's important to note that increasing the replicaCount does not automatically guarantee high availability.
    The Kubernets scheduler might place all the Pod replicas on single node if Pod `AntiAffinity` is not configured, resulting in downtime if that specific Kubernetes node goes offline.

On the downside, a higher replica count will consume more resources within the cluster, leading to increased operating costs. Configuring proper replicaCount is a balancing game between availability and infrastructure cost.

!!! example "increasing replicaCount"

    ```yaml title="custom-values.yaml" linenums="1"
    replicaCount: 3
    ```

To ensure greater application availability, it's recommended to have at least 2-3 replicas of the application running at all times.

## Assigning Pod to nodes

By default, the Kubernetes scheduler aims to pack Pods as densely as possible, minimizing resource overhead on nodes. Consequently, the default scheduler always attempts to use the fewest number of nodes in the cluster.


There are couple of ways to influence default scheduler and Pod placement strategy.
In this section we will discuss [affinity,  anti-affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity), as well as [Pod topology spread constraints](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#pod-topology-spread-constraints).
For more detailed information, please follow the links to the official documentation.

### Affinity

The affinity configuration allows as to define soft (preferred) or hard (required) Pod affinity and anti-affinity rules for Pods.

Kubedeploy allows for automatic setup of simple Pod anti-affinity rules:

!!! example "Simple Pod anti-affinity"

    ```yaml title="Soft anti-affinity" linenums="1"
    fullnameOverride: my-app
    replicaCount: 3
    podAntiAffinity: "soft"
    ```

    The above values will establish soft pod-anti-affinity rules based on Pod selector labels. In this scenario, Pods will strive to be placed on different hosts if resources are available. If there aren't enough nodes available in the cluster, but the Pod's resource requirement allows it, the scheduler might place two Pods on one node and the third Pod on another node. To ensure that the scheduler provisions Pods on different nodes, we can adjust the configuration as follows:

    ```yaml title="Hard anti-affinity" linenums="1"
    fullnameOverride: my-app
    replicaCount: 3
    podAntiAffinity: "hard"
    ```

    In the previous example, the scheduler is required to place all Pod replicas on different nodes.

    !!! info "With configured cluster autoscaler"
        If there aren't enough available nodes (even if there are sufficient resources), the cluster autoscaler will be activated to provide additional nodes, meeting the hard anti-affinity requirement.
        If the autoscaler is unable to allocate more nodes, it will schedule as many Pod replicas as possible based on the requirement, with remaining Pods remaining in a Pending state until the requirement can be fulfilled.


The simple Pod anti-affinity configuration permits the selection of the topology key for spreading the pods. Topology keys are labels assigned to Kubernetes nodes.
Anti-affinity rules will search for values in those keys and ensure that each Pod is placed on a node with a different value for the given topology key.

The default topology key for simple Pod anti-affinity rules is  `kubernetes.io/hostname`. However, this is configurable and can be changed based on use case.

!!! example "Simple Pod anti-affinity with zone key"

    ```yaml title="Soft anti-affinity by zone" linenums="1"
    fullnameOverride: my-app
    replicaCount: 3
    podAntiAffinity: "soft"
    podAntiAffinityTopologyKey: kubernetes.io/zone
    ```

    In the example above, Pods will be spread across multiple availability zones, enhancing application resilience to failures within a single AZ.
    Soft anti-affinity is preferred here, as the availability zone count is finite and oftentimes can't be increased.
    If the cluster is configured with only two availability zones, two Pod replicas would be placed in zone `A` and one Pod in zone `B`.

    !!! warning

        In case of hard anti-afinity rules based on zones, if the replicaCount is greater than the number of configured zones, some Pods will never be scheduled.


Kubedeploy also provides the ability to define custom affinity and anti-affinity rules. This offers finer control over Pod placement, not only in relation to each other but also in relation to other deployments. Custom affinity rules can be created via `affinity` option in Kubedeploy values, which will be directly translated into Pods `spec.affinity`.

!!! warning

    Defining custom affinity rules will disable any configured simple anti-affinity rules.

Configuration of custom affinity rules is beyond the scope of this document; please refer to [official documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity) for usage examples.

### Topology Spread Constraints

For more detailed explanation on [Pod Toplology Spread Constraints](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/) please refer to the official documentation.

In essence, these constraints provide a flexible alternative to Pod Affinity/Anti-Affinity.
Topology spread constraints let you separate nodes into groups and assign Pods using a label selector. They also allow you to instruct the scheduler on how (un)evenly to distribute those Pods.

Topology spread constraints can overlap with other scheduling policies like Node Selector or taints. The last two fields of a Pod topology spread let you decide on the nature of these relations:

**nodeAffinityPolicy** lets you decide how to treat your Pod’s nodeAffinity and nodeSelector when calculating the topology spread skew. You get two options:
1. Honor only includes nodes matching nodeAffinity and nodeSelector.
2. Ignore, ignoring these settings and including all nodes in the calculations.

The Honor approach is the default if you leave this field empty.

**nodeTaintsPolicy** indicates how you wish to treat node taints when calculating Pod topology spread skew. Here you also get two options: Honor or Ignore, with the latter being followed if you leave this field empty.

Kubedeploy offers the `toplologySpreadConstraints` configuration value to pass raw configuration. For more information on the format, please refer to the official [examples](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/#topology-spread-constraint-examples).

!!! example "Spreading multiple Pod replicas evenly across availability zones"

    Topology constraints offer similar "soft" and "hard" requiremnets in the form of `whenUnsatisfiable` option. The "hard" requierment is the default.
    Unlike the example with "hard" anti-affinity rules when selecting zone as toplology key, toplology constraint can successfully schedule more replicas (for example, 5) across 2 availability zones.

    ```yaml title="Hard toplologySpreadConstraint by zone" linenums="1"
    fullnameOverride: my-app
    replicaCount: 5
    toplologySpreadConstraints:
      - maxSkew: 1
        topologyKey: kubernetes.io/zone
        whenUnsatisfiable: DoNotSchedule
        labelSelector:
            matchLabels:
                app.kubernetes.io/name=my-app
    ```

    In the example above, with cluster deployed in only two availability zones, three Pods would be deployed in zone `A` and two Pods in zone `B`.

### Node Selectors

Each node in the cluster is assigned a predefined set of common labels. Node labels can be utilized in Pod scheduling decisions by defining node selectors.

Kubedeploy offers this functionality via the `nodeSelector` value config option, enabling you to specifically target a particular node group.

!!! example "Targeting specific node group"

    ```yaml title="Node selectors" linenums="1"
    fullnameOverride: my-app
    replicaCount: 2
    nodeSelector:
      kubernetes.io/arch: arm64
    ```

    In the example above, Pods will target nodes of **arm64** architecture and will not attempt to schedule on nodes with the **amd64** architecture.

    !!! warning

        Containers must be built specifically for **arm64** or for both architectures to utilize the above-mentioned nodeSelector. **arm64** nodes offer the same resource capacity as their **amd64** counterparts usually at a considerably lower price.

Pods can also target multiple known node selector labels to gain more fine-grained control over their placement. EKS clusters that utilize [Karpenter](https://karpenter.sh/) can dynamically provision nodes based on requirements.
If the provisioner is set to deploy specific instance types, Pods can use any of the [well-known Node labels](https://kubernetes.io/docs/reference/labels-annotations-taints/).
Furthermore, Karpenter will label nodes based on their [instance types](https://karpenter.sh/preview/concepts/instance-types/), allowing the `nodeSelectors` to provision specific instance generation or family.


!!! example "Provisioning on specific instance family"

    ```yaml title="Node selectors" linenums="1"
    fullnameOverride: my-app
    replicaCount: 2
    nodeSelector:
      karpenter.k8s.aws/instance-family: m6g
    ```

    From this example we will be provisioning Pods on `m6g` instance family. `kubernetes.io/arch` is implied to be **arm64** as the **m6g** instances are only available for **arm64**.


!!! example "Provisioning on instance-category and generation"

    ```yaml title="Node selectors" linenums="1"
    fullnameOverride: my-app
    replicaCount: 2
    nodeSelector:
      karpenter.k8s.aws/instance-category: m
      karpenter.k8s.aws/instance-generation: 6
    ```

    In this example, we are targeting any instance type starting with `m6`, including:

    - m6a
    - m6g
    - m6gd
    - m6i
    - m6id
    - etc.

    !!! note

        If we specifically want to limit the scheduler to provision on **arm64** instances, this should be explicitly defined as additional label in node selector: `kubernetes.io/arch: arm64`. This will restrict the scheduler to just `m6g` and `m6gd` instance family

### Node Taints and Tolerations

Nodes can be grouped for provisioning, isolating workloads from one another. For example, Kubernetes cluster might have a dedicated node group solely for database services.
To achieve this, nodes can be configured with specific node taints. Pods that lack specified tolerations for those taints will avoid scheduling on such node groups.

For more information on toleration and taints, please follow the official [documentation](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).

Kubedeploy offers the ability to define custom tolerations for Pods with `tolerations` value configuration.

!!! example "Provision node on specific node group with taints"

    Let's assume we have a specific node group running the `c6` instance family, intended only for database workloads. Nodes have a specific label set: `workload-type: database`.
    Additionally, there's a taint  named `workload-type` with the value `database` and the effect `NoSchedule`. If we wish to target this specific node group, we can't rely solely on Karpenter's known labels. Using those labels would provision new nodes of the desired instance family, where other workloads could be scheduled if free capacity is available.

    To target this specific group, we need to use a `nodeSelector` with `tolerations`.

    ```yaml title="Node selectors and tolerations" linenums="1"
    fullnameOverride: my-app
    replicaCount: 2
    nodeSelector:
      workload-type: database
    tolerations:
      - key: workload-type
        value: database
        effect: NoSchedule
    ```

    This configuration targets the specific `workload-type: database` node group. Kubernets cluster administrators can then control which instance family is required for this workload on a system level, rather than defining the desired instance family in each deployment. The toleration key ensures that our Pods will tolerate the taints set on the node group.


### Spot vs On-demand capacity types

!!! info "Cloud provider specific"

    This section covers AWS specific configuration, depending on your cloud provider you might need to adjust the settings accordingly.

AWS offers two different capacity types for all their instance families:


- **On-Demand**: These instances are permanent, running on-demand workloads. They are non-interruptible capacity types, remaining operational until you decide to terminate them.
- **Spot**: This capacity type involves temporary, interruptible compute instances. They are sold by AWS when there is excess spare capacity in the region/zone. While identical in terms of compute power, spot instances offer a price saving of 50-70% compared to on-demand instances. However, spot instances can be terminated by AWS at any time in favor of on-demand instances, potentially causing workload interruption.

!!! note

    Kubernetes workloads, at their core, should tolerate such interruptions well, especially if multiple application replicas are defined and spread across nodes, as explained earlier in this document.

!!! tip "Handling spot instance interruptions"

    When dealing with spot instance interruptions it is advisable to configure either Karpenter's built-in "Interruption handling" or configuring dedicated [Node termination handler](https://github.com/aws/aws-node-termination-handler)

Karpenter provides the functionality to intercept spot instance interruption events. AWS sends a 2-minute termination notice before an instance is terminated. Karpenter will then:

1. Flag the node with a special taint to prevent new scheduling activity.
2. Provision a replacement node, considering workload node selection and resource requirements on the to-be-interrupted node.
3. Pre-allocate workloads to the newly provisioned node.
4. Initiate a graceful eviction of the node's workload, allowing Pods to finish their current operations and migrate to the new node.
5. After eviction, either Karpenter decommissions the node scheduled for termination or AWS's Termination handler cleans up the node, whichever comes first.


!!! warning

    This process is not the same as "live migrating" the Pod.
    Eviction and migration will interrupt Pods execution. Please make sure to read other best-practices on how to deal with this gracefully.

!!! question "When should I avoid spot instances?"

    - For non-HA services (1 replica) in production environments.
    - If your workload does not tolerate interruptions well (e.g., caching proxies like Varnish and some databases).

!!! example "Explicitly targeting on-demand capacity type"

    For most cases, you can safely skip this configuration and let the cluster provisioner determine the optimal capacity type. However, if your application falls into the categories mentioned earlier or there is a reasonable demand for on-demand instances, you can define this in your deployment using nodeSelectors.


    ```yaml title="Targeting on-demand capacity-type" linenums="1"
    fullnameOverride: my-app
    replicaCount: 2
    nodeSelector:
      karpenter.sh/capacity-type: on-demand
    ```

    This ensures that the workload always runs on on-demand instances.

## Pod Disruption budgets

Pods do not disappear until someone (a person or a controller) destroys them, or there is an unavoidable hardware or system software error.
We call these unavoidable cases involuntary disruptions to an application. Examples are:

- a hardware failure of the physical machine backing the node
- cluster administrator deletes VM (instance) by mistake
- cloud provider or hypervisor failure makes VM disappear
- a kernel panic
- the node disappears from the cluster due to cluster network partition
- eviction of a Pod due to the node being out-of-resources.

Except for the out-of-resources condition, all these conditions should be familiar to most users; they are not specific to Kubernetes.

We call other cases voluntary disruptions. These include both actions initiated by the application owner and those initiated by a Cluster Administrator. Typical application owner actions include:

- deleting the deployment or other controller that manages the pod
- updating a deployment's Pod template causing a restart
- directly deleting a Pod (e.g. by accident)

Cluster administrator actions include:

- Draining a node for repair or upgrade.
- Draining a node from a cluster to scale the cluster up or down
- Removing a Pod from a node to permit something else to fit on that node.

These actions might be taken directly by the cluster administrator, or by automation run by the cluster administrator.

Kubernetes offers features to help you run highly available applications even when you introduce frequent voluntary disruptions.

As an application owner, you can create a PodDisruptionBudget (PDB) for each application. A PDB limits the number of Pods of a replicated application that are down simultaneously from voluntary disruptions. For example, a quorum-based application would like to ensure that the number of replicas running is never brought below the number needed for a quorum. A web front end might want to ensure that the number of replicas serving load never falls below a certain percentage of the total.

Kubedeploy offers an option to define PodDisruptionBudget by configuring `podDisruptionBudget` values.

!!! example "Enabling podDisruptionBudget"

    ```yaml title="podDisruptionBudget example" linenums="1"
    fullnameOverride: my-app
    replicaCount: 3
    podDisruptionBudget:
      enabled: true
      minAvailable: 2
    ```

    In the example configuration above, we ensure that our Pod has 3 replicas at normal runtime. Configured PodDisruptionBudget requires that at least 2 replicas are always available during any voluntary disruptions.

To learn more about Pod disruptions and PodDisruptionBudgets, please refer to the official [documentation](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#dealing-with-disruptions).

## Resource requirements


!!! tip

    A key to effective deployment and resource management is setting appropriate resource requests and limits on the containers running within a pod.

By default no resource requests and limits are imposed on Pods and containers unless otherwise specified by namespace [LimitRange](https://kubernetes.io/docs/concepts/policy/limit-range/) policy.
As a result, any Pod is allowed to consume as many resources as it requires or as are available on the node. Additionally, the scheduler has no insight into how many resources a pod needs and assumes that all Pods can fit on a single node unless other pod placement rules are configured.

This creates the possibility of resource starvation on the node and some involuntary Pod disruptions. To avoid such situations it is recommended to define at least resource requests for Pods.

!!! note "Resource requests vs limits"

    Resource requests reserve the specified resources for the execution of a Pod. Once reserved, the Kubernetes scheduler considers these resources unusable for scheduling new workloads on that node.

    Resource limits establish upper bounds on the resources a Pod can actually use. If limits are unspecified, a Pod can consume all available (unreserved) resources on the node where it's scheduled.

!!! example

    ```yaml title="Defining resource requirements" linenums="1"
    resource:
      requests:
        cpu: 1
        memory: 512Mi
      limits:
        cpu: 2
        memory: 1024Mi
    ```

    In this example, the container reserves 1 CPU core and 512MB of memory for its execution. This reservation is guaranteed at all times.
    During scheduling, this Pod will not be placed on nodes with fewer resources than requested.

    Simultaneously, the container can burst up to 2 CPU cores (after which it will be throttled) and utilize up to 1024MB of memory.
    If the memory limit is reached and the container requests more memory from the system, the out-of-memory killer (OOM) will terminate it.

    In a scenario where a container with the aforementioned resource requests and limits is placed on a node with only enough capacity for its requests but not its limits, CPU usage will be throttled.
    Additionally, in cases of memory pressure, the pod will be evicted from the node in order to find a more suitable node with more available resources.

!!! tip

    There's no one-size-fits-all rule for defining resource requests and limits. It largely involves a balancing act among actual requirements, workload availability, and platform cost optimization. As a general guideline, start with smaller requests and larger limits. Then, observe the workload patterns in your monitoring dashboards and make adjustments to the limits.

Defining excessively large resource requests will result in a larger cluster and subsequently higher operating costs.

Kubedeploy offers the ability to define resource requirements for each of its container components (main container, additionalContainers, and initContainers).

!!! example

    ```yaml title="Defining resource requests" linenums="1"
    fullnameOverride: my-app
    resources:
      requests:
        cpu: 0.1
        memory: 128Mi
      limits:
        cpu: 1
        memory: 512Mi
    ```

    If you don't know your application requiremetns, this example provides a solid starting point for defining resource requirements for the main container. After some time, review the resource dashboards in your monitoring tool for this workload and fine-tune the requests and limits accordingly.

For further insights into resource management for pods and containers, please refer to the official [documentation](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) page.

## Autoscaling


!!! tip

    Autoscaling can aid in maintaining low resource and platform cost utilization while retaining the capability to automatically enhance application throughput based on various scaling triggers.


Autoscaling features within Kubedeploy enable the utilization of either Kubernets' built in [Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) or [Keda](https://keda.sh/).

Configuration options are available under the `autoscaling` and `keda` values.

!!! note

    You can only use one of the options, either HPA or Keda. HPA serves as a simpler autoscaling solution, which we will cover on this page. On the other hand, Keda offers a more intricate, fine-grained scaling solution; however, its configuration is beyond the scope of this document.

!!! warning

    For HPA to function correctly, pods must define at least resource requests, as they are used in calculating utilization based on the CPU and memory utilization of the pods. While HPA can be deployed for deployments without defined resource requests, scaling will remain disabled until resource requests are defined.

!!! example "Define autoscaling policy"

    ```yaml title="Simple autoscaling" linenums="1"
    fullnameOverride: my-app
    resources:
      requests:
        cpu: 0.5
        memory: 128Mi
    autoscaling:
      enabled: true
      minReplicas: 2
      maxReplicas: 10
      targetCPUUtilizationPercentage: 80
    ```

    In the above example we are defining deployment with resource requirements of 1/2 of CPU core.

    HPA is then configured to watch the CPU utilization of this workload.
    If it hits 80% of requested CPU resources it will increase the number of replicas by one until average deployment CPU utilization either drops below `80%` or `maxReplicas` is reached.

    HPA will attempt to downscale underutilized deployments every 5 minutes if the average CPU utilization is below 80%.

    !!! imporant
        It's important to note that the utilization percentage is always calculated from resource requests, not limits. If you have higher limits, you can, for example, define a percentage of 200%, which would allow pods to burst beyond their resource requests before triggering scaling.

## Pod security context

The securityContext field allows you to set various security-related options for the containers within a pod. Some of the options that can be set include:

- `runAsUser`: Sets the user ID (UID) that the container should run as. This can help to prevent privilege escalation attacks.
- `runAsGroup`: Sets the group ID (GID) that the container should run as.
- `capabilities`: Specifies the Linux capabilities that the container should have.
- `privileged`: Indicates whether the container should be run in privileged mode or not.
- `seLinuxOptions`: Specifies the SELinux context that the container should run with.
- `fsGroup`: Sets the GID that the container’s filesystem should be owned by.

To gain a deeper understanding of how the securityContext options behave in different situations, refer to the official Kubernetes [documentation](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/). It outlines the intended behavior of each option, taking into consideration various factors such as the underlying operating system and container runtime being used, as well as the configuration of the Kubernetes cluster itself.

By studying the documentation, you can gain insights into how these options can provide additional security controls for containers running within a Kubernetes pod. However, misconfiguring these options can lead to unintended consequences, such as preventing a container from running correctly or opening up security vulnerabilities, so read carefully and follow best practices when setting up these security controls.

Kubedeploy offers configuration value `podSecurityContext` that can be used define desired security context applied to all containers in a Pod or `securityContext` which will be applied only to main container.

!!! example

    ```yaml title="Pod security context" linenums="1"
    fullnameOverride: my-app
    podSecurityContext:
      runAsUser: 1000
      runAsGroup: 3000
      fsGroup: 2000
    ```

    In the configuration above, the runAsUser field specifies that for any Containers in the Pod, all processes run with user ID 1000.

    The runAsGroup field specifies the primary group ID of 3000 for all processes within any containers of the Pod. If this field is omitted, the primary group ID of the containers will be root(0).

    Any files created will also be owned by user 1000 and group 3000 when runAsGroup is specified. Since fsGroup field is specified, all processes of the container are also part of the supplementary group ID 2000. The owner for volume /data/demo and any files created in that volume will be Group ID 2000.


## Healthchecks and Pod lifecycle

Defining proper health check probes can enhance the robustness of application deployments, mitigating potential downtimes and errors during rolling updates. Combined with Pod lifecycle hooks and minReadySeconds, we can fortify our application, minimizing runtime errors during evictions.


### Healthcheck Probes


Many applications, when running for extended periods, eventually encounter broken states from which they cannot recover except through a restart. To address such situations, Kubernetes offers liveness probes for detection and remediation.

In some cases, dealing with legacy applications demands an additional startup time during their initial initialization. In such scenarios, configuring liveness probe parameters can be challenging without compromising the swift response to application deadlocks that necessitated such a probe. The solution is to establish a startup probe using the same command, HTTP, or TCP check, with a failureThreshold * periodSeconds duration covering the worst-case startup time.

Furthermore, applications might occasionally be unable to serve traffic temporarily. This could occur during startup when loading substantial data or configuration files, or when dependent on external services post-startup. In such instances, you don't want to terminate the application, but you also don't want to direct requests to it. Kubernetes provides readiness probes to detect and mitigate these scenarios. A pod with containers indicating they are not ready won't receive traffic through Kubernetes Services.


Kubedeploy offers the possibility to define custom health check probes via `healthcheck` configuration value, both for the main container and  additional containers.

!!! example

    ```yaml title="Main container healthcheck" linenums="1"
    fullnameOverride: my-app
    ports:
      - name: liveness-port
        containerPort: 8080
        protocol: TCP
    healthcheck:
      enabled: true
      probes:
        livenessProbe:
          httpGet:
            path: /healthz
            port: liveness-port
          failureThreshold: 5
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /healthz
            port: liveness-port
          failureThreshold: 1
          periodSeconds: 10
        startupProbe:
          httpGet:
            path: /healthz
            port: liveness-port
          failureThreshold: 30
          periodSeconds: 10
    ```

    In the example above we have exposed main containers port `8080` with name `liveness-port`. We then configured three healthcheck probes. The liveness probe generates HTTP request on liveness-port at /healthz URI every 10 seconds. If there are five consecutive request errors, the container will be restarted. The liveness probe will become effective onlyly after startupProbe returns a healthy state.

    Since the application might take some time to start up, we create startupProbe with same URI endpoint checks. However, we tolerate 30 failures before the container is restarted.

     Additionally, we've established a readinessProbe to remove the pod from load balancing if even one failure is detected. This helps avoid failed HTTP requests before the application restarts after five failures.

!!! note

    Healthcheck probes can also be configured as commands that can be executed within container.

To learn more about Kubernetes health check probes please see the official [documentation](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/).

### minReadySeconds

When combined with defined `readinessProbe`, [minReadySeconds](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#min-ready-seconds) is used to signal the scheduler when the old replica versions can be removed during rolling version upgrades.

!!! example "Defining minReadySeconds with Kubedeploy"

    ```yaml title="minReadySeconds" linenums="1"
    fullnameOverride: my-app
    ports:
      - name: liveness-port
        containerPort: 8080
        protocol: TCP
    healthcheck:
      enabled: true
      probes:
        livenessProbe:
          httpGet:
            path: /healthz
            port: liveness-port
          failureThreshold: 5
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /healthz
            port: liveness-port
          failureThreshold: 1
          periodSeconds: 10
    minReadySeconds: 120
    ```

    In the example above, the container is deemed ready and begins receiving requests through the service object as soon as the readinessProbe reports a healthy status. Additionally, we've defined minReadySeconds to increase the time before the container is considered available.


**How Does This Impact Rolling Updates?**

- When a rolling version update occurs, the Kubernetes scheduler respects any pod disruption budgets and rolling update strategies.
- By default, a new replicaSet is created with the new version. A new pod is then generated by the new replicaSet.
- Once the new pod is ready as indicated by the `readinessProbe`, it is included in service load balancing and starts receiving new traffic.
- The `minReadySeconds` timer waits for an additional `120 seconds` to ascertain whether the pod might crash with the influx of new traffic.
- This timer resets upon any crash. After the `minReadySeconds` duration passes, the old replicaSet's pod is removed.

This process repeats until all replicas are updated to the new version. By employing `minReadySeconds`, applications become more resilient and less error-prone during rolling updates.

### Lifecycle Hooks

Kubernetes supports the postStart and preStop events. Kubernetes sends the postStart event immediately after a Container is started, and it sends the preStop event immediately before the Container is terminated. A Container may specify one handler per event.

!!! example "Defining custom lifecycle hook with Kubedeploy"

    ```yaml title="minReadySeconds" linenums="1"
    fullnameOverride: my-app
    image:
      terminationGracePeriodSeconds: 120
      lifecycle:
        preStop:
          exec:
            command: ["/bin/sh","-c","nginx -s quit; while killall -0 nginx; do sleep 1; done"]
    healthcheck:
      enabled: true
      probes:
        readinessProbe:
          httpGet:
            path: /healthz
            port: liveness-port
          failureThreshold: 1
          periodSeconds: 10
    ```

    In this example, we've registered a `preStop` hook triggered just before the container terminates.
    Kubernetes awaits the completion of this command or until the `terminationGracePeriod` is reached before terminating the container.

    The command in the example sends a graceful shutdown signal to nginx, allowing it to stop accepting new requests while completing ongoing ones.

    Consequently, the readiness probe will fail, and the pod will no longer be actively load balanced by the service object.

    Any long-running requests will be finalized, and the command will exit, enabling a clean and graceful pod termination without generating failed HTTP requests.

To learn more about lifecycle hooks please see the official [documentation](https://kubernetes.io/docs/tasks/configure-pod-container/attach-handler-lifecycle-event/).
