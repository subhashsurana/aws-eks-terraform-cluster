## Steps to Install & Configure AWS CLI on your local machine



### CLI Installation 
- For Linux


Please check the release of the AWS CLI version 2 that you would  like to install. For a list of versions, see the [AWS CLI version 2 changelog](https://github.com/aws/aws-cli/blob/v2/CHANGELOG.rst) on GitHub.

>Linux x86 (64-bit)
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
>Linux ARM
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64-2.0.30.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

- For Setting up on other OS please check the below link

[AWS CLI v2 Installation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-version.html)

### Configuration 

Quick configuration using ``aws configure``

For general use, the aws configure command is the fastest way to set up your AWS CLI installation. When you enter this command, the AWS CLI prompts you for four pieces of information:

```
aws configure

AWS Access Key ID [None]: XXXXXXXX
AWS Secret Access Key [None]: XXXXXX
Default region name [None]: us-west-2
Default output format [None]: json
```
Profiles

 By default, the AWS CLI uses the default profile. You can create and use additional named profiles with varying redentials and settings by specifying the --profile option and assigning a name. 

 ```
 aws configure --profile produser
 ```
You can then specify a --profile profilename and use the credentials and settings stored under that name.

```
aws s3 ls --profile produser
```
