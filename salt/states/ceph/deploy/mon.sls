{% set mon = salt['mine.get']('ceph:role:mon', 'test.ping', 'grain') | join(' ') %}

ceph-cluster-initial-mons:
  cmd.run:
    - name: ceph-deploy mon create-initial
    - cwd: /home/ceph-admin/ceph
    - runas: ceph-admin

ceph-cluster-mgr:
  cmd.run:
    - name: ceph-deploy mgr create {{ mon }}
    - cwd: /home/ceph-admin/ceph
    - runas: ceph-admin
    - require:
        - cmd: ceph-cluster-initial-mons

ceph-cluster-health:
  cmd.wait:
    - name: sudo ceph -s
    - cwd: /home/ceph-admin/ceph
    - runas: ceph-admin
    - watch:
        - cmd: ceph-cluster-mgr
