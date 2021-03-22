# Announcing PullPreview

Ever wanted to easily preview a branch or pull request on GitHub? Check out my latest product: [PullPreview.com](https://pullpreview.com)

## Features

### On demand preview environments

From your project, just click on any pull request, branch, or tag to start a live environment based on your `docker-compose.pullpreview.yml` file. You'll get a custom URL that you can share with anyone wanting to have a look at the app or a new feature.

### Auto-deploy pull requests and branches

Manually starting sessions from any reference is nice, but what's better is to automatically deploy new commits as they come for a pull request or branch. Enabling auto-deploy will make sure your preview environment is always up to date with the latest changes.

By default, and to save on credits, auto-deployed environments will be shut down after 72h, unless a new commit is pushed. You can also manually wake up an auto-deploy environment that went asleep from the UI.

When a branch or pull request is deleted, any auto-deploy environment associated with it will be automatically shut down, ending the credits consumption.

### Expose any port

Contrary to a lot of other platforms, you are not limited to only 1 publicly-exposed port. Any process declared in your docker-compose file can expose any number of ports (as long as they don't conflict). You will get a dedicated IP for each deployment.

### Persistent volumes

Want to keep demo data around across redeploys? Just define volumes in your docker-compose file and we'll take care of persisting them, and reattaching them for your next deploys. For instance, you can easily keep a persistent postgres/mysql database with demo data for the same branch or pull request, across deployments.

### Simple credit system

Each plan comes with a dedicated number of credits. A one-hour preview session costs 1 credit (each hour started is due). On the free plan you will get 50 credits/month. The first paid plan starts at $50, for 750 credits/month (equivalent to 1 session running without interruption for 1 month). With auto-deploy jobs automatically going asleep or ending when the branch or pull request is closed, you should be able to run a lot of auto-deploy sessions on that plan. A common use case is to enable auto-deploy for your main branch (e.g. `master`), and for any pull request that requires thorough end-to-end testing and/or approval by a product manager.
