# Display trends table as DT

trends_table_ui <- function(id) {
  ns <- NS(id)
  
  tagList( 
    div(DTOutput(ns('table')), style = 'margin-top: 1rem')
  )
  
}

trends_table_server <- function(id, trendtable, alias) {
 
  moduleServer(id, function(input, output, session) { 
    
    clean_table <- reactive({
      # clean Margin of Error columns and column/row reorder for DT
      
      dt <- trendtable
      
      col <- names(dtype.choice[dtype.choice %in% "MOE"])
      col2 <- names(dtype.choice[dtype.choice %in% "estMOE"])

      # round columns
      dt[, (col) := lapply(.SD, function(x) round(x*100, 1)), .SDcols = col
      ][, (col2) := lapply(.SD, function(x) prettyNum(round(x, 0), big.mark = ",", preserve.width = "none")), .SDcols = col2]
      
      # add symbols
      dt[, (col) := lapply(.SD, function(x) paste0("+/-", as.character(x), "%")), .SDcols = col
      ][, (col2) := lapply(.SD, function(x) paste0("+/-", as.character(x))), .SDcols = col2]
      
      # format survey year column, reorder rows
      dt[, Survey := str_replace_all(Survey, "_", "/")]
      dt <- dt[order(Survey)]
      
      new.colorder <- c('Survey',
                        alias,
                        names(dtype.choice[dtype.choice %in% c("share")]),
                        col,
                        names(dtype.choice[dtype.choice %in% c("estimate")]),
                        col2,
                        names(dtype.choice[dtype.choice %in% c("sample_count")]))
      
      setcolorder(dt,  new.colorder)
      return(dt)
    })
    
    output$table <- renderDT({
      # render DT with some additional column formatting
      
      colors <- list(ltgrey = '#bdbdc3', dkgrey = '#343439')
      
      dt <- clean_table()
      
      fmt.per <- names(dtype.choice[dtype.choice %in% c('share')])
      fmt.num <- names(dtype.choice[dtype.choice %in% c('estimate', 'sample_count')])
      
      DT::datatable(dt,
                    options = list(autoWidth = FALSE,
                                   columnDefs = list(list(className = "dt-center", width = '100px', targets = c(2:ncol(dt))))
                    )
      ) %>%
        formatPercentage(fmt.per, 1) %>%
        formatRound(fmt.num, 0) %>%
        formatStyle(columns = 2:ncol(dt),
                    valueColumns = ncol(dt),
                    color = styleInterval(c(30), c(colors$ltgrey, colors$dkgrey)))
    })
    
  }) # end moduleServer
  
}