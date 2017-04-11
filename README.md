## Ansible Playbooks
My customized ansible scripts which help to manage or deploy something

## INSTRUCTIONS

    $ ansible-playbook -vvvi hosts playbooks/[playbook-filename]
    e,g:
    $ ansible-playbook -vvvi hosts playbooks/initenv.yml

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

## playbook: np(Nignx+PHP)
Create a Nignx PHP environment
- ensure specific php version installed
- ensure speicfic php-fpm version installed
- configure php-fpm to work with nginx
- ensure nginx installed
- configure nginx to work with php-fpm

### playbook: ensure-pip
Ensure a specific Pip vesrion installed

