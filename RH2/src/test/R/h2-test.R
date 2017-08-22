library(hamcrest)
library(RH2)

test.driver <- function() {
        dbPath = paste (tempdir(), "/h2", sep = "", collapse = NULL)
        unlink(dbPath, recursive = FALSE, force = FALSE)
        dbUrl = paste ("jdbc:h2:file:",dbPath,"/db_external", sep = "", collapse = NULL)
	con <- dbConnect(RH2(), url=dbUrl, username="sa", password="")
	renjinDBITest(con)
}
