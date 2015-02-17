library(DBI)

RMySQL <- MySQLRMySQL <- function() {
	JDBC('com.mysql.jdbc.Driver', 'MySQL')
} 

# load DBI to replicate GNU R 'Depends:'
.onLoad <- function(libname, pkgname) library(DBI)