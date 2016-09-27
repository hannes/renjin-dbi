[R DBI](http://cran.r-project.org/web/packages/DBI/index.html) interface and various database interfaces for [Renjn](http://www.renjin.org/).

Example usage:

## MonetDB
```R
library(MonetDB.R)
con <- dbConnect(MonetDB.R(), url="jdbc:monetdb://localhost:50000/somedatabase", username="monetdb", password="monetdb")
df  <- dbGetQuery(con, "SELECT * from sometable")
```

## MySQL/MariaDB
```R
library(RMySQL)
con <- dbConnect(RMySQL(), url="jdbc:mysql://localhost:3306/somedatabase", username="someuser", password="somepass")
df  <- dbGetQuery(con, "SELECT * from sometable")
```

## Oracle ®
```R
library(ROracle)
con <- dbConnect(ROracle(), url="jdbc:oracle:thin:@localhost", username="someuser", password="somepass")
df  <- dbGetQuery(con, "SELECT * from sometable")
```

## PostgreSQL
```R
library(RPostgreSQL)
con <- dbConnect(RPostgreSQL(), url="jdbc:postgresql://localhost:5432/somedatabase", username="someuser", password="somepass")
df  <- dbGetQuery(con, "SELECT * from sometable")
```

## SQLite
```R
library(RSQLite)
con <- dbConnect(RSQLite(), url="jdbc:sqlite:", username="", password="")
df  <- dbGetQuery(con, "SELECT * from sometable")
```


## H2 database
```R
library(RH2)
con <- dbConnect(RH2(), url="jdbc:h2:file:/tmp/mydb", username="", password="")
df  <- dbGetQuery(con, "SELECT * from sometable")
```

## H2GIS database
```R
library(RH2GIS)
con <- dbConnect(RH2GIS(), url="jdbc:h2:file:/tmp/mydb", username="sa", password="")
loadSpatialFunctions(con)
#Create a table with a geometry column
dbSendQuery(con,"CREATE TABLE VANNES (the_geom geometry, id int)")
#Insert a polygon
dbSendQuery(con,"INSERT INTO VANNES VALUES('POLYGON ((100 300, 210 300, 210 200, 100 200, 100 300))'::geometry, 1)"); 
#Run a spatial function
df  <- dbGetQuery(con,"SELECT ST_AREA(the_geom) as area FROM VANNES")
```
