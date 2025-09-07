# Don't add a passphrase, just press Enter twice
ssh-keygen -t ed25519 -C "circleci-gatsby-deploy" -f ~/.ssh/circleci_gatsby_deploy

This creates two files: `circleci_gatsby_deploy` (the private key) and `circleci_gatsby_deploy.pub` (the public key).

#### Step 2: Add the Public Key as a "Deploy Key" on GitHub

You need to grant this new key read-only access to your **`portfolio-gatsby`** repository.

1.  In your `portfolio-gatsby` GitHub repository, go to **Settings** > **Deploy keys** > **Add deploy key**.
2.  Give it a title, like `CircleCI Deploy Key`.
3.  Copy the entire contents of your **public key** file (`~/.ssh/circleci_gatsby_deploy.pub`) and paste it into the "Key" field.
4.  **Do not** check "Allow write access". The pipeline only needs to read the code.
5.  Click **Add key**.



#### Step 3: Add the Private Key to CircleCI

Now, you need to give CircleCI the private key so it can authenticate with GitHub.

1.  In the CircleCI web app, go to your **`terraform-services`** project's settings by clicking **Project Settings**.
2.  In the side menu, click on **SSH Keys**.
3.  Click **Add SSH Key**.
4.  Leave the "Hostname" field blank (it will default to `github.com`).
5.  Copy the entire contents of your **private key** file (`~/.ssh/circleci_gatsby_deploy`) and paste it into the "Private Key" field.
6.  Click **Add SSH Key**.



Once you've completed these steps, your CircleCI pipeline will have secure, read-only access to your Gatsby repository and the `git clone` command will work seamlessly.