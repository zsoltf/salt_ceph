{% set rgw = salt['mine.get']('ceph:role:rgw', 'test.ping', 'grain') | join(' ') %}

ceph-cluster-rgws:
  cmd.run:
    - name: ceph-deploy rgw create {{ rgw }}
    - cwd: /home/ceph-admin/ceph
    - runas: ceph-admin
