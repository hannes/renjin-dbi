library(hamcrest)
library(RMySQL)

test.driver <- function() {
	con <- dbConnect(RMySQL(), url="jdbc:mysql://localhost:3306/renjintest", username="renjintest", password="renjintest")
	renjinDBITest(con)
}
