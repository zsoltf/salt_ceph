include:
  - .repo

ceph-deploy:
  pkg.installed:
    - name: ceph-deploy
    - require:
      - pkgrepo: ceph-repo

ceph-admin-user:
  user.present:
    - name: ceph-admin
    - fullname: Cephalopod Adminicus
    - shell: /bin/bash
    - home: /home/ceph-admin
    - groups:
      - admin
      - sudo

generate-admin-key:
  cmd.run:
    - name: ssh-keygen -t rsa -b 4096
    - creates:
      - /home/ceph-admin/.ssh/id_rsa.pub
      - /home/ceph-admin/.ssh/id_rsa.key

push-admin-pub-key:
  module.wait:
    - name: cp.push
    - path: /home/ceph-admin/.ssh/id_rsa.pub
