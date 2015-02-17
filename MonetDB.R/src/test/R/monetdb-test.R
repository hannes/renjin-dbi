library(hamcrest)
library(MonetDB.R)

test.driver <- function() {
	con <- dbConnect(MonetDB.R(), url="jdbc:monetdb://localhost:50000/renjintest", username="renjintest", password="renjintest")
	renjinDBITest(con)
}
