## San Fransisco Crime Classification

This project contains and demonstrates my contribution
to the San Fransisco Crime Classification problem of Kaggle.
The task is carried out using R.
   
DATASET:
        
For this report, only the training data, `train.csv` is used
for quick evaluation of the approaches.
Nonetheless, the models that are used can most certainly be tried
on the test.csv file of the San Fransisco Crime Classification.
The data can be retrieved from the link below:
https://www.kaggle.com/c/sf-crime/data
	
NOTE: please keep `train.csv` in the working directory
while running the code(s) 
  
The packages used are: dplyr`, `lubridate`,
`nnet`, `caret`, `doMC`, `data.table` and `phyclust`
    
Brief descriptions of the files are given below:
- report.pdf:
	Description of the approaches that are taken.
- report.Rmd:
        This is the rmarkdown file that generated the pdf above.
        Given all the packages are installed,
        knitting this file in R should generate the same pdf.
        The process takes less than 5 minutes in a Unix machine of RAM 4GB.
- experiment.Rmd:
This file is the same as report.Rmd.
Any changes made and executed to the code chunk of this file
will generate another report `experiment.pdf`.
    
Possible changes might be, changing the size of subset
used for evaluation.
The original report produces and shows results
of a subset of 2,000 observations from the full 878,049.
This is indeed done for convenient report generation,
but as a result, the accuracy of the models suffer.
The amount of subset to be considered can be easily changed
by simple changing the value of `m` in the code.
If, `m` is very large (i.e. close the 878,049),
then computation will take longer and
might even require bigger RAM.
    
Other possible changes include chaning the tuning parameters
of the learning models. But once again, these changes
must be done with patience and caution,
since longer time and bigger RAM might be required.

