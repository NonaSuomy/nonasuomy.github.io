---
layout: post
title: Hypervisor Virsh Console for Copy & Pasting id_rsa.pub To Terminal of VM
---

# Process #

Didn't have public key added to the VM that was locked down, needed a way to paste the long id_ssh.pub key to the vm's authorized_keys.

## Local Machine ##

```
ssh-keygen -t rsa -b 2048
eval `ssh-agent -c` 
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub
```

Copy the key...

## virsh console ##

Inside the VM via virt-manager or virt-viewer enable the tty for use with virsh.

```
systemctl enable serial-getty@ttyS0.service
systemctl start serial-getty@ttyS0.service
systemctl status serial-getty@ttyS0.service
```

Make sure the virt-manager window is not open for the VM you want to attach.

SSH into the hypervisor then connect to the console that was just made.

```
ssh 
virsh console vmdomainnamehere --safe
```

If there is just a cursor and you can't type... it might not be working, otherwise it may just be waiting for you to type the username and password so try that.

```
Login:
username
Password:
password
vi ~/.ssh/authorized_keys
```

Paste in your massive key, save and should be good to go.

To exit type exit then push CTRL + [

**Note:** *If you don't type exit the next person that types the virsh console command will not be prompted for a password. You may want to disable the tty systemctl service that was started after finished for security reasons.*
