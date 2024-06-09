# Homelab
## Ubuntu 22 LTS
machine hostname 'hp-elite'

I have my router DHCP set to assign my server to 192.168.1.154. You'll wanna do this or ctrl+f and replace with your homelabs local ip (if anywhere). 

This is for when the homelab inevitably breaks, so i can rebuild it to the same (low) standards.


# Steps:

- Install Github CLI and sign in `sudo apt install gh -y && gh auth login`

- Then clone the repo `git clone https://github.com/harryabbott/homelab.git`

- Install docker engine by following these docs: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

- Install kubectl `curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"` then `sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl`

- (Optional) Alias kubectl `echo 'alias k=kubectl' >> ~/.bashrc`

- Install k3s `curl -sfL https://get.k3s.io | sh -`

- Enable k3s `sudo systemctl enable k3s`

- Create the hosts mount paths with `./localvolumes.sh`
