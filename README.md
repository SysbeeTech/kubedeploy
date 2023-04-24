# kubedeploy

Generic Helm template for deploying containers in Kubernetes cluster

## Chart options
You can find chart options and documentation in chart [README.md](kubedeploy/README.md)
Or here: https://charts.sysbee.io/kubedeploy/

## publishing new version checklist

- Bump chart version in kubedeploy/Chart.yaml
- Update kubedeploy/CHANGELOG.md
- Merge with main branch
- glab release create 0.8.1 -F kubedeploy/CHANGELOG.md
