# Ansible Playbooks

<<<<<<< HEAD
## playbook: initenv(mostly works for VPS initialzation)
Initialize a minimal Linux env for production ready env
=======
Each sub directory is an ansible playbook for specific purpose, you can download it and run with ansible.

## Instructions

    # pip install ansible
    $ cd <playbook_name>
    - Edit hosts file according to ansible document, e,g:
    <hostnameA>:<host portA> ansible_user=root ansible_ssh_password=
    <hostnameB>:<host portB> ansible_user=oracle ansible_ssh_password=
    ...    
    $ ansible-playbook -vvi hosts site.yml

## Playbooks
### init_env
Initialize a minimal Linux env for development or production ready env
>>>>>>> 61bd834aad37df366d15e032d35b4641507fc172
 - add a normal user and setup password
 - enable sudo and add normal user to sudoers
 - enable additional package repository
 - ensure pip is installed and at the latest version
 - harden Linux to add protection for security
<<<<<<< HEAD

## playbook: dnu(django+Nginx+uWSGI)
Create a Django development env with Nginx + uWsgi
- ensure specific python version isntalled
- ensure specific pip version install
- ensure virtualenv installed
- install django specific version in virtualenv
=======
>>>>>>> 61bd834aad37df366d15e032d35b4641507fc172
