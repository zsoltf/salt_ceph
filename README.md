# Salt Ceph

Create a Ceph cluster with Salt and ceph-deploy.

This state follows the official [ceph-deploy installation guide](https://docs.ceph.com/docs/nautilus/start/).

Works with Ubuntu. Centos/Fedora support will be added later.

## Quickstart

### Prepare

Edit `pillar/ceph.sls`

Set ceph:role grain on hosts to mon, osd, admin, rgw or deploy
```
salt 'frigate-1' grains.append ceph:role admin
salt 'frigate-1' grains.append ceph:role deploy
salt 'frigate-*' grains.append ceph:role mon
salt 'frigate-*' grains.append ceph:role mds
salt 'frigate-*' grains.append ceph:role rgw
salt 'carrier-*' grains.set ceph:role osd
```

### Orchestrate
```
  salt-run state.orch orchestrate.ceph
```

### Cleanup
Purge the cluster, all data and keys
```
  salt -G ceph:role:osd state.sls ceph.zap
  salt -G ceph:role:deploy state.sls ceph.deploy.purge
```
