## Go Go Go 
First things first, follow the steps in the [setup documentation](SETUP.md) to get your testing host ready.

### Setup Terraform input
- create ```aws.tfvars``` from [aws.tfvars.example](test/assets/aws.tfvars.example)
```
region = "us-west-2"
azs = ["us-west-2a","us-west-2b"]
nameserver = "8.8.8.8"
allowed_mgmt_cidr = ["0.0.0.0/0", "10.0.0.0/8"]
ec2_key_name = "myec2keyname"
ec2_key_file = "/path/to/myprivatekeyfile"
```
- adjust the region and availability zones (azs) to meet your needs
- adjust the allowed_mgmt_cidr list to include cidrs that will be allowed access to the BIG-IP management point. 
Note: the list must include "10.0.0.0/8" to allow connectivity within the VPC. 
- adjust ec2_key_name to the name of a key pair in the AWS region specified above
- set the ec2_key_file to a local path for the private key associated with the key named in ec2_key_name 


- create ```azure.tfvars``` from [azure.tfvars.example](test/assets/aws.tfvars.example)
```
region            = "westus2"
azs               = ["1"]
publickeyfile     = "/path/to/mypublickeyfile"
privatekeyfile    = "/path/to/myprivatekeyfile"
allowed_mgmt_cidr = "127.0.0.1/32"
allowed_cidrs     = ["127.0.0.1/32"]
nameserver        = "168.63.129.16"
```
- adjust the region and availability zones (azs) to meet your needs
- adjust the allowed_mgmt_cidr list to include cidrs that will be allowed access to the BIG-IP management point. 
Note: the list must include "10.0.0.0/8" to allow connectivity within the VPC. 
- adjust publickeyfile to the local path for a public
- set the ec2_key_file to a local path for the private key associated with the key named in ec2_key_name 


### Build, Test, and Destroy
You should be good to go now. Let's test on AWS.
- build on AWS - this should take about fifteen minutes  
```bash
bundle exec kitchen converge aws
```
- test on AWS - this should take less than two minutes
```bash
bundle exec kitchen verify aws
```
You should see results similar to this
```shell
Profile: BIG-IP Automation Toolchain readiness (bigip-ready)
Version: 0.1.0
Target:  local://

  ✔  bigip-connectivity: BIG-IP is reachable
     ✔  Host 54.71.63.144 port 443 proto tcp is expected to be reachable
  ✔  bigip-declarative-onboarding: BIG-IP has Declarative Onboarding
     ✔  HTTP GET on https://54.71.63.144:443/mgmt/shared/declarative-onboarding/info status is expected to cmp == 200
     ✔  HTTP GET on https://54.71.63.144:443/mgmt/shared/declarative-onboarding/info headers.Content-Type is expected to match "application/json"
  ✔  bigip-declarative-onboarding-version: BIG-IP has specified version of Declarative Onboarding
     ✔  JSON content [0, "version"] is expected to eq "1.21.0"
  ✔  bigip-application-services: BIG-IP has Application Services
     ✔  HTTP GET on https://54.71.63.144:443/mgmt/shared/appsvcs/info status is expected to cmp == 200
     ✔  HTTP GET on https://54.71.63.144:443/mgmt/shared/appsvcs/info headers.Content-Type is expected to match "application/json"
  ✔  bigip-application-services-version: BIG-IP has specified version of Application Services
     ✔  JSON content version is expected to eq "3.28.0"
  ✔  bigip-telemetry-streaming: BIG-IP has Telemetry Streaming
     ✔  HTTP GET on https://54.71.63.144:443/mgmt/shared/telemetry/info status is expected to cmp == 200
     ✔  HTTP GET on https://54.71.63.144:443/mgmt/shared/telemetry/info headers.Content-Type is expected to match "application/json"
  ✔  bigip-telemetry-streaming-version: BIG-IP has specified version of Telemetry Streaming
     ✔  JSON content version is expected to eq "1.20.0"
  ✔  bigip-licensed: BIG-IP has an active license
     ✔  HTTP GET on https://54.71.63.144:443/mgmt/tm/sys/license body is expected to match /registrationKey/


Profile: bigip Kitchen-Terraform (bigip)
Version: 0.1.0
Target:  local://

  ✔  bigip-postbuildconfig-do-self: expected selfIps
     ✔  JSON content address is expected to cmp == "10.20.0.9/24"
     ✔  JSON content vlan is expected to cmp == "/Common/external"
     ✔  JSON content allowService is expected to cmp == "tcp:443"
     ✔  JSON content address is expected to cmp == "10.30.0.10/24"
     ✔  JSON content vlan is expected to cmp == "/Common/internal"
     ✔  JSON content allowService is expected to cmp == "default"
  ✔  bigip-postbuildconfig-do-dns: expected dns
     ✔  JSON content nameServers is expected to cmp == "8.8.8.8"
  ✔  bigip-postbuildconfig-do-vlan: expected vlans
     ✔  JSON content tag is expected to cmp == "10"
     ✔  JSON content mtu is expected to cmp == "1500"
     ✔  JSON content tag is expected to cmp == "20"
     ✔  JSON content mtu is expected to cmp == "1500"
  ✔  bigip-postbuildconfig-do-provision: expected provisioning
     ✔  JSON content level is expected to cmp == "nominal"
     ✔  JSON content level is expected to cmp == "nominal"
```


- destroy the AWS environment - this should take less than two minutes
```bash
bundle exec kitchen destroy aws
```

And, now we'll test on Azure
- build on Azure - should take about fifteen minutes
```bash
bundle exec kitchen converge azure
```
- test on Azure - this should take less than two minutes
```bash
bundle exec kitchen verify azure
```
- destroy the Azure environment - this should take less than two minutes
```bash
bundle exec kitchen destroy azure
```