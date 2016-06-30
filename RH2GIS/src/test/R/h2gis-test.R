library(hamcrest)
library(RH2GIS)

test.driver <- function() {
	con <- dbConnect(RH2GIS(), url="jdbc:h2:file:/tmp/db", username="sa", password="")
	print(loadSpatialFunctions(con));
        sq <- dbSendQuery(con,"DROP TABLE IF EXISTS VANNES; CREATE TABLE VANNES (the_geom geometry, id int)")
        stopifnot(identical(dbExistsTable(con,"VANNES"),TRUE))
        sq <- dbSendQuery(con,"INSERT INTO VANNES VALUES('POINT(0 1)'::GEOMETRY, 1)"); 
        sq <- dbSendQuery(con,"SELECT ST_BUFFER(the_geom, 20) as the_geom FROM VANNES");
}
