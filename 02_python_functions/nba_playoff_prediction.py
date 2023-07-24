import get_new_players
import get_new_teams
import get_new_seasons
import get_new_rosters
import get_new_game_ids
import get_new_draft
import get_new_playoff_wins
import get_new_boxscorefourfactors
import averaged_data
import lagged_data
import adding_pwins

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
#get_new_rosters.get_new_rosters(seasons,teams)
print("END: get_new_rosters.py")

print("BEGIN: get_new_game_ids.py")
get_new_game_ids.get_new_game_ids()
print("END: get_new_game_ids.py")

print("BEGIN: get_new_draft.py")
get_new_draft.get_new_draft()
print("END: get_new_draft.py") 

print("BEGIN: get_new_playoff_wins.py")
get_new_playoff_wins.get_new_playoff_wins()
print("END: get_new_playoff_wins.py") 

print("READING: /users/jordanwegner/Desktop/nba2/03_data/game_ids.csv")
gids = pd.read_csv("/users/jordanwegner/Desktop/nba2/03_data/game_ids.csv")

print("BEGIN: get_new_boxscorefourfactors.py")
gotten_or_error = ['G0020300778'] # ids to skip 
get_new_boxscorefourfactors.get_new_boxscorefourfactors(gids,gotten_or_error)
print("END: get_new_boxscorefourfactors.py")

print("READING: /users/jordanwegner/Desktop/nba2/03_data/box_score_four_factors.csv")
bsff = pd.read_csv("/users/jordanwegner/Desktop/nba2/03_data/box_score_four_factors.csv")

# THIS IS ALL BACKWARDS! I NEED TO LAG THE DATA BEFORE COMBINING BY TEAM BECAUSE I AM INTERESTED IN PLAYER CONTRIBUTIONS ON NEW TEAMS


print("BEGIN: averaged_data.py")
t1 = averaged_data.averaged_data(bsff,gids)
print("END: averaged_data.py")

print("Adding in non-average predictors")

print("adding win percentage from last year from payoff_wins.csv")
print("READING: /users/jordanwegner/Desktop/nba2/03_data/playoff_wins.csv")
pwins = pd.read_csv("/users/jordanwegner/Desktop/nba2/03_data/playoff_wins.csv")
print("creating TEAM_SEASON in the playoff wins data")
pwins['TEAM_SEASON'] = pwins['TEAM_ID'].astype(str)+'_'+pwins['YEAR']
print("merging with the averaged data set")
t1 = t1.merge(pwins[['TEAM_SEASON','WIN_PCT']],how='left',on='TEAM_SEASON')

print("BEGIN: lagged_data.py")
t2 = lagged_data.lagged_data(t1)
print("END: lagged_data.py")
print("BEGIN: adding_pwins.py")
t3 = adding_pwins.adding_pwins(t2,pwins)
print("END: adding_pwins.py")

print("adding height, weight, and experience from rosters.csv")
print("READING: /users/jordanwegner/Desktop/nba2/03_data/rosters.csv")
rs = pd.read_csv("/users/jordanwegner/Desktop/nba2/03_data/rosters.csv")

print("merging with the seasons data")
rs = rs.merge(seasons,how='left',left_on='SEASON',right_on='y1')
print("creating the TEAM_SEASON id")
rs['TEAM_SEASON'] = rs['TeamID'].astype(str)+'_'+rs['id']
print("creating EXP")
rs['EXP'] = rs['EXP'].mask(rs['EXP']=='R',0)
rs['EXP'] = rs['EXP'].astype(float)
print("averaging experience, height, and weight")
rsh = rs[['TEAM_SEASON','HEIGHT_INCHES','WEIGHT','EXP']].groupby('TEAM_SEASON').mean().reset_index()
print("merging with the main data")
t4 = t3.merge(rsh,how='left',on='TEAM_SEASON')
print("Averaged and Lagged Data Shape: {}".format(t4.shape))

print("Writing averaged and lagged data as /users/jordanwegner/Desktop/nba2/03_data/averaged_lagged.csv")
t4.to_csv("/users/jordanwegner/Desktop/nba2/03_data/averaged_lagged.csv",index=False)