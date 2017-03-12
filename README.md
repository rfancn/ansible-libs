# Ansible Playbooks

Each sub directory is an ansible playbook for specific purpose, you can download it and run with ansible.

## INSTRUCATIONS

    # pip install ansible
    # cd <playbook_name>
    # ansible-playbook -vvi hosts site.yml

## init_env
Initialize a minimal Linux env for development or production ready env
 - add a normal user and setup password
 - enable sudo and add normal user to sudoers
 - enable additional package repository
 - ensure pip is installed and at the latest version
 - harden Linux to add protection for security
