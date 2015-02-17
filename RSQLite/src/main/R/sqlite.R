RSQLite <- SQLite <- function() {
	JDBC('org.sqlite.JDBC', 'SQLite')
} 

# load DBI to replicate GNU R 'Depends:'
.onLoad <- function(libname, pkgname) library(DBI)


# some defaults for quick connections
dbConnect.SQLiteDriver <- function(drv, url="jdbc:sqlite:", username="", password="") {
	dbConnect.JDBCDriver(drv, url, username, password)
}