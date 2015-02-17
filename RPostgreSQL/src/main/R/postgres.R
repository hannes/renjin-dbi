library(DBI)

RPostgreSQL <- PostgreSQL <- function() {
	JDBC('org.postgresql.Driver', 'PostgreSQL')
} 

# load DBI to replicate GNU R 'Depends:'
.onLoad <- function(libname, pkgname) library(DBI)