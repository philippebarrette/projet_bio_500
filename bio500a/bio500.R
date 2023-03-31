getwd()
setwd("C:/Users/phili/Documents")
install.packages('RSQLite')
library(RSQLite)

con <- dbConnect(SQLite(), dbname="")