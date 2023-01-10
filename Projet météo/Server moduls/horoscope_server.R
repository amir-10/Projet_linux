horoscope_server <- function(input, output){
  # get connected to the db
  signdb <- mongo(collection = "horoscope", db = "AKZN")  
  
  #create a reactive function to the sign chosen
  my_sign <- reactive({
    as.character(input$sign)
    
  })
  
  
  #return the name of the sign
  output$my_sign <- renderText(
    toupper(my_sign())
  ) 
  
  #return the description of the sign
  output$descr <- renderText(
    (signdb$find( paste0( '{ "sign_name" : "', my_sign(), '" }' ) ) )$description
    
  )
  
  #return the image file i want to show
  output$preImage <- renderImage({
    # When input$n is 3, filename is ./images/image3.jpeg
    filename <- normalizePath(file.path("stars/",
                                        paste(my_sign(), '.png', sep='')))
    
    # Return a list containing the filename and alt text
    list(src = filename,
         alt = paste("Selected Sign", my_sign()))
    
  }, deleteFile = FALSE)
  
  
  # filling the infoBoxes and ValueBoxes --
  
  #compatibility -
  output$compatibility <- renderInfoBox(
     infoBox(
       title = "Compatible with ",
       value = (signdb$find( paste0( '{ "sign_name" : "', my_sign(), '" }' ) ) )$compatibility,
       icon = icon("heart"),
       color = "maroon"
     
       #value subtitle fill ...
     )
   
  )
  
  #mood -
  output$mood <- renderInfoBox(
    infoBox(
      title = "today's mood : ",
      value = (signdb$find( paste0( '{ "sign_name" : "', my_sign(), '" }' ) ) )$mood,
      icon = icon("face-smile"),
      color = "yellow"
      
      #color ...
    )
  )
  
  #lucky number
  output$lucky_nb <- renderValueBox(
    valueBox(
      value = (signdb$find( paste0( '{ "sign_name" : "', my_sign(), '" }' ) ) )$lucky_number,
      subtitle =  "is your lucky number ",
      icon = icon("clover"),
      color = "green"
      
    )
  )
  
  #lucky color
  output$lucky_color <- renderInfoBox(
    infoBox(
      value = (signdb$find( paste0( '{ "sign_name" : "', my_sign(), '" }' ) ) )$color,
      title = "today's lucky color ",
      icon = icon("palette"),
      color = "teal"
      #color ...
      
    )
  )
  
  #lucky time
  output$lucky_time <- renderValueBox(
    valueBox(
      value = (signdb$find( paste0( '{ "sign_name" : "', my_sign(), '" }' ) ) )$lucky_time,
      subtitle =  HTML( paste(p("is your lucky time"))),
      icon = icon("clock", lib = "font-awesome"),
      color = "purple"
    )
  )
  
}