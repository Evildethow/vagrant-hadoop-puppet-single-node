vagrant-hadoop-puppet-single-node
=================================

Migrated from https://github.com/vangj/vagrant-hadoop-2.3.0

# Description
Creates a single node hadoop installation using default configuration.

# Versions
* Hadoop 2.5.2
* java-1.7.0-openjdk-1.7.0.71.x86_64
* Centos 6.4 Minimum (http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130731.box)

# Requirements
* Vagrant (>= 1.4.3)
* Virtualbox (>= 4.2.16)

# Usage

To start Server (from root directory):

```bash
vagrant up
```

To ssh into Server (from root directory):
```bash
vagrant ssh
```

To halt Server (from root directory):
```bash
vagrant halt
```

To destroy Server (from root directory):
```bash
vagrant destroy
```

Hadoop URL's:
* http://localhost:50070/dfshealth.html
* http://localhost:50075/dataNodeHome.jsp
* http://localhost:8088/cluster
* http://localhost:8042/node
* http://localhost:19888/jobhistory

HDFS Shell command
```bash
hdfs dfs -ls /
```

