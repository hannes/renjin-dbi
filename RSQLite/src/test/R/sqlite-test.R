library(hamcrest)
library(RSQLite)

test.driver <- function() {
	drv <- dbDriver("RSQLite")	
	con <- dbConnect(drv, url="jdbc:sqlite:", username="", password="")
	con <- dbConnect(drv) # shorthand
	renjinDBITest(con)
}
