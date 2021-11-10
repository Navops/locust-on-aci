# Doc Changes from Upstream

## Environment Creation

This branch removes the need for the keyvault and uses local state storage.  Simple instructions:

    cd src/testing/infra
    terraform init
    terraform apply --var 'locustWorkerNodes=5' --var 'prefix=navops'
    # Enter 'yes' when prompted if everything looks good
    .
    .
    .
    Apply complete! Resources: 13 added, 0 changed, 0 destroyed.
    
    Outputs:

    locust_webui = "http://locust:QYhCkMMr65_zW%9_@safeoryx-locust-master.northeurope.azurecontainer.io:8089/"

Newer versions may output `<sensitive>` in the place of a value for locust\_webui.  Simply run the following command
to see the output values:

```
terraform output --json
{
  "locust_webui": {
    "sensitive": true,
    "type": "string",
    "value": http://locust:QYhCkMMr65_zW%9_@safeoryx-locust-master.northeurope.azurecontainer.io:8089/"
  }
}
```

The above commands will create resource group 'locust-navops-rg' and install a master and 5 workers in ACI.  The
Locust environment can be accessed at the URL returned from terraform.

## Locust Tests

The locust tests are defined at `src/testing/locustfile.py` and can be changed as needed.

## Environment Destruction

The environment can be destroyed with a single command:

    terraform destroy --var 'locustWorkerNodes=5' --var 'prefix=navops'


# Locust on Azure Container Instances (ACI)

Load testing with [Locust](https://locust.io) using Azure Container Instances (ACI). This repository contains sample implementations in Terraform how to deploy and run load tests with Locust.

## Locust deployment via Terraform

This repository contains two different Terraform definitions to deploy Locust:

* [headless](./src/headless/infra) - To conduct fully automated load tests without a user interface triggered via a GitHub workflow.
* [webui](./src/testing/infra) - To deploy a load testing infrastructure with multiple worker nodes and a webui to conduct and monitor tests.

## Locust deployment pipelines

### Headless

The "headless" workflow asks upfront for all required information to conduct the load test:

* Number of Locust worker nodes
* Duration in minutes
* The rate per second in which users are spawned
* Number of concurrent Locust users
* Locust target URL

The workflow will then, based on your selection, deploy the required infrastructure in Azure, conduct the load test as defined, store the results in it's Azure Storage Account and scale down the infrastructure back to 0 - except its Storage Account.

### WebUI

The "webui" workflow spins up a full Locust deployment with the selected number of worker nodes. You can run the same pipeline again to scale the infrastructure down.

![locust webui architecture overview](img/locust-webui-architecture.png)
