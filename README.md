# Custom RHCOS image layering

This repository contains a `Containerfile` to build a custom container image to install a custom `NetworkManager` RPM packages with fix for https://issues.redhat.com/browse/RHEL-67324.

## Prerequisites

- [Podman](https://podman.io/) installed
- Access to [Quay.io](https://quay.io) with an account

## Steps to Build and Push the Image

### 1. Clone or Prepare the Repository
Ensure you have the following files in the same directory:
- `Containerfile` 

### 2. Build the Container Image
Run the following command to build the container image:
```bash
$ export OCP_VERSION="4.14.38"
$ VARIABLE_NAME=$(curl -s https://mirror.openshift.com/pub/openshift-v4/clients/ocp/$OCP_VERSION/release.txt | grep -m1 'rhel-coreos' | awk -F ' ' '{print $2}')
$ build -t networkmanager-1.42.2-30.rmroutes.x86_64:${OCP_VERSION} --no-cache --build-arg rhel_coreos_release=${VARIABLE_NAME} .
$ podman tag localhost/networkmanager-1.42.2-30.rmroutes.x86_64:${OCP_VERSION} quay.io/jclaret/networkmanager-1.42.2-30.rmroutes.x86_64:${OCP_VERSION}
$ podman push quay.io/jclaret/networkmanager-1.42.2-30.rmroutes.x86_64:${OCP_VERSION}
```

## How to apply the NetworkManager RPMS to OCP using MachineConfig:

- for `master` nodes:

```bash
$ oc create -f machine-config-nmanager-hotfix-master.yaml
```

- for `worker` nodes:

```bash
$ oc create -f machine-config-nmanager-hotfix-worker.yaml
```

### 4. Refs
* https://docs.openshift.com/container-platform/4.14/post_installation_configuration/coreos-layering.html#coreos-layering-updating_coreos-layering
* https://github.com/openshift/rhcos-image-layering-examples/
