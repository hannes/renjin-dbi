library(hamcrest)
library(RPostgreSQL)

test.driver <- function() {
	con <- dbConnect(RPostgreSQL(), url="jdbc:postgresql://localhost:5432/renjintest", username="renjintest", password="renjintest")
	renjinDBITest(con)
}
