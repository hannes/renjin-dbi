library(hamcrest)
library(RH2GIS)

test.driver <- function() {
        dbPath = paste ("jdbc:h2:file:",tempdir(), "/db", sep = "", collapse = NULL)
	con <- dbConnect(RH2GIS(), url=dbPath, username="sa", password="")
	print(loadSpatialFunctions(con));
        sq <- dbSendQuery(con,"DROP TABLE IF EXISTS VANNES; CREATE TABLE VANNES (the_geom geometry, id int)")
        stopifnot(identical(dbExistsTable(con,"VANNES"),TRUE))
        sq <- dbSendQuery(con,"INSERT INTO VANNES VALUES('POLYGON ((100 300, 210 300, 210 200, 100 200, 100 300))'::GEOMETRY, 1)"); 
        stopifnot(identical(as.numeric(dbGetQuery(con,"SELECT ST_AREA(the_geom) as area FROM VANNES")[[1]]),11000))
}
