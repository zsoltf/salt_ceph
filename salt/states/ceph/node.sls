ntpsec:
  pkg.installed: []

openssh-server:
  pkg.installed: []

ceph-admin-user:
  user.present:
    - name: ceph-admin
    - fullname: Cephalopod Adminicus
    - shell: /bin/bash
    - home: /home/ceph-admin
    - groups:
      - admin
      - sudo

# ceph-admin passwordless sudo

ceph-admin-ssh-auth:
  ssh_auth.present:
    - name: ceph admin key
    - user: ceph-admin
    - enc: ssh-rsa
    - source: salt://minionfs/ceph-admin/id_rsa.pub
    - require:
      - user: ceph-admin-user

# ssh config
