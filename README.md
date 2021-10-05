## Let's get started
We're going to focus on test automation in this article to help you integrate your F5 assets with your CI/CD practices. The demonstration resources described below show how tools like HashiCorp [Terraform](https://www.terraform.io/), [Test Kitchen](https://kitchen.ci/), Chef [Inspec](https://community.chef.io/products/chef-inspec/) and F5's [Automation Toolchain](https://www.f5.com/products/automation-and-orchestration) can be used to validate that your BIG-IPs and their configuration are [fit for purpose](https://en.wikibooks.org/wiki/ITIL_v3_(Information_Technology_Infrastructure_Library)/Introduction#:~:text=fit%20to%20purpose). By following along with the [README](https://github.com/mjmenger/f5-bigip-testing/blob/main/README.md) in the [demonstration repository](https://github.com/mjmenger/f5-bigip-testing), you should be able to run this demonstration and explore the implications for your own environments.

## Caveats
- These repositories use simplifying demonstration shortcuts for password, key, and network security. Production-ready enterprise designs and workflows should be used in place of these shortcuts.  
*DO NOT ASSUME THAT THE CODE AND CONFIGURATION IN THESE REPOSITORIES IS PRODUCTION-READY*  
- A variety of tools are used in this demonstration. In most cases they are not exclusively required and can be replaced with other similar tools. 

## Enough Expository Already
If you just want to run the code and see the output, then feel free to [charge ahead](#go-go-go)

## Use Case
For simplicity's sake, we're going to validate a simple use-case. We want to validate that our [Declarative On-boarding](https://clouddocs.f5.com/products/extensions/f5-declarative-onboarding/latest/) declaration works as expected on both AWS and Azure. You can find the declaration in [do.json](do.json).

Here are a couple of stanzas that we want to validate.
We will validate that when the declaration returns with a 200 response code that a Self IP with the following configuration is on the BIG-IP.
```json
"internal-self": {
    "class": "SelfIp",
    "address": "10.30.0.10/24",
    "vlan": "internal",
    "allowService": "default",
    "trafficGroup": "traffic-group-local-only"
},
```
We will also validate that the DNS configuration on the BIG-IP is consistent with the following stanza. Note that the name server field is parameterized.
```json
"myDns": {
    "class": "DNS",
    "nameServers": [
        "${nameserver}"
    ],
    "search": [
        "f5.com"
    ]
},
```
## Exploring ```kitchen.yml```
You can explore the possibilities of the configuration in the ```kitchen.yml``` file in the [Kitchen documentation](https://kitchen.ci/docs/getting-started/kitchen-yml/). We'll look at a few of the stanzas of interest to our use case found in the [kitchen.yml](kitchen.yml) within our repository.

Since we're using Terraform to build out the clean-room testing environment, we specify the appropriate driver as shown below. You can find comprehensive details about the Kitchen-Terraform driver in their [documentation](https://newcontext-oss.github.io/kitchen-terraform/). The parallelism and command_timeout parameters control, as is expected from the names, the number of simultaneous threads of execution Terraform can use and the maximum time for the Terraform apply to run.
```yaml
driver:
  name: terraform
  parallelism: 4
  command_timeout: 1200
```

The verifier stanza is used to specify what controls and tests we want to run in our testing environment. The verifier stanza can show up globally, as we have it, or discretely in each platform. Since we want to validate that we get the same results independent of platform, we're specifying our verification configuration globally.
```yaml
verifier:
  name: terraform
  systems:
    - name: local
      backend: local
      profile_locations:
        - https://github.com/f5devcentral/big-ip-atc-ready.git
        - test/integration/bigip
      controls:
        - bigip-postbuildconfig-do-self
        - bigip-postbuildconfig-do-dns
        - bigip-postbuildconfig-do-vlan
        - bigip-postbuildconfig-do-provision
        - bigip-connectivity        
        - bigip-declarative-onboarding
        - bigip-declarative-onboarding-version
        - bigip-application-services
        - bigip-application-services-version
        - bigip-telemetry-streaming
        - bigip-telemetry-streaming-version
        - bigip-licensed
```
The ```backend parameter``` is set to **local**, indicating that the tests are going to be run from the testing host.  
The ```profile_locations``` parameter contains a list of locations from which to retrieve the testing logic. In this case, you can see that we're retrieving tests from a GitHub respository and from a directory within this repository.  
Finally, the ```controls``` parameter is a list of the controls and their associated tests to run. In our configuration we are not running all of the controls retrieved from the ```profile_locations```. For example, there is a ```bigip-fast``` control that validates the installation of the [FAST extension](https://clouddocs.f5.com/products/extensions/f5-appsvcs-templates/latest/) that we're not using as part of this demonstration.


## Go Go Go 
First things first, follow the steps in the [setup documentation](SETUP.md) to get your testing host ready.

### Setup Terraform input
- create ```aws.tfvars``` from [aws.tfvars.example](test/assets/aws.tfvars.example)
- create ```azure.tfvars``` from [azure.tfvars.example](test/assets/aws.tfvars.example)

### First time through
You should be good to go now. Let's test on AWS.
- build on AWS (should take about ten minutes)
```bash
bundle exec kitchen converge aws
```
- test on AWS (this should take a few minutes)
```bash
bundle exec kitchen verify aws
```
- destroy the AWS environment
```bash
bundle exec kitchen destroy aws
```