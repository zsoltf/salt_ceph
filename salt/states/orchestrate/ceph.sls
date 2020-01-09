install-ceph-deploy:
  salt.state:
    - tgt: 'ceph:role:deploy'
    - tgt_type: grain
    - sls:
        - ceph.deploy
        - ceph.deploy.bootstrap

prepare-ceph-nodes:
  salt.state:
    - tgt: 'ceph:role'
    - tgt_type: grain
    - sls:
        - ceph.node
        - ceph.network

ceph-deploy-mon:
  salt.state:
    - tgt: 'ceph:role:deploy'
    - tgt_type: grain
    - sls: ceph.deploy.mon
    - require:
        - salt: prepare-ceph-nodes

ceph-deploy-admin:
  salt.state:
    - tgt: 'ceph:role:deploy'
    - tgt_type: grain
    - sls: ceph.deploy.admin
    - require:
        - salt: ceph-deploy-mon

ceph-deploy-osd:
  salt.state:
    - tgt: 'ceph:role:deploy'
    - tgt_type: grain
    - sls: ceph.deploy.osd
    - require:
        - salt: ceph-deploy-mon

ceph-deploy-mds:
  salt.state:
    - tgt: 'ceph:role:deploy'
    - tgt_type: grain
    - sls: ceph.deploy.mds
    - require:
        - salt: ceph-deploy-osd

ceph-deploy-rgw:
  salt.state:
    - tgt: 'ceph:role:deploy'
    - tgt_type: grain
    - sls: ceph.deploy.rgw
    - require:
        - salt: ceph-deploy-osd
