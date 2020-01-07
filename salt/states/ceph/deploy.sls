{% set mon_nodes = salt['mine.get']('ceph:role:mon', 'ip', 'grain') | dictsort() %}
{% set osd_nodes = salt['mine.get']('ceph:role:osd', 'ip', 'grain') | dictsort() %}

{% set mons = mon_nodes|map('first')|join(' ') %}
{% set osds = osd_nodes|map('first')|join(' ') %}
{% set all = mons + ' ' + osds %}

testo:
  test.nop:
    - mons: {{ mons }}
    - osds: {{ osds }}
    - all: {{ mons + ' ' + osds }}

ceph-common:
  pkg.installed: []

ceph-cluster-dir:
  file.directory:
    - name: /home/ceph-admin/ceph
    - user: ceph-admin

ceph-cluster-new:
  cmd.run:
    - name: ceph-deploy new {{ mons }}
    - cwd: /home/ceph-admin/ceph
    - runas: ceph-admin
    - require:
        - file: ceph-cluster-dir

# network config: public network = {ip-address}/{bits}

ceph-cluster-install:
  cmd.run:
    - name: ceph-deploy install {{ all }}
    - cwd: /home/ceph-admin/ceph
    - runas: ceph-admin
    - require:
        - cmd: ceph-cluster-new

ceph-cluster-initial-mons:
  cmd.run:
    - name: ceph-deploy mon create-initial
    - cwd: /home/ceph-admin/ceph
    - runas: ceph-admin
    - require:
        - cmd: ceph-cluster-install

ceph-cluster-mgr:
  cmd.run:
    - name: ceph-deploy mgr create {{ mons }}
    - cwd: /home/ceph-admin/ceph
    - runas: ceph-admin
    - require:
        - cmd: ceph-cluster-initial-mons

ceph-cluster-admin:
  cmd.run:
    - name: ceph-deploy admin ceph-admin
    - cwd: /home/ceph-admin/ceph
    - runas: ceph-admin
    - require:
        - cmd: ceph-cluster-initial-mons

# ceph-deploy osd create --data /dev/sda node1

# sudo ceph health
# sudo ceph -s