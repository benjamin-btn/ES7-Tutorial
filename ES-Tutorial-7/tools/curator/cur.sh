#!/bin/bash

function delete_duration_indices
{
    if [ -z $1 ]; then
        echo "##########################################################"
        cat config/es.config.yml
        echo "##########################################################"
        cat action/delete_duration.action.yml
        echo "##########################################################"
        /bin/curator --dry-run --config config/es.config.yml action/delete_duration.action.yml # dry-run
        cat logs/curator.log
        \rm logs/curator.log
    elif [ $1 == "real" ]; then
        /bin/curator --config config/es.config.yml action/delete_duration.action.yml
        cat logs/curator.log
        \rm logs/curator.log
    else
        echo "Incorrect parameter"
    fi
}

function create_indices
{
    curl -s -H 'Content-Type: application/json' -XPOST http://localhost:9200/tuto-$(date -d '2 day ago' '+%Y-%m-%d')/_doc -d '{ "TEST":"TTT" }' > /dev/null
    curl -s -H 'Content-Type: application/json' -XPOST http://localhost:9200/tuto-$(date -d '1 day ago' '+%Y-%m-%d')/_doc -d '{ "TEST":"TTT" }' > /dev/null
    curl -s -H 'Content-Type: application/json' -XPOST http://localhost:9200/tuto-$(date -d '0 day ago' '+%Y-%m-%d')/_doc -d '{ "TEST":"TTT" }' > /dev/null
}

function delete_name_indices
{
    if [ -z $1 ]; then
        echo "##########################################################"
        cat action/delete_name.action.yml
        echo "##########################################################"
        /bin/curator --dry-run --config config/es.config.yml action/delete_name.action.yml # dry-run
        cat logs/curator.log
        \rm logs/curator.log
    elif [ $1 == "real" ]; then
        /bin/curator --config config/es.config.yml action/delete_name.action.yml # dry-run
        cat logs/curator.log
        \rm logs/curator.log
    else
        echo "Incorrect parameter"
    fi

}

function add_alias
{
    curl -s -H 'Content-Type: application/json' -XPOST http://localhost:9200/tuto-$(date -d '1 day ago' '+%Y-%m-%d')/_aliases/tuto-today > /dev/null
    if [ -z $1 ]; then
        echo "##########################################################"
        cat action/alias.action.yml
        echo "##########################################################"
        /bin/curator --dry-run --config config/es.config.yml action/alias.action.yml # dry-run
        cat logs/curator.log
        \rm logs/curator.log
    elif [ $1 == "real" ]; then
        /bin/curator --config config/es.config.yml action/alias.action.yml # dry-run
        cat logs/curator.log
        \rm logs/curator.log
    else
        echo "Incorrect parameter"
    fi

}

function close_indices
{
    if [ -z $1 ]; then
        echo "##########################################################"
        cat action/close.action.yml
        echo "##########################################################"
        /bin/curator --dry-run --config config/es.config.yml action/close.action.yml # dry-run
        cat logs/curator.log
        \rm logs/curator.log
    elif [ $1 == "real" ]; then
        /bin/curator --config config/es.config.yml action/close.action.yml 
        cat logs/curator.log
        \rm logs/curator.log
    else
        echo "Incorrect parameter"
    fi

}

function open_indices
{
    if [ -z $1 ]; then
        echo "##########################################################"
        cat action/open.action.yml
        echo "##########################################################"
        /bin/curator --dry-run --config config/es.config.yml action/open.action.yml # dry-run
        cat logs/curator.log
        \rm logs/curator.log
    elif [ $1 == "real" ]; then
        /bin/curator --config config/es.config.yml action/open.action.yml # dry-run
        cat logs/curator.log
        \rm logs/curator.log
    else
        echo "Incorrect parameter"
    fi

}

function forcemerge_indices
{
    if [ -z $1 ]; then
        echo "##########################################################"
        cat action/forcemerge.action.yml
        echo "##########################################################"
        /bin/curator --dry-run --config config/es.config.yml action/forcemerge.action.yml # dry-run
        cat logs/curator.log
        \rm logs/curator.log
    elif [ $1 == "real" ]; then
        /bin/curator --config config/es.config.yml action/forcemerge.action.yml # dry-run
        cat logs/curator.log
        \rm logs/curator.log
    else
        echo "Incorrect parameter"
    fi

}

function rollover_indices
{
    curl -s -H 'Content-Type: application/json' -XPUT http://localhost:9200/rollover-curator-000001 -d '
    {
        "aliases": {
            "rollover-write": {},
            "rollover-read": {}
        }
    }
    ' > /dev/null
    curl -s -H 'Content-Type: application/json' -XPOST http://localhost:9200/rollover-write/_doc -d '{ "TEST":"TTT" }' > /dev/null
    curl -s -H 'Content-Type: application/json' -XPOST http://localhost:9200/rollover-write/_doc -d '{ "TEST":"TTT" }' > /dev/null
    curl -s -H 'Content-Type: application/json' -XPOST http://localhost:9200/rollover-write/_doc -d '{ "TEST":"TTT" }' > /dev/null

    if [ -z $1 ]; then
        echo "##########################################################"
        cat action/rollover.action.yml
        echo "##########################################################"
        /bin/curator --dry-run --config config/es.config.yml action/rollover.action.yml # dry-run
        sleep 3
        /bin/curator --dry-run --config config/es.config.yml action/rollover_alias.action.yml # dry-run
        cat logs/curator.log
        \rm logs/curator.log
    elif [ $1 == "real" ]; then
        /bin/curator --config config/es.config.yml action/rollover.action.yml # dry-run
        sleep 3
        /bin/curator --config config/es.config.yml action/rollover_alias.action.yml # dry-run
        cat logs/curator.log
        \rm logs/curator.log
    else
        echo "Incorrect parameter"
    fi

}

function towarm_indices
{
    if [ -z $1 ]; then
        echo "##########################################################"
        cat action/warm.action.yml
        echo "##########################################################"
        /bin/curator --dry-run --config config/es.config.yml action/warm.action.yml # dry-run
        cat logs/curator.log
        \rm logs/curator.log
    elif [ $1 == "real" ]; then
        /bin/curator --config config/es.config.yml action/warm.action.yml # dry-run
        cat logs/curator.log
        \rm logs/curator.log
    else
        echo "Incorrect parameter"
    fi

}

if [ -z $1 ]; then
        echo "##################### Menu ##############"
        echo " $ ./cur.sh [Command]"
        echo "#####################%%%%%%##############"
        echo "         1 : delete all indices by duration without kibana index"
        echo "         2 : create test indices"
        echo "         3 : delete all indices by name without kibana index"
        echo "         4 : add a alias"
        echo "         5 : close indices"
        echo "         6 : open indices"
        echo "         7 : forcemerge indices"
        echo "         8 : rollover indices"
        echo "         9 : towarm indices"
        echo "#########################################";
        exit 1;
fi

case "$1" in
        "1" ) delete_duration_indices $2;;
        "2" ) create_indices;;
        "3" ) delete_name_indices $2;;
        "4" ) add_alias $2;;
        "5" ) close_indices $2;;
        "6" ) open_indices $2;;
        "7" ) forcemerge_indices $2;;
        "8" ) rollover_indices $2;;
        "9" ) towarm_indices $2;;
        *) echo "Incorrect Command" ;;
esac
