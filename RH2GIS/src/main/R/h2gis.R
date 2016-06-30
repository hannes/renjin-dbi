RH2GIS <- H2GIS <- function() {
	JDBC(Driver$new(), "H2GIS")
} 

# load DBI to replicate GNU R 'Depends:'
.onLoad <- function(libname, pkgname) library(DBI)


loadSpatialFunctions <- function(con){
    if(dbIsValid(con)){
        dbSendQuery(con,"CREATE ALIAS IF NOT EXISTS H2GIS_EXTENSION FOR \"org.h2gis.ext.H2GISExtension.load\";")
        dbSendQuery(con,"CALL H2GIS_EXTENSION()")
        
        return ("H2GIS functions have been successfully loaded.")
    }
        return ("The connection is not valid. Cannot load H2GIS functions")
}
