#Homework 6

#Part 1

#in numbers 3 and 4, individual plots are #commented out. the render together in the pushViewport chunks, but all coding
#for these items should be run together as a chunk.

#1. #weight to price by color
require(ggplot2) #using ggplot as required
require(grid) #will need grid later
data(diamonds) #dataframe is diamonds
carat_prc_scatter <- ggplot(diamonds, aes(x=carat, y=price))
carat_prc_scatter_1 <- carat_prc_scatter + geom_point(aes(color = factor(color))) + labs(title="Diamonds - Weight to Price by Color") + #designates scatterplot and creates title
  labs(x="Weight", y="Price") # this defines text of labels
print(carat_prc_scatter_1) #renders plot

#2. #remove non-linearity and replot. eg. take natural log of both variables.
e=2.718281 #natural logs use base e, which is a mathematical constant
carat_log <- log(diamonds$carat, base = e) #takes natural log of variable carat
price_log <- log(diamonds$price, base = e) #takes natural log of variable price
logged_variables <- data.frame(carat_log, price_log, diamonds$color) #create new data frame using logged variables, factor still color, so pull color from diamonds dataframe
carat_prc_log <- ggplot(logged_variables, aes(x=carat_log, y=price_log))
carat_prc_log_1 <- carat_prc_log + geom_point(aes(color = factor(diamonds$color))) + labs(title="Diamonds - Weight to Price by Color") + #changes title
  labs(x="Weight", y="Price", factor="Color") # this defines text of labels #factor label still includes 'diamonds$'
print(carat_prc_log_1) #renders plot

#3. #place on same page using grid
require(ggplot2)
require(grid)
resids <- resid(lm(price_log ~ carat_log, data = logged_variables)) #regresses natural logs of carat and price found in #2, then calculates residuals
pricebycarat <- data.frame(carat_log, price_log, diamonds$color, resids) #creates dataframe for scatterplot
pricebycarat_1 <- ggplot(pricebycarat, aes(carat_log, resids)) 
scattered_resids <- pricebycarat_1 + geom_point(aes(color = factor(diamonds$color))) + labs(title="Diamonds - Weight to Price by Color") + labs(x="Weight", y="Price Residuals") + 
  theme(legend.position = "top") #moves legend across the top
#print(scattered_resids) #renders plot

#creates density histogram for carat
xdensity <- data.frame(diamonds$carat, diamonds$color) #extracting data frame and putting it in a variable
bin50 <- (max(xdensity[[1]])-min(xdensity[[1]]))/50  #bin50 is a variable assigning range divided by 50 from column 1. this gives us width of bin
Test_Plot <- ggplot(xdensity, aes(x=xdensity[[1]], color = diamonds$color,)) #mapping variable to x axis
Test_Plot <- Test_Plot + aes(y=..density..) +
  geom_histogram(binwidth = bin50) + labs(x="", y="") + #telling R what binwidth we want, no labels
  theme(legend.position = "none") #removes legend,
#print(Test_Plot)

#creates density histogram for price #need it to flip the other way
ydensity <- data.frame(diamonds$price, diamonds$color) #extracting data frame and putting it in a variable

## Prof G: Test_Frame is not defined
#Test_Plot_2 <- ggplot(Test_Frame, aes(x=ydensity[[1]]), color = diamonds$color) #mapping variable to x axis
## Prof G: Try to fix it.
Test_Plot_2 <- ggplot(ydensity, aes(x=ydensity[[1]]), color = diamonds$color) #mapping variable to x axis


Test_Plot_2 <- Test_Plot_2 + geom_histogram(binwidth = 100) + aes(y=..density.., fill = factor(diamonds$color), color = factor(diamonds$color)) + #bin width of 100 should get close to plot in hw assignment
  coord_flip() +  labs(x="", y="") + theme(legend.position = "none") #rotates plot, but not the direction I want. No labels. Also eliminates legend 
#print(Test_Plot_2)

#puts the three together. maps specific items to specific cells
pushViewport(viewport(layout = grid.layout(10, 10))) #creates grid matrix of ten rows and ten columns
vplayout <- function(x,y) viewport(layout.pos.row =x, layout.pos.col = y) #creates a function that will allow mapping plots to specific cells
 print(Test_Plot_2, vp= vplayout(1:8,1:3)) #scaling each plot to specific cells
 print(scattered_resids, vp = vplayout(1:8, 4:10))
 print(Test_Plot, vp = vplayout(9:10,4:10))
##need to fix y labels so that "diamonds$" separates from "color"

#4. OVERLAY THESE ITEMS USING GRID.
require(ggplot2)
require(grid)
resids <- resid(lm(price_log ~ carat_log, data = logged_variables)) #regresses natural logs of carat and price found in #2, then calculates residuals
pricebycarat <- data.frame(carat_log, price_log, diamonds$color, resids) #creates dataframe for scatterplot
pricebycarat_1 <- ggplot(pricebycarat, aes(carat_log, resids)) 
scattered_resids <- pricebycarat_1 + geom_point(aes(color = factor(diamonds$color))) + theme(legend.postion = "top") + labs(title="Diamonds - Weight to Price by Color") + labs(x="Weight", y="Price Residuals")
#print(scattered_resids) 
 

xdensity <- data.frame(diamonds$carat, diamonds$color) #extracting data frame and putting it in a variable
bin50 <- (max(xdensity[[1]])-min(xdensity[[1]]))/50  #bin50 is a variable assigning range divided by 50 from column 1. this gives us width of bin
Test_Plot <- ggplot(xdensity, aes(x=xdensity[[1]], color = diamonds$color,)) #mapping variable to x axis
Test_Plot <- Test_Plot + aes(y=..density..) + #makes plot a density plot
  geom_histogram(binwidth = bin50) + labs(x="", y="") + #telling R what binwidth we want
  theme(legend.position = "none") #removing legend for this plot
#print(Test_Plot)
 
 
ydensity <- data.frame(diamonds$price, diamonds$color) #extracting data frame and putting it in a variable
Test_Plot_2 <- ggplot(Test_Frame, aes(x=ydensity[[1]]), color = diamonds$color) #mapping variable to x axis
Test_Plot_2 <- Test_Plot_2 + geom_histogram(binwidth = 100) + aes(y=..density.., fill = factor(diamonds$color), color = factor(diamonds$color)) +
  labs(x="", y="") + # no labels
  theme(legend.position = "none") #removing legend from this plot
#print(Test_Plot_2)
 
#putting individual plots together
pushViewport(viewport(layout = grid.layout(6,6))) #creates grid matrix of six rows and six columns
vplayout <- function(x,y) viewport(layout.pos.row =x, layout.pos.col = y) #creates a function that will allows mapping plots to specific cells
print(scattered_resids, vp = vplayout(1:6, 1:6))
print(Test_Plot_2, vp= vplayout(6, 1:2))
print(Test_Plot, vp = vplayout(2, 5:6)) #using similar approach to #3, but assigning to cells occupied by other plots

