RH2GIS <- H2GIS <- function() {
	JDBC(Driver$new(), "H2GIS")
} 

# load DBI to replicate GNU R 'Depends:'
.onLoad <- function(libname, pkgname) library(DBI)
