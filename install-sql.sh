#!/bin/bash
HOSTNAME=$DATABASE_HOST #数据库信息

PORT=$DATABASE_PORT

USERNAME=$DATABASE_USER
PASSWORD=$DATABASE_PWD

DBNAME=$DATABASE_NAME  #数据库名称

ADMINUSER=$ADMIN_USER
ADMINPASSWORD=$ADMIN_PWD
WEBTITLE=$WEB_TITLE #网站title
WEBURL=$WEB_URL #网站域名
BUCKETNAME=$BUCKET_NAME  #存储桶名字










#创建数据库

create_db_sql="create database IF NOT EXISTS ${DBNAME}"

mysql -h${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} -e "${create_db_sql}"
mysql -h${HOSTNAME} -u${USERNAME} -p${PASSWORD} ${DBNAME} < /var/www/html/install/database.sql

#sign=`echo -n  $ADMINPASSWORD | md5sum`
sign=`echo -n $ADMINPASSWORD |md5sum|cut -d ' ' -f1`


#插入初始化管理员账号
insert_admin_sql="INSERT INTO users (id, user, email, password, created, modified, isAdmin) VALUES (1, '${ADMINUSER}', '90333@qq.com', '${sign}', now(), now(), true)"
mysql -h${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${insert_admin_sql}"

#删除默认分类
delete_category_sql="DELETE FROM categories WHERE id = 1"
mysql -h${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${delete_category_sql}"

#插入默认分类值
insert_sql="INSERT INTO categories (id, name, clean_name, description, created, modified) VALUES (1, 'Default', 'default','', now(), now())"

#删除默认配置
delete_config_sql="DELETE FROM configurations WHERE id = 1";
mysql -h${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${delete_config_sql}"

#插入默认配置
insert_congig_sql="INSERT INTO configurations (id, video_resolution, users_id, version, webSiteTitle, language, contactEmail, encoderURL,  created, modified) VALUES (1, '858:480', 1,'7.8', '${WEBTITLE}', 'en', '907262317@qq.com', '${WEBURL}', now(), now())"


mysql -h${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${insert_congig_sql}"

#插入并S3插件配置

insert_sthree_sql="INSERT INTO plugins (id, uuid, status, created, modified, object_data, name, dirName, pluginversion) VALUES (NULL, '1ddecbec-91db-4357-bb10-ee08b0913778', 'active', now(), now(), '{\"region\":\"cn-northwest-1\",\"bucket_name\":\"${BUCKETNAME}\",\"key\":\"AKIA6E2GEODUOVRFWGPT\",\"secret\":\"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\",\"endpoint\":\"\",\"profile\":\"\",\"useS3DirectLink\":true,\"presignedRequestSecondsTimeout\":\"43200\",\"CDN_Link\":\"\",\"makeMyFilesPublicRead\":false}', 'AWS_S3', 'AWS_S3', '1.0')"

mysql -h${HOSTNAME} -P${PORT} -u${USERNAME} -p${PASSWORD} ${DBNAME} -e "${insert_sthree_sql}"