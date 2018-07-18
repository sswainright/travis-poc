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
    echo "Installing Prerequisites for build"

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

            echo "[+] Installing AWS CLI"
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
            echo "[+] Downloading kubectl"
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

    echo "[+] Verify kubectl connectivity"
    kubectl version

    ###################################################################
    # HELM 
    ###################################################################

    if [ ! -x /usr/local/bin/helm ]; then
        if [ ! -x ${TOOLS_PATH}/helm ]; then
            echo "[+] Downloading helm"
            curl -sSLO https://storage.googleapis.com/kubernetes-helm/${HELM_VERSION}
            tar -xzf ${HELM_VERSION}
            mv linux-amd64/* .
            rm -rf linux-amd64
        fi
        cp ${TOOLS_PATH}/helm /usr/local/bin
    fi
    echo "[+] Verify helm connectivity"
    helm version

    ###################################################################
    # Done
    ###################################################################
    echo "Prerequisites completed."

#    touch "${HAS_RUN}"
#fi
