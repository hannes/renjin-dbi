library(hamcrest)
library(MonetDB.R)

test.driver <- function() {
	con <- dbConnect(MonetDB.R(), port=50000, dbname="mTests_clients_R", wait=T)
	renjinDBITest(con)
}
