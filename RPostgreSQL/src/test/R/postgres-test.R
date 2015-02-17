library(hamcrest)
library(RPostgreSQL)

test.driver <- function() {
	drv <- dbDriver("RPostgreSQL")	
	con <- dbConnect(drv, url="jdbc:postgresql://localhost:5432/renjintest", username="renjintest", password="renjintest")
	renjinDBITest(con)
}
