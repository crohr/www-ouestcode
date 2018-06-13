We assume that you have assigned IAM Roles with the EC2 instances you launch.

Then:

``` bash
apt-get install jq -y
instance_profile=$(curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/)

curl -s http://169.254.169.254/latest/meta-data/iam/security-credentials/${instance_profile} | \
  jq -r '"AWS_ACCESS_KEY_ID=\(.AccessKeyId)\nAWS_SECRET_ACCESS_KEY=\(.SecretAccessKey)\nAWS_SESSION_TOKEN=\(.Token)"'
```
