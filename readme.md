# General notes
- Building this in AWS to start b/c most customers are there and it will avoid Entra/Azure AD

# Other code samples
- [Base Image inspiration](https://github.com/hashicorp-education/learn-packer-windows-ami)
  
# Sysprep fun 
- [EC2 Launch specifics](https://discuss.hashicorp.com/t/packer-with-aws-ec2launch/15244)
- [Amazon sysprep docs](https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/Creating_EBSbacked_WinAMI.html#sysprep-gui-procedure-ec2launchv2)
- [Hashi AMI sysprep docs](https://developer.hashicorp.com/packer/integrations/hashicorp/amazon/latest/components/builder/ebs#windows-2016-sysprep-commands-for-amazon-windows-amis-only)

# Useful docs
- [Packer docs for Amazon EBS builder](https://developer.hashicorp.com/packer/integrations/hashicorp/amazon/latest/components/builder/ebs)

# ToDo's
- Modify [this code](https://github.com/andybaran/vault-in-azure/blob/main/provision-domain.tf) to work with a deployed image on AWS