# A docker container to cleanup your docker containers

If you don't use the `--rm` flag when launching docker containers (and even if you do), your disks are going to slowly but surely fill up with all the cached layers and unused images. People usually schedule [docker-cleanup-volumes](https://github.com/chadoe/docker-cleanup-volumes) in a cron to counter this, but now you can also just run a docker image that does it for you:

```bash
docker run \
  -d \
  --restart=on-failure \
  -e KEEP_IMAGES="ubuntu:14.04 corp/important-image:tag" \
  -v /var/run/docker.sock:/var/run/docker.sock:rw \
  -v /var/lib/docker:/var/lib/docker:rw \
  meltwater/docker-cleanup:latest
```

See the [relevant repo](https://github.com/meltwater/docker-cleanup) for more details and a systemd init script.
