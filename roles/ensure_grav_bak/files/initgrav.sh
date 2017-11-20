BASE_DIR=$1
USER_HOME=$2
GRAV_ROOTDIR=$3

if [ ! -d "$GRAV_ROOTDIR" ];then
    echo "Please specify valid grav rootdir!"
    exit 1
fi

DROPBOX_GRAV_ROOTDIR=$USER_HOME/Dropbox/grav
DROPBOX_GRAV_USER_DIR=$DROPBOX_GRAV_ROOTDIR/user

# the first time dropbox will sync grav/user dir
# we need make it to be a link to grav installation
DROPBOX_STATUS=`python $BASE_DIR/bin/dropbox.py status`
if [[ -d "$DROPBOX_GRAV_USER_DIR" && ! -L "$DROPBOX_GRAV_USER_DIR" ]];then
    if [[ "$DROPBOX_STATUS" != "Up to date" ]];then
        echo "Dropbox is not ready"
        exit 1
    fi
    # backup original user dir
    mv $GRAV_ROOTDIR/user $GRAV_ROOTDIR/user.`date +%Y%m%d%H%M`
    # move dropbox user dir to grav user dir
    mv $DROPBOX_GRAV_USER_DIR $GRAV_ROOTDIR
    cd $DROPBOX_GRAV_ROOTDIR
    ln -s $GRAV_ROOTDIR/user user
fi

# if we already linked the grav/user to dropbox/grav/user
# then setup multiple site
if [[ -L "$DROPBOX_GRAV_USER_DIR" && -d "$DROPBOX_GRAV_USER_DIR" ]];then
    cd $GRAV_ROOTDIR 
    rm setup.php > /dev/null
    ln -s user/sites/setup.php .
fi


