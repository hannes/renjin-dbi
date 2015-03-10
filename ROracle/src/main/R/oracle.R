ROracle <- function() {
	options(dbi.insert.splitsize=1)
	JDBC(OracleDriver$new(), "ROracle")
} 
# load DBI to replicate GNU R 'Depends:'
.onLoad <- function(libname, pkgname) library(DBI)

# Extrawurst
dbDataType.ROracleConnection <- function(con, obj, ...) {
	if (is.factor(obj)) "CLOB"
	else if (is.logical(obj)) "BOOLEAN"
	else if (is.integer(obj)) "INTEGER"
	else if (is.numeric(obj)) "NUMBER"
	else if (is.raw(obj)) "BLOB"
	else "CLOB"
}