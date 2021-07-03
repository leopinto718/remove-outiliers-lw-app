# remove-outliers-lw-app
Removing outliers by graphic inspection is largely used when treating length-weight data of fish. Picking these observations one by one, however, may demand a lot of time, especially when you have a dataset with a large number of species. Besides, this methodology might sometimes generate different outcomes depending on the person doing it. The use of student residuals has long been used to remove outliers from many different kinds of data and it is defined as the quotient from a division between a residual and an estimate of its standard deviation (Cook & Weisberg, 1982). With this in mind, we written a function in R to automatically remove the data outliers based on statistical criteria. This function calculates the student residuals of the observations and removes the ones which are out of the range between -2.5 and 2.5 (Parker et al. 2018). After this we implemented the function in a app using the web app development Shiny. This repository contains the development version of the software and web application.

### Use of the App

### Citation

### Use offline

### Contact us

### Authors

### References
Cook, R. D., & Weisberg, S. (1982). *Residuals and influence in regression.* New York: Chapman and Hall.

Parker, J., Fritts, M. W., & DeBoer, J. A. (2018). Length-weight relationships for small Midwestern US fishes. *Journal of Applied Ichthyology*, 34(4), 1081-1083.
