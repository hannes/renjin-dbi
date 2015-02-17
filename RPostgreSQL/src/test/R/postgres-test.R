library(hamcrest)
library(RPostgreSQL)

test.driver <- function() {
	drv <- dbDriver("RPostgreSQL")	
	con <- dbConnect(drv, url="jdbc:postgresql://localhost/hannes", username="hannes", password="")
	renjinDBITest(con)
}
