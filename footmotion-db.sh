#! /bin/bash
dbs=(
  "footmotion"
)
echo "############ Download Footmotion MongoDB from Production: `date`"
cd ~/tmp
for db in "${dbs[@]}"
do
  echo "- $db downloading..."
  mongodump -u mongo -p 1ds7sh220fkhnbasiuyg489eys --db $db --host 104.155.192.135 --port 17425 -o dump
  echo "  - complete - `date`"
done
for db in "${dbs[@]}"
do
  echo "- $db restoring..."
  mongorestore --drop dump/$db --db $db --quiet
  echo "- $db restored - `date`"
done
echo "############ Restore Complete: `date`"
rm -rf dump
cd ~/
