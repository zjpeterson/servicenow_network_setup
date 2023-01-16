# servicenow_network_setup

This project aims to create a collection of turn-key network automation solutions using Red Hat Ansible Automation Platform and ServiceNow Now Platform.

Collection: https://galaxy.ansible.com/zjpeterson/servicenow_network

Execution Envionment: [quay.io/zachp/servicenow_network](https://quay.io/repository/zachp/servicenow_network)

Intended to work with: https://github.com/zjpeterson/servicenow_network_content

## Requirements

- `ansible-core` 2.11 or later
- `ansible-navigator` 2.0.0 or later

## Setup

You will need the files located under `setup/` in this repository. The rest of the repository is packaged into a collection `zjpeterson.servicenow_network` and can be ignored for setup purposes.

1. Fill out `inventory_setup.yml` according to your environment
2. Run `ansible-navigator run playbook_setup.yml`
3. *If running against a workshop:* Run `ansible-navigator run playbook_workshop.yml`
4. Access the configured Automation Controller and update the "Network Devices" credential object with valid data for accessing the network devices. *For workshops:* the username will be `ec2-user` and the private key data can be found in `/home/student/.ssh/id_rsa` on the code/controller machine

## Support

This project supports network devices running the following operating systems:

- Cisco IOS (IOS-XE and legacy IOS)
- Cisco NX-OS
- Juniper JunOS
- Arista EOS

## Testing

This is desgned to be tested (and demoed) against an [Ansible Network Automation Workshop](https://github.com/ansible/workshops) student seat and a ServiceNow [Personal Development Instance](https://developer.servicenow.com/dev.do). The workshop can be provisioned [in AWS](https://aap2.demoredhat.com/provisioner/README.html) or Red Hat employees can use [RHPDS](https://demo.redhat.com/).

The playbook `playbook_workshop.yml` can be used to set these environments up prior to running `playbook_setup.yml`.

## Assumptions

Use of this setup makes a number of assumptions about the environment it will be managing, including but not limited to:

- Network devices are populated in the ServiceNow Network Gear table (cmdb_ci_netgear) or one of its child tables
- The Ansible Automation Controller machine is an acceptable place to store backups and software images

## Problems

- Controller has no built-in way to sync inventory from ServiceNow, so it needs to be done with an inventory source file. Controller also does not support using such a file from a local/manual type project (and discussion of this was [closed upstream](https://github.com/ansible/awx/issues/1288)). This means that we can't avoid getting the dynamic inventory definition via Git, unless you were to do some kind of CLI-based workaround, which is unintuitive and would be practically invisible from the Controller UI. For that reason, the actual Ansible content (inventory and playbooks) are in [another repository](https://github.com/zjpeterson/servicenow_network_content).
- Don't know of a programmitic way to assign reports to a dashboard; has to be done by hand
- Time since last backup does not update regularly and causes the backup report to be wrong; possibly needs to be made a different way?
- Can't get Ansible Spoke installed in a PDI, so have to build service catalog a different way +  don't know how to affect Ansible Spoke via REST anyway
- Can't get a table built to track all available backup date/times as the REST API rejects a table creation with no columns - no docs available on how to provide columns at create time
- Currently have to the use bootstrap `playbook_setup.yml` to consume this; the idea was originally to run playbooks [directly from the collection](https://docs.ansible.com/ansible/latest/collections_guide/collections_using_playbooks.html#using-a-playbook-from-a-collection), but `ansible-navigator` currently can't do it. Issue filed upstream https://github.com/ansible/ansible-navigator/issues/1385
- Currently assuming connected environment, several changes needed to make this work without an internet connection
- Image upgrade currently a placeholder that only uploads an image file to the target, need to work on this with upgradeable hardware
- Software reports are not interesting to look at due to the low amount and diversity of equipment in a workshop
