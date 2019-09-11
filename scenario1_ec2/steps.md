

## Create Rule

Go to https://eu-west-2.console.aws.amazon.com/config/home?region=eu-west-2#/rules/view
Click "Add rule"

Search for "desired-instance-type" and click on the Rule to create it.

### Rule Name
Change the name (substitute <USER> with your username): 
Rule Name: dpg-config-<USER>-ec2-wrong-type

### Triggers
Under Trigger:

Choose "Tags" for "Schope of changes"

Enter the tag (substitute <USER> with your username): 

DPGEC2User = <USER>


### Parameters
Enter Rule Parameters: instanceType: t2.nano

Press the Save button to create the rule.

## EC2

### Create Instance
Head to Ec2 

https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#Instances:sort=instanceId

Click "Launch Instance"

### Choose an Amazon Machine Image (AMI)

Choose an 
"Amazon Linux 2 AMI (HVM), SSD Volume Type - ami-0ce71448843cb18a1 (64-bit x86) / ami-0307a0fc74afcef28 (64-bit Arm)" Click "Select"

### Choose an Instance Type

Select "t2.small"

### Add Tags


Click "Add Tags"
Add "DPGEC2User" = <USER>
Add "Name" = dpguser<USER>

### Configure Security Group

Click Configure Security Group

Click Select an existing Security Group

Choose "sg-eafac89d"

### Review and Launch

Click Review

Click Launch

Leave the "key pair" settings as they are ("default")

Check "I acknowledge that I have access to the selected private key file (default.pem), and that without this file, I won't be able to log into my instance"

Click "Launch Instances"


## Test Config Rule

Go back to your AWS Config tab and find the rule you just created (dpg-config-<USER>-ec2-wrong-type). 

You may need to click "Reevaluate" for the results to be displayed
