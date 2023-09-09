#!/bin/bash

#example location Home & Var/log
#target size more than 4MB
location1="/home"
location2="/var/log"
currentdate=$(date +"%Y-%m-%d_%H:%M")
output="/home/nizam/rogue/output/resultf_"$currentdate".txt"

find $location1 $location2 -size +4M -printf '%s %p\n'| sort -nr >> $output

#send email
#"to: alarm@animapoint.net"
gzip -f $output
( echo "to: alarm@animapoint.net"
  echo "from: no_reply@$HOSTNAME"
  echo "subject: Report of rough file by $HOSTNAME"
  echo "mime-version: 1.0"
  echo "content-type: multipart/related; boundary=messageBoundary"
  echo
  echo "--messageBoundary"
  echo "content-type: text/plain"
  echo
  echo "Please find the document attached."
  echo
  echo "--messageBoundary"
  echo "content-type: text/plain; name=rough_$currentdate.txt.gz"
  echo "content-transfer-encoding: base64"
  echo
  openssl base64 < $output.gz) | sendmail -t -i