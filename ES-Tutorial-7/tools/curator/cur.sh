#!/bin/bash

/bin/curator --dry-run --config config/es.config.yml action/es.action.yml # dry-run
/bin/curator --config config/es.config.yml action/es.action.yml # real

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
