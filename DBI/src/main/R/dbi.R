JDBC <- function(jdriver, rclassprefix, ...) {
	rclass <- paste0(rclassprefix, "Driver")
	structure(list(jdriver=jdriver, rclassprefix=rclassprefix), class = c(rclass, "JDBCDriver", "DBIDriver"))
}

# DBI methods in S3 form for source compatibility
# driver
dbDriver          <- function(drvName, ...)   do.call(drvName, list(...))

dbConnect         <- function(drv, ...)       UseMethod("dbConnect") 
dbIsValid         <- function(obj, ...)       UseMethod("dbIsValid") 
dbGetInfo         <- function(obj, ...)       UseMethod("dbGetInfo") 

# connection
dbDisconnect      <- function(con, ...)       UseMethod("dbDisconnect") 
dbListTables      <- function(con, ...)       UseMethod("dbListTables") 
dbBegin           <- function(con, ...)       UseMethod("dbBegin") 
dbCommit          <- function(con, ...)       UseMethod("dbCommit") 
dbRollback        <- function(con, ...)       UseMethod("dbRollback")
dbListFields      <- function(con, name, ...) UseMethod("dbListFields")
dbExistsTable     <- function(con, name, ...) UseMethod("dbExistsTable")
dbReadTable       <- function(con, name, ...) UseMethod("dbReadTable")
dbRemoveTable     <- function(con, name, ...) UseMethod("dbRemoveTable")
dbSendQuery       <- function(con, qry, ...)  UseMethod("dbSendQuery")
dbSendUpdate      <- function(con, qry, ...)  UseMethod("dbSendUpdate")
dbGetQuery        <- function(con, qry, ...)  UseMethod("dbGetQuery")
dbQuoteIdentifier <- function(con, idnt, ...) UseMethod("dbQuoteIdentifier")
dbDataType        <- function(con, obj, ...)  UseMethod("dbDataType")
dbGetException    <- function(con, ...)       UseMethod("dbGetException")

# result sets
fetch <- dbFetch  <- function(res, n, ...)    UseMethod("dbFetch")
dbHasCompleted    <- function(res, ...)       UseMethod("dbHasCompleted")
dbClearResult     <- function(res, ...)       UseMethod("dbClearResult")
dbColumnInfo      <- function(res, ...)       UseMethod("dbColumnInfo")

dbQuoteString     <- function(con, x, ...)    UseMethod("dbQuoteString")
dbQuoteIdentifier <- function(con, x, ...)    UseMethod("dbQuoteIdentifier")

# Not in DBI, but useful
dbWriteTable      <- function(conn, name, value, ...) UseMethod("dbWriteTable")


dbQuoteString.JDBCConnection <- function(con, x, ...) {
	if (substring(x, 1, 2) == "'") {
		return(x)
	}
	x <- gsub("'", "''", x, fixed = TRUE)
	paste("'", x, "'", sep = "")
}

dbQuoteIdentifier.JDBCConnection <- function(con, x, ...) {
	if (substring(x, 1, 2) == '"') {
		return(x)
	}
	x <- gsub('"', '""', x, fixed = TRUE)
	paste('"', x, '"', sep = "")
}

# custom stuff
dbWriteTable      <- function(conn, name, value, ...) UseMethod("dbWriteTable")

dbIsValid.JDBCDriver <- function(drv) {
	inherits(drv, "JDBCDriver")
}

dbGetInfo.JDBCDriver <- function(obj, ...) {
	list()
}

dbIsValid.JDBCConnection <- function(con) {
	inherits(con, "JDBCConnection")
}

dbRemoveTable.JDBCConnection <- function(con, name, ...) {
	if (dbExistsTable(con, name)) {
		dbSendUpdate(con, paste("DROP TABLE", tolower(name)))
		return(invisible(TRUE))
	}
	invisible(FALSE)
}

dbConnect.JDBCDriver <- function(drv, url, username, password) {
	# this will throw an exception if it fails, so no need for additional checks here.
	if (getOption("dbi.debug", F)) message("II: Connecting to ",url," with user ", username, " and a non-printed password.")
	prop <- import(java.util.Properties)$new()
	prop$setProperty("user", username)
	prop$setProperty("password", password)
	jconn <- drv$jdriver$connect(url, prop)
	rclass <- paste0(drv$rclassprefix, "Connection")
	invisible(structure(list(conn = jconn), class = c(rclass, "JDBCConnection", "DBIConnection")))
}

dbSendQuery.JDBCConnection <- function (con, qry) {
	if (getOption("dbi.debug", F))  message("QQ: '", qry, "'")
	
	stmt <- con$conn$createStatement()
	res <-  stmt$execute(qry)
	invisible(structure(list(query = qry, statement = stmt, resultset = JDBCUtils$gimmeResults(stmt), success = TRUE), 
			class = "JDBCResultSet"))
}

dbSendUpdate.JDBCConnection <- function(con, qry, ...) {
	if(length(list(...))){
		if (length(list(...))) qry <- .bindParameters(con, qry, list(...))

	}
	res <- dbSendQuery(con, qry)
	if (!res$success) {
		stop(qry, " failed!\nServer says:", "TODO")
	}
	invisible(TRUE)
}

dbReadTable.JDBCConnection <- function(con, name, ...) {
	if (!dbExistsTable(con, name))
		stop(paste0("Unknown table: ", name));
	dbGetQuery(con,paste0("SELECT * FROM ", name))
}

# copied from DBI
dbGetQuery.JDBCConnection <- function(con, qry, ...) {
	rs <- dbSendQuery(con, qry, ...)
	on.exit(dbClearResult(rs))
	if (dbHasCompleted(rs)) return(NULL)
	res <- dbFetch(rs, n = -1, ...)
	if (!dbHasCompleted(rs)) warning("pending rows")
	res
}

dbExistsTable.JDBCConnection <- function(con, name, ...) {
	tolower(gsub("(^\"|\"$)","",as.character(name))) %in% 
			tolower(dbListTables(con))
}

dbListTables.JDBCConnection <- function(con) {
	JDBCUtils$getTables(con$conn,c("TABLE") )
}

dbBegin.JDBCConnection <- function(con, ...) {
	JDBCUtils$toggleAutocommit(con$conn, FALSE)
	invisible(TRUE)
} 

dbCommit.JDBCConnection <- function(con, ...) {
	con$conn$commit()
	JDBCUtils$toggleAutocommit(con$conn, TRUE)
	invisible(TRUE)
} 

dbRollback.JDBCConnection <- function(con, ...) {
	con$conn$rollback()
	JDBCUtils$toggleAutocommit(con$conn, TRUE)
	invisible(TRUE)
} 

dbDisconnect.JDBCConnection <- function(con, ...) {
	invisible(TRUE)
}

# dealing with ResultSet and ResultSetMetaData objects is far too ugly to do here
dbFetch.JDBCResultSet <- function(res, n=-1, ...) {
	JDBCUtils$fetch(res$resultset, n)	
}

dbColumnInfo.JDBCResultSet <- function(res, ...) {
	cinf <- JDBCUtils$columnInfo(res$resultset)	
	tpes <- unlist(lapply(cinf,'[[',"type"))
	nmes <- unlist(lapply(cinf,'[[',"name"))
	data.frame(field.name=nmes, field.type=tpes, data.type=.typeMapping[tpes])
}

dbHasCompleted.JDBCResultSet <- function(res, ...) {
	JDBCUtils$hasCompleted(res$resultset)
}

dbClearResult.JDBCResultSet <- function(res, ...) {
	res$resultset$close()
	res$statement$close()
}

# TODO: how to check this? do we need an env after all?
dbIsValid.JDBCResultSet <- function(res, ...) {
	TRUE
}

.typeMapping <- rep(c("numeric", "character", "character", "logical", "raw"), c(10, 3, 4, 1, 1))
names(.typeMapping) <- c(c("TINYINT", "SMALLINT", "INT", "BIGINT", "HUGEINT", "REAL", "DOUBLE", "DECIMAL", "WRD", "NUMBER"), 
		c("CHAR", "VARCHAR", "CLOB"), 
		c("INTERVAL", "DATE", "TIME", "TIMESTAMP"), 
		"BOOLEAN", 
		"BLOB")

# copied from DBI
.SQL92Keywords <- c("ABSOLUTE", "ADD", "ALL", "ALLOCATE", "ALTER", "AND", "ANY", 
		"ARE", "AS", "ASC", "ASSERTION", "AT", "AUTHORIZATION", "AVG", "BEGIN", 
		"BETWEEN", "BIT", "BIT_LENGTH", "BY", "CASCADE", "CASCADED", "CASE", "CAST",
		"CATALOG", "CHAR", "CHARACTER", "CHARACTER_LENGTH", "CHAR_LENGTH",
		"CHECK", "CLOSE", "COALESCE", "COLLATE", "COLLATION", "COLUMN",
		"COMMIT", "CONNECT", "CONNECTION", "CONSTRAINT", "CONSTRAINTS",
		"CONTINUE", "CONVERT", "CORRESPONDING", "COUNT", "CREATE", "CURRENT",
		"CURRENT_DATE", "CURRENT_TIMESTAMP", "CURRENT_TYPE", "CURSOR", "DATE",
		"DAY", "DEALLOCATE", "DEC", "DECIMAL", "DECLARE", "DEFAULT",
		"DEFERRABLE", "DEFERRED", "DELETE", "DESC", "DESCRIBE", "DESCRIPTOR",
		"DIAGNOSTICS", "DICONNECT", "DICTIONATRY", "DISPLACEMENT", "DISTINCT",
		"DOMAIN", "DOUBLE", "DROP", "ELSE", "END", "END-EXEC", "ESCAPE",
		"EXCEPT", "EXCEPTION", "EXEC", "EXECUTE", "EXISTS", "EXTERNAL",
		"EXTRACT", "FALSE", "FETCH", "FIRST", "FLOAT", "FOR", "FOREIGN",
		"FOUND", "FROM", "FULL", "GET", "GLOBAL", "GO", "GOTO", "GRANT",
		"GROUP", "HAVING", "HOUR", "IDENTITY", "IGNORE", "IMMEDIATE", "IN",
		"INCLUDE", "INDEX", "INDICATOR", "INITIALLY", "INNER", "INPUT",
		"INSENSITIVE", "INSERT", "INT", "INTEGER", "INTERSECT", "INTERVAL",
		"INTO", "IS", "ISOLATION", "JOIN", "KEY", "LANGUAGE", "LAST", "LEFT",
		"LEVEL", "LIKE", "LOCAL", "LOWER", "MATCH", "MAX", "MIN", "MINUTE",
		"MODULE", "MONTH", "NAMES", "NATIONAL", "NCHAR", "NEXT", "NOT", "NULL",
		"NULLIF", "NUMERIC", "OCTECT_LENGTH", "OF", "OFF", "ONLY", "OPEN",
		"OPTION", "OR", "ORDER", "OUTER", "OUTPUT", "OVERLAPS", "PARTIAL",
		"POSITION", "PRECISION", "PREPARE", "PRESERVE", "PRIMARY", "PRIOR",
		"PRIVILEGES", "PROCEDURE", "PUBLIC", "READ", "REAL", "REFERENCES",
		"RESTRICT", "REVOKE", "RIGHT", "ROLLBACK", "ROWS", "SCHEMA", "SCROLL",
		"SECOND", "SECTION", "SELECT", "SET", "SIZE", "SMALLINT", "SOME", "SQL",
		"SQLCA", "SQLCODE", "SQLERROR", "SQLSTATE", "SQLWARNING", "SUBSTRING",
		"SUM", "SYSTEM", "TABLE", "TEMPORARY", "THEN", "TIME", "TIMESTAMP",
		"TIMEZONE_HOUR", "TIMEZONE_MINUTE", "TO", "TRANSACTION", "TRANSLATE",
		"TRANSLATION", "TRUE", "UNION", "UNIQUE", "UNKNOWN", "UPDATE", "UPPER",
		"USAGE", "USER", "USING", "VALUE", "VALUES", "VARCHAR", "VARYING",
		"VIEW", "WHEN", "WHENEVER", "WHERE", "WITH", "WORK", "WRITE", "YEAR",
		"ZONE")

# this is a old DBI method that is used by sqlsurvey...
make.db.names <- function(conn, snames, keywords = .SQL92Keywords, 
		unique = TRUE, allow.keywords = TRUE) {
	makeUnique <- function(x, sep = "_") {
		if(length(x)==0) return(x)
		out <- x
		lc <- make.names(tolower(x), unique=FALSE)
		i <- duplicated(lc)
		lc <- make.names(lc, unique = TRUE)
		out[i] <- paste(out[i], substring(lc[i], first=nchar(out[i])+1), sep=sep)
		out
	}
	## Note: SQL identifiers *can* be enclosed in double or single quotes
	## when they are equal to reserverd keywords.
	fc <- substring(snames, 1, 1)
	lc <- substring(snames, nchar(snames))
	i <- match(fc, c("'", '"'), 0)>0 & match(lc, c("'", '"'), 0)>0
	snames[!i]  <- make.names(snames[!i], unique=FALSE)	
	
	if(unique)
		snames[!i] <- makeUnique(snames[!i])
	
	if(!allow.keywords){
		kwi <- match(keywords, toupper(snames), nomatch = 0L)
		snames[kwi] <- paste('"', snames[kwi], '"', sep='')
	}
	
	gsub("\\.", "_", snames)
}


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


dbDataType.JDBCConnection <- function(con, obj, ...) {
	if (is.factor(obj)) "TEXT"
	else if (is.logical(obj)) "BOOLEAN"
	else if (is.integer(obj)) "INTEGER"
	else if (is.numeric(obj)) "DOUBLE PRECISION"
	else if (is.raw(obj)) "BLOB"
	else "TEXT"
}

dbListFields.JDBCConnection <- function(con, name, ...) {
	if (!dbExistsTable(con, name))
		stop("Unknown table ", name);
	JDBCUtils$getColumns(con$conn, name)	
}

# TODO: this breaks if the value contains a ?, fix this (also in MonetDB.R!)
.bindParameters <- function(con, statement, param) {
	for (i in 1:length(param)) {
		value <- param[[i]]
		valueClass <- class(value)
		if (is.na(value))
			statement <- sub("?", "NULL", statement, fixed=TRUE)
		else if (valueClass %in% c("numeric", "logical", "integer"))
			statement <- sub("?", sub(",", ".",value), statement, fixed=TRUE)

		else if (valueClass == "factor")
			statement <- sub("?", paste(dbQuoteString(con, toString(as.character(value))), sep=""), statement, 
					fixed=TRUE)
		else if (valueClass == c("raw"))
			stop("raw() data is so far only supported when reading from BLOBs")
		else
			statement <- sub("?", paste(dbQuoteString(con, toString(value)), sep=""), statement, 
					fixed=TRUE)
	}
	statement
}
