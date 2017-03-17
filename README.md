# Ansible Playbooks

## playbook: initenv(mostly works for VPS initialzation)
Initialize a minimal Linux env for production ready env
 - add a normal user and setup password
 - enable sudo and add normal user to sudoers
 - enable additional package repository
 - ensure pip is installed and at the latest version
 - harden Linux to add protection for security

## playbook: dnu(django+Nginx+uWSGI)
Create a Django development env with Nginx + uWsgi
- ensure specific python version isntalled
- ensure specific pip version install
- ensure virtualenv installed
- install django specific version in virtualenv