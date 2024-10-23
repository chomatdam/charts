# Helm Charts Repository

## KubeVirt Data Volumes

This example will create a Data Volume (DV) for an Ubuntu 24.04 desktop image.

```shell
WORK_DIR=examples/kubevirt-dvs
helm upgrade --install data-volumes $WORK_DIR/../../charts/kubevirt-dvs \
  --namespace base-images \
  --create-namespace \
  --values $WORK_DIR/values.yaml
```

```shell
helm uninstall data-volumes -n base-images
```

## KubeVirt VMs

### Image Builder

This example provisions a KubeVirt VM as an image builder. The VM is based on an Ubuntu 24.04 image pulled from a
snapshot and data volume created with the first chart.

```shell
WORK_DIR=examples/kubevirt-vm/kubevirt-image-builder
helm dependency update $WORK_DIR
helm dependency build $WORK_DIR
helm upgrade --install image-builder $WORK_DIR --namespace image-builder --create-namespace
```

```shell
helm uninstall image-builder -n image-builder
```
