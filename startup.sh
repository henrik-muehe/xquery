#!/bin/bash

cd /src

basexserver -S
basexclient -Uadmin -Padmin -c "CREATE USER xquery de689428f1c2fcf57fa72aa0d1073ab8"
basexclient -Uadmin -Padmin -c "create database uni data/uni.xml"
basexclient -Uadmin -Padmin -c "create database uni2 data/uni2.xml"
basexclient -Uadmin -Padmin -c "GRANT READ ON uni TO xquery"
basexclient -Uadmin -Padmin -c "GRANT READ ON uni2 TO xquery"

node server.js
