library(DBI)

MonetDB.R <- MonetDB <- function() {
	JDBC("nl.cwi.monetdb.jdbc.MonetDriver", "MonetDB")
} 

# load DBI to replicate GNU R 'Depends:'
.onLoad <- function(libname, pkgname) library(DBI)

# custom stuff

# this takes the same parameters as dbConnect() parameters in MonetDB.R for compatibility
dbConnect.MonetDBDriver <- function(drv, dbname="demo", username="monetdb", 
		password="monetdb", host="localhost", port=50000L, timeout=86400L, wait=FALSE, language="sql", 
		..., url="") {
	if (substring(dbname, 1, 5) != "jdbc:") {
		if (substring(dbname, 1, 10) == "monetdb://") {
			url <- paste("jdbc:", dbname, sep="")
		} else {
			url <- paste("jdbc:monetdb://", host,":", as.integer(port), "/", dbname, sep="")
		}
	} else {
		url <- dbname
	}
	# TODO: auto-assign a specific class to the connection based on the driver name for ez overloading
	structure(list(conn = dbConnect.JDBCDriver(drv, url, username, password)$conn), class = c("MonetDBConnection", "JDBCConnection"))
}

monet.read.csv <- monetdb.read.csv <- function(conn, files, tablename, nrows, header=TRUE, 
		locked=FALSE, na.strings="", nrow.check=500, delim=",", newline="\\n", quote="\"", ...){
	
	if (length(na.strings)>1) stop("na.strings must be of length 1")
	headers <- lapply(files, utils::read.csv, sep=delim, na.strings=na.strings, quote=quote, nrows=nrow.check, 
			...)
	
	if (length(files)>1){
		nn <- sapply(headers, ncol)
		if (!all(nn==nn[1])) stop("Files have different numbers of columns")
		nms <- sapply(headers, names)
		if(!all(nms==nms[, 1])) stop("Files have different variable names")
		types <- sapply(headers, function(df) sapply(df, dbDataType, dbObj=conn))
		if(!all(types==types[, 1])) stop("Files have different variable types")
	} 
	
	dbWriteTable(conn, tablename, headers[[1]][FALSE, ])
	
	delimspec <- paste0("USING DELIMITERS '", delim, "','", newline, "','", quote, "'")
	
	if(header || !missing(nrows)){
		if (length(nrows)==1) nrows <- rep(nrows, length(files))
		for(i in seq_along(files)) {
			thefile <- normalizePath(files[i])
			dbSendUpdate(conn, paste("COPY", format(nrows[i], scientific=FALSE), "OFFSET 2 RECORDS INTO", 
							tablename, "FROM", paste("'", sub("file://", "", thefile, fixed=T), "'", sep=""), delimspec, "NULL as", paste("'", 
									na.strings[1], "'", sep=""), if(locked) "LOCKED"))
		}
	} else {
		for(i in seq_along(files)) {
			thefile <- normalizePath(files[i])
			dbSendUpdate(conn, paste0("COPY INTO ", tablename, " FROM ", paste("'", sub("file://", "", thefile, fixed=T), "'", sep=""), 
							delimspec, "NULL as ", paste("'", na.strings[1], "'", sep=""), if(locked) " LOCKED "))
		}
	}
	dbGetQuery(conn, paste("select count(*) from", tablename))
}
