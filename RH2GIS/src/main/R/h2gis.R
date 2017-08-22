RH2GIS <- H2GIS <- function() {
	JDBC(Driver$new(), "H2GIS")
} 

# load DBI to replicate GNU R 'Depends:'
.onLoad <- function(libname, pkgname) library(DBI)


###Override DBI functions to support custom table data types

dbListTables      <- function(con, ...)       UseMethod("dbListTables") 
dbListTables <- function(con) {
    JDBCUtils$getTables(con$conn,c("TABLE", "VIEW", "TABLE LINK", "EXTERNAL")) 
}

dbExistsTable      <- function(con, ...)       UseMethod("dbExistsTable") 
dbExistsTable.JDBCConnection <- function(con, name, ...) {
	tolower(gsub("(^\"|\"$)","",as.character(name))) %in% 
			tolower(dbListTables(con))
}

dbRemoveTable      <- function(con, ...)       UseMethod("dbRemoveTable")
dbRemoveTable.JDBCConnection <- function(con, name, ...) {
	if (dbExistsTable(con, name)) {
		dbSendUpdate(con, paste("DROP TABLE", tolower(name)))
		return(invisible(TRUE))
	}
	invisible(FALSE)
}

dbReadTable      <- function(con, ...)       UseMethod("dbReadTable")
dbReadTable.JDBCConnection <- function(con, name, ...) {
	if (!dbExistsTable(con, name))
		stop(paste0("Unknown table: ", name));
	dbGetQuery(con,paste0("SELECT * FROM ", name))
}

dbWriteTable      <- function(con, ...)       UseMethod("dbWriteTable")
dbWriteTable.JDBCConnection <- function(conn, name, value, overwrite=FALSE, 
		append=FALSE, csvdump=FALSE, transaction=TRUE, ...) {
	if (is.vector(value) && !is.list(value)) value <- data.frame(x=value)
	if (length(value)<1) stop("value must have at least one column")
	if (is.null(names(value))) names(value) <- paste("V", 1:length(value), sep='')
	if (length(value[[1]])>0) {
		if (!is.data.frame(value)) value <- as.data.frame(value, row.names=1:length(value[[1]]))
	} else {
		if (!is.data.frame(value)) value <- as.data.frame(value)
	}
	if (overwrite && append) {
		stop("Setting both overwrite and append to true makes no sense.")
	}
	qname <- make.db.names(conn, name)
	if (dbExistsTable(conn, qname)) {
		if (overwrite) dbRemoveTable(conn, qname)
		if (!overwrite && !append) stop("Table ", qname, " already exists. Set overwrite=TRUE if you want 
							to remove the existing table. Set append=TRUE if you would like to add the new data to the 
							existing table.")
	}
	if (!dbExistsTable(conn, qname)) {
		fts <- sapply(value, function(x) {
					dbDataType(conn, x)
				})
		fdef <- paste(make.db.names(conn, tolower(names(value))), fts, collapse=', ')
		ct <- paste("CREATE TABLE ", qname, " (", fdef, ")", sep= '')
		dbSendUpdate(conn, ct)
	}
	if (length(value[[1]])) {
		vins <- paste("(", paste(rep("?", length(value)), collapse=', '), ")", sep='')

		if (transaction) dbBegin(conn)
		# chunk some inserts together so we do not need to do a round trip for every one
		splitlen <- 0:(nrow(value)-1) %/% getOption("dbi.insert.splitsize", 1000)

		lapply(split(value, splitlen), 
				function(valueck) {
					bvins <- c()
					for (j in 1:length(valueck[[1]])) {
						bvins <- c(bvins, .bindParameters(conn, vins, as.list(valueck[j, ])))
                                                                                                
					} 
					dbSendUpdate(conn, paste0("INSERT INTO ", qname, " VALUES ",paste0(bvins, collapse=", ")))
				})
		if (transaction) dbCommit(conn)		
	}
	invisible(TRUE)
}

dbListFields      <- function(con, ...)       UseMethod("dbListFields")
dbListFields.JDBCConnection <- function(con, name, ...) {
	if (!dbExistsTable(con, name))
		stop("Unknown table ", name);
	JDBCUtils$getColumns(con$conn, name)	
}


#This function load the H2GIS spatial functions
loadSpatialFunctions <- function(con){
    if(dbIsValid(con)){
        dbSendQuery(con,"CREATE ALIAS IF NOT EXISTS H2GIS_EXTENSION FOR \"org.h2gis.ext.H2GISExtension.load\";")
        dbSendQuery(con,"CALL H2GIS_EXTENSION()")
        
        return ("H2GIS functions have been successfully loaded.")
    }
        return ("The connection is not valid. Cannot load H2GIS functions")
}
