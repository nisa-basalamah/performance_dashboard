# Performance Analysis Dashboard

This dashboard is part of the Analysing Esports Players’ Skills and Performance project. You may read the full version of the project from this [link](https://rpubs.com/nisa_basalamah/esports_performance_analysis) to the article or try to replicate the dashboard by downloading the file from this repository.

## Things to prepare:

1. Install R and RStudio
    - [R installation](http://cran.us.r-project.org/)
    - [RStudio installation](https://www.rstudio.com/products/rstudio/download/)
    - [Rtools installation](https://cran.r-project.org/bin/windows/Rtools/) (for Windows users)  
    
2. Make an account at [shinyapps.io](https://www.shinyapps.io/).

## Replicate the dashboard:

1. Get all files in this repository.
2. On your device, open RStudio from `performance_dashboard.Rproj` file, then open the `global.R` file from the files tab.
3. Prepare a google spreadsheet. You may build a new one or use an existing one. **Notes: the name of the spreadsheet should be the same as the one in the `global.R` file, more precisely on the `drive_get("performance")$id` code part (in this case, the name of the spreadsheet is `performance`), and the name of the main sheet should be `Sheet1`.** If you build a new spreadsheet, just make sure it's following the notes then you can proceed to the next step. However, if you already have your own spreadsheet, follow these steps:
    - Besides its name, make sure the contents of your spreadsheet must follow the following template:
      
      | date | kdRatio | assists | scorePerMinute | cluster_result |
      | ---- | ------- | ------- | -------------- | -------------- |
      | *date* | *number* | *number* | *number* | *number* |

      Columns description:
      * `date`: the gameplay date.
      * `kdRatio`: kill/deaths ratio that means, if a player has 10 kills and 5 deaths, his KD ratio is equal to 2. A KD ratio of 1 means that the player got killed exactly as many times as he successfully eliminated his opponents.
      * `assists`: the number of times a player damages an enemy but a teammate gets the kill.
      * `scorePerMinute`: a measure of how many points players are gaining per unit of time.
      * `cluster_result`: the prediction result from a classification model (leave this column blank).
      
    - Open the `prediction.R` file, and make sure the name of the spreadsheet is already the same as the one in the `drive_get("performance")$id` code part (in this case, the name of the spreadsheet is `performance`). Run the file by clicking `ctrl + A`, then `ctrl + Enter`. Check if the `cluster_result` column is filled. **Notes: There will be an authentication window open twice on your browser, choose the account you want to use and checklist the last option to give access to _See, edit, create, and delete all of your Google Drive files_**.
      <p align="center">
      <img src="https://github.com/nisa-basalamah/performance_dashboard/blob/main/assets/auth.png" alt="./assets/auth.png" width="700"/>
      </p>
    
4. Back to the `global.R` file. Click the <img src="https://github.com/nisa-basalamah/performance_dashboard/blob/main/assets/run_app.png" alt="./assets/run_app.png" width="100"/> button at the top, then the dashboard will open in a new window. If you first time running the file, you will be directed to do the authentication twice in a window open on your browser. Choose the account you want to use and checklist the last option to give access to **_See, edit, create, and delete all of your Google Drive files_**. Only after that step, you can see the full display of the dashboard. (**Notes: If there is no data in the spreadsheet, the dashboard will show lots of red text. The red text will disappear once you enter data or observations into the spreadsheet.**)
   <p align="center">
   <img src="https://github.com/nisa-basalamah/performance_dashboard/blob/main/assets/dashboard1.png" alt="./assets/dashboard1.png" width="700"/>
   <img src="https://github.com/nisa-basalamah/performance_dashboard/blob/main/assets/dashboard1_2.png" alt="./assets/dashboard1_2.png" width="700"/>
   </p>
      
5. To use your dashboard without having to run the program repeatedly as in the previous step, you need to publish the dashboard to [shinyapps.io](https://www.shinyapps.io/). To do so, follow the steps below according to your condition:
    - To publish a dashboard for the first time on **a new shinyapps account**, you need to do some administration steps to connect your account with R (skip this step if you have already done this before):
        * Close the dashboard from the opened window on the last step.
        * On the console tab of the `global.R` file, write this code `install.packages("rsconnect")` and click `Enter`.
        * Login to your [shinyapps.io](https://www.shinyapps.io/) account. On the left, choose Account > Tokens. Click the `Show` button on the Token list, then click `Show secret` and `Copy to clipboard`. Make sure you already copy the command that appears.
          <p align="center">
          <img src="https://github.com/nisa-basalamah/performance_dashboard/blob/main/assets/shiny_token.png" alt="./assets/shiny_token.png" width="700"/>
          </p>
        * Go back to the `global.R` file and paste the command you copied from your shinyapps account, then click `Enter`.
        * Run the app again and proceed to the next point.
        
    - To publish a dashboard for the first time on a shinyapps account that **already connects with R** (if you previously have published the same dashboard, keep using this step but you may see a slightly different display):
        * From the dashboard window opened by clicking the <img src="https://github.com/nisa-basalamah/performance_dashboard/blob/main/assets/run_app.png" alt="./assets/run_app.png" width="100"/> button at the `global.R` file, click the <img src="https://github.com/nisa-basalamah/performance_dashboard/blob/main/assets/publish_button.png" alt="./assets/publish_button.png" width="100"/> button on the top right corner.
        * There will be a new window pop up, uncheck the `prediction.R`, `README.md` file, and `assets` folder from the file lists on the left, and choose the account on the right. Fill in the title field, this will be used and shown in the link to your shiny dashboard. Click <img src="https://github.com/nisa-basalamah/performance_dashboard/blob/main/assets/publish_button.png" alt="./assets/publish_button.png" width="100"/>, then you may have to wait until a new window opened in your browser which shows your dashboard.
          <p align="center">
          <img src="https://github.com/nisa-basalamah/performance_dashboard/blob/main/assets/publish_shiny.png" alt="./assets/publish_shiny.png" width="700"/>
          </p>
   
   Now, you only need to go to your shiny dashboard app link and don't need to run the R file repeatedly to use the dashboard.

## Reference

- [Connect Shiny with Google Drive & Sheets](https://www.jdtrat.com/blog/connect-shiny-google/)
- [`rintrojs` R package](https://github.com/carlganz/rintrojs)
