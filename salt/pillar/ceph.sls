{% load_yaml as map %}

base:
  release: nautilus

boneyard:

  domain: fiber
  public_network: '10.130.1.0/24'

  osds:
    carrier-1:
      - /dev/sdb
      - /dev/sdc
      - /dev/sdd
      - /dev/sde
      - /dev/sdf

    carrier-3:
      - /dev/sda
      - /dev/sdb
      - /dev/sdc
      - /dev/sdd
      - /dev/sdf

    carrier-4:
      - /dev/sdb
      - /dev/sdc
      - /dev/sdd
      - /dev/sde
      - /dev/sdf
      - /dev/sdg
      - /dev/sdh
      - /dev/sdi
      - /dev/sdj
      - /dev/sdk
      - /dev/sdl
      - /dev/sdm
      - /dev/sdn
      - /dev/sdo
      - /dev/sdq
      - /dev/sdr
      - /dev/sds
      - /dev/sdt
      - /dev/sdu
      - /dev/sdv
      - /dev/sdw
      - /dev/sdx
      - /dev/sdy

{% endload %}
{% set ceph = salt['grains.filter_by'](map, grain='datacenter', base='base') %}

ceph:
  {{ ceph|yaml }}
