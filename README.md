# remove-outliers-lw-app
Removing outliers by graphic inspection is largely used when treating length-weight data of fish. Picking these observations one by one, however, may demand a lot of time, especially when you have a dataset with a large number of species. Besides, this methodology might sometimes generate different outcomes depending on the person doing it. The use of standard residuals has long been used to remove outliers from many different kinds of data and it is defined as the quotient from a division between a residual and an estimate of its standard deviation (Cook & Weisberg, 1982). 

With this in mind, we have written a function in R to automatically remove the data outliers based on statistical criteria. This function calculates the student residuals of the observations and removes the ones which are out of the range between -2.5 and 2.5 (Parker et al. 2018). After this, we implemented the function in an app, using the web app development package Shiny. This repository contains the code for the app and a brief tutorial on how to use it.

### Use of the App

You can access the app by clicking here: [remove-outliers-lw-app](https://leopinto.shinyapps.io/remove_outlier_from_lw_data/)

The use of the app is very straightfoward, but here are some steps you should follow:

**1.** Upload the file with the data by clicking in the **Browse** button.

**2.** Choose the range of the standard residuals to be considered when treating outliers. The default is between -2.5 and 2.5 (Parker et al. 2018).

**3.** By pressing the **Remove outliers** buttom the app will generate three results: 
   1. One scatter plot containing all the data, including the outliers that will be shown in red
   1. Another one with the data after the outlier treatment
   1. A table with a before and after summary of the outlier treatment
 
**4.** You will have the option of downloading only the selected outliers if you want to inspect it or download the data with the exclusion of the outliers, ready to fit a model 

The app has only three requirements in order to properly function:

1. The upload archive should be an **.csv** with **","** as separator.
1. It should contain the logarithmized length and weight in columns named **LogL** and **LogW** respectively.
1. You should avoid using archives with any special characters like accents.


### Contact us

In case of any questions, please create an issue on github or email leopinto.ca@gmail.com

### Authors
[Leonardo Mesquita Pinto](http://lattes.cnpq.br/5850104797441922)

[Ronaldo César Gurgel Lourenço](http://lattes.cnpq.br/6413963941929910)

[Jorge Iván Sánchez Botero](http://lattes.cnpq.br/9058005255713255)

### References
Cook, R. D., & Weisberg, S. (1982). *Residuals and influence in regression.* New York: Chapman and Hall.

Parker, J., Fritts, M. W., & DeBoer, J. A. (2018). Length-weight relationships for small Midwestern US fishes. *Journal of Applied Ichthyology*, 34(4), 1081-1083. https://doi.org/10.1111/jai.13721
