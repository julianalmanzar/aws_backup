# aws_backup
A simple script that saves application and database data to an S3 bucket
to use this script, you must use parameters like this:

./backup_to_aws.sh -p /path/to/appfiles/1/ -p /path/to/appfiles/2/ -p /path/to/appfiles/n/ -i [DB_Server_IP_1] -i [DB_Server_IP_2] -i [DB_Server_IP_N] -n [DATABASE_NAME_1] -n [DATABASE_NAME_2] -n [DATABASE_NAME_N] -u dbusername -w dbpassword -b aws_bucket

for more information about this, please refer to my blog https://dev.to/julianalmanzar/backup-web-application-database-to-aws-s3-1mpj
