# Convox

Last update: 11 October 2018

If I look back at my last 15 years of programming, there were a few things that
got me pretty excited, and for a few of them changed my career (dates are when
I discovered them):

* ~1998 **Internet**
* ~2000 **HTML & JavaScript**
* ~2006 jQuery
* ~2006 **Rails 1.x** and the [Build a Blog in 15 minutes](https://www.youtube.com/watch?v=Gzj723LkRJY&feature=youtu.be) screencast
* ~2008 RESTful APIs
* ~2008 Puppet
* ~2013 **Docker**
* ~2016 Convox

[Convox](https://convox.com) is the latest thing in that list that blows my
mind. It's basically your own Heroku, built only with AWS primitives, and
incredibly powerful and cheap to run. I've been following it since 2016, and
after they switched over to the second generation of their tool (ALB
integration) I built a few production clusters with it and couldn't be happier.

If you really like Heroku but it's too expensive for you, or if you really like
Kubernetes but the learning curve is too steep, then you should give Convox a try.

You get everything I always dreamed of, perfectly integrated around a single CLI:

* Cluster (a "rack" in convox parlance) autoinstalls in minutes. You just need to provide AWS credentials.
* Can be installed in your own AWS account, completely for free, and without any interactions with the official convox Console.
* Deploy an app from your local directory. The local dir is tarball'ed, uploaded, and the docker image is built on EC2 so that you're not dependent on your ISP bandwidth.
* All your apps can be made highly available since they're all behind a load balancer.
* A single ALB (Application Load Balancer) for all your apps, saving huge amounts of $$$.
* Inspect running processes, and scale them up or down in seconds.
* Easy (and secure) way to configure apps through env variables.
* Rolling restarts.
* Integrated health checks.
* Integrated auto-scaling policies.
* Exec into a running container right from your machine.
* SSH into a running EC2 instance right from your machine.
* Centralized logs, and easy tailing.
* Automatic SSL certificate generation.
* Create AWS resources (mysql, postgres, s3, etc.) right from the command line.

Cost: ~$70/m for a rack with 3 t3.medium machines (spot enabled) that can host
apps for a total of 12GB RAM.

It's hard to believe, but with Convox the hardest thing to do to deploy an app
right now is building the Dockerfile, which is basically Computing 101 nowadays.

No more terraform, puppet/ansible/salt/etc., capistrano, shell scripts. You can
deploy a rack full of machines and deploy your first app in half a day. And
then 10 more apps the following afternoon, it is that powerful.

Other niceties:

* Built by 3 early heroku employees, including the awesome @ddollar.
* Private networking is supported, if you need NAT gateways.
* EFS support included, so you can share files across multiple instances of the same process.
* You can enable spot instance bidding for massive savings.
* OpenSource.
* In active development.

Caveats:

* if you need raw TCP connections for your web services, you may use gen1 apps,
  but I would just deploy them in another way. Convox really shines with
HTTP(/2) apps.
* it doesn't have the same traction as Kubernetes, and is dependent on AWS.
