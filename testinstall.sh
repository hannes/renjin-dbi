#!/bin/bash
for f in DBI MonetDB.R RSQLite RPostgreSQL RMySQL ; do
	mvn -q -f $f/pom.xml clean install
done