library(hamcrest)
library(ROracle)

test.driver <- function() renjinDBITest(dbConnect(ROracle(), url="jdbc:oracle:thin:@localhost", username="renjintest", password="renjintest"))
