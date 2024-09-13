Here's a step-by-step guide to set up Continuous Integration (CI) with GitHub Actions to automatically trigger a pull from GitHub and restart a service on a DigitalOcean droplet when you push to the `master` branch.

### Prerequisites
- A GitHub repository
- A DigitalOcean Droplet with a service (managed by `systemctl`)
- SSH access to the droplet
- GitHub Actions enabled for your repository

### Step 1: Prepare the DigitalOcean Droplet

1. **SSH into your DigitalOcean droplet:**
   ```bash
   ssh root@your_droplet_ip
   ```

2. **Install Git on the droplet (if not installed):**
   ```bash
   sudo apt update
   sudo apt install git
   ```

3. **Clone the GitHub repository on the droplet:**
   ```bash
   git clone https://github.com/your-username/your-repo.git /path/to/your/repo
   ```

4. **Create a script to pull and restart the service:**
   ```bash
   sudo nano /path/to/your/repo/deploy.sh
   ```

   Inside the file, add the following script:
   ```bash
   #!/bin/bash
   cd /path/to/your/repo
   git pull origin master
   sudo systemctl restart your-service
   ```

5. **Make the script executable:**
   ```bash
   sudo chmod +x /path/to/your/repo/deploy.sh
   ```

6. **Test the deploy script:**
   Run the script to ensure it works:
   ```bash
   /path/to/your/repo/deploy.sh
   ```

### Step 2: Create SSH Key Pair for GitHub to Droplet Access

1. **Generate an SSH key pair on your local machine (or on the droplet):**
   ```bash
   ssh-keygen -t rsa -b 4096 -C "your-email@example.com"
   ```
   Follow the prompts to save the key, typically in `~/.ssh/id_rsa`.

2. **Add the SSH public key to the droplet:**
   Copy the contents of `~/.ssh/id_rsa.pub` to the droplet:
   ```bash
   cat ~/.ssh/id_rsa.pub
   ```
   Then, on the droplet:
   ```bash
   nano ~/.ssh/authorized_keys
   ```
   Paste the public key and save the file.

3. **Add the SSH private key to GitHub:**
    - Go to your repository on GitHub.
    - Navigate to **Settings** > **Secrets and variables** > **Actions** > **New repository secret**.
    - Add the private SSH key (`~/.ssh/id_rsa`) as a secret called `DO_SSH_PRIVATE_KEY`.

### Step 3: Create GitHub Actions Workflow

1. **In your GitHub repository**, create a `.github/workflows/deploy.yml` file:
   ```bash
   mkdir -p .github/workflows
   nano .github/workflows/deploy.yml
   ```

2. **Define the workflow in the `deploy.yml` file:**

   ```yaml
   name: Deploy to DigitalOcean

   on:
     push:
       branches:
         - master

   jobs:
     deploy:
       runs-on: ubuntu-latest

       steps:
       - name: Checkout code
         uses: actions/checkout@v3

       - name: Set up SSH
         uses: webfactory/ssh-agent@v0.8.1
         with:
           ssh-private-key: ${{ secrets.DO_SSH_PRIVATE_KEY }}

       - name: Deploy to Droplet
         run: |
           ssh -o StrictHostKeyChecking=no root@your_droplet_ip "/path/to/your/repo/deploy.sh"
   ```

### Step 4: Push Changes to GitHub

1. **Add and commit the GitHub Actions workflow:**
   ```bash
   git add .github/workflows/deploy.yml
   git commit -m "Add GitHub Actions workflow for deployment"
   git push origin master
   ```

2. **Trigger a deployment:**
   When you push to the `master` branch, GitHub Actions will run the workflow, SSH into your DigitalOcean droplet, pull the latest code, and restart the service.

### Step 5: Verify the Setup

1. **Check GitHub Actions:**
   Go to the **Actions** tab of your GitHub repository to see if the deployment job runs successfully.

2. **Verify on the Droplet:**
   Ensure that the code is pulled and the service is restarted after the GitHub Action is triggered.

### Optional: Automating Multiple Services

If you need to restart multiple services, simply modify the `deploy.sh` script to restart additional services.

### Troubleshooting

- **Permission issues**: Ensure the SSH private key has the correct permissions and that GitHub Actions has access to it.
- **Service not restarting**: Ensure your service is correctly configured with `systemctl` and that the path to the service file is correct in the `deploy.sh` script.

Now your setup is complete! Every time you push to `master`, GitHub Actions will trigger the deployment, pull the latest changes from your GitHub repo, and restart your service on the DigitalOcean droplet.

### Systemd configuration
``` 
[Unit]
# describe the app
Description=My App
# start the app after the network is available
After=network.target

[Service]
# usually you'll use 'simple'
# one of https://www.freedesktop.org/software/systemd/man/systemd.service.html#Type=
Type=simple
# which user to use when starting the app
User=root
# path to your application's root directory
WorkingDirectory=/root/digital-ocean-github-actions-ci
# the command to start the app
# requires absolute paths
ExecStart=/root/.bun/bin/bun run src/index.ts
# restart policy
# one of {no|on-success|on-failure|on-abnormal|on-watchdog|on-abort|always}
Restart=always

[Install]
# start the app automatically
WantedBy=multi-user.target

```