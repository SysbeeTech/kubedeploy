# Syncthing

[Syncthing](https://syncthing.net/) is a continuous file synchronization program. It synchronizes files between two or more computers in real time, safely protected from prying eyes. Your data is your data alone and you deserve to choose where it is stored, whether it is shared with some third party, and how it’s transmitted over the internet.

## Deploying with Kubedeploy

We will use [Helmfile](../helmfile.md) to define our release and configuration.

```yaml title="helmfile.yaml" linenums="1"
---
repositories:
  - name: sysbee
    url: https://charts.sysbee.io/stable/sysbee

releases:

  - name: syncthing
    namespace: apps
    chart: sysbee/kubedeploy
    disableValidationOnInstall: true
    version: 1.1.0
    installed: true

    values:
      # one replica should be enough
      - replicaCount: 1
      # We wish to preserve Synthing data over restarts
      - deploymentMode: Statefulset
      - image:
          repository: syncthing/syncthing
          tag: latest
          pullPolicy: Always
      - ports:
          # Admin UI pot
          - name: http
            containerPort: 8384
            protocol: TCP
          # Sync ports
          - name: syncthingtcp
            containerPort: 22000
            protocol: TCP
          - name: syncthingudp
            containerPort: 22000
            protocol: UDP
      # Enable healtchecks for automatic container restart if it stops responding
      - healthcheck:
          enabled: true
          probes:
            livenessProbe:
              tcpSocket:
                port: http
            readinessProbe:
              tcpSocket:
                port: http
      # Define service as NodePort, each Syncthing pod will need direct communication
      # with other peers. We explicitly skip opening Admin UI port via service
      - service:
          enabled: true
          type: NodePort
          ports:
            - port: 22000
              targetPort: syncthingtcp
              protocol: TCP
              name: syncthingtcp
            - port: 22000
              targetPort: syncthingudp
              protocol: UDP
              name: syncthingudp
      # Configure persistent volume for Syncthing data
      - persistency:
          # enable persistent volume
          enabled: true
          capacity:
            storage: 10Gi
          mountPath: "/var/syncthing"
```

Deploy command

```bash
helmfile --file helmfile.yaml apply
```

## Connect to Admin UI

Start the port forwarding to Admin UI port
```bash
kubectl -n apps port-forward syncthing-kubdeploy-0 8384:8384
```

Open your browser at

[http://localhost:8384](http://localhost:8384)
