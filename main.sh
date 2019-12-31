CMD="sqoop import --connect \"jdbc:mysql://[HOSTNAME]/[DBNAME]\" \
--username [USERNAME] \
--password [PASSWORD] \
--table [TABLENAME] \
--num-mappers [MAPPERS] \
--target-dir /usr/sqoopjobauto/[TABLENAME] \
--autoreset-to-one-mapper"



HOSTNAME=`grep HOSTNAME db.properties | cut -d= -f2`
DBNAME=`grep DATABASE db.properties | cut -d= -f2`
USERNAME=`grep USERNAME db.properties | cut -d= -f2`
PASSWORD=`grep PASSWORD db.properties | cut -d= -f2`
for LINE in `cat tables`;
do
TABLE=`echo ${LINE}|cut -d: -f1`
MAPPERS=`echo ${LINE}|cut -d: -f2`
SQOOPCMD=`echo $CMD | sed -e "s/\[TABLENAME\]/\"${TABLE}\"/g"`
SQOOPCMD=`echo $SQOOPCMD | sed -e "s/\[MAPPERS\]/\"${MAPPERS}\"/g"`
SQOOPCMD=`echo $SQOOPCMD | sed -e "s/\[HOSTNAME\]/\"${HOSTNAME}\"/g"`
SQOOPCMD=`echo $SQOOPCMD | sed -e "s/\[DBNAME\]/\"${DBNAME}\"/g"`
SQOOPCMD=`echo $SQOOPCMD | sed -e "s/\[USERNAME\]/\"${USERNAME}\"/g"`
SQOOPCMD=`echo $SQOOPCMD | sed -e "s/\[PASSWORD\]/\"${PASSWORD}\"/g"`

echo "loading ${TABLENAME}  using  ${SQOOPCMD}"
`${SQOOPCMD}`
done
