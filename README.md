# Automating the process of granting/revoking SSH access to a group of servers instances to a new developer

 There are number of solutions to Automate this process
 I'm using 2 simple methods
 1. Managing the set of authorized_keys 
 2. Running our own Directory services 

* We know which developers needs access to Instances , so we will create those users and transfer puliv key to the server
For Example we will Create a user Tom and generate public key

` ssh -keygen -b 1024 -f Tom -t dsa
 chmod 600 user.pub 
`
 * Now we will Transfer the Public Key to the server 
 * Below is the Script for Ubuntu servers,

What this Script does is

   1. Create individual User IDs. we know the list of users and their public keys, so list them in this script.
   2. Give some of them sudo access, but give everyone read rights to all the log files by adding them to groups such as adm.
   3. Add their SSH public key to their own authorized_keys so they can login as themselves.

* When Launching the instance Add the Below Script in Advanced User Detail Section to automate the process
`
 #!/bin/bash
 declare -A USERKEY
 USERKEY[tom]="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyFgGobmiU2H Tom's Public Key"
 USERKEY[Louis]="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyFgGobmiU2H Louis's Public Key"
 USERKEY[Jenelly]="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyFgGobmiU2H Jenally's Public Key"
 declare -A SUDOUSER
 SUDOUSER[tom]=y
 for user in "${!USERKEY[@]}" ; do
  adduser --disabled-password --gecos "" $user
   usermod -a -G adm $user

    if [ "${SUDOUSER[$user]}" == 'y' ] ; then
     usermod -a -G sudo $user
      echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-cloud-init-users
    fi

   mkdir /home/$user/.ssh 	
   echo "${USERKEY[$user]}" >> /home/$user/.ssh/authorized_keys
   chown -R $user:$user /home/$user/.ssh
   chmod -R go-rx /home/$user/.ssh
  done `


We can Automate this by creating an AMI based on the instance. All future launches can now use this custom AMI.


## Using Amazon directory servicce to Grant / Revoke Access to the AWS Resources.

* To Create the Necessary Setup we will use CloudFormation.
Template URL:https://github.com/hem4nth/AccesstoEc2/blob/master/Directory-service-Setup.s3

* This CloudFormation Template will Join Windows instance to AWS-Active Directory or Microsoft AD. 
And Creates a SSM document, IAM Role, and EC2 Instance and finally Attaches EC2 instance to AD.

* After Seting up the Directory we will usse our directory account to manage our resources in the AWS Cloud

* which will have three organizational units (OUs) under the domain root:

1. AWS Delegated Groups : Stores all of the groups that we can use to delegate AWS specific permissions to our users. 
2. AWS Reserved  : Stores all AWS Management specific accounts.
3. <ourdomainname> : The name of this OU is based off of the NetBIOS . This OU is owned by AWS and contains all of our AWS-related directory objects, which we are granted Full Control over. Two child OUs exist under this OU by default; Computers and Users. For example:

    Corp

        Computers

        Users


* Finally in the  AWS Directory Service console
 * We will Manage access to AWS Resources Such as EC2,S3 etc.. by assigning the users and groups to the role. 

 Here we will Create role with  Directory Service and AmazonEC2FullAccess using CloudFormation
 And we can attach this role to our users/Group in the directory to grant access to EC2 instances.
 https://github.com/hem4nth/AccesstoEc2/blob/master/DS-Role
 
 In this way when a new developer needs access to group of servers Instances in AWS we can attach this role .
 
 
 
