#!/bin/bash

# Fire up PHP and then start Nginx in non daemon mode so docker has something to keep running
echo "Starting php7-fpm"
service php7.2-fpm start
echo "*** Starting NginX ***"
nginx
echo "*** Starting shell to prevent sleep ***"
/bin/bash
