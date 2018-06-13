# Difference between round-robin DNS and Route53 multivalue answers

Until now, if you want to load-balance traffic between multiple servers, you can either:
* use DNS round-robin to distribute traffic to a pool of IPs (but if one server is down you might get some traffic sent to it if clients are not clever enough to try all IPs returned by the DNS server)
* use a load-balancer appliance (ELB, HAProxy, etc.) to handle the server pool and removal of unhealthy servers automatically, based on health checks (but it can be expensive to run, and/or another thing to monitor).

But Amazon just [announced](https://aws.amazon.com/about-aws/whats-new/2017/06/amazon-route-53-announces-support-for-multivalue-answers-in-response-to-dns-queries/) a few days ago they were adding a new type of routing policy for DNS records: multivalue answers, with support for health checks.

Basically this means that you can create multiple records for the same domain name, and associate each record with a different server IP and a health check that returns whether this server is up or not. Based on that, Route53 will reply to DNS queries for the domain name with just the IPs that are healthy, meaning that contrary to classic round-robin DNS, client programs will not see unhealthy IPs in the DNS response.

## Demo

First, let's create two EC2 instances with a simple nginx server running on it, which returns the hostname of the server it is currently running on. For this test you can use a t2.nano instance, and setup the user-data to automatically install nginx and the default index.html page with [this script](https://raw.githubusercontent.com/crohr/route53-multivalue-answers/master/install.sh):

```shell
#!/bin/bash
set -e
apt-get update -qq && apt-get install -y nginx
hostname > /var/www/html/index.nginx-debian.html
```

<p class="clearfix">
<img width="1409" alt="Setup EC2 instance with user-data" src="https://user-images.githubusercontent.com/6114/27764859-d33ae2fe-5e9b-11e7-93c1-578be62c0e96.png">

<img width="830" alt="Our 2 servers are running" src="https://user-images.githubusercontent.com/6114/27764873-0792d912-5e9c-11e7-9ea2-0395a093c02c.png">
</p>

Next, you will need to create 2 Route53 health checks (one for each server):

<p class="clearfix">
<img width="1214" alt="Health check server 1" src="https://user-images.githubusercontent.com/6114/27764880-46abb72c-5e9c-11e7-8135-378fb56c3778.png">

<img width="1216" alt="Health check server 2" src="https://user-images.githubusercontent.com/6114/27764881-46b14b42-5e9c-11e7-8a26-99fb2cf26810.png">
</p>

For now the health check status is `Unknown`, but a few seconds after they should both switch to `Healthy`:

<p class="clearfix">
<img width="1082" alt="unknown health" src="https://user-images.githubusercontent.com/6114/27764886-5d06dbaa-5e9c-11e7-9648-4805cd211847.png">

<img width="1071" alt="healthy!" src="https://user-images.githubusercontent.com/6114/27764932-1acaa2e8-5e9d-11e7-804a-1b4f3ccf85ca.png">
</p>

You now have 2 servers, with the corresponding health checks. Let's create the final piece with the 2 DNS records, using the new multivalue answers policy:

<p class="clearfix">
<img width="50%" alt="dns record server 1" src="https://user-images.githubusercontent.com/6114/27764946-4e33c1b4-5e9d-11e7-9347-46ffea2cade2.png">

<img width="50%" alt="dns record server 2" src="https://user-images.githubusercontent.com/6114/27764947-4e35a696-5e9d-11e7-9c75-09439dc883c5.png">
</p>

After a little while, both IPs should show in the `dig` report:

```
$ dig poor-man-lb.barebuild.com
poor-man-lb.barebuild.com. 60INA52.23.222.220
poor-man-lb.barebuild.com. 60INA52INA34.227.93.176
```

Now, if you stop one of the servers, after about 1 min (or lower if you set a TTL < 60s, which is probably a good idea if you're using this policy) the unhealthy host should disappear:

```
$ dig poor-man-lb.barebuild.com
poor-man-lb.barebuild.com. 60sINA52.23.222.220
```

## Is it useful?

This is definitely no replacement for a proper load-balancer, but if you have a large number of backend servers and/or dumb clients that only try the first (or first N) IPs returned, this can prove useful as you don't run the risk of exposing unhealthy servers in your DNS replies.

Although nowadays, in a round-robin DNS setup, all browsers, cURL, etc. are able to try the other IPs until one connects, but again you never know what old stack/program your clients may be using to connect to your service, so using this new Route53 policy puts you on the safe there. Also, keeping unhealthy IPs in DNS replies is probably not that great performance-wise, as the client will have to potentially try to connect to multiple IPs before being able to send a request.
