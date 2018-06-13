# Getting started with Google Container Engine and Kubernetes

Mainly a cheatsheet for myself, work in progress.

## Create a Cluster

You should probably create a new project first.
Then the easiest way is to just do it through the Google Cloud UI, and choose your cluster size, zone(s), etc. This is pretty straightforward.

## Install CLI

You need `gcloud` SDK and `kubectl`. Documentation can be found at https://cloud.google.com/sdk/downloads. Those can be installed with:

```bash
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init
```

Now install the `kubectl` component:

```bash
gcloud components update kubectl
```

## Start a kubernetes proxy and access the UI

I'm not sure if it's because I'm running from a remote terminal, or if the instructions given in the developer console are incorrect or incomplete, but I had to setup the `application-default` login stuff in addition to the `gcloud init` to make the `kubectl` work. Otherwise it would return the following:

```
$ kubectl proxy
Unable to connect to the server: oauth2: cannot fetch token: 400 Bad Request
Response: {
  "error" : "invalid_grant"
}
```

So here are the commands I had to enter:

```
gcloud auth application-default login # go through the OAuth dance again
gcloud container clusters get-credentials cluster-name --zone us-central1-b
kubectl proxy # or kubectl proxy --address=0.0.0.0 --accept-hosts=your-ip-or-domain-name if need to make it available to the world
```

Yeah! We can see the Kubernetes dashboard with all the pods and replication sets and services running on my cluster.

<img width="1388" alt="kubernetes-ui" src="https://cloud.githubusercontent.com/assets/6114/20731939/62652798-b684-11e6-8617-3736d99b7117.png">

Next, I'll try to see if I can easily start a full application from an existing docker-compose file.
