DROPBOX_PARENT_DIR=$1

export http_proxy=http://127.0.0.1:8118 
export https_proxy=http://127.0.0.1:8118
cd $DROPBOX_PARENT_DIR
curl -L "https://www.dropbox.com/download?plat=lnx.x86_64" -o dropbox.tar.gz
tar zxvf dropbox.tar.gz