# README

## 1. Prerequisites

### 1.1 Ansible Environment

You must install `Ansible` on the control machine, preferably in a virtual Python environment:

    virtualenv pyenv
    . pyenv/bin/activate
    pip install ansible==2.5 netaddr

### 1.2 Download Hadoop + Spark

Play `download-hadoop.yml` to download Hadoop binaries under `.data`. 

Play `download-spark.yml` to download Spark binaries (without Hadoop) under `.data`. 

These binaries will be copied to all machines in the cluster (to avoid downloading for each one of them).

### 1.3 Provide SSH keys

Place your PEM-formatted private key under `keys/id_rsa` and corresponding public key under `keys/id_rsa.pub`. 
Ensure that private key has proper permissions (`0600`).

### 1.4 Provide inventory file

Copy `hosts.yml.example` to `hosts.yml` and adhust to your needs.

## 2. Setup

Setup using Vagrant:

    vagrant up

If machines are already created (along with SSH connectivity), you can play the Ansible recipes:

    ansible-playbook -v -b -u vagrant play-basic.yml
    ansible-playbook -v -b -u vagrant play-hadoop.yml

## 3. Start/Stop services

### 3.1. Start/Stop HDFS

The easy way to start/stop everything is by using the `{start,stop}-dfs.sh` helper scripts. This script will start data nodes (by logging-in via SSH to each one of them), and name nodes.

For starting, the process is rougly equivalent to the following (in this order). All commands are invoked as user `hadoop`.

On namenode:

    hadoop-daemon.sh start namenode

On secondary namenode (the FS image updater):

    hadoop-daemon.sh start secondarynamenode
    
On each one of the data nodes (i.e. every host included in `slaves` file):

    hadoop-daemon.sh start datanode

After starting all daemons, verify that all data nodes have checked-in succesfully. On namenode:

    hdfs dfsadmin -report

The HDFS cluster is stopped using the same `hadoop-daemon.sh` script (in the reverse order: first stop data nodes, last name nodes).

### 3.2. Start/Stop YARN 

#### 3.2.1. Start/Stop basic services

The easy way to start/stop everything is by using the `{start,stop}-yarn.sh` helper scripts. This script will start node managers (by logging-in via SSH to each one of them) and the resource manager (locally). The auxiliary services (timeline server and MR history server) are not started/stopped automatically.

For starting, the process is rougly equivalent to the following (in this order). All commands are invoked as user `yarn`.

On manager node, start resource manager:

    yarn-daemon.sh start resourcemanager
    
On each compute node (same as data nodes), start node manager:

    yarn-daemon.sh start nodemanager

On manager node, verify that compute nodes have checked-in:

    yarn node -list

The YARN cluster is stopped using the same `yarn-daemon.sh` script (in the reverse order: first stop compute nodes, last the manager).

#### 3.2.2. Start auxiliary services

In order to have reporting/tracking information for YARN jobs we must also start the timeline server. For the specific case of MR jobs, a MR history server is also useful (to report stats on mapper/reducer level).

All commands are invoked as user `yarn`.

On manager:

    yarn-daemon.sh start timelineserver
    mr-jobhistory-daemon.sh start historyserver

Having these history services running, we can extract useful information on executions (aka application attempts) of submitted applications.

List all applications:

    yarn application -list -appStates ALL
    
List executions (aka attempts) for a specific application (the application id can be retrieved by previous command):

    yarn applicationattempt -list application_1550497940748_0002
    
Get status for a given execution (application attempt):

    yarn applicationattempt -status appattempt_1550497940748_0002_000001

List YARN containers for a given execution:

    yarn container -list appattempt_1550497940748_0002_000001


