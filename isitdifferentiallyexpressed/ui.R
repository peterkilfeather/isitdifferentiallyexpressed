library(shiny)
library(waiter)
library(shinydashboard)
library(DT)
library(shinycssloaders)
library(ggrepel)
library(cowplot)
library(IHW)

library(DESeq2)
library(tidyverse)

library(ggpubr)

# Define UI for application that draws a histogram
header <- dashboardHeader(title = "Is it differentially expressed?",
                          titleWidth = 300)

sidebar <- dashboardSidebar(width = 175,
                            sidebarMenu(
                                menuItem(
                                    "By gene", 
                                    tabName = "byGeneTab", 
                                    icon = icon("chart-bar")
                                ),
                                menuItem(
                                    "By dataset",
                                    tabName = "byDatasetTab",
                                    icon = icon("table")
                                )
                            ))
body <- dashboardBody(
    tabItems(tabItem(
        tabName = "byDatasetTab",
    fluidPage(tags$head(includeHTML(("analytics/google-analytics.html"))), # google analytics
              use_waiter(), # waiter init
              waiter_show_on_load(html = spin_fading_circles()), # waiter loading screen
              fluidRow(column(
        width = 3,
        box(
            title = "Select Data", 
            tagList(
                selectizeInput(
                    inputId = "dds_select", 
                    label = "Select dataset", 
                    choices = c("SNCA A53T and Triplication" = "dds_snca", 
                                "GBA N370S" = "dds_gba", 
                                "LRRK2 G2019S" = "dds_lrrk2", 
                                "TRAP Enrichment" = "dds_TRAP_ALL", 
                                "TRAP Age/Genotype/Region" = "dds_TRAP_IP")
                ),
                selectizeInput(
                    inputId = "comparison_select", 
                    label = "Select a comparison", 
                    choices = NULL
                ),
                sliderInput(
                    inputId = "baseMean_select", 
                    label = "Filter genes below count value",
                    value = 100, 
                    min = 0, 
                    max = 1000, 
                    step = 25
                ), 
                checkboxInput(
                    inputId = "signif_only", 
                    label = "Show only significant", 
                    value = TRUE
                )
            ), 
            width = TRUE, 
            solidHeader = TRUE
        )
        
    ), 
    column(
        width = 9, 
        box(
            title = "Results Table", 
            tagList(
                tags$div(class="header", checked=NA,
                         tags$b("Click a row to plot expression"), 
                         tags$br(" ")),
                shinycssloaders::withSpinner(DT::dataTableOutput("results_table"))
            ),
            width = TRUE, 
            solidHeader = TRUE
        ), 
        box(
            title = "Expression Plot",
            plotOutput("scatterPlot"),
            width = TRUE,
            solidHeader = TRUE
        )
    )
    )
    )
), 
tabItem(
    tabName = "byGeneTab",
    fluidPage(fluidRow(column(
        width = 3,
        box(
            title = "Enter gene of interest", 
            width = TRUE, 
            solidHeader = TRUE,
            tagList(
                selectizeInput(
                    inputId = "byGene_gene_select", 
                    label = "Select or type in a gene", 
                    choices = NULL
                )
            )
        )
    ), 
    column(
        width = 3, 
        box(
            title = "Human comparisons", 
            width = TRUE, 
            solidHeader = TRUE, 
            tagList(
                uiOutput("human_homolog_select"),
                htmlOutput(
                    outputId = "signif_check_human"
                )
            )
        ),
        box(
            title = "Mouse expression", 
            width = TRUE, 
            solidHeader = TRUE, 
            tagList(
                uiOutput("mouse_homolog_select"),
                htmlOutput(
                    outputId = "enrichment_check_mouse"
                )
            )
        ),
        box(
            title = "Mouse comparisons", 
            width = TRUE, 
            solidHeader = TRUE, 
            tagList(
                htmlOutput(
                    outputId = "signif_check_mouse"
                )
            )
        )
    ), 
    column(
        width = 6, 
        box(
            title = "Plot of expression", 
            width = TRUE, 
            solidHeader = TRUE, 
            tagList(
                selectizeInput(
                    inputId = "byGene_comparison_select", 
                    label = "Show expression plot", 
                    choices = NULL
                ),
                # conditionalPanel(
                #     condition = "input.byGene_comparison_select == 'SNCA Ageing'", 
                #     checkboxInput(
                #         inputId = "brent_mode", 
                #         label = "Brent mode", 
                #         value = TRUE
                #     )
                # ), 
                # textOutput(outputId = "byGene_debug"),
                plotOutput(
                    "byGene_scatterPlot"
                    ), 
                dataTableOutput(
                    "byGene_resultTable"
                )
            )
        )
    )
    )
    )
)
)
)


shinyUI(dashboardPage(header, 
                      sidebar, 
                      body)
)
