#! /bin/sh
port=`ls /dev/ttyACM*`
echo dev@$port
stty 9600 -F $port
stty -F $port
echo reading...
cat $port
