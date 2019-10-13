#!/bin/bash

function delete_indices
{
    /bin/curator --dry-run --config config/delete_duration.config.yml action/es.action.yml # dry-run
    cat logs/curator.log
    #/bin/curator --config config/es.config.yml action/es.action.yml # real
}

##/bin/curator --dry-run --config config/es.config.yml action/alias_es.action.yml
##/bin/curator --config config/es.config.yml action/alias_es.action.yml
##
##/bin/curator --dry-run --config config/es.config.yml action/close_es.action.yml
##/bin/curator --config config/es.config.yml action/close_es.action.yml
##
##/bin/curator --dry-run --config config/es.config.yml action/delete_es.action.yml
##/bin/curator --config config/es.config.yml action/delete_es.action.yml
##
##/bin/curator --dry-run --config config/es.config.yml action/delete_name_es.action.yml
##/bin/curator --config config/es.config.yml action/delete_name_es.action.yml
##
##/bin/curator --dry-run --config config/es.config.yml action/force_es.action.yml
##/bin/curator --config config/es.config.yml action/force_es.action.yml
##
##/bin/curator --dry-run --config config/es.config.yml action/rollover_es.action.yml
##/bin/curator --config config/es.config.yml action/rollover_es.action.yml
##
##/bin/curator --dry-run --config config/es.config.yml action/warm_es.action.yml
##/bin/curator --config config/es.config.yml action/warm_es.action.yml

if [ -z $1 ]; then
        echo "##################### Menu ##############"
        echo " $ ./cur.sh [Command]"
        echo "#####################%%%%%%##############"
        echo "         1 : delete all indices without kibana index"
        echo "         2 : configure es hot template"
        echo "         3 : install elasticdump package"
        echo "         4 : install telegram package"
        echo "         5 : install ansible package"
        echo "#########################################";
        exit 1;
fi

case "$1" in
        "1" ) delete_indices;;
        "2" ) configure_es_template;;
        "3" ) install_elasticdump_package;;
        "4" ) install_telegram_package;;
        "5" ) install_ansible_package;;
        *) echo "Incorrect Command" ;;
esac
