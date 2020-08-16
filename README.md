# Terraform Istio

This repo is an experimental project of installing Istio 1.6.7 in GKE clusters. After version 1.5 Istio has removed support of helm install, which was a convenient way of installing Istio on GKE clusters.

This project tries to install Istio 1.6.7 version though Terraform on GKE. Istio website support installing using `istioctl` command. 

```bash
istioctl manifest apply --set-profile=demo
```
The above command will help install `demo` profile of Istio. More [details][1].

But we need a customized Istio installation process. To acheive the same we did a profile dump using the below command:

```bash
istioctl profile dump > istio-profile.yaml
```

The above profile is fed into the `local_exec` provisioner and used to install Istio on GKE. The use of `null_resource` helped to install Istio 1.6.7 version. But it does come with its own challenges:

1. `null_resource` executes only the first time. Subsequent executions of `null_resource` have to be triggered, if there is an additional customization done to the istio profile dump.

    This was handled using `trigger` parameter within the `null_resource`. This parameter will make execute the `null_resource` block if there are any changes to the profile file.

2. Cluster config have to be initialized, inside `null_resource`

    Since `null_resource` itself is a provider, there is a Terraform limitation where we cannot use a different provider block. So the initialization to generate `.kube/config` was handled in `local_exec`.


## Challenges during after installation:

While installation of Istio was smooth using the above method. There were some challenges encountered when:

> label the default namespace istio-injection=enabled

1. Deploying a application:

    Tried deploying the sample book service app. which comes with Istio. The `kubectl` apply command showed no errors. But when tried to list the pods, it was not showing `No resources found`. Went to Google cloud and checked for workloads in the default namespace. Below was the error:

    `
    Error from server (InternalError): error when creating "STDIN": Internal error occurred: failed calling webhook "validation.istio.io": Post https://istiod.istio-system.svc:443/validate?timeout=30s
    `
    
    This issue can also to be a problem of webhook validation. For webhook works, firewall rule needs setting to port 15017,instead of 9443. More details can be found [here][2].

    This [link][3] has instructions for amending the firewall for private gke clusters.

2. Change was made to the `istio-profile` file. Although Terraform was executed successfully, there were some  error messages during the Terraform execution.

[1]: https://istio.io/latest/docs/setup/additional-setup/config-profiles/
[2]: https://github.com/istio/istio/issues/22319
[3]: https://istio.io/latest/docs/setup/platform-setup/gke/