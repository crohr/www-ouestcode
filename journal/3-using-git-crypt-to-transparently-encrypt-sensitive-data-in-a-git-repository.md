# Using git-crypt to transparently encrypt sensitive data in a git repository

Let's say your job includes provisioning servers, and/or that you want to share passwords with selected people in your team. Wouldn't it be great to be able to use a git repo for that?

![lock-10-256x256](https://cloud.githubusercontent.com/assets/6114/11686850/4e9017d6-9e7b-11e5-9527-6641ac52bae9.png)

## Requirements

1. Install [`git-crypt`](https://github.com/AGWA/git-crypt).
   
   ```
   brew install git-crypt
   ```
   
   On other systems than MacOS, you can either compile the program from source (recommended), or use my [docker image](https://hub.docker.com/r/crohr/git-crypt/).

## Usage

1. Clone the repo that will host your sensitive data:
   
   ```
   git clone git@github.com:my-org/ops.git
   ```

2. Initialize `git-crypt`:
   
   ```
   cd ops/
   git-crypt init
   ```

3. Add yourself to the list of authorized users:
   
   ```
   git-crypt add-gpg-user --trusted USER_ID
   ```
   
   `USER_ID` can be a key ID, a full fingerprint, an email address, or anything else that uniquely identifies a public key to GPG. Add the `--trusted` option unless you want to manually trust the user using GPG's original vision of a web-of-trust.

4. Commit a `.gitattributes` file containing the list of file extensions to encrypt (see below).

5. Commit new files that use one of the protected extensions and verify that they appear as gibberish on Github/Gitweb, etc.

6. Share the repo with others by adding their GPG key:
   
   ```
   git-crypt add-gpg-user --trusted USER_ID
   ```
   
   Note: `git-crypt add-gpg-user` will add and commit a GPG-encrypted key file in the .git-crypt directory of the root of your repository.
   
   Now, that user can unlock the repo with her GPG key:
   
   ```
     cd ops/
     git-crypt unlock
   ```

## Encrypted files

Assuming you commit the following `.gitattributes` file:

```
secretfile filter=git-crypt diff=git-crypt
*.key filter=git-crypt diff=git-crypt
*.password filter=git-crypt diff=git-crypt
*.env filter=git-crypt diff=git-crypt
*.env.json filter=git-crypt diff=git-crypt
*.yaml filter=git-crypt diff=git-crypt
*.yml filter=git-crypt diff=git-crypt
```

Any file with one of the following extensions will automatically be encrypted when you commit and `git push`:
- `.key`
- `.password`
- `.yaml` or `.yml`
- `.env`

Those files will still appear in clear-text if you look at them in your terminal, or using any of the git commands. Any new files that you commit with an extension present in the `.gitattributes` file will be transparently encrypted for you.
