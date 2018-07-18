#!/bin/bash
set -e

#HAS_RUN=/tmp/get-shared-tools-has-run
#if [ ! -f "${HAS_RUN}" ]; then

    HELM_VERSION="helm-v2.8.2-linux-amd64.tar.gz"
    KUBECTL_VERSION="v1.8.12"
    TOOLS_PATH=/tmp/tools

    ###################################################################
    # Start
    ###################################################################
    echo
    echo "Installing Prerequisites for build"
    echo

    mkdir -p ${TOOLS_PATH}
    cd ${TOOLS_PATH}


    ###################################################################
    # AWS
    ###################################################################
    if [ ! -x /usr/local/bin/aws ]; then
        mkdir -p ${TOOLS_PATH}/aws-cli
        pushd ${TOOLS_PATH}/aws-cli
        if [ ! -d install ]; then
            if [ ! -d awscli-bundle ]; then
                echo "[+] Downloading AWS CLI"
                curl -sSLO "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip"
                unzip awscli-bundle.zip
            fi
            echo
            echo "[+] Installing AWS CLI"
            echo
            time ./awscli-bundle/install -i $(pwd)/install -b ${TOOLS_PATH}/aws
        fi
        ln -s ${TOOLS_PATH}/aws /usr/local/bin/aws
        popd
    fi
    aws --version

    ###################################################################
    # Kubernetes
    ###################################################################
    if [ ! -x /usr/local/bin/kubectl ]; then
        if [ ! -x ${TOOLS_PATH}/kubectl ]; then
            echo
            echo "[+] Downloading kubectl"
            echo
            curl -sSLO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
            chmod +x kubectl
        fi
        cp ${TOOLS_PATH}/kubectl /usr/local/bin
    fi

    echo "TODO [+] Configuring kubectl"
    kubectl config set-cluster ${KUBERNETES_CLUSTER} --server=${KUBERNETES_SERVER} --insecure-skip-tls-verify=true
    kubectl config set-credentials ${KUBERNETES_USER} --token=${KUBERNETES_TOKEN}
    kubectl config set-context pipeline-context --cluster=${KUBERNETES_CLUSTER} --user=${KUBERNETES_USER}
    kubectl config use-context pipeline-context

    echo
    echo "[+] Verify kubectl connectivity"
    echo
    kubectl version

    ###################################################################
    # HELM 
    ###################################################################

    if [ ! -x /usr/local/bin/helm ]; then
        if [ ! -x ${TOOLS_PATH}/helm ]; then
            echo
            echo "[+] Downloading helm"
            echo
            curl -sSLO https://storage.googleapis.com/kubernetes-helm/${HELM_VERSION}
            tar -xzf ${HELM_VERSION}
            mv linux-amd64/* .
            rm -rf linux-amd64
        fi
        cp ${TOOLS_PATH}/helm /usr/local/bin
    fi
    echo
    echo "[+] Verify helm connectivity"
    echo
    helm version

    ###################################################################
    # Done
    ###################################################################
    echo
    echo "Prerequisites completed."
    echo

#    touch "${HAS_RUN}"
#fi
