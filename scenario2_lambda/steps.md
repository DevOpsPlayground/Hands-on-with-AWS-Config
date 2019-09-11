# Lambda

## Create Function

We'll start by creating the custom rule Lambda function. Head to https://eu-west-1.console.aws.amazon.com/lambda/home?region=eu-west-1# in your browser.

Click "Create function"

Under function name, enter the following, replacing <USER> with your user number: dpg-user<USER>-lambda-evaluate 
Runtime - select: Python3.6

Click "Choose or create an execution role" under "Permissions" to expand the field.

Click "Use an existing role"

Select "lambda-dpgconfig".

Click "Create function"

## Deploy Code

Copy code from lambda_function.py

Click Save at the top of the screen

Copy the ARN from the top of the screen. You will need this to create your custom Config Rule.

# Config

Head to the following URL to create a custom rule: https://eu-west-1.console.aws.amazon.com/config/home?region=eu-west-1#/rules/configure-rule/add/

In the Name section, enter the following, replacing <USER> with your user number: dpg-user<USER>-lambda-logging

Paste ARN from the Lambda function you created  into "AWS Lambda function ARN"

## Trigger

Trigger type: Check the box marked "Configuration changes"

Scope of changes: Select "Resources"

Resources: Type "Function" and then click on the option "Lambda Function"

Scroll down to the bottom of the page and click "Save"


## Test Rule

We've already deployed a Lambda function (dpg-no-logging) without the appropriate logging permissions. All the Lambdas we have deployed as part of this workshop have the correct logging permissions so will be marked as Compliant.


Find and click on your Rule in the list of rules.

Click "Evaluate". Wait a minute and refresh the page. You should now be able to see the Compliant and Noncompliant resources by using the "Compliance Status" filter.
