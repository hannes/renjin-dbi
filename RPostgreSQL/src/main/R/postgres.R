RPostgreSQL <- PostgreSQL <- function() {
	JDBC(Driver$new(), 'PostgreSQL')
} 

# load DBI to replicate GNU R 'Depends:'
.onLoad <- function(libname, pkgname) library(DBI)