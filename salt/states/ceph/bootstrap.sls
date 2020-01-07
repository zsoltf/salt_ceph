{% set cluster_mine = salt['mine.get']('app:ceph', 'ip', 'grain') | dictsort() %}

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
    - name: ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
    - runas: ceph-admin
    - creates:
      - /home/ceph-admin/.ssh/id_rsa.pub
      - /home/ceph-admin/.ssh/id_rsa.key
    - require:
        - user: ceph-admin-user

push-admin-pub-key:
  module.wait:
    - name: cp.push
    - path: /home/ceph-admin/.ssh/id_rsa.pub
    - watch:
        - cmd: generate-admin-key


{% for name, ips in cluster_mine %}

ceph-admin-known-host_{{ name }}:
  cmd.run:
    - name: ssh-keyscan -H {{ name }} >> ~/.ssh/known_hosts
    - runas: ceph-admin
    - require:
        - user: ceph-admin-user

{% endfor %}
