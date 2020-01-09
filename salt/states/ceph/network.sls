{% set cluster_mine = salt['mine.get']('ceph:role', 'ip', 'grain') | dictsort() %}
{% set ceph_domain = salt['pillar.get']('ceph:domain') %}
{% set ceph_network = salt['pillar.get']('ceph:public_network') %}

{% for name, ips in cluster_mine %}
{% for ip in ips if salt['network.ip_in_subnet'](ip, ceph_network) %}

ceph-etc_hosts_{{ name }}:
  host.present:
    - name: {{ [name, ceph_domain]|join('.') }}
    - ip: {{ ip }}
    - clean: True

{% endfor %}
{% endfor %}
