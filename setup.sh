#!/usr/bin/env bash

DEBUG=$1

##################################
# ANSI colorized action function #
##################################
BOOTUP=color
RES_COL=60
MOVE_TO_COL="echo -en \\033[${RES_COL}G"
SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_WARNING="echo -en \\033[1;33m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"

echo_success()
{
  [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
  echo -n "["
  [ "$BOOTUP" = "color" ] && $SETCOLOR_SUCCESS
  echo -n $"  OK  "
  [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
  echo -n "]"
  echo -ne "\r"
  return 0
}

echo_failure()
{
  [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
  echo -n "["
  [ "$BOOTUP" = "color" ] && $SETCOLOR_FAILURE
  echo -n $"FAILED"
  [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
  echo -n "]"
  echo -ne "\r"
  return 1
}

echo_passed() {
  [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
  echo -n "["
  [ "$BOOTUP" = "color" ] && $SETCOLOR_WARNING
  echo -n $"PASSED"
  [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
  echo -n "]"
  echo -ne "\r"
  return 1
}

echo_warning() {
  [ "$BOOTUP" = "color" ] && $MOVE_TO_COL
  echo -n "["
  [ "$BOOTUP" = "color" ] && $SETCOLOR_WARNING
  echo -n $"WARNING"
  [ "$BOOTUP" = "color" ] && $SETCOLOR_NORMAL
  echo -n "]"
  echo -ne "\r"
  return 1
}

# Log that something succeeded
success() {
  [ "$BOOTUP" != "verbose" -a -z "${LSB:-}" ] && echo_success
  return 0
}

# Log that something failed
failure() {
  local rc=$?
  [ "$BOOTUP" != "verbose" -a -z "${LSB:-}" ] && echo_failure
  [ -x /bin/plymouth ] && /bin/plymouth --details
  return $rc
}

# Log that something passed, but may have had errors. Useful for fsck
passed() {
  local rc=$?
  [ "$BOOTUP" != "verbose" -a -z "${LSB:-}" ] && echo_passed
  return $rc
}

# Log a warning
warning() {
  local rc=$?
  [ "$BOOTUP" != "verbose" -a -z "${LSB:-}" ] && echo_warning
  return $rc
}

# Run some action. Log its output.
fn_action() {
  local STRING rc

  STRING=$1
  echo -n "$STRING "
  shift
  "$@" && success $"$STRING" || failure $"$STRING"
  rc=$?
  echo
  return $rc
}

fn_get_os_info()
{
    OSTYPE=`uname -s`
    OSREV=`uname -r`
    OSMACH=`uname -m`

    if [ "${OSTYPE}" = "SunOS" ] ; then
	    OSTYPE=Solaris
	    OSARCH=`uname -p`
	    OSSTR="${OSTYPE} ${OSREV}(${ARCH} `uname -v`)"
    elif [ "${OSTYPE}" = "AIX" ] ; then
	    OSSTR="${OSTYPE} `oslevel` (`oslevel -r`)"
    elif [ "${OSTYPE}" = "Linux" ] ; then
	    OSKERNEL=`uname -r`
	    if [ -f /etc/oracle-release ] ; then
		    OSDIST='OracleLinux'
		    PSUEDONAME=`cat /etc/oracle-release | sed s/.*\(// | sed s/\)//`
		    OSREV=`cat /etc/oracle-release | sed s/.*release\ // | sed s/\ .*//`
		elif [ -f /etc/centos-release ] ; then
		    OSDIST='CentOS'
		    PSUEDONAME=`cat /etc/centos-release | sed s/.*\(// | sed s/\)//`
		    OSREV=`cat /etc/centos-release | sed s/.*release\ // | sed s/\ .*//`
        elif [ -f /etc/redhat-release ] ; then
		    OSDIST='RedHat'
		    PSUEDONAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
		    OSREV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
	    elif [ -f /etc/SUSE-release ] ; then
		    OSDIST=`cat /etc/SUSE-release | tr "\n" ' '| sed s/VERSION.*//`
		    OSREV=`cat /etc/SUSE-release | tr "\n" ' ' | sed s/.*=\ //`
	    elif [ -f /etc/mandrake-release ] ; then
		    OSDIST='Mandrake'
		    PSUEDONAME=`cat /etc/mandrake-release | sed s/.*\(// | sed s/\)//`
		    OSREV=`cat /etc/mandrake-release | sed s/.*release\ // | sed s/\ .*//`
	    elif [ -f /etc/debian_version ] ; then
		    OSDIST="Debian `cat /etc/debian_version`"
		    OSREV=""
        fi
	    if [ -f /etc/UnitedLinux-release ] ; then
		    OSDIST="${OSDIST}[`cat /etc/UnitedLinux-release | tr "\n" ' ' | sed s/VERSION.*//`]"
	    fi


	    OSSTR="${OSTYPE} ${OSDIST} ${OSREV}(${PSUEDONAME} ${OSKERNEL} ${OSMACH})"
    fi
}

fn_detect_os_family()
{
    # get environment related variables
    fn_get_os_info
    shopt -s nocasematch
    case $OSDIST in
        'redhat'|'centos'|'oraclelinux')
            OS_FAMILY='redhat';;
        'debian')
            OS_FAMILY="debian";;
        'ubuntu')
            OS_FAMILY="ubuntu";;
        *)
            echo "Not supported operating system!"
            exit 1;;
    esac
}

check_privilege()
{
    if [[ "$(id -u)" -ne "$ROOTUID" ]];then
        echo "This script must be executed with root privileges or run in sudo mode!"
        exit 1
    fi
}

ensure_python_version()
{
    PY_VER=$(python -V 2>&1 | grep -Po '(?<=Python )(.+)')
    if [[ -z "$PY_VER" ]];then
        echo "No python found, please install it!"
        exit 1
    fi

    # Ansible can be run from any machine with Python 2 (versions 2.6 or 2.7)
    # or Python 3 (versions 3.5 and higher) installed
    PY_VER_NUM=$(echo "${PY_VER//./}")
    if [[ "$PY_VER_NUM" -lt "260" || ("$PY_VER_NUM" -gt "300" && "$PY_VER_NUM" -lt "350")  ]];then
        echo "Only support python2 >= 2.6 or python3 >= 3.5"
        exit 1
    fi
}

ensure_basic_sys_packages()
{
    fn_detect_os_family

    case "$OS_FAMILY" in
        'redhat')
            SYS_PKGS="gcc openssl-devel python python-devel python2-pip epel-release"
            PKG_CMD="yum install -y -q $SYS_PKGS"
            ;;
        *)
            echo "$OSDIST is not supported at this version!"
            exit 1
            ;;
    esac

    for pkg in $SYS_PKGS;do
        rpm -q $pkg > /dev/null
        if [ $? -ne 0 ]; then
            fn_action "* Install basic system package $pkg:" yum install -y -q $pkg
            if [ $? -ne 0 ]; then
                echo "Error installing system packages $pkg!"
                exit 1
            fi
        fi
    done
}

ensure_ansible()
{
    ansible --version > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        ANSIBLE_INSTALL_CMD="pip -q install --upgrade ansible"
        fn_action "* Install ansible (it need take long time)" $ANSIBLE_INSTALL_CMD
        if [ $? -ne 0 ]; then
            echo "Error install ansible!"
            exit 1
        fi
    fi
}

ensure_docker()
{
    echo "ensure docker"
}

check_privilege
ensure_basic_sys_packages
ensure_python_version
ensure_ansible
ensure_docker

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
