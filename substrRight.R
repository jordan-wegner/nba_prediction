# gets everything to the right of the input number  

substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}