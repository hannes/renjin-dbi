library(hamcrest)
library(RH2GIS)

test.driver <- function() {
	con <- dbConnect(RH2GIS(), url="jdbc:h2:file:/tmp/db", username="sa", password="")
	sq <- dbSendQuery(con,"CREATE ALIAS IF NOT EXISTS H2GIS_EXTENSION FOR \"org.h2gis.ext.H2GISExtension.load\";")
        sq <- dbSendQuery(con,"CALL H2GIS_EXTENSION()")
        sq <- dbSendQuery(con,"DROP TABLE IF EXISTS VANNES; CREATE TABLE VANNES (the_geom geometry, id int)")
        stopifnot(identical(dbExistsTable(con,"VANNES"),TRUE))
}
