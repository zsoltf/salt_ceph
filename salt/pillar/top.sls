base:

  '*':
    - test
    - ip-mine

  'ceph:role':
    - match: grain
    - ceph
