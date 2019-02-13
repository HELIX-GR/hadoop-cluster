# README

## 1. Prerequisites ##

### 1.1 Ansible Environment ###

You must install `Ansible` on the control machine, preferably in a virtual Python environment:

    virtualenv pyenv
    . pyenv/bin/activate
    pip install ansible==2.5 netaddr

### 1.2 Download Hadoop ###

Play `download-hadoop.yml` to download Hadoop binaries (locally) under `.data`. These binaries will be copied to all machines
in the cluster (to avoid downloading for each one of them).

### 1.3 Provide SSH keys ###

Place your PEM-formatted private key under `keys/id_rsa` and corresponding public key under `keys/id_rsa.pub`. 
Ensure that private key has proper permissions (`0600`).

### 1.4 Provide inventory file ###

Copy `hosts.yml.example` to `hosts.yml` and adhust to your needs.

## 2. Setup ##

Setup using Vagrant:

    vagrant up

