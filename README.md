## CentOS (centos/7) setup (remote hosts)

```bash

sudo yum install gcc
sudo yum install python-setuptools
sudo easy_install pip
sudo yum install python-devel
sudo pip install ansible

# amending the /etc/ssh/sshd_config 'PasswordAuthentication yes' 
# then re-started the service 'sudo systemctl restart sshd'
sudo vi /etc/ssh/sshd_config
sudo systemctl restart sshd

```

## Ubuntu (ubuntu/xenial64) setup (access control host)

```bash
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update && sudo apt-get install ansible -y

ansible 192.168.33.20 -i inventory -u vagrant -m ping -k
```
