import get_new_players
import get_new_teams
import get_new_seasons
import get_new_rosters

import pandas as pd
import numpy as np 

# Main Script

print("BEGIN: get_new_players.py")
get_new_players.get_new_players()
print("END: get_new_players.py")

print("BEGIN: get_new_teams.py")
get_new_teams.get_new_teams()
print("END: get_new_teams.py")

print("BEGIN: get_new_seasons.py")
get_new_seasons.get_new_seasons()
print("END: get_new_seasons.py")

print("READING: /users/jordanwegner/Desktop/nba2/03_data/seasons.csv")
seasons = pd.read_csv("/users/jordanwegner/Desktop/nba2/03_data/seasons.csv")
print("READING: /users/jordanwegner/Desktop/nba2/03_data/teams.csv")
teams = pd.read_csv("/users/jordanwegner/Desktop/nba2/03_data/teams.csv")

print("BEGIN: get_new_rosters.py")
get_new_rosters.get_new_rosters(seasons,teams)
print("END: get_new_rosters.py")

print("READING: /users/jordanwegner/Desktop/nba2/03_data/rosters.csv")
rosters = pd.read_csv("/users/jordanwegner/Desktop/nba2/03_data/rosters.csv")

