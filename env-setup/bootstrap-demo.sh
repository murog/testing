#!/usr/bin/env bash

set -e

if [[ $OSTYPE == "linux-gnu" && $CLOUD_SHELL == true ]]; then 

    ./common/install-tools.sh
    
    echo -e "\nMultiple tasks are running asynchronously to setup your environment.  It may appear frozen, but you can check the logs in $WORK_DIR for additional details in another terminal window." 

    ./gke/provision-gke.sh &> ${WORK_DIR}/provision-gke.log
    wait

    kubectx belgium && ./config-management/install-config-operator.sh && ./config-management/install-config-sync.sh
    kubectx taiwan && ./config-management/install-config-operator.sh && ./config-management/install-config-sync.sh

else
    echo "This has only been tested in GCP Cloud Shell.  Only Linux (debian) is supported".
fi
