# Automating the process of granting/revoking SSH access to a group of servers instances to a new developer

We will use Directory Service provided by AWS to Grant / Revoke Access to the AWS Resources.

To Create the Necessary Ssetup we will use CloudFormation.
Template URL:
This CloudFormation Template will Join Windows instance to AWS-Active Directory or Microsoft AD (no powershell). 
And Creates a SSM document, IAM Role, SSM doc and EC2 Instance and finally Attaches EC2 instance to AD.
