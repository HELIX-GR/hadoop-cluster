#!/bin/bash

export HADOOP_PREFIX=/usr/local/hadoop

export HADOOP_CONF_DIR=/etc/hadoop
export HADOOP_LOG_DIR=/var/local/hadoop/logs

export YARN_CONF_DIR=${HADOOP_CONF_DIR} 
export YARN_LOG_DIR=${HADOOP_LOG_DIR}

export HTTPFS_CONFIG=${HADOOP_CONF_DIR}

PATH=${PATH}:/usr/local/hadoop/bin:/usr/local/hadoop/sbin
