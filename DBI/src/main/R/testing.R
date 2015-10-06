renjinDBITest <- function (con) {
	conn <- con
	
	
	iris <- structure(list(Sepal.Length = c(5.1, 4.9, 4.7, 4.6, 5, 5.4, 4.6, 
							5, 4.4, 4.9, 5.4, 4.8, 4.8, 4.3, 5.8, 5.7, 5.4, 5.1, 5.7, 5.1, 
							5.4, 5.1, 4.6, 5.1, 4.8, 5, 5, 5.2, 5.2, 4.7, 4.8, 5.4, 5.2, 
							5.5, 4.9, 5, 5.5, 4.9, 4.4, 5.1, 5, 4.5, 4.4, 5, 5.1, 4.8, 5.1, 
							4.6, 5.3, 5, 7, 6.4, 6.9, 5.5, 6.5, 5.7, 6.3, 4.9, 6.6, 5.2, 
							5, 5.9, 6, 6.1, 5.6, 6.7, 5.6, 5.8, 6.2, 5.6, 5.9, 6.1, 6.3, 
							6.1, 6.4, 6.6, 6.8, 6.7, 6, 5.7, 5.5, 5.5, 5.8, 6, 5.4, 6, 6.7, 
							6.3, 5.6, 5.5, 5.5, 6.1, 5.8, 5, 5.6, 5.7, 5.7, 6.2, 5.1, 5.7, 
							6.3, 5.8, 7.1, 6.3, 6.5, 7.6, 4.9, 7.3, 6.7, 7.2, 6.5, 6.4, 6.8, 
							5.7, 5.8, 6.4, 6.5, 7.7, 7.7, 6, 6.9, 5.6, 7.7, 6.3, 6.7, 7.2, 
							6.2, 6.1, 6.4, 7.2, 7.4, 7.9, 6.4, 6.3, 6.1, 7.7, 6.3, 6.4, 6, 
							6.9, 6.7, 6.9, 5.8, 6.8, 6.7, 6.7, 6.3, 6.5, 6.2, 5.9), Sepal.Width = c(3.5, 
							3, 3.2, 3.1, 3.6, 3.9, 3.4, 3.4, 2.9, 3.1, 3.7, 3.4, 3, 3, 4, 
							4.4, 3.9, 3.5, 3.8, 3.8, 3.4, 3.7, 3.6, 3.3, 3.4, 3, 3.4, 3.5, 
							3.4, 3.2, 3.1, 3.4, 4.1, 4.2, 3.1, 3.2, 3.5, 3.6, 3, 3.4, 3.5, 
							2.3, 3.2, 3.5, 3.8, 3, 3.8, 3.2, 3.7, 3.3, 3.2, 3.2, 3.1, 2.3, 
							2.8, 2.8, 3.3, 2.4, 2.9, 2.7, 2, 3, 2.2, 2.9, 2.9, 3.1, 3, 2.7, 
							2.2, 2.5, 3.2, 2.8, 2.5, 2.8, 2.9, 3, 2.8, 3, 2.9, 2.6, 2.4, 
							2.4, 2.7, 2.7, 3, 3.4, 3.1, 2.3, 3, 2.5, 2.6, 3, 2.6, 2.3, 2.7, 
							3, 2.9, 2.9, 2.5, 2.8, 3.3, 2.7, 3, 2.9, 3, 3, 2.5, 2.9, 2.5, 
							3.6, 3.2, 2.7, 3, 2.5, 2.8, 3.2, 3, 3.8, 2.6, 2.2, 3.2, 2.8, 
							2.8, 2.7, 3.3, 3.2, 2.8, 3, 2.8, 3, 2.8, 3.8, 2.8, 2.8, 2.6, 
							3, 3.4, 3.1, 3, 3.1, 3.1, 3.1, 2.7, 3.2, 3.3, 3, 2.5, 3, 3.4, 
							3), Petal.Length = c(1.4, 1.4, 1.3, 1.5, 1.4, 1.7, 1.4, 1.5, 
							1.4, 1.5, 1.5, 1.6, 1.4, 1.1, 1.2, 1.5, 1.3, 1.4, 1.7, 1.5, 1.7, 
							1.5, 1, 1.7, 1.9, 1.6, 1.6, 1.5, 1.4, 1.6, 1.6, 1.5, 1.5, 1.4, 
							1.5, 1.2, 1.3, 1.4, 1.3, 1.5, 1.3, 1.3, 1.3, 1.6, 1.9, 1.4, 1.6, 
							1.4, 1.5, 1.4, 4.7, 4.5, 4.9, 4, 4.6, 4.5, 4.7, 3.3, 4.6, 3.9, 
							3.5, 4.2, 4, 4.7, 3.6, 4.4, 4.5, 4.1, 4.5, 3.9, 4.8, 4, 4.9, 
							4.7, 4.3, 4.4, 4.8, 5, 4.5, 3.5, 3.8, 3.7, 3.9, 5.1, 4.5, 4.5, 
							4.7, 4.4, 4.1, 4, 4.4, 4.6, 4, 3.3, 4.2, 4.2, 4.2, 4.3, 3, 4.1, 
							6, 5.1, 5.9, 5.6, 5.8, 6.6, 4.5, 6.3, 5.8, 6.1, 5.1, 5.3, 5.5, 
							5, 5.1, 5.3, 5.5, 6.7, 6.9, 5, 5.7, 4.9, 6.7, 4.9, 5.7, 6, 4.8, 
							4.9, 5.6, 5.8, 6.1, 6.4, 5.6, 5.1, 5.6, 6.1, 5.6, 5.5, 4.8, 5.4, 
							5.6, 5.1, 5.1, 5.9, 5.7, 5.2, 5, 5.2, 5.4, 5.1), Petal.Width = c(0.2, 
							0.2, 0.2, 0.2, 0.2, 0.4, 0.3, 0.2, 0.2, 0.1, 0.2, 0.2, 0.1, 0.1, 
							0.2, 0.4, 0.4, 0.3, 0.3, 0.3, 0.2, 0.4, 0.2, 0.5, 0.2, 0.2, 0.4, 
							0.2, 0.2, 0.2, 0.2, 0.4, 0.1, 0.2, 0.2, 0.2, 0.2, 0.1, 0.2, 0.2, 
							0.3, 0.3, 0.2, 0.6, 0.4, 0.3, 0.2, 0.2, 0.2, 0.2, 1.4, 1.5, 1.5, 
							1.3, 1.5, 1.3, 1.6, 1, 1.3, 1.4, 1, 1.5, 1, 1.4, 1.3, 1.4, 1.5, 
							1, 1.5, 1.1, 1.8, 1.3, 1.5, 1.2, 1.3, 1.4, 1.4, 1.7, 1.5, 1, 
							1.1, 1, 1.2, 1.6, 1.5, 1.6, 1.5, 1.3, 1.3, 1.3, 1.2, 1.4, 1.2, 
							1, 1.3, 1.2, 1.3, 1.3, 1.1, 1.3, 2.5, 1.9, 2.1, 1.8, 2.2, 2.1, 
							1.7, 1.8, 1.8, 2.5, 2, 1.9, 2.1, 2, 2.4, 2.3, 1.8, 2.2, 2.3, 
							1.5, 2.3, 2, 2, 1.8, 2.1, 1.8, 1.8, 1.8, 2.1, 1.6, 1.9, 2, 2.2, 
							1.5, 1.4, 2.3, 2.4, 1.8, 1.8, 2.1, 2.4, 2.3, 1.9, 2.3, 2.5, 2.3, 
							1.9, 2, 2.3, 1.8), Species = structure(c(1L, 1L, 1L, 1L, 1L, 
									1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 
									1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 
									1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 2L, 2L, 2L, 
									2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 
									2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 
									2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 3L, 
									3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 
									3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 
									3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 3L, 
									3L), .Label = c("setosa", "versicolor", "virginica"), class = "factor")), .Names = c("Sepal.Length", 
					"Sepal.Width", "Petal.Length", "Petal.Width", "Species"), row.names = c(NA, 
					-150L), class = "data.frame")
	
	
	
	mtcars <- structure(list(mpg = c(21, 21, 22.8, 21.4, 18.7, 18.1, 14.3, 
							24.4, 22.8, 19.2, 17.8, 16.4, 17.3, 15.2, 10.4, 10.4, 14.7, 32.4, 
							30.4, 33.9, 21.5, 15.5, 15.2, 13.3, 19.2, 27.3, 26, 30.4, 15.8, 
							19.7, 15, 21.4), cyl = c(6, 6, 4, 6, 8, 6, 8, 4, 4, 6, 6, 8, 
							8, 8, 8, 8, 8, 4, 4, 4, 4, 8, 8, 8, 8, 4, 4, 4, 8, 6, 8, 4), 
					disp = c(160, 160, 108, 258, 360, 225, 360, 146.7, 140.8, 
							167.6, 167.6, 275.8, 275.8, 275.8, 472, 460, 440, 78.7, 75.7, 
							71.1, 120.1, 318, 304, 350, 400, 79, 120.3, 95.1, 351, 145, 
							301, 121), hp = c(110, 110, 93, 110, 175, 105, 245, 62, 95, 
							123, 123, 180, 180, 180, 205, 215, 230, 66, 52, 65, 97, 150, 
							150, 245, 175, 66, 91, 113, 264, 175, 335, 109), drat = c(3.9, 
							3.9, 3.85, 3.08, 3.15, 2.76, 3.21, 3.69, 3.92, 3.92, 3.92, 
							3.07, 3.07, 3.07, 2.93, 3, 3.23, 4.08, 4.93, 4.22, 3.7, 2.76, 
							3.15, 3.73, 3.08, 4.08, 4.43, 3.77, 4.22, 3.62, 3.54, 4.11
					), wt = c(2.62, 2.875, 2.32, 3.215, 3.44, 3.46, 3.57, 3.19, 
							3.15, 3.44, 3.44, 4.07, 3.73, 3.78, 5.25, 5.424, 5.345, 2.2, 
							1.615, 1.835, 2.465, 3.52, 3.435, 3.84, 3.845, 1.935, 2.14, 
							1.513, 3.17, 2.77, 3.57, 2.78), qsec = c(16.46, 17.02, 18.61, 
							19.44, 17.02, 20.22, 15.84, 20, 22.9, 18.3, 18.9, 17.4, 17.6, 
							18, 17.98, 17.82, 17.42, 19.47, 18.52, 19.9, 20.01, 16.87, 
							17.3, 15.41, 17.05, 18.9, 16.7, 16.9, 14.5, 15.5, 14.6, 18.6
					), vs = c(0, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 
							0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1), am = c(1, 
							1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 
							0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1), gear = c(4, 4, 4, 3, 
							3, 3, 3, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 4, 4, 4, 3, 3, 3, 
							3, 3, 4, 5, 5, 5, 5, 5, 4), carb = c(4, 4, 1, 1, 2, 1, 4, 
							2, 2, 4, 4, 3, 3, 3, 4, 4, 4, 1, 2, 1, 1, 2, 2, 4, 2, 1, 
							2, 2, 4, 6, 8, 2)), .Names = c("mpg", "cyl", "disp", "hp", 
					"drat", "wt", "qsec", "vs", "am", "gear", "carb"), row.names = c("Mazda RX4", 
					"Mazda RX4 Wag", "Datsun 710", "Hornet 4 Drive", "Hornet Sportabout", 
					"Valiant", "Duster 360", "Merc 240D", "Merc 230", "Merc 280", 
					"Merc 280C", "Merc 450SE", "Merc 450SL", "Merc 450SLC", "Cadillac Fleetwood", 
					"Lincoln Continental", "Chrysler Imperial", "Fiat 128", "Honda Civic", 
					"Toyota Corolla", "Toyota Corona", "Dodge Challenger", "AMC Javelin", 
					"Camaro Z28", "Pontiac Firebird", "Fiat X1-9", "Porsche 914-2", 
					"Lotus Europa", "Ford Pantera L", "Ferrari Dino", "Maserati Bora", 
					"Volvo 142E"), class = "data.frame")
	
	tname <- "renjintest"
	
# basic MAPI/SQL test
# Oracle does not like this...
#	stopifnot(identical(dbGetQuery(con,"SELECT 'DPFKG!'")[[1]],"DPFKG!"))
	
# is valid?
	stopifnot(dbIsValid(con))
	
# remove test table
	if (dbExistsTable(con,tname)) dbRemoveTable(con,tname)
	stopifnot(identical(dbExistsTable(con,tname),FALSE))
	
	
# test basic handling
	dbSendUpdate(con,"CREATE TABLE renjintest (a varchar(10),b integer,c varchar(100))")
	stopifnot(identical(dbExistsTable(con,tname),TRUE))
	dbSendUpdate(con,"INSERT INTO renjintest VALUES ('one',1,'1111')")
	dbSendUpdate(con,"INSERT INTO renjintest VALUES ('two',2,'22222222')")
	stopifnot(identical(as.integer(dbGetQuery(con,"SELECT count(*) FROM renjintest")[[1]]),2L))
	stopifnot(identical(dbReadTable(con,tname)[[3]],c("1111", "22222222")))
	dbRemoveTable(con,tname)
	stopifnot(identical(dbExistsTable(con,tname),FALSE))
	
# write test table iris
	
	dbWriteTable(con,tname,iris)
	
	stopifnot(identical(dbExistsTable(con,tname),TRUE))
	stopifnot(identical(dbExistsTable(con,"monetdbtest2"),FALSE))
	# we have no way of knowing whether the table name was uppercased or not.
	stopifnot(tolower(tname) %in% tolower(dbListTables(con)))
		
	stopifnot(identical(tolower(dbListFields(con,tname)),c("sepal_length","sepal_width",
							"petal_length","petal_width","species")))
# get stuff, first very convenient
	iris2 <- dbReadTable(con,tname)
	stopifnot(identical(dim(iris), dim(iris2)))
	
# then manually
	res <- dbSendQuery(con,"SELECT species, sepal_width FROM renjintest")
	stopifnot(dbIsValid(res))
	stopifnot(identical(res$success,TRUE))
	
	stopifnot(tolower(dbColumnInfo(res)[[1,1]]) == "species")
	stopifnot(tolower(dbColumnInfo(res)[[2,1]]) == "sepal_width")
# cannot get row count, JDBC does not export it
# stopifnot(dbGetInfo(res)$row.count == 150 && res@env$info$rows == 150)

	data <- dbFetch(res, 10)
	
	stopifnot(dim(data)[[1]] == 10)
	stopifnot(dim(data)[[2]] == 2)
	stopifnot(attr(res, 'env')$delivered == 10)
	stopifnot(dbHasCompleted(res) == FALSE)
	
# fetch rest
	data2 <- dbFetch(res, -1)
	stopifnot(dim(data2)[[1]] == 140)
	stopifnot(dbHasCompleted(res) == TRUE)
	
	stopifnot(dbIsValid(res))
	dbClearResult(res)
	
# TODO: get this to work, not now
#	stopifnot(!dbIsValid(res))
	
# remove table again
	dbRemoveTable(con,tname)
	stopifnot(identical(dbExistsTable(con,tname),FALSE))
	
	write.csv <- function(df,fl, sep=",") {
		as.csv <- function(df) {
			sapply(1:nrow(df), function(row.index)
						paste(df[row.index,], collapse=sep))
		}
		fl = file(fl)
		writeLines(paste(names(df), collapse=sep), con = fl)
		writeLines(as.csv(df), con = fl)	
		close(fl)
	}
	
# test dbWriteTable
	tsize <- function(conn,tname) 
		as.integer(dbGetQuery(conn,paste0("SELECT COUNT(*) FROM ",tname))[[1]])
	
# clean up
	if (dbExistsTable(conn,tname))
		dbRemoveTable(conn,tname)
	
# table does not exist, append=F, overwrite=F, this should work
	dbWriteTable(conn,tname,mtcars,append=F,overwrite=F)
	stopifnot(dbExistsTable(conn,tname))
	stopifnot(identical(nrow(mtcars),tsize(conn,tname)))
	
# these should throw errors
	errorThrown <- F
	tryCatch(dbWriteTable(conn,tname,mtcars,append=F,overwrite=F),error=function(e){errorThrown <<- T})
	stopifnot(errorThrown)
	
	errorThrown <- F
	tryCatch(dbWriteTable(conn,tname,mtcars,overwrite=T,append=T),error=function(e){errorThrown <<- T})
	stopifnot(errorThrown)
	
# this should be fine
	dbWriteTable(conn,tname,mtcars,append=F,overwrite=T)
	stopifnot(dbExistsTable(conn,tname))
	stopifnot(identical(nrow(mtcars),tsize(conn,tname)))
	
# append to existing table
	dbWriteTable(conn,tname,mtcars,append=T,overwrite=F)
	stopifnot(identical(as.integer(2*nrow(mtcars)),tsize(conn,tname)))
	dbRemoveTable(conn,tname)
	
	dbRemoveTable(conn,tname)
	dbWriteTable(conn,tname,mtcars,append=F,overwrite=F,insert=T)
	dbRemoveTable(conn,tname)
	
# info
#stopifnot(identical("MonetDBDriver", dbGetInfo(MonetDB.R())$name))
#stopifnot(identical("MonetDBConnection", dbGetInfo(conn)$name))
	
# transactions...
	stopifnot(!dbExistsTable(conn,tname))
	sq <- dbSendQuery(conn, "CREATE TABLE renjintest (a integer)")
	stopifnot(dbExistsTable(conn,tname))
	
	dbBegin(conn)
	sq <- dbSendQuery(conn,"INSERT INTO renjintest VALUES (42)")
	stopifnot(identical(1L, tsize(conn, tname)))
	dbRollback(conn)
	stopifnot(identical(0L, tsize(conn, tname)))
	dbBegin(conn)
	sq <- dbSendQuery(conn,"INSERT INTO renjintest VALUES (42)")
	stopifnot(identical(1L, tsize(conn, tname)))
	dbCommit(conn)
	stopifnot(identical(1L, tsize(conn, tname)))
	dbRemoveTable(conn,tname)
	
# funny characters in strings
	
# TODO: UTF escapes in JDBC, yummy. Not now. sqlsurvey does not need this after all
	stopifnot(dbIsValid(conn))
#dbBegin(conn)
#sq <- dbSendQuery(conn,"CREATE TABLE monetdbtest (a string)")
#sq <- dbSendQuery(conn,"INSERT INTO monetdbtest VALUES ('Роман Mühleisen')")
#stopifnot(identical("Роман Mühleisen", dbGetQuery(conn,"SELECT a FROM monetdbtest")$a[[1]]))
#sq <- dbSendQuery(conn,"DELETE FROM monetdbtest")
#dbSendUpdate(conn, "INSERT INTO monetdbtest (a) VALUES (?)", "Роман Mühleisen")
#stopifnot(identical("Роман Mühleisen", dbGetQuery(conn,"SELECT a FROM monetdbtest")$a[[1]]))
#dbRollback(conn)
	
	stopifnot(dbIsValid(conn))
#thrice to catch null pointer errors
	stopifnot(identical(dbDisconnect(con),TRUE))
# TODO: fix this
#stopifnot(!dbIsValid(conn))
#stopifnot(identical(dbDisconnect(con),TRUE))
#stopifnot(identical(dbDisconnect(con),TRUE))
	

}
