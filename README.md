# Sqoop-Automation
Sqoop import automation with mysql database

How To Automate Sqoop Incremental Import

If you’ve done sqoop incremental import, you must have seen we need to provide the last incremented value each time we do sqoop incremental import.

But in normal working we don’t run such sqoop incremental import daily or when needed. We basically automate sqoop incremental import work so that automatically it will import the incremented values.

In this tutorial, we are going to see how to automate sqoop incremental import. If you’re new to sqoop, you may follow our free sqoop tutorial guide.

How to automate sqoop incremental import job?
In sqoop incremental import, the newly added record of the RDBMS table will be added to the file those have already been imported to HDFS.

1. create a command template like this

sqoop import --connect "jdbc:mysql://[HOSTNAME]/[DBNAME]" \
--username [USERNAME] \
--password [PASSWORD] \
--table [TABLENAME] \
--num-mappers [MAPPERS] \
--target-dir /usr/sqoopjobauto/[TABLENAME] \
--autoreset-to-one-mapper

2.create db.properties file to pass to read db connection string

3.create file tables keep all your table names

4.Finaly create a main shell script which will be something like this 


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


