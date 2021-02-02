#! /bin/bash
echo "############ Download Dominion Cross MongoDB from Production: `date`"
cd ~/tmp
rm -rf dump latest.tar
sudo gsutil cp gs://dcross/_mongo/latest.tar latest.tar
tar -xzvf latest.tar
mv -f ~/tmp/home/bpetro_dominioncross_com_au/backup/dump ~/tmp/dump
dbs=(
  "affiliates"
  "forklift"
  "highstreet"
  "tarmac"
  "wholesale"
)
for db in "${dbs[@]}"
do
  echo "- $db restoring..."
  mongorestore --drop dump/$db --db $db
  echo "  - complete - `date`"
done

echo "############ Restore Complete: `date`"
