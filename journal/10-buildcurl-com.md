# Introducing buildcurl.com

cURL + #docker = [buildcurl.com](http://buildcurl.com) â Build precompiled binaries on demand.

## TL;DR

I just released a new project: [buildcurl.com](http://buildcurl.com)

Use it to get precompiled binaries for your platform, for instance:

``` bash
curl buildcurl.com -GL -d recipe=ruby -d target=ubuntu:14.04 -d version=2.3.1 -d prefix=/usr/local -o - | tar xzf - -C /usr/local
```

If you want to stream the build logs, you would do:

``` bash
params="-d recipe=ruby -d target=ubuntu:14.04 -d version=2.3.1 -d prefix=/usr/local"
curl buildcurl.com -G $params && curl buildcurl.com -GL $params -o - | tar xzf - -C /usr/local
```
## Why?

Ever wanted to get a specific version of `ruby`/`node`/`php`/`python`/`nginx`/etc. to install on your server, development VM, or embed in a DEB/RPM package or docker image? If so, you usually have to compile it from source, or rely on alternate APT/YUM repositories to provide the version you need.

But what if you could just fetch a tarball with a precompiled version of your binary for your target platform, put that into your filesystem, and be done with it?

This is what buildcurl.com provides, and you can very easily install multiple versions of the same recipe in different `prefix`.
## How it works

The high-level overview is very basic: apache receives a request, forwards to a simple [CGI script](https://github.com/crohr/buildcurl/blob/master/cgi-bin/build.cgi), which itself launches a container, which starts the compilation of the requested recipe for the target distribution. Finally, the result of the compilation is saved in a compressed archived and cached so that future requests for the same `<recipe,target,version,prefix>` are instantaneous.

Under the hood, we get a bit more complex so that we can also build and stream build logs in a browser (using Server-Side Events), and we do a few redirects when using a command-line based tools so that you can also see the streamed logs if you need to.

You can find more details at https://github.com/crohr/buildcurl. Pull requests for new recipes are welcome!

