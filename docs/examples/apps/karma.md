#Karma

Alertmanager UI is useful for browsing alerts and managing silences, but it's lacking as a dashboard tool - [Karma](https://github.com/prymitive/karma) aims to fill this gap.

In this example we will deploy [Karma](https://github.com/prymitive/karma) and use [oauth2-proxy](https://github.com/oauth2-proxy/oauth2-proxy) container to facilitate SSO authentication to Karma's web interface.

In this example we will use [GitLab](https://gitlab.com) as oauth provider.

## OIDC preparations

Before continuing with application configuration, we need to create Oauth application in GitLab. Please follow the [official documentation](https://docs.gitlab.com/ee/integration/oauth_provider.html) and store the clientID and Secret as environment variables.

Required environment variables:

- `OIDC_APPLICATION_ID` - obtained from GitLab
- `OIDC_SECRET` - obtained from GitLab
- `OIDC_COOKIE_SECRET` - generate using [oauth2-proxy docs example](https://oauth2-proxy.github.io/oauth2-proxy/docs/configuration/overview#generating-a-cookie-secret)
- `KARMA_DOMAIN` - domain name on which we will run Karma
- `GITLAB_GROUP` - members of this GitLab group will have access to Karma

export the env variables from shell or save them as secrets/variables in your CI/CD pipeline configuration.

## Deploying with Kubedeploy

We will use [Helmfile](../helmfile.md) to define our release and configuration.

Let's now create a deployment configuration

```yaml title="helmfile.yaml" linenums="1"
---
repositories:
  - name: sysbee
    url: https://charts.sysbee.io/stable/sysbee

releases:

  - name: karma
    namespace: monitoring
    chart: sysbee/kubedeploy
    version: 1.1.0
    installed: true
    values:
      - fullnameOverride: karma

      - image:
          repository: ghcr.io/prymitive/karma
          tag: "v0.115"

      # Expose Karma container Port
      - ports:
        - name: http
          containerPort: 8080
          protocol: TCP

      # Enable Karma healtchecks
      - healthcheck:
          disableAutomatic: true
          enabled: true
          probes:
            livenessProbe:
              httpGet:
                path: /health
                port: http
                initialDelaySeconds: 5
                periodSeconds: 5
            readinessProbe:
              httpGet:
                path: /health
                port: http
                initialDelaySeconds: 5
                periodSeconds: 5

      # Restrict the container privileges
      - securityContext:
          runAsUser: 2000
          allowPrivilegeEscalation: false

      # Define required env variables
      - env:
        - name: CONFIG_FILE # (1)
          value: "/etc/karma/karma.conf"
        - name: OAUTH2_PROXY_CLIENT_ID
          value: {{ requiredEnv "OIDC_APPLICATION_ID" | quote }}
        - name: OAUTH2_PROXY_CLIENT_SECRET
          value: {{ requiredEnv "OIDC_SECRET" | quote }}
        - name: OAUTH2_PROXY_COOKIE_SECRET
          value: {{ requiredEnv "OIDC_COOKIE_SECRET" | quote }}
        - name: OAUTH2_PROXY_EMAIL_DOMAINS
          value: "*"
        - name: OAUTH2_PROXY_UPSTREAMS
          value: "http://127.0.0.1:8080/"
        - name: OAUTH2_PROXY_REDIRECT_URL
          value: "https://{{ requiredEnv "KARMA_DOMAIN" }}/oauth2/callback"
        - name: OAUTH2_PROXY_COOKIE_DOMAIN
          value: {{ requiredEnv "KARMA_DOMAIN" | quote }}
        - name: OAUTH2_PROXY_COOKIE_EXPIRE
          value: "8h"
        - name: OAUTH2_PROXY_COOKIE_SECURE
          value: "true"
        - name: OAUTH2_PROXY_PROVIDER
          value: "gitlab"
        - name: OAUTH2_PROXY_OIDC_ISSUER_URL
          value: "https://gitlab.com"
        - name: OAUTH2_PROXY_REVERSE_PROXY
          value: "true"

      # Configure Oauth2-porxy container
      - additionalContainers:
          enabled: true
          containers:
            - name: oauth2-proxy
              repository: quay.io/oauth2-proxy/oauth2-proxy
              tag: v7.4.0
              args:
                - --http-address=0.0.0.0:8081
                - --real-client-ip-header=X-Forwarded-For
                - --footer=-
                - --gitlab-group={{ requiredEnv "GITLAB_GROUP" |quote }}
                - --custom-sign-in-logo=-
                - --pass-user-headers=true
              ports:
                # Expose Oauth2-proxy container port
                - containerPort: 8081
                  name: authenticated
                  protocol: TCP

      - service:
          ports:
            - port: 8081
              targetPort: authenticated
              protocol: TCP
              name: authenticated

            - port: 8080 # (2)
              targetPort: http
              protocol: TCP
              name: http

      - ingress:
          enabled: true
          # Use Oauth2-proxy port for routing external traffic
          svcPort: 8081
          hosts:
            - host: {{ requiredEnv "KARMA_DOMAIN" }}

      # Define configMap that will be used as karma config file
      - configMaps:
        - name: config
          mount: True
          mountPath: /etc/karma
          data:
            karma.conf: |
              authentication:
                header:
                  name: X-Forwarded-Email
                  value_re: ^(.+)$
              alertmanager:
                interval: 30s
                servers:
                  - name: cluster
                    uri: http://alertmanager-operated:9093
                    timeout: 10s
                    cluster: cluster
                    proxy: true
                    healthcheck:
                      filters:
                        watchdog:
                          - alertname=Watchdog
              alertAcknowledgement:
                enabled: true
                duration: 15m0s
                author: karma
                comment: ACK! This alert was acknowledged using karma on %NOW%
              annotations:
                default:
                  hidden: true
                visible:
                  - value
                  - summary
                hidden:
                  - help
                  - runbook
                keep: []
                strip: []
                order:
                  - value
                  - summary
                  - description
              labels:
                color:
                  static: []
                  unique:
                    - group
                    - path
                  custom:
                    "@cluster":
                      - value_re: ".*"
                        color: "#3683CB"
                    instance:
                      - value_re: ".*"
                        color: "#d4f081"
                    severity:
                      - value: critical
                        color: "#C0392B"
                      - value: scrit
                        color: "#AF7AC5"
                      - value: warning
                        color: "#F4D03F"
                      - value: unknown
                        color: "#D35400"
                      - value: info
                        color: "#85C1E9"
                      - value_re: ".*"
                        color: "#99A3A4"
                    service:
                      - value_re: ".*"
                        color: "#9B59B6"
                    value:
                      - value_re: ".*"
                        color: "#9B59B6"
                    check:
                      - value_re: ".*"
                        color: "#9B59B6"
                keep: []
                strip:
                valueOnly:
                  - alertname
                  - instance
              filters:
                default:
                  - "@state=active"
              karma:
                name: "Karma"
              grid:
                sorting:
                  order: label
                  reverse: false
                  label: severity
                  customValues:
                    labels:
                      severity:
                        critical: 1
                        warning: 2
                        unknown: 3
                        info: 4
              history:
                enabled: true
                timeout: 20s
                workers: 30
              ui:
                refresh: 30s
                hideFiltersWhenIdle: false
                colorTitlebar: false
                theme: "dark"
                animations: true
                minimalGroupWidth: 420
                alertsPerGroup: 7
                collapseGroups: collapsedOnMobile
                multiGridLabel: ""
                multiGridSortReverse: false
```

1. Karma config file is later added as `configMaps` mounted at this location.
2. Karma port is not strictly required here if you don't have any other services in the cluster that needs to contact Karma without authentication.


Deploy command

```bash
kubedeploy --file kubedeploy.yaml apply
```

Your protected Karma instance should now be available at `KARMA_DOMAIN`
