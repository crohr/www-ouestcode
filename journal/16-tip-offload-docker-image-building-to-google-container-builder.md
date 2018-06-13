# Tip - Offload docker image building to Google Container Builder

Want fast docker builds without maintaining costly server(s)? You can offload your build process to Google with their [Container Builder service](https://cloud.google.com/container-builder/).

Quickstart with the Google Cloud Platform is always a pain (but maybe it's because I'm so used to AWS), but once you're past the initial project setup and the `gcloud` command line install ([doc](https://cloud.google.com/container-builder/docs/quickstarts/gcloud)), building a docker image is as simple as:

```shell
gcloud container builds submit --tag 'gcr.io/pullpreview/openproject:test' .
```

The docker build output will be streamed to your terminal, and then you'll see a quick recap showing how long it took:
```
DONE
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ID                                    CREATE_TIME                DURATION  SOURCE                                               IMAGES                              STATUS
3ea83cca-e13d-4e46-b500-a3a2cc2cb667  2017-06-26T20:11:47+00:00  7M34S     gs://pullpreview_cloudbuild/source/1498507902.79.gz  gcr.io/pullpreview/openproject:test  SUCCESS
```

Success indeed! Based on my tests the machines used are quite fast (the example above is for a really big Rails/NodeJS project), and you get 120min for free per month (but the pricing is ridiculously low anyway). Big caveat though: you can't run more than one build at a time.
