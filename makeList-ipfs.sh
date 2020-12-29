#!/bin/bash

date=$(date +%s)
file=$1
if [ "$file" == "" ];
then
listCommand="ipfs pin ls -t recursive -q"
else
listCommand="cat $file"
fi
echo "<html><body><h3>IPFS Linklist</h3><ul><small>" > /tmp/$date.html
echo "IPFS Linklist" > /tmp/ipfs.txt
touch ~/.cache/ipfs.cache
for item in $($listCommand|sort|uniq); do newName=0; name=$(cat ~/.cache/ipfs.cache|grep $item|head -n1| cut -d';' -f2 2>/dev/null|sed s/\"//g); if [ "$name" == "" ]; then name=$(ipfs ls $item 2>/dev/null| cut -d' ' -f3-|sed s/\"//g); newName=1; fi; if [ "$name" == "" ]; then name="[unknown object]"; fi; echo "<li><b><a href=\"/ipfs/$item\" target=\"_blank\" style=\"text-decoration: none;\">${name:0:80}</a></b>" >> /tmp/$date.html; echo "$item - $name" >> /tmp/ipfs.txt; if [ "$newName" == "1" ]; then echo "\"$item\";\"$name\";\"https://ipfs.io/ipfs/$item\";\""$(date +%s)"\"" >> ~/.cache/ipfs.cache; fi; done
echo "</ul></small></body></html>" >> /tmp/$date.html
newItem=$(ipfs add /tmp/$date.html | tail -n1 | cut -d ' ' -f 2)
echo "local: http://localhost:8080/ipfs/$newItem"
echo ipfs.io: https://ipfs.io/ipfs/$newItem
ipfs pin rm $newItem >/dev/null
rm /tmp/$date.html >/dev/null


firefox http://localhost:8080/ipfs/$newItem &


