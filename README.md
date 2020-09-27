# lambda-ci-example
Minimal aws lambda function used for setup of CI process
This is a typescript example project which shows set of steps (needed for CI process) in order to create/update AWS Lambda function.

## Instructions for setup in CI environment

### Setup of IAM roles and permissions:
Before going into details on how to create actual AWS Lambda function, we need to do necessary IAM setup. That means following:

#### Create Lambda execution IAM role

Lambda function's execution role grants it permission to access AWS services and resources. Create IAM role **ci-simple-exec-role** which has predefined policy called **AWSLambdaBasicExecutionRole** attached. This policy provides write permissions to CloudWatch logs. This is fine for this minimal setup but we can obviously add more sophisticated set of policies that will be needed for the actual AWS Lambda function (depending on its interaction with other AWS services)

#### Attach appropriate IAM role to CI node

CI node, on which this setup will be running, needs to have specific permissions for creating/updating/invoking lambda function. Therefore, following steps need to be done:

1. Create IAM policy called **ci-lambda-access** which looks like this:
```
   {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "lambda:CreateFunction",
                "lambda:UpdateFunctionCode",
                "lambda:ListFunctions",
                "lambda:InvokeFunction",
                "lambda:GetFunction",
                "lambda:UpdateFunctionConfiguration",
                "lambda:GetFunctionConfiguration",
                "lambda:PublishVersion",
                "iam:PassRole"
            ],
            "Resource": [
                "*",
                "arn:aws:iam::************:role/ci-simple-exec-role"
            ]
        }
    ]
}
```

2. Create IAM role called **ci-lambda** with **ci-lambda-access** policy attached.
3. Attach IAM role **ci-lambda** to the EC2 instance which is your CI node.

### Initial project setup:

Login to your CI node machine, clone this git repo and do following:
```
$ npm install -g typescript
$ npm install
$ npm install -g ts-node
$ tsc
```

With this, we will get code transpiled and located in: **./dist** folder:
```
$ tree
.
|-- index.js
`-- lib
    `-- userData.js
```

### Create deployment package and create/update lambda function

Now that we have code transpiled, we can create a deployment package (zip file which contains code and its dependencies) in following way:
```
$ cd ./dist
./dist $ zip -r lambda-ci-example.zip .
```

If the function doesn't exist already on the AWS Lambda, we can create it in following way:
```
$ aws lambda --region <REGION> create-function --function-name lambda-ci-example --runtime nodejs12.x --role arn:aws:iam::************:role/ci-simple-exec-role --handler index.handler --zip-file fileb://dist/lambda-ci-example.zip
```
The handler is the method in your Lambda function that processes events. Important thing to note here is that name of the handler is in format: <index.js_file_name_without_js_suffix>.<method_name_which_processes_event>. Therefore, in our case, that is: **index.handler**
Also, index.js file (handler) needs to exist in the root of the project. 

If the function exists already, we can updated it in following way:
```
$ aws lambda --region <REGION> update-function-code --function-name lambda-ci-example --zip-file fileb://dist/lambda-ci-example.zip
```

Finally, we can test our lambda function in following way:
```
$ aws lambda --region <REGION> invoke --function-name lambda-ci-example --payload '{ "firstName": "Bakir", "lastName": "Jusufbegovic", "age": 34 }' response.json
{
    "StatusCode": 200,
    "ExecutedVersion": "$LATEST"
}

$ cat response.json
"\"Hello from Lambda! User data: First name: Bakir, Last name: Jusufbegovic, Age: 34\""
```
