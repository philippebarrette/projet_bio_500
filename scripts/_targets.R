library(targets)
install.packages(target)
render("mon_rmarkdown.Rmd")
rmarkdown::render

a = rnorm(1000,1,1)
hist(a)
