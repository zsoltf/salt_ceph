{% set mds = salt['mine.get']('ceph:role:mds', 'test.ping', 'grain') | join(' ') %}

ceph-cluster-mds:
  cmd.run:
    - name: ceph-deploy mds create {{ mds }}
    - cwd: /home/ceph-admin/ceph
    - runas: ceph-admin
