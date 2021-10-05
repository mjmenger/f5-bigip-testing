## Requirements
- a linux host for running Terraform and associated tools.  
This may work on OSX. This will likely not work on Windows workstation.

## Setup
### Install Terraform
You can follow [HashiCorp's instructions](https://learn.hashicorp.com/tutorials/terraform/install-cli) to install Terraform, if you choose. I find being able to arbitrarily switch between versions is of use to me. If you'd like that as well, you can follow these steps to install ```tfenv```. 
```bash
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
sudo ln -s ~/.tfenv/bin/* /usr/local/bin
sudo apt install unzip -y
tfenv install 0.15.5
tfenv use 0.15.5
```
if you'd like to understand ```tfenv``` better then run
```bash
tfenv help
```
### Prepare to install Ruby, Bundler, and Kitchen
Create a file named ```Gemfile``` in your project directory (unless it's already there in the repository you've cloned), with the following content.
```ruby
ruby '2.7.4'

source "https://rubygems.org/" do
    gem "kitchen-terraform", "~> 5.7"
end
```

### Install Ruby

```bash
# install Ruby
sudo apt-get install software-properties-common
sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get install rvm
sudo usermod -a -G rvm $USER
```
You will likely need to logout and login again in order for the ```usermod``` to take effect. Then you can
```bash
rvm install ruby
```
### Install bundler
```bash
gem install bundler
```

### Install kitchen

Using the contents of the ```Gemfile``` you created earlier, Bundler will make certain that the requirements specified are fulfilled. This includes installing Test Kitchen.
```bash
bundle install
```

### Setup AWS credentials
The AWS Terraform code in this repository assumes that the necessary credentials are configured as [environment variables](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#environment-variables) or in a [shared credentials file](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#shared-credentials-file). Please choose the approach that works for you and follow the documentation at either link.

### Setup Azure credentials
The Azure Terraform code in this repository assumes that you've authenticated with the proper account [using the Azure CLI](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli). There are alternative approaches, which you can also read about at the same link. At this time, the CLI approach is the only one with which we've tested.

