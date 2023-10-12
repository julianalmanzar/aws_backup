#!/bin/bash

#Initializing our variables
#db_username, db_passwd and aws_bucket are not suposed to be used as arrays
paths=()
ips=()
databases=()
db_username=()
db_passwd=()
aws_bucket=()
#Getting our parameters and creating our lists
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p)
            paths+=("$2")
            shift 2;;
        -i)
            ips+=("$2")
            shift 2;;
        -n)
            databases+=("$2")
            shift 2;;
        -u)
            db_username+=("$2")
            shift 2;;
        -w)
            db_passwd+=("$2")
            shift 2;;
        -b)
            aws_bucket+=("$2")
            shift 2;;

        *)
            echo "Unknown flag: $1"
            exit 1;;
    esac
done

#Create a directory to save current backup
mkdir backup$(date +"%d%m%Y")
#Create a log file
touch backup$(date +"%d%m%Y")/logs.txt
#Iterate through all paths and create a backup for each one of them
for path in "${paths[@]}"; do
    tar -cvpzf backup$(date +"%d%m%Y")/$(basename $path).tar.gz $path
    echo "Backup for $path saved as $(basename $path).tar.gz" >> backup$(date +"%d%m%Y")/logs.txt
done
##Iterate through all database servers IPs and check if the database name exists and create a backup
for ip in "${ips[@]}"; do
    for database in "${databases[@]}"; do
        if mysql -u "$db_username" -p"$db_passwd" -h "$ip" -e "USE $database;" 2>/dev/null; then
            sudo mysqldump --no-tablespaces -u $db_username -p$db_passwd "$database" > backup$(date +"%d%m%Y")/"$database$ip.sql"
            echo "Database $database from $ip saved as $database$ip.sql" >> backup$(date +"%d%m%Y")/logs.txt
        else
            echo "Database $database doesnt exists on $ip server" >> backup$(date +"%d%m%Y")/logs.txt
        fi
    done
done

#Create a tar for the whole folder
tar -cvpzf backup$(date +"%d%m%Y").tar.gz backup$(date +"%d%m%Y")
#Upload file to AWS bucket
aws s3 cp backup$(date +"%d%m%Y").tar.gz s3://$aws_bucket/
echo "File backup$(date +"%d%m%Y").tar.gz uploaded to $aws_bucket" >> backup$(date +"%d%m%Y")/logs.txt
#Delete local folder and file
rm -rf backup$(date +"%d%m%Y")
rm backup$(date +"%d%m%Y").tar.gz
