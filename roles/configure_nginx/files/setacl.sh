DIR=$1
until [ "$DIR" = "/" ]; do
  DIR_NAME=`ls -d $DIR`
  su -m nginx -c "test -r '$DIR_NAME' -a -x '$DIR_NAME'"
  if [ $? != 0 ];then
    echo $DIR_NAME
    setfacl -m u:nginx:rx $DIR_NAME
  fi
  DIR=`dirname $DIR`
done