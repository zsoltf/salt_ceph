base:

  '*':
    - test
    - ip-mine

  'app:ceph':
    - match: grain
    - ceph
