NOK <- function(nokdata){
  
  suppressMessages(library(stringr))
  nokdata$Group.1 <- str_replace(nokdata$Group.1, 'NOK', 'NOH')
  return(nokdata)
  
}