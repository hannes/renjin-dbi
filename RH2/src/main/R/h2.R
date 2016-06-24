RH2 <- H2 <- function() {
	JDBC(JDBC$new(), "H2")
} 

# load DBI to replicate GNU R 'Depends:'
.onLoad <- function(libname, pkgname) library(DBI)


# some defaults for quick connections
dbConnect.H2Driver <- function(drv, url="jdbc:h2:", username="", password="") {
	if (substring(url, 1, 8) != "jdbc:h2:") url <- paste0("jdbc:h2:", url)
	dbConnect.JDBCDriver(drv, url, username, password)
}