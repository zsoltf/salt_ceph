install-ceph-deploy:
  salt.state:
    - tgt: 'ceph:role:admin'
    - tgt_type: grain
    - sls: ceph.bootstrap

prepare-ceph-nodes:
  salt.state:
    - tgt: 'ceph:role'
    - tgt_type: grain
    - sls: ceph.node

ceph-deploy-cluster:
  salt.state:
    - tgt: 'ceph:role:admin'
    - tgt_type: grain
    - sls: ceph.deploy
