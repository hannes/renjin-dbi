library(hamcrest)
library(RMySQL)

test.driver <- function() {
	drv <- dbDriver("RMySQL")
	con <- dbConnect(drv, url="jdbc:mysql://localhost:3306/renjintest", username="renjintest", password="renjintest")
	renjinDBITest(con)
}
