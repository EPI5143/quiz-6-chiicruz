##################################################
## 
## SHERYLL DIMANLIG-CRUZ
## 
##################################################

library(tidyverse)
library(ggplot2)



# EPI5143 Winter 2020 Quiz 3. Due Wednesday March 11th, 2020 by 11:59pm.   
# Please provide the code (and results from console if requested) you used to execute 
# the requested commands in each question 1 to 4 in this file.  Don't forget to include 
# your name in the document! (and in the filename) don't include the plot images themselves
# When you have completed the assignment, save it in same file format right from RStudio 
# (.R which is simply a plain text file) ans submit it to Github using instructions 
# from last class and the link emailed to you
# If you haven't already, install the "tidyverse" package, and load it into memory
# using the library() command
# The data visualization lecture notes, as well as Chapter 3: Data Visualization from 
# "R for Data Science" (available at https://r4ds.had.co.nz/ ) are good resources to 
# provide guidance 

# Question 1. The dataset mpg dataset is a base R dataset which includes data on fuel efficiency of a number
# of makes and models of automobile Have a look at this dataset using the View() command.
# how many observations and how many variables does this dataset have? (provide the code 
# and result from the console window)
# (hint:  use the nrow() and ncol() and/or the dim()  R functions )

View(mpg)
nrow(mpg)
> nrow(mpg)
[1] 234
ncol(mpg)
> ncol(mpg)
[1] 11

#Answer: There are 234 observations and 11 variables.

# The following commands to ggplot create a basic plot of the 
# highway fuel efficiency vs.engine size (displacement in L) for vehicles in the dataset
# ie. x=displ and y=hwy, run this code and look at the plot 
# (click zoom in the plots window to make it bigger) 
##################
 ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy))
##################
# Question 2. modify and run the ggplot code to make each class of vehicle a different colour

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color=class))

# Question 3. further modify and run the code to use a different shape to plot vehicles
# according whether vehicle is front, rear or 4 wheel drive (drv)

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color=class, shape=drv))


# Question 4. further modify and run the code to make the size of each point on the plot proportional
# to the number of cylinders the vehicle's engine has (cyl)

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color=class, shape=drv, size=cyl))

# Question 5. Modify the code to add a suitable title of your choice to your plot
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color=class, shape=drv, size=cyl)) +
  labs(title="Fuel Efficiency and Engine Size of Cars") + theme(plot.title = element_text(hjust=0.5)) +
  xlab("Engine Size (Displacement in L)") +  ylab("Highway Fuel Efficiency")




