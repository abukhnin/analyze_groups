# Author: Alexey Bukhnin

library(shiny)

shinyUI(fluidPage(
    navbarPage("Analyze Independent Groups",
    tabPanel("Compare Groups",

    sidebarLayout(
        sidebarPanel(
            helpText("Adjust data file options if needed, then choose the file to load (either local or from the Internet)."),
            helpText("For example choose the file http://dataminingproject.googlecode.com/svn/iris.csv"),
            textInput("fieldSeparator", "Field separator character", value=","),
            textInput("decimalPoint", "Character used for decimal points", value="."),
            fileInput("inputFile", label="Data file"),
            uiOutput("chooseGroupField")
        ),

        mainPanel(
            h3("First rows of data file:"),
            tableOutput("summary"),
            h3("Groups:"),
            textOutput("groups"),
            h3("Result of group comparison with Kruskal-Wallis test:"),
            tableOutput("comparisonResult"),
            helpText("Here '*' marks values with significance level p<0.05, '**' - significance level p<0.01, '***' - significance level p<0.001.")
        )
    )
    ),
    tabPanel("Help",
             HTML("
This application facilitates comparison of several independent groups of objects 
with Kruskal-Wallis test, which is a non-parametric method for testing whether 
samples originate from the same distribution.
See more details on the test at 
<a href=\"http://en.wikipedia.org/wiki/Kruskal-Wallis_one-way_analysis_of_variance\">Wikipedia</a>.
<br/><br/>
To perform analysis:
<ul><li>Switch to 'Compare Groups' tab.</li>
<li>If needed, adjust data file format options: the field separator character and the character used for decimal points.</li>
<li>Choose a data file in CSV format - either local, or from the Internet.</li>
<li>Select the group field, which values represent different object groups to compare.</li>
<li>Analysis results will be present as a table with rows per non-grouping field. 
If the p-value for the particular field is less than the desired significance level (e.g. 0.05), 
then the null hypothesis (that the field values for different groups originate from the same distribution) 
shall be rejected, i.e. the field allows distinguishing between the groups with that significance level.</li>
</ul>
<br/>
For example:
<ul>
<li>Keep default values for the field separator character and the character used for decimal points</li>
<li>Choose the file http://dataminingproject.googlecode.com/svn/iris.csv</li>
<li>Keep 'Species' as the group field</li>
<li>Under 'Result of group comparison with Kruskal-Wallis test' caption, 
you will find a table with p-values for each of four non-grouping fields. 
All p-values will be very small (much smaller than even 0.001), 
which means the groups 'setosa', 'versicolor', and 'virginica' 
can be distinguished by each non-grouping field with significance level p<0.001</li>
                  ")
    )
)))
