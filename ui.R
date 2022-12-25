dashboardPage(
  
  skin = "black",
  
  # ----- HEADER
  dashboardHeader(
    title = "Performance Analysis"
  ),
  
  # ----- SIDEBAR
  dashboardSidebar(
    introjsUI(),
    
    fluidRow(
      column(
        width=12,
        box(
          width = NULL, background = "black",
          title = "SKILL CHECKER",
          
          # ----- GUIDE 1
          introBox(
            data.step = 1,
            data.intro = p("Insert the gameplay",
                           code("`date`"), ",", code("`kdRatio`"), ",", code("`assists`"), ", and", code("`scorePerMinute`"),
                           "scores in its field. This feature will utilize the model to predict the skill status based on the",
                           code("`kdRatio`"), ",", code("`assists`"), ", and", code("`scorePerMinute`"),
                           "values that have been submitted before."),
            
            # ----- GUIDE 2
            introBox(
              data.step = 2,
              data.intro = p("The default value of the predicted skill status will be", code("`newbie`"), "since the default of the",
                           code("`kdRatio`"), ",", code("`assists`"), ", and", code("`scorePerMinute`"),
                           "values is zero, and so the model predicts it as", code("`newbie`"), "."),
              
              # ----- DYNAMIC STATUS INFO
              infoBox(
                width = NULL, color = "light-blue",
                title = span("skill status", style="color:black"),
                value = span(textOutput(outputId = "status_info"), style="color:black"),
                icon = icon("user"),
                # fill = TRUE
              )
            ),
            
            # ----- date INPUT
            dateInput(inputId = "date_input",
                      label = "Insert date:",
                      value = Sys.Date()),
            
            # ----- kdRatio INPUT
            formatNumericInput(inputId = "kdRatio_input",
                               label = "Insert kdRatio score:",
                               value = 0,
                               format = "dotDecimalCharCommaSeparator"),
            
            # ----- assists INPUT
            formatNumericInput(inputId = "assists_input",
                               label = "Insert assists score:",
                               value = 0,
                               format = "dotDecimalCharCommaSeparator"),
            
            # ----- scorePerMinute INPUT
            formatNumericInput(inputId = "scorePerMinute_input",
                               label = "Insert scorePerMinute score:",
                               value = 0,
                               format = "dotDecimalCharCommaSeparator"),
            
            # ----- SUBMIT ALL DATA
            fluidRow(
              # ----- CHECK ONLY
              column(
                width = 4, #background = "olive",
                
                # ----- GUIDE 3
                introBox(
                  data.step = 3,
                  data.intro = p("The", strong("check button"), "will only do the prediction and display the output at the top."),
                  
                  actionButton(inputId = "check_button",
                               label = strong("Check"))
                )
              ),
              
              # ----- CHECK & SAVE
              column(
                width = 8, #background = "olive",
                
                # ----- GUIDE 4
                introBox(
                  data.step = 4,
                  data.intro = p("The", strong("save button"), "will do the prediction and save it to the main data along with the submitted",
                                 code("date"), ",", code("kdRatio"), ",", code("assists"), ", and", code("scorePerMinute"), "values."),
                  
                  actionButton(inputId = "save_button",
                               label = strong("Save"))
                )
              )
              
            )
          ),
          
          actionButton(inputId = "user_guide",
                       label = "User Guide",
                       icon = icon("circle-question")),
          
          span(strong(em(br(),
                         "DISCLAIMER: This dashboard is part of the Analysing Esports Players’ Skills and Performance project.
                         You may read the full version of the project or try to replicate the dashboard from this link to the",
                         a(href="https://rpubs.com/nisa_basalamah/esports_performance_analysis", "article"), "or the",
                         a(href="https://github.com/nisa-basalamah/performance_dashboard", "GitHub repository"), ".")
                      ),
               style="color:red")
          
        )
      )
    )
  ),
  
  # ----- BODY
  dashboardBody(
    introjsUI(),
    
    # ----- GUIDE 5
    introBox(
      data.step = 5,
      data.intro = p("The performance score based on the data of the latest game the player played."),
      
      # ----- ROW 1
      fluidRow(
        box(
          title = "LATEST GAME PERFORMANCE",
          width = 12, background = "black",
          column(width = 3,
                 infoBox(
                   width = NULL, color = "light-blue",
                   title = "skill status",
                   value = textOutput(outputId = "latest_status"),
                   icon = icon("gamepad"),
                   fill = TRUE
                 )
          ),
          
          column(width = 3,
                 infoBox(
                   width = NULL, color = "light-blue",
                   title = "kdRatio",
                   value = textOutput(outputId = "latest_kdRatio"),
                   icon = icon("skull"),
                   fill = TRUE
                 )
          ),
          
          column(width = 3,
                 infoBox(
                   width = NULL, color = "light-blue",
                   title = "assists",
                   value = textOutput(outputId = "latest_assists"),
                   icon = icon("handshake"),
                   fill = TRUE
                 )
          ),
          
          column(width = 3,
                 infoBox(
                   width = NULL, color = "light-blue",
                   title = "scorePerMinute",
                   value = textOutput(outputId = "latest_scorePerMinute"),
                   icon = icon("star"),
                   fill = TRUE
                 )
          )
        )
      )
    ),
    
    # ----- ROW 2
    fluidRow(
      
      box(
        width = 4, height = 440,
        background = "black",
        title = "OVERALL AVERAGE SCORE",
        
        # ----- GUIDE 6
        introBox(
          data.step = 6,
          data.intro = p("The overall gameplay average score for each variable.
                         This radar chart was built based on the maximum and minimum values of each variable.",
                         tags$ul(
                           tags$li("The outer circle represents the maximum value for each variable"), 
                           tags$li("The small or the middle circle represents the minimum value"), 
                           tags$li("The points shown are the average value for each variable")
                         ),
                         "(Here, the author uses the median to avoid any outliers affecting the result)."),
          
          plotOutput(outputId = "radar_plot",
                     height = 380)
        )
      ),
      
      box(
        width = 8, height = 440,
        background = "black",
        
        # ----- GUIDE 7
        introBox(
          data.step = 7,
          data.intro = p(strong("Insert the start-to-end date input."),
                         "The default value of the end date is from the", code("Sys.Date"),
                         "function, while the default value of the start date is one week before the end date."),
          
          fluidRow(
            box(
              width = 5, height=50, 
              background = "black",
              dateRangeInput(inputId = "input_dateRange",
                             label = "Insert Date Range:",
                             start = Sys.Date()-7,
                             end = Sys.Date())
            )
          )
        ),
        
        # ----- GUIDE 8
        introBox(
          data.step = 8,
          data.intro = p("This line plot will visualize the player's performance score over the submitted date range in the input.",
                         br(), br(),
                         span(
                           strong(em("Warning: If an error appears, it may be caused by an input error or the data is unavailable.
                                     Please re-check your input and data.")),
                           style="color:red"
                         )),
          
          fluidRow(
            box(
              width = 12, background = "black",
              plotlyOutput(outputId = "line_plot",
                           height = 340)
            )
          )
        )
      )
    ),
    
    # ----- ROW 3
    fluidRow(
      
      box(
        width = 12, background = "black",
        title = "GAMEPLAY RECORDS",
        fluidRow(
          column(width = 2,
                 
                 # ----- GUIDE 9
                 introBox(
                   data.step = 9,
                   data.intro = p(strong("Insert the month and year values for the input."),
                                  "The default value for the month and year is from the", code("sys.Date"),
                                  "function. This input will be used by the calendar to show which days a player plays the game and which doesn't."),
                   
                   selectInput(inputId = "input_calendar_month",
                               label = "Choose Month:",
                               choices = month.name,
                               selected = month.name[month(Sys.Date())]),
                   
                   selectInput(inputId = "input_calendar_year",
                               label = "Choose Year:",
                               choices = seq(from = 2020,
                                             to = year(Sys.Date())),
                               selected = year(Sys.Date()))
                 )
          ),
          
          column(width = 10,
                 
                 # ----- GUIDE 10
                 introBox(
                   data.step = 10,
                   data.intro = p(strong("Grey color"), "means the player plays a game on that day, whereas",
                                  strong("white color"), "means the player doesn't play.",
                                  br(), br(),
                                  span(
                                    strong(em("Warning: If an error appears, it may be caused by an input error or the data is unavailable.
                                                Please re-check your input and data.")),
                                    style="color:red"
                                  )),
                   
                   plotOutput(outputId = "calendar")
                 )
          )
        )
      )
    )
  )
  
)