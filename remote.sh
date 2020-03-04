#!/bin/bash

SSH="ssh -q -o ConnectTimeout=5 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

echo -n Enter comma separated IP/hostname:             ## Enter IP in comma seperated form eg:- 172.16.2.37,172.16.2.40,172.16.2.38
read I

echo -n Enter Command:        ## Enter command which needs to be executed in remote host...
read com

for i in ${I//,/ } ## Elementating "," from given IP input / alternate command for same purpose "for i in $(echo $I | tr ',' '\n')"
     do

$SSH $i "exit" 2> /dev/null 1> /dev/null ## Verifying Password-less Login from JUMP server, if not password-less use "sshpass"  
     if [ $? = 0 ]; then
     echo "Login SUCCESS on $i"
     else
     echo "Login DENIED on $i"
     fi
done

for i in $(echo $I | tr ',' '\n')
      do
a=`$SSH $i "$com"` ## Remote execution  
echo -e "$i \n O/P for $com is $a"  
done
