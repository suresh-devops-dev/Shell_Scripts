#!/bin/bash

if [ -s /etc/init.d/vsftpd ]
then
    /etc/init.d/httpd status
else
    echo "FTP is not installed"
fi
