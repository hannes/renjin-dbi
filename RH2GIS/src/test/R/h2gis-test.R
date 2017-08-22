library(hamcrest)
library(RH2GIS)

test.driver <- function() {
        dbPath = paste (tempdir(), "/h2gis", sep = "", collapse = NULL)
        unlink(dbPath, recursive = FALSE, force = FALSE)
        dbUrl = paste ("jdbc:h2:file:",dbPath,"/db_external", sep = "", collapse = NULL)
        con <- dbConnect(RH2GIS(), url=dbUrl, username="sa", password="")
	print(loadSpatialFunctions(con));
        sq <- dbSendQuery(con,"DROP TABLE IF EXISTS VANNES; CREATE TABLE VANNES (the_geom geometry, id int)")
        stopifnot(identical(dbExistsTable(con,"VANNES"),TRUE))
        sq <- dbSendQuery(con,"INSERT INTO VANNES VALUES('POLYGON ((100 300, 210 300, 210 200, 100 200, 100 300))'::GEOMETRY, 1)"); 
        stopifnot(identical(as.numeric(dbGetQuery(con,"SELECT ST_AREA(the_geom) as area FROM VANNES")[[1]]),11000))
}


test.externalFile <- function() {        
        dbPath = paste (tempdir(), "/h2gis", sep = "", collapse = NULL)
        unlink(dbPath, recursive = FALSE, force = FALSE)
        dbUrl = paste ("jdbc:h2:file:",dbPath,"/db_external", sep = "", collapse = NULL)
	con <- dbConnect(RH2GIS(), url=dbUrl, username="sa", password="")
        sq <- dbSendQuery(con,"DROP TABLE IF EXISTS VANNES, LINKED_SHAPE; CREATE TABLE VANNES (the_geom geometry, gid int)")
        sq <- dbSendQuery(con,"INSERT INTO VANNES VALUES('POLYGON ((100 300, 210 300, 210 200, 100 200, 100 300))'::GEOMETRY, 1)"); 
        shapeWrite = paste ("CALL SHPWrite('",dbPath, "/vannes.shp', 'VANNES')", sep = "", collapse = NULL)      
        dbSendQuery(con,shapeWrite);
        shapeTable = paste ("CALL FILE_TABLE('",dbPath, "/vannes.shp', 'LINKED_SHAPE')", sep = "", collapse = NULL)
        dbSendQuery(con,shapeTable);
        stopifnot(identical(dbExistsTable(con,"LINKED_SHAPE"),TRUE))
        dbRemoveTable(con, "LINKED_SHAPE");
        stopifnot(identical(dbExistsTable(con,"LINKED_SHAPE"),FALSE))
}
