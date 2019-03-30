# Automating the process of granting/revoking SSH access to a group of servers instances to a new developer

We will use Directory Service provided by AWS to Grant / Revoke Access to the AWS Resources.

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
 
 
 
