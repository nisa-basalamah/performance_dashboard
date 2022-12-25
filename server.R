shinyServer(function(input, output, session) {
  
  ## ----- USER GUIDE
  # start introjs when button is pressed with custom options and events
  observeEvent(input$user_guide,
               introjs(session, options = list("nextLabel"="Next",
                                               "prevLabel"="Previous",
                                               "doneLabel"="Done",
                                               "hidePrev" = TRUE,
                                               "showBullets" = FALSE))
  )
  
  ## ----- PLOT 1
  output$radar_plot <- renderPlot({
    
    # data preparation
    cod <- as.data.frame(read_sheet(ss = sheet_id)) # data
    
    cod <- cod %>% 
      mutate(date = as.Date(date),
             cluster_result = as.factor(cluster_result)) %>% 
      mutate_if(is.numeric, round, 2) %>% 
      arrange(date)
    
    radar_data <- rbind(
      # cod[,-c(1,5)] %>% summarise_all(max),
      # cod[,-c(1,5)] %>% summarise_all(min),
      cod[,-c(1,5)] %>% summarise_all(median)
    ) %>% 
      relocate(scorePerMinute) %>% 
      mutate_all(round, 2)
    
    rownames(radar_data) <- c("median")
    
    radar_data <- radar_data %>% 
      rownames_to_column()
    
    radar_data[-1] <- as.data.frame(t(scale(t(radar_data[-1]))))
    
    # build plot
    # plot1 <- radarchart(radar_data,
    #                    cglty = 1, cglcol = "gray",
    #                    pcol = 4, plwd = 2,
    #                    pfcol = rgb(0, 0.4, 1, 0.25))
    
    # ggRadar(data = radar_data[3,],
    #         rescale = FALSE,
    #         colour = "blue",
    #         interactive = TRUE,
    #         grid.max = radar_data[1,],
    #         grid.min = radar_data[2,]
    # )
    
    ggradar(radar_data,
            grid.min = -3, grid.max = 3,
            gridline.mid.colour = "grey",
            label.gridline.min = FALSE,
            label.gridline.mid = FALSE,
            label.gridline.max = FALSE,
            group.line.width = 0.5,
            group.point.size = 2,
            fill = TRUE)

  })
  
  ## ----- PLOT 2
  output$line_plot <- renderPlotly({
    
    # data preparation
    cod <- as.data.frame(read_sheet(ss = sheet_id)) # data
    
    cod <- cod %>% 
      mutate(date = as.Date(date),
             cluster_result = as.factor(cluster_result)) %>% 
      mutate_if(is.numeric, round, 2) %>% 
      arrange(date)
    
    line_data <- cod %>% 
      melt(id.vars=c("date","cluster_result"))
    
    line_data <- line_data %>% 
      mutate(label = glue(
        "Date: {date}
         Score: {value}
         Skill: {cluster_result}"
      ))
    
    # build plot
    plot2 <- ggplot(data = line_data %>%
                      mutate(value = scale(value)) %>%
                      # subset(!(variable %in% c("headshots","scorePerMinute"))) %>%
                      # filter((date >= "2022-12-01") & (date <= "2022-12-07")),
                      filter((date >= input$input_dateRange[1]) & (date <= input$input_dateRange[2])),
                   aes(x = date, y = value, colour = variable)) +
      geom_line() +
      geom_point(aes(text = label)) +
      labs (
        title = "Performance Over Time",
        x = "Date",
        y = "Score"
      ) +
      theme_minimal() +
      theme(
        legend.title = element_blank(),
        # legend.position = "top",
        # legend.direction = "horizontal"
      )
    
    ggplotly(plot2, tooltip = "text")
    
  })
  
  ## ----- PLOT 3
  output$calendar <- renderPlot({
    
    # data preparation
    cod <- as.data.frame(read_sheet(ss = sheet_id)) # data
    
    cod <- cod %>% 
      mutate(date = as.Date(date),
             cluster_result = as.factor(cluster_result)) %>% 
      mutate_if(is.numeric, round, 2) %>% 
      arrange(date)
    
    calendar_data <- cod %>% 
      pad(interval = "day",
          start_val = floor_date(cod$date[1], unit = "month"),
          end_val = ceiling_date(tail(cod$date,1), unit = "month")-1)
    
    calendar_data <- calendar_data %>% 
      mutate(logic = case_when(
        is.na(cluster_result) ~ 0,
        !is.na(cluster_result) ~ 1
      ))
    
    # build plot
    plot3 <- calendR(year = input$input_calendar_year,
                     month = match(input$input_calendar_month, month.name),
                     # text = glue(
                     #   "kdRatio: {calendar_data$kdRatio}
                     #    assists: {calendar_data$assists}
                     #    scorePerMinute: {calendar_data$scorePerMinute}
                     #    Skill: {calendar_data$cluster_result}"
                     # ),
                     special.days = calendar_data %>% 
                       filter((year(date) == input$input_calendar_year) &
                              (month(date) == match(input$input_calendar_month, month.name))) %>% 
                       pull(logic),
                     gradient = TRUE
                     )
    
    # ggplotly(plot3)
    plot3
    
  })

  ## ----- ACTION BUTTON CHECK
  output$status_info <- renderText({
    
    # input from the action button
    input$check_button
    
    # isolate function is used to create dependency on the action button
    isolate({
      # get new data from dashboard input
      new_data <- data.frame(kdRatio = input$kdRatio_input,
                             assists = input$assists_input,
                             scorePerMinute = input$scorePerMinute_input)
      
      # predict status info of new data
      prediction <- predict(object = model, newdata = new_data)
      
      paste(prediction)
      
    })
    
  })
  
  observeEvent(input$save_button, {
    # get new data from dashboard input
    new_data <- data.frame(kdRatio = input$kdRatio_input,
                           assists = input$assists_input,
                           scorePerMinute = input$scorePerMinute_input)
    
    # predict status info of new data
    prediction <- predict(object = model, newdata = new_data)
    
    # combine new data with prediction
    response_data <- cbind(date = input$date_input,
                           new_data,
                           cluster_result = prediction)
    
    # Read our sheet
    values <- read_sheet(ss = sheet_id)
    
    # Check to see if our sheet has any existing data.
    # If not, let's write to it and set up column names. 
    # Otherwise, let's append to it.
    
    if (nrow(values) == 0) {
      sheet_write(data = response_data,
                  ss = sheet_id,
                  sheet = "Sheet1")
    } else {
      sheet_append(data = response_data,
                   ss = sheet_id,
                   sheet = "Sheet1")
    }
    
  })
  
  ## ----- LATEST STATUS OUTPUT
  output$latest_status <- renderText({
    # data preparation
    cod <- as.data.frame(read_sheet(ss = sheet_id)) # data
    
    cod <- cod %>% 
      mutate(date = as.Date(date),
             cluster_result = as.factor(cluster_result)) %>% 
      mutate_if(is.numeric, round, 2) %>% 
      arrange(date)
    
    paste(tail(cod$cluster_result,1))
    
  })
  
  ## ----- LATEST KDRATIO OUTPUT
  output$latest_kdRatio <- renderText({
    # data preparation
    cod <- as.data.frame(read_sheet(ss = sheet_id)) # data
    
    cod <- cod %>% 
      mutate(date = as.Date(date),
             cluster_result = as.factor(cluster_result)) %>% 
      mutate_if(is.numeric, round, 2) %>% 
      arrange(date)
    
    paste(tail(cod$kdRatio,1))
    
  })
  
  ## ----- LATEST ASSISTS OUTPUT
  output$latest_assists <- renderText({
    # data preparation
    cod <- as.data.frame(read_sheet(ss = sheet_id)) # data
    
    cod <- cod %>% 
      mutate(date = as.Date(date),
             cluster_result = as.factor(cluster_result)) %>% 
      mutate_if(is.numeric, round, 2) %>% 
      arrange(date)
    
    paste(tail(cod$assists,1))
    
  })
  
  ## ----- LATEST SCOREPERMINUTE OUTPUT
  output$latest_scorePerMinute <- renderText({
    # data preparation
    cod <- as.data.frame(read_sheet(ss = sheet_id)) # data
    
    cod <- cod %>% 
      mutate(date = as.Date(date),
             cluster_result = as.factor(cluster_result)) %>% 
      mutate_if(is.numeric, round, 2) %>% 
      arrange(date)
    
    paste(tail(cod$scorePerMinute,1))
    
  })
})