# Joplin server

[Joplin](https://joplinapp.org/) is an open source note-taking app. Capture your thoughts and securely access them from any device.

Joplin support synchronization to various targets including open source Joplin server.

Server application requires exteranal PostgreSQL datababase for storing notes. In this example we will use Kubedeploy to deploy Joplin server, and Bitnami PostgreSQL chart for deploying the database.

## Environment variables

In this example we will use couple of environment variables in `helmfile.yaml`

- `JOPLIN_PG_PASS` - PostgreSQL password for joplin user
- `JOPLIN_PG_POSTGRESPASS` - PostgreSQL password for postgres user
- `JOPLIN_DOMAIN` - domain on which we will expose Joplin server

## Deploying with Kubedeploy

We will use [Helmfile](../helmfile.md) to define our release and configuration.

!!! note

    Make sure required environment variables are configured either by exporting them on command line or by configuring them in CI/CD pipeline settings

```yaml title="helmfile.yaml" linenums="1"

---
repositories:
  - name: sysbee
    url: https://charts.sysbee.io/stable/sysbee

  - name: bitnami-pg
    url: registry-1.docker.io/bitnamicharts
    oci: true

releases:
  - name: joplin-pg
    namespace: apps
    chart: bitnami-pg/postgresql
    installed: true
    version: 12.6.0
    values:
      - fullnameOverride: joplin-pg
      - auth:
          username: joplin
          database: joplin
          password: {{ requiredEnv "JOPLIN_PG_PASS" }}
          postgresPassword: {{ requiredEnv "JOPLIN_PG_POSTGRESPASS" }}
      - metrics:
          enabled: true
          serviceMonitor:
            enabled: true
            labels:
              release: prometheus

  - name: joplin-server
    namespace: apps
    chart: sysbee/kubedeploy
    needs:
      - apps/joplin-pg
    installed: true
    version: 1.1.0
    values:
      - fullnameOverride: joplin-server

      - image:
          repository: florider89/joplin-server
          tag: latest
          pullPolicy: Always

      - ports:
          - name: http
            containerPort: 22300
            protocol: TCP

      - healthcheck:
          disableAutomatic: true
          enabled: true
          probes:
            livenessProbe:
              httpGet:
                path: /api/ping
                port: 22300
                httpHeaders:
                  - name: Host
                    value: {{ requiredEnv "JOPLIN_DOMAIN" }}
              initialDelaySeconds: 3
              periodSeconds: 5
            readinessProbe:
              httpGet:
                path: /api/ping
                port: 22300
                httpHeaders:
                  - name: Host
                    value: {{ requiredEnv "JOPLIN_DOMAIN" }}
              initialDelaySeconds: 3
              periodSeconds: 5

      - env:
          - name: APP_PORT
            value: "22300"
          - name: APP_BASE_URL
            value: https://{{ requiredEnv "JOPLIN_DOMAIN" }}
          - name: DB_CLIENT
            value: pg
          - name: POSTGRES_PASSWORD
            value: {{ requiredEnv "JOPLIN_PG_PASS" }}
          - name: POSTGRES_DATABASE
            value: joplin
          - name: POSTGRES_USER
            value: joplin
          - name: POSTGRES_PORT
            value: "5432"
          - name: POSTGRES_HOST
            value: joplin-pg

      - ingress:
          enabled: true
          hosts:
            - host: {{ requiredEnv "JOPLIN_DOMAIN" }}
```

Deploy command

```bash
helmfile --file helmfile.yaml apply --skip-needs=false
```
