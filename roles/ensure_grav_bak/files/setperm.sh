GRAV_ROOTDIR=$1

if [ ! -d "$GRAV_ROOTDIR" ];then
    echo "Please specify valid grav rootdir!"
    exit 1
fi

# set grav dirs and files permission
chown -R ryan:nginx $GRAV_ROOTDIR 
cd $GRAV_ROOTDIR 
find . -type f | xargs chmod 664 
find . -type d | xargs chmod 775
find . -type d | xargs chmod +s
umask 0002