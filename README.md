# Kubedeploy

Kubedeploy is generic Helm chart for deploying containers in Kubernetes cluster

## Chart documentation

You can find chart options and documentation at official chart page [https://kubedeploy.app](https://kubedeploy.app)

## What is Kubdeploy?

- **Generalized Helm Chart:** At the core of Kubedeploy is a generalized Helm chart, designed to effortlessly deploy any containerized application into Kubernetes clusters. Say goodbye to the tedious task of crafting complex Kubernetes manifest files or developing custom Helm charts for your applications.

- **Simplicity for Beginners:** Kubedeploy is your trusted ally if you're new to Kubernetes. With just two values to tweak, image.repository and image.tag, you can deploy a new application in no time. It's an ideal starting point for those taking their first steps in Kubernetes.

- **Flexibility for Advanced Users:** For the seasoned Kubernetes users, Kubedeploy offers a playground of possibilities. Define custom values to fine-tune and extend your deployments precisely as you need. It adapts to your expertise, ensuring your applications are deployed with the precision you demand.

- **Compatibility Across Scenarios:** Kubedeploy doesn't play favorites; it aims to be compatible with a wide range of deployment scenarios. Whether you're deploying microservices, web applications, or databases, Kubedeploy's got your back.

## What Kubedeploy isn't?

- **Not a Replacement for Specialized Charts:** While Kubedeploy is a powerful tool, it's not meant to replace specialized application charts tailored to specific software. It complements them by offering a more generalized approach to deployment.

- **Not a Deployment Engine:** Kubedeploy is a facilitator, not a replacement for essential deployment engines like Helm. You'll still need these tools to orchestrate and manage the deployment process.

## License

Chart is licensed under Apache 2.0, read more in [LICENSE](LICENSE)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)

## Publishing new version checklist

- Bump chart version in kubedeploy/Chart.yaml
- Update kubedeploy/CHANGELOG.md
- Merge with main branch
- create a tag with new version
