#### R Shiny Project 

library(shiny)
library(shinydashboard)
library(plyr)
library(plotrix)
library(ggplot2)
library(plotly)
library(RColorBrewer)
library(dashboardthemes)
library(magrittr)
library(dplyr)
library(lessR)
library(sqldf)


nba <- read.csv('/Users/jordanwegner/Desktop/nba2/predictions/2022-10-17-predictions.csv')
teams <- nba$ab


ui <- dashboardPage(skin = "yellow", 
                    dashboardHeader(title = shinyDashboardLogo(theme = "grey_dark",
                                                               boldText = "NBA Playoff Predictions",
                                                               mainText = "2021-2022 Season",
                                                               badgeText = "Jordan Wegner")),
                    dashboardSidebar(sidebarMenu(menuItem("Matchup Analysis",
                                                          tabName = "mu",
                                                          icon = icon('times')),
                                                 menuItem("Overall Seeding",
                                                          tabName = "os",
                                                          icon = icon("trophy")))),
                    dashboardBody(tabItems(tabItem(tabName = "mu",
                                                   h1("Matchup Analysis"),
                                                   fluidRow(box(selectInput('team1',
                                                                            label = "Home Team",
                                                                            choices = teams,
                                                                            selected = "DAL"),
                                                                imageOutput("logo1"),
                                                                selectInput("team2",
                                                                            label = "Away Team",
                                                                            choices = teams,
                                                                            selected = "LAC"),
                                                                imageOutput("logo2")),
                                                            box(plotOutput("plot1")))
                    ),
                    tabItem(tabName = "os",
                            h1("Overall Seeding"),
                            fluidRow(tableOutput("overall")),
                            fluidRow(textOutput("east_champ")),
                            fluidRow(textOutput("west_champ")),
                            fluidRow(textOutput("atl_champ")),
                            fluidRow(textOutput("ce_champ")),
                            fluidRow(textOutput("ne_champ")),
                            fluidRow(textOutput("sw_champ")),
                            fluidRow(textOutput("nw_champ")),
                            fluidRow(textOutput("pac_champ")),
                            fluidRow(textOutput("nba_champ")))))
)

server <- function(input, output) {
    
    output$plot1 <- renderPlot({
        
        x <- input$team1
        y <- input$team2
        
        team1 <- nba %>% filter(ab == x)
        team2 <- nba %>% filter(ab == y)
        
        wins1 <- team1$pred
        wins2 <- team2$pred
        
        if (wins1 <= 0){
            wins1 <- .01
        }
        if (wins2 <= 0){
            wins2 <- .01
        }
        total_wins <- wins1+wins2
        
        perc1 <- round(wins1/total_wins*100,0)
        perc2 <- round(wins2/total_wins*100,0)
        
        results <- data.frame("Team" = c(x,y), "win_prob" = c(perc1,perc2))
        
        
        # Hole size
        hsize <- 3
        
        results <- results %>% 
            mutate(x = hsize)
        
        ggplot(results, aes(x = hsize, y = win_prob, fill = Team)) +
            geom_col(color = "black") +
            geom_text(aes(label = win_prob),
                      position = position_stack(vjust = 0.5), color = "white") +
            coord_polar(theta = "y") +
            scale_fill_manual(values = c("black","grey")) +
            xlim(c(0.2, hsize + 0.5)) +
            theme(panel.background = element_rect(fill = "white"),
                  panel.grid = element_blank(),
                  axis.title = element_blank(),
                  axis.ticks = element_blank(),
                  axis.text = element_blank()) +
            labs(title = "Win Probabilities")
        
    })
    
    output$logo1 <- renderImage({
        if (input$team1 == "All Teams") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/all.jpg",
                contentType = "image/jpeg",
                alt = "All Teams"
            ))
        } else if (input$team1 == "DAL") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/mavs.png",
                filetype = "image/png",
                alt = "Dallas Mavericks"
            ))
            
        } else if (input$team1 == "CHI") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/bulls.png",
                filetype = "image/png",
                alt = "Chicago Bulls"
            ))
        } else if (input$team1 == "DAL") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/mavs.png",
                filetype = "image/png",
                alt = "Dallas Mavericks"
            ))
        } else if (input$team1 == "ATL") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/hawks.png",
                filetype = "image/png",
                alt = "Atlanta Hawks"
            ))
        } else if (input$team1 == "BOS") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/celtics.png",
                filetype = "image/png",
                alt = "Boston Celtics"
            ))
        } else if (input$team1 == "BRK") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/nets.png",
                filetype = "image/png",
                alt = "Brooklyn Nets"
            ))
        } else if (input$team1 == "CHO") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/hornets.jpg",
                filetype = "image/jpeg",
                alt = "Charlotte Hornets"
            ))
        } else if (input$team1 == "CLE") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/cavs.png",
                filetype = "image/png",
                alt = "Cleveland Caveliers"
            ))
        } else if (input$team1 == "DEN") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/nuggets.png",
                filetype = "image/png",
                alt = "Denver Nuggets"
            ))
        } else if (input$team1 == "DET") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/pistons.png",
                filetype = "image/png",
                alt = "Detroit Pistons"
            ))
        } else if (input$team1 == "GSW") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/warriors.png",
                filetype = "image/png",
                alt = "Golden State Warriors"
            ))
        } else if (input$team1 == "HOU") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/rockets.png",
                filetype = "image/png",
                alt = "Houston Rockets"
            ))
        } else if (input$team1 == "IND") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/pacers.png",
                filetype = "image/png",
                alt = "Indianapolis Pacers"
            ))
        } else if (input$team1 == "LAC") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/clippers.png",
                filetype = "image/png",
                alt = "Los Angeles Clippers"
            ))
        } else if (input$team1 == "LAL") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/lakers.png",
                filetype = "image/png",
                alt = "Los Angeles Lakers"
            ))
        } else if (input$team1 == "MEM") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/grizzlies.png",
                filetype = "image/png",
                alt = "Memphis Grizzlies"
            ))
        } else if (input$team1 == "MIA") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/heat.png",
                filetype = "image/png",
                alt = "Miami Heat"
            ))
        } else if (input$team1 == "MIL") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/bucks.png",
                filetype = "image/png",
                alt = "Milwaukee Bucks"
            ))
        } else if (input$team1 == "MIN") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/timberwolves.png",
                filetype = "image/png",
                alt = "Minnisota Timberwolves"
            ))
        } else if (input$team1 == "NOP") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/pelicans.jpg",
                filetype = "image/jpeg",
                alt = "New Orleans Pelicans"
            ))
        } else if (input$team1 == "NYK") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/trash.png",
                filetype = "image/png",
                alt = "New York Knicks"
            ))
        } else if (input$team1 == "OKC") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/thunder.png",
                filetype = "image/png",
                alt = "Oklahoma City Thunder"
            ))
        } else if (input$team1 == "ORL") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/magic.png",
                filetype = "image/png",
                alt = "Orlando Magic"
            ))
        } else if (input$team1 == "PHI") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/sixers.png",
                filetype = "image/png",
                alt = "Philadelphia 76ers"
            ))
        } else if (input$team1 == "PHO") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/suns.png",
                filetype = "image/png",
                alt = "Phoenix Suns"
            ))
        } else if (input$team1 == "POR") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/blazers.png",
                filetype = "image/png",
                alt = "Portland Trailblazers"
            ))
        } else if (input$team1 == "SAC") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/kings.png",
                filetype = "image/png",
                alt = "Sacramento Kings"
            ))
        } else if (input$team1 == "SAS") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/spurs.png",
                filetype = "image/png",
                alt = "San Anonio Spurs"
            ))
        } else if (input$team1 == "TOR") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/raptors.png",
                filetype = "image/png",
                alt = "Toronto Raptors"
            ))
        } else if (input$team1 == "UTA") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/jazz.png",
                filetype = "image/png",
                alt = "Utah Jazz"
            ))
        } else if (input$team1 == "TOT") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/woj bomb.jpg",
                filetype = "image/jpeg",
                alt = "Traded"
            ))
        } else if (input$team1 == "WAS") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/wizards.png",
                filetype = "image/png",
                alt = "Washington Wizards"
            ))}
        
    }, deleteFile = FALSE)
    
    output$logo2 <- renderImage({
        if (input$team2 == "All Teams") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/all.jpg",
                contentType = "image/jpeg",
                alt = "All Teams"
            ))
        } else if (input$team2 == "DAL") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/mavs.png",
                filetype = "image/png",
                alt = "Dallas Mavericks"
            ))
            
        } else if (input$team2 == "CHI") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/bulls.png",
                filetype = "image/png",
                alt = "Chicago Bulls"
            ))
        } else if (input$team2 == "DAL") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/mavs.png",
                filetype = "image/png",
                alt = "Dallas Mavericks"
            ))
        } else if (input$team2 == "ATL") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/hawks.png",
                filetype = "image/png",
                alt = "Atlanta Hawks"
            ))
        } else if (input$team2 == "BOS") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/celtics.png",
                filetype = "image/png",
                alt = "Boston Celtics"
            ))
        } else if (input$team2 == "BRK") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/nets.png",
                filetype = "image/png",
                alt = "Brooklyn Nets"
            ))
        } else if (input$team2 == "CHO") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/hornets.jpg",
                filetype = "image/jpeg",
                alt = "Charlotte Hornets"
            ))
        } else if (input$team2 == "CLE") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/cavs.png",
                filetype = "image/png",
                alt = "Cleveland Caveliers"
            ))
        } else if (input$team2 == "DEN") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/nuggets.png",
                filetype = "image/png",
                alt = "Denver Nuggets"
            ))
        } else if (input$team2 == "DET") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/pistons.png",
                filetype = "image/png",
                alt = "Detroit Pistons"
            ))
        } else if (input$team2 == "GSW") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/warriors.png",
                filetype = "image/png",
                alt = "Golden State Warriors"
            ))
        } else if (input$team2 == "HOU") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/rockets.png",
                filetype = "image/png",
                alt = "Houston Rockets"
            ))
        } else if (input$team2 == "IND") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/pacers.png",
                filetype = "image/png",
                alt = "Indianapolis Pacers"
            ))
        } else if (input$team2 == "LAC") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/clippers.png",
                filetype = "image/png",
                alt = "Los Angeles Clippers"
            ))
        } else if (input$team2 == "LAL") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/lakers.png",
                filetype = "image/png",
                alt = "Los Angeles Lakers"
            ))
        } else if (input$team2 == "MEM") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/grizzlies.png",
                filetype = "image/png",
                alt = "Memphis Grizzlies"
            ))
        } else if (input$team2 == "MIA") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/heat.png",
                filetype = "image/png",
                alt = "Miami Heat"
            ))
        } else if (input$team2 == "MIL") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/bucks.png",
                filetype = "image/png",
                alt = "Milwaukee Bucks"
            ))
        } else if (input$team2 == "MIN") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/timberwolves.png",
                filetype = "image/png",
                alt = "Minnisota Timberwolves"
            ))
        } else if (input$team2 == "NOP") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/pelicans.jpg",
                filetype = "image/jpeg",
                alt = "New Orleans Pelicans"
            ))
        } else if (input$team2 == "NYK") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/trash.png",
                filetype = "image/png",
                alt = "New York Knicks"
            ))
        } else if (input$team2 == "OKC") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/thunder.png",
                filetype = "image/png",
                alt = "Oklahoma City Thunder"
            ))
        } else if (input$team2 == "ORL") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/magic.png",
                filetype = "image/png",
                alt = "Orlando Magic"
            ))
        } else if (input$team2 == "PHI") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/sixers.png",
                filetype = "image/png",
                alt = "Philadelphia 76ers"
            ))
        } else if (input$team2 == "PHO") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/suns.png",
                filetype = "image/png",
                alt = "Phoenix Suns"
            ))
        } else if (input$team2 == "POR") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/blazers.png",
                filetype = "image/png",
                alt = "Portland Trailblazers"
            ))
        } else if (input$team2 == "SAC") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/kings.png",
                filetype = "image/png",
                alt = "Sacramento Kings"
            ))
        } else if (input$team2 == "SAS") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/spurs.png",
                filetype = "image/png",
                alt = "San Anonio Spurs"
            ))
        } else if (input$team2 == "TOR") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/raptors.png",
                filetype = "image/png",
                alt = "Toronto Raptors"
            ))
        } else if (input$team2 == "UTA") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/jazz.png",
                filetype = "image/png",
                alt = "Utah Jazz"
            ))
        } else if (input$team2 == "TOT") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/woj bomb.jpg",
                filetype = "image/jpeg",
                alt = "Traded"
            ))
        } else if (input$team2 == "WAS") {
            return(list(
                src = "/Users/jordanwegner/Desktop/nba2/logos/wizards.png",
                filetype = "image/png",
                alt = "Washington Wizards"
            ))}
        
    }, deleteFile = FALSE)
    
    output$overall <- renderTable({
        
        ranked_e <- sqldf("SELECT ab FROM nba WHERE conf = 'East' LIMIT 8")
        ranked_w <- sqldf("SELECT ab FROM nba WHERE conf = 'West' LIMIT 8")
        
        seeds <- data.frame(ranked_e, ranked_w, c(1:8))
        colnames(seeds) <- c("Eastern Conference","Western Conference","Seed")
        
        seeds
        
    })
    
    output$east_champ <- renderText({
        
        champ <- sqldf("SELECT ab FROM nba 
                  WHERE conf = 'East' 
                  ORDER BY pred DESC 
                  LIMIT 1")
        
        print(paste("Eastern Conference Champion:", champ))
        
    })
    
    output$west_champ <- renderText({
        
        champ <- sqldf("SELECT ab FROM nba 
                  WHERE conf = 'West' 
                  ORDER BY pred DESC 
                  LIMIT 1")
        
        print(paste("Western Conference Champion:", champ))
    })
    
    output$atl_champ <- renderText({
        
        champ <- sqldf("SELECT ab FROM nba 
                  WHERE div = 'Atlantic' 
                  ORDER BY pred DESC 
                  LIMIT 1")
        print(paste("Atlantic Division Champion:", champ))
    })
    
    output$se_champ <- renderText({
        
        champ <- sqldf("SELECT ab FROM nba 
                  WHERE div = 'Southeast' 
                  ORDER BY pred DESC 
                  LIMIT 1")
        print(paste("Southeast Division Champion:", champ))
    })
    
    output$ce_champ <- renderText({
        
        champ <- sqldf("SELECT ab FROM nba 
                  WHERE div = 'Central' 
                  ORDER BY pred DESC 
                  LIMIT 1")
        print(paste("Central Division Champion:", champ))
    })
    
    output$sw_champ <- renderText({
        
        champ <- sqldf("SELECT ab FROM nba 
                  WHERE div = 'Southwest' 
                  ORDER BY pred DESC 
                  LIMIT 1")
        print(paste("Southwest Division Champion:", champ))
        
    })
    
    output$pac_champ <- renderText({
        
        champ <- sqldf("SELECT ab FROM nba 
                  WHERE div = 'Pacific' 
                  ORDER BY pred DESC 
                  LIMIT 1")
        
        print(paste("Pacific Division Champion:", champ))
    })
    
    output$nw_champ <- renderText({
        
        champ <- sqldf("SELECT ab FROM nba 
                  WHERE div = 'Northwest' 
                  ORDER BY pred DESC 
                  LIMIT 1")
        print(paste("Northwest Division Champion:", champ))
        
    })
    
    output$nba_champ <- renderText({
        
        champ <- sqldf("SELECT ab FROM nba 
                  ORDER BY pred DESC 
                  LIMIT 1")
        print(paste("NBA CHAMPION:", champ))
        
    })
    
}


shinyApp(ui, server)
