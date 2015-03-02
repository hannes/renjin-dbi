RMySQL <- MySQLRMySQL <- function() {
	JDBC(Driver$new(), 'MySQL')
} 

# load DBI to replicate GNU R 'Depends:'
.onLoad <- function(libname, pkgname) library(DBI)