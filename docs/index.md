---
hide:
 - toc
 - navigation
---
#
<figure markdown>
![Kubedeploy](img/Kubedeploy.png){ width="528" }
<figcaption>Kubedeploy: Your Gateway to Effortless Kubernetes Application Deployment</figcaption>
</figure>


In the fast-paced world of modern software deployment, simplicity and flexibility are paramount. Meet Kubedeploy, your ultimate solution for effortlessly deploying containerized applications to your Kubernetes cluster.

Kubedeploy was born out of the need for a straightforward and versatile framework to streamline the deployment of Docker images to Kubernetes clusters.

<figure markdown>
[Quick Start :fontawesome-solid-rocket:](start/quickstart.md){ .md-button .md-button--primary } [Documentation :fontawesome-solid-book:](start/index.md){ .md-button } [Examples :fontawesome-solid-eye:](examples/index.md){ .md-button }
</figure>

## Kubedeploy in a nutshell

Kubedeploy is the bridge that brings simplicity and flexibility together in the Kubernetes deployment journey.
Whether you're a beginner looking for an easy start or an advanced user seeking precision and control, Kubedeploy empowers you to navigate the complexities of Kubernetes deployment with ease.

Deploy smarter, deploy with Kubedeploy.

!!! example "Simple Nginx deployment"

    ```bash
    helm install nginx sysbee/kubedeploy --set image.repository=nginx
    ```

Follow the [Quickstart](start/quickstart.md) guide for more examples.

## What is Kubdeploy

- **Generalized Helm Chart:** At the core of Kubedeploy is a generalized Helm chart, designed to effortlessly deploy any containerized application into Kubernetes clusters. Say goodbye to the tedious task of crafting complex Kubernetes manifest files or developing custom Helm charts for your applications.

- **Simplicity for Beginners:** Kubedeploy is your trusted ally if you're new to Kubernetes. With just two values to tweak, image.repository and image.tag, you can deploy a new application in no time. It's an ideal starting point for those taking their first steps in Kubernetes.

- **Flexibility for Advanced Users:** For the seasoned Kubernetes users, Kubedeploy offers a playground of possibilities. Define custom values to fine-tune and extend your deployments precisely as you need. It adapts to your expertise, ensuring your applications are deployed with the precision you demand.

- **Compatibility Across Scenarios:** Kubedeploy doesn't play favorites; it aims to be compatible with a wide range of deployment scenarios. Whether you're deploying microservices, web applications, or databases, Kubedeploy's got your back.

## What Kubedeploy isn't

- **Not a Replacement for Specialized Charts:** While Kubedeploy is a powerful tool, it's not meant to replace specialized application charts tailored to specific software. It complements them by offering a more generalized approach to deployment.

- **Not a Deployment Engine:** Kubedeploy is a facilitator, not a replacement for essential deployment engines like Helm. You'll still need these tools to orchestrate and manage the deployment process.
