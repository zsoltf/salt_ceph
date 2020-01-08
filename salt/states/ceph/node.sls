{% set cluster_mine = salt['mine.get']('ceph:role', 'ip', 'grain') | dictsort() %}
{% set cluster_admin = salt['mine.get']('ceph:role:admin', 'test.ping', 'grain') | first %}

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
    - source: salt://minionfs/{{ cluster_admin }}/home/ceph-admin/.ssh/id_rsa.pub
    - require:
      - user: ceph-admin-user

{% for name, ips in cluster_mine %}

ceph-etc_hosts_{{ name }}:
  host.present:
    - name: {{ name }}.fiber
    - ip: {{ ips|first }}
    - clean: True
    - require:
        - user: ceph-admin-user

{% endfor %}
