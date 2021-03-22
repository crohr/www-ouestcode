# One-liner to install a precompiled AWS CLI for your distribution

For anyone using Amazon Web Services, installing the AWS CLI is often the first thing you do on your own machine, or on EC2 instances or Docker images when you need to interact with the AWS API from within your infrastructure (especially if you're using CloudFormation templates with inline user-data to setup the EC2 instances). Here is how you can quickly get it installed without the need to `apt-get` or `yum` install stuff.

We use the [BUILDcURL](http://buildcurl.com) service that [I developed](/journal/10-buildcurl-com) to get a precompiled and self-contained version of `awscli`, including the `python` runtime:

``` bash
mkdir /opt/awscli
curl buildcurl.com -d recipe=awscli -d version=1.10.43 \
  -d prefix=/opt/awscli -d target=ubuntu:14.04 -L -o - | tar -xzf - -C /opt/awscli
/opt/awscli/bin/aws help
```

Note that you can specify the exact version that you want, and change the target distribution as needed.
