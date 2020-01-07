{% set cluster_mine = salt['mine.get']('app:ceph', 'ip', 'grain') | dictsort() %}

ntpsec:
  pkg.installed: []

openssh-server:
  pkg.installed: []

python-minimal:
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

ceph-admin-sudo:
  file.managed:
    - name: /etc/sudoers.d/ceph-admin
    - contents: ceph-admin ALL = (root) NOPASSWD:ALL
    - mode: 440

ceph-admin-ssh-auth:
  ssh_auth.present:
    - name: ceph admin key
    - user: ceph-admin
    - enc: ssh-rsa
    - source: salt://minionfs/ceph-admin/home/ceph-admin/.ssh/id_rsa.pub
    - require:
      - user: ceph-admin-user

{% for name, ips in cluster_mine %}

ceph-etc_hosts_{{ name }}:
  host.present:
    - name: {{ name }}
    - ip: {{ ips|first }}
    - clean: True
    - require:
        - user: ceph-admin-user

{% endfor %}
