admin-node = ceph-admin
mon-nodes = ceph-mon-1 ceph-mon-2 ceph-mon-3
osd-nodes = ceph-osd-1 ceph-osd-2 ceph-osd-3
salt = salt

all: salt admin mon osd
.PHONY: all

default: multipass

multipass:
	which multipass

salt: cloud-init/$(salt).yaml multipass
	@echo
	@echo Creating Salt Master $(salt)
	@echo
	@multipass list | grep $(salt) || (multipass launch -c 2 -n $(salt) --cloud-init cloud-init/$(salt).yaml && \
	  multipass mount ../ $(salt):/srv/ && \
	  multipass exec $(salt) -- sudo cp /srv/test/master.conf /etc/salt/master.d/ && \
	  multipass exec $(salt) -- sudo service salt-master restart && \
	  sleep 2 && \
	  multipass exec $(salt) -- sudo salt-key)

admin: cloud-init/admin.yaml multipass salt
	@echo
	@echo Creating Admin Node
	@echo
	@echo $(admin-node) | xargs -n1 multipass launch --cloud-init cloud-init/admin.yaml -n

mon: cloud-init/mon.yaml multipass salt
	@echo
	@echo Creating Mon Nodes
	@echo
	@echo $(mon-nodes) | xargs -n1 multipass launch -c 2 -m 2G --cloud-init cloud-init/mon.yaml -n

osd: cloud-init/osd.yaml multipass salt
	@echo
	@echo Creating Osd Node
	@echo
	@echo $(osd-nodes) | xargs -n1 multipass launch -c 2 -m 2G --cloud-init cloud-init/osd.yaml -n

clean: multipass
	@echo $(admin-node) $(mon-nodes) $(osd-nodes) | xargs -n1 echo multipass delete --purge
