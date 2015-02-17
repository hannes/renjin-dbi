library(hamcrest)
library(RMySQL)

test.driver <- function() {
	drv <- dbDriver("RMySQL")
	con <- dbConnect(drv, url="jdbc:mysql://localhost/testing", username="root", password="")
	renjinDBITest(con)
}
