## CentOS (centos/7) setup (remote hosts)

```bash

# install from source with pip
sudo yum install gcc -y
sudo yum install python-setuptools -y
sudo easy_install pip -y
sudo yum install python-devel -y
sudo pip install ansible -y

# amending the /etc/ssh/sshd_config 'PasswordAuthentication yes'
# then re-started the service 'sudo systemctl restart sshd'
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
sudo systemctl restart sshd

# Alternatively, you can install ansible this way
sudo yum install epel-release -y
sudo yum install ansible -y
```

## Ubuntu (ubuntu/xenial64) setup (access control host)

```bash
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update && sudo apt-get install ansible -y

# note: in order to make password based auth (-k) work, you have to enable it, e.g.
# vi /etc/ssh/sshd_config
#    PasswordAuthentication yes
# $ service sshd restart
ansible 192.168.33.20 -i inventory -u vagrant -m ping -k
```

## Key setup

Nowdays, most OS by default will disable the plain password based authentication for security reason.
The alternative is public/private key based authentication. The idea is keep private key only on your local pc,
and upload the public key to the remote host. Such that the authentication can be done using PKS.

For ansible, the best way is using PKS for auth. Here is the normal flow for key deployment:
* generate a key pair on any machine with ssh-keygen
* upload pub key to the remote host
* save the private key to your local pc
* pass the private key when talking to remote host. e.g.
```bash
 ansible  -i '192.168.33.30,' all  --private-key=./my_rsa_key_pair -m ping -u vagrant -vvv
```

## Execution and flow
* evaluate the playbook and create a python package for the playbook
* scp the python package to remote host
* python on remote run the package, and return result to ansible control server, then delete the package
* continue with next play

## Execution types
* remote - upload package to remote and exec, mostly use webapi
* local - when remote bos is not exuting plays

## Ansible archetecture
* inventory maps hosts
* configuation sets ansible parameters
* modules define actions
* playbooks to coordinate multiple tasks
* python to build the execution
* ssh to deliver the task

## Ansible basic command

Include system, inventory file, module, and user

```bash
ansible <system>
  -i <inventoryFile>
  -m <module>
  -u <username>
  -k <password prompt>
  --private-key=<path_to_private_key>
  -v (-vv debug level2/-vvv debug level3)

# e.g.
ansible  -i '192.168.33.30,'  --private-key=./my_rsa_key_pair  -m ping all -vvv -u vagrant
```


## Terms

* Inventory: ansible hosts file, i.e., the managed hosts ip, users etc
* Modules: A programmed unit of work to be done, e.g., yaml module
* Playbook: Glue bring all modules together, it contains a set of plays. In other words, it is a set of plays build in specific order sequence to produce an expected outcome or outcomes across many different sets of hosts.
* Play: a single or set of tasks using modules, executed on a defined set of hosts. e.g., copy  a file, start a server, install a software, etc
* Ansible Config: Global config, such as how many parallel operation sys perform. It can be overrided.
* Python:
* Variables:
  * Host Variables - defined in inventory file per host or group
  * Facts - gathered from the remote managed host, such as ip, os, cpu speed
  * Dynamic variables - use data gathered by tasks or created at runtime
