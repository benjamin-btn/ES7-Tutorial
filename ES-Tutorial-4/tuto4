#!/bin/sh

ES_VER="7.5.1"
ES_URL="https://artifacts.elastic.co/downloads/elasticsearch"
ES_RPM="elasticsearch-${ES_VER}-x86_64.rpm"

ES_ETC="/etc/elasticsearch"
ES_MYML="elasticsearch.yml"
ES_ADDYML="ymladd.yml"
ES_JVM="jvm.options"

ES_NODEIP=$(ifconfig | grep inet | grep -vE '127.0.0.1|inet6' | awk '{print $2}')
ES_NODENAME=$(hostname -s)

SEQ="4th"
ORG_SEQ="org_4th"

git pull

# ES Package Install
function install_es_packages
{
    wget 2> /dev/null
    if [ $? -ne 1 ]; then
        sudo yum -y install wget
    fi

    ls -alh /usr/local/src/elasticsearch* 2> /dev/null
    if [ $? -ne 0 ]; then
        sudo wget ${ES_URL}/${ES_RPM} -O /usr/local/src/${ES_RPM}
    fi

    rpm -ql elasticsearch > /dev/null
    if [ $? -ne 0 ]; then
        sudo rpm -ivh /usr/local/src/${ES_RPM}
    fi
}

# elasticsearch.yml Configure
function configure_es_yaml
{
    sudo cp -f ${ES_ETC}/${ES_MYML} ${ES_ETC}/${ES_MYML}.${ORG_SEQ}
    sudo cp -f ${ES_MYML}.${SEQ} ${ES_ETC}/${ES_MYML}

    sudo echo "### For ClusterName & Node Name" | sudo tee -a ${ES_ETC}/${ES_MYML} > /dev/null
    sudo echo "cluster.name: mytuto-es" | sudo tee -a ${ES_ETC}/${ES_MYML} > /dev/null
    sudo echo "node.name: warm-$ES_NODENAME" | sudo tee -a ${ES_ETC}/${ES_MYML} > /dev/null
    sudo echo "" | sudo tee -a ${ES_ETC}/${ES_MYML} > /dev/null

    sudo echo "### For Head" | sudo tee -a ${ES_ETC}/${ES_MYML} > /dev/null
    sudo echo "http.cors.enabled: true" | sudo tee -a ${ES_ETC}/${ES_MYML} > /dev/null
    sudo echo "http.cors.allow-origin: \"*\"" | sudo tee -a ${ES_ETC}/${ES_MYML} > /dev/null
    sudo echo "" | sudo tee -a ${ES_ETC}/${ES_MYML} > /dev/null

    sudo echo "### For Response by External Request" | sudo tee -a ${ES_ETC}/${ES_MYML} > /dev/null
    sudo echo "network.bind_host: 0.0.0.0" | sudo tee -a ${ES_ETC}/${ES_MYML} > /dev/null
    sudo echo "network.publish_host: $ES_NODEIP" | sudo tee -a ${ES_ETC}/${ES_MYML} > /dev/null
    sudo echo "" | sudo tee -a ${ES_ETC}/${ES_MYML} > /dev/null

    sudo echo "### Discovery Settings" | sudo tee -a ${ES_ETC}/${ES_MYML} > /dev/null
    sudo echo "discovery.seed_hosts: [ \"\",  \"\",  \"\", ]" | sudo tee -a ${ES_ETC}/${ES_MYML} > /dev/null

    sudo cat ${ES_ADDYML}.${SEQ} | sudo tee -a ${ES_ETC}/${ES_MYML} > /dev/null

    # jvm options Configure for Heap Memory
    sudo cp -f ${ES_ETC}/${ES_JVM} ${ES_ETC}/${ES_JVM}.${ORG_SEQ}
    sudo cp -f ${ES_JVM}.${SEQ} ${ES_ETC}/${ES_JVM}

}

# Start Elasticsearch
function start_es_process
{
    sudo cat /etc/elasticsearch/elasticsearch.yml | grep '"",  "",  "",' > /dev/null
    if [ $? -eq 0 ]; then
        echo "Set your unicast.hosts!! Edit your /etc/elasticsearch/elasticsearch.yml & Input your node1,2,3 in \"\""
    else
        sudo systemctl daemon-reload
        sudo systemctl enable elasticsearch.service
        sudo systemctl restart elasticsearch
    fi
}

function configure_es_template
{
    curl -s localhost:9200 > /dev/null
    if [ $? -ne 0 ]; then
	echo "Your ES Process is not working yet"
    else
	curl -s -H 'Content-Type: application/json' -XPUT http://localhost:9200/_template/estemplate -d '
        {
            "index_patterns": ["*"],
            "order" : 0,
            "settings": {
                "index.routing.allocation.require.box_type" : "hotdata"
            }
        }'
    fi

}

function configure_es_hotmove
{
    curl -s localhost:9200 > /dev/null
    if [ $? -ne 0 ]; then
        echo "Your ES Process is not working yet"
    else
        curl -s -H 'Content-Type: application/json' -XPUT http://localhost:9200/_all/_settings -d '
        {
            "index.routing.allocation.require.box_type" : "hotdata"
        }'
    fi
}

function configure_es_warmmove
{
    if [ -z $1 ]; then
	echo "Input Your Index Name"
    else
        curl -s localhost:9200 > /dev/null
        if [ $? -ne 0 ]; then
    	    echo "Your ES Process is not working yet"
        else
    	    curl -s -H 'Content-Type: application/json' -XPUT http://localhost:9200/$1/_settings -d '
            {
                "index.routing.allocation.require.box_type" : "warmdata"
            }'
        fi
    fi
}

function init_ec2
{
    # remove rpm files
    sudo \rm -rf /usr/local/src/*

    # delete a es template
    curl -s -H 'Content-Type: application/json' -XDELETE http://localhost:9200/_template/estemplate

    # shard reloacate to hot data node
    curl -s -H 'Content-Type: application/json' -XPUT http://localhost:9200/_all/_settings -d '
    {
        "index.routing.allocation.require.box_type" : "hotdata"
    }'
    sleep 30

    # stop & disable elasticsearch & kibana daemon
    sudo systemctl stop elasticsearch
    sudo systemctl disable elasticsearch.service
    sudo systemctl daemon-reload

    # erase rpm packages
    sudo rpm -e elasticsearch-${ES_VER}-1.x86_64

    # remove package configs
    sudo rm -rf /etc/elasticsearch
    sudo rm -rf /var/lib/elasticsearch
    sudo rm -rf /var/log/elasticsearch

}


if [ -z $1 ]; then
        echo "##################### Menu ##############"
        echo " $ ./tuto4 [Command]"
        echo "#####################%%%%%%##############"
        echo "         1 : elasticsearch packages"
        echo "         2 : configure elasticsearch.yml & jvm.options"
        echo "         3 : start elasticsearch process"
        echo "         4 : hotdata/warmdata template settings"
        echo "         5 : all indices move to hotdata node"
        echo "         6 : specific index moves to warmdata node"
        echo "         init : ec2 instance initializing"
        echo "#########################################";
        exit 1;
fi

case "$1" in
        "1" ) install_es_packages;;
        "2" ) configure_es_yaml;;
        "3" ) start_es_process;;
        "4" ) configure_es_template;;
        "5" ) configure_es_hotmove $2;;
        "6" ) configure_es_warmmove $2;;
        "init" ) init_ec2;;
        *) echo "Incorrect Command" ;;
esac
