navbarPage(
  id = "my_id",
  tags$style("@import url(https://use.fontawesome.com/releases/v6.3.0/css/all.css);"),
  
  # logo
  title = a(div(tags$img(src='psrc-logo.png',
                         style="margin-top: -30px; padding-left: 40px;",
                         height = "80")), 
            href="https://www.psrc.org", target="_blank"),
  
  # navbar height
  tags$head(
    tags$style(HTML('.navbar-nav > li > a, .navbar-brand {
                            padding-top:25px !important; 
                            padding-bottom:0 !important;
                            height: 75px;
                            }
                           .navbar {min-height:25px !important;}'))
  ),
  
  windowTitle = "PSRC Travel Survey Explorer", 
  theme = "styles.css",
  position = "fixed-top",
  
  # tabs ----
 
  tabPanel(title = "Trends", trends_tab_ui('trendsTab')),
  
  tabPanel(title = "Current Demographic Travel", dummy_tab_ui('dummy')),
  
  tags$footer(footer_ui('myFooter'))
  
) # end navbarpage

