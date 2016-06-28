library(hamcrest)
library(RH2)

test.driver <- function() {
	con <- dbConnect(RH2(), url="jdbc:h2:file:/tmp/db", username="sa", password="")
	renjinDBITest(con)
}
