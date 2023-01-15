sidebar <-  dashboardSidebar(
              sidebarMenu(
                menuItem("Weather", tabName = "dashboard", icon =  icon("sun", lib = "font-awesome")),
                menuItem("Horoscope", tabName = "secondsection", icon =  icon("star", lib = "font-awesome")),
                menuItem("AirQuality", tabName = "thirdsection", icon=icon("smog", lib = "font-awesome")),
                menuItem("Bikes rental", tabName = "fourthsection", icon =icon("bicycle", lib = "font-awesome"))
                
              )
            )