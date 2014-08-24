# Author: Alexey Bukhnin

library(shiny)

g_inputData = NULL

shinyServer(function(input, output) {
    observe({
        if (is.null(input$inputFile)){
            g_inputData <<- NULL
            return()
        }
        g_inputData <<- read.csv(input$inputFile$datapath, sep=input$fieldSeparator, dec=input$decimalPoint)
    })
    
    output$chooseGroupField <- renderUI({
        if(is.null(input$inputFile) || is.null(g_inputData)){
            return()
        }
        
        fieldNames <- names(g_inputData)
        
        selectInput("groupField", label="Group field", choices=fieldNames, selected=fieldNames[length(fieldNames)])
    })
    
    output$summary <- renderTable({
        if(is.null(input$inputFile) || is.null(g_inputData)){
            return()
        }
        head(g_inputData)
    })
    
    output$groups <- renderText({
        if(is.null(input$inputFile) || is.null(g_inputData) || is.null(input$groupField)){
            return()
        }
        result <- paste(levels(g_inputData[, input$groupField]), collapse=', ')
        return(result)
    })

    output$comparisonResult <- renderTable({
        if(is.null(input$inputFile) || is.null(g_inputData) || is.null(input$groupField)){
            return()
        }
        compareManyIndependentGroups(g_inputData, input$groupField)
    })
})

pStars <- function(p)
{
    ifelse(p < .001, "***", ifelse(p < .01, "** ", ifelse(p < .05, "* ", " ")))
}

compareManyIndependentGroups <- function(dat, groupField, p=0.05)
{
    groups <- levels(dat[groupField])
    resultP <- c()
    resultStatistic <- c()
    datWithoutGroup <- dat[ , -which(names(dat) %in% c(groupField)), drop=FALSE]
    for (i in seq_len(ncol(datWithoutGroup)))
    {
        name = names(datWithoutGroup)[i]
        testResult <- kruskal.test(datWithoutGroup[, i] ~ dat[, groupField], data=dat)
        resultP <- c(resultP, testResult$p.value)
        resultStatistic <- c(resultStatistic, testResult$statistic)
    }
    resultStatistic <- format(resultStatistic, digits = 5, nsmall = 2)
    resultPFormatted <- format(resultP, digits = 1, nsmall = 3)
    distinctiveVariables <- colnames(datWithoutGroup)[resultP < p]
    distinctiveVariablesStr <- paste(distinctiveVariables, collapse=", ")
    mystars <- pStars(resultP)
    resultPFormatted <- paste(resultPFormatted, mystars, sep="")
    
    result <- rbind(as.numeric(resultStatistic), resultPFormatted)
    rownames(result) <- c("H", "p")
    colnames(result) <- paste(colnames(datWithoutGroup))
    return(t(result))
}
