library(hamcrest)
library(RSQLite)

test.driver <- function() {
	drv <- dbDriver("RSQLite")	
	con <- conn <- dbConnect(drv, url="jdbc:sqlite:", username="", password="")
	con <- conn <- dbConnect(drv) # shorthand
	renjinDBITest(con)
}
