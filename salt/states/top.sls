base:
  '*':
    - test

  'app:ceph':
    - match: grain
    - ceph
