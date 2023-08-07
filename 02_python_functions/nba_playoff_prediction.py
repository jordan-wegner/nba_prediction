import get_new_players
import get_new_teams
import get_new_seasons
import get_new_rosters
import get_new_game_ids
import get_new_draft
import get_new_playoff_wins
import get_new_boxscorefourfactors
import averaged_team_data
import lagged_data
import averaged_player_data
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

print("READING: /users/jordanwegner/Desktop/nba2/03_data/playoff_wins.csv")
pwins = pd.read_csv("/users/jordanwegner/Desktop/nba2/03_data/playoff_wins.csv")

print("READING: /users/jordanwegner/Desktop/nba2/03_data/rosters.csv")
rs = pd.read_csv("/users/jordanwegner/Desktop/nba2/03_data/rosters.csv")

print("BEGIN: averaged_player_data.py")
t1 = averaged_player_data.averaged_player_data(bsff,gids,2023,seasons,rs)
print("END: averaged_player_data.py")

print("BEGIN: lagged_data.py")
t2 = lagged_data.lagged_data(t1)
print("END: lagged_data.py")

print("BEGIN: averaged_team_data.py")
t3 = averaged_team_data.averaged_team_data(t2)
print("END: averaged_team_data.py")

print("adding height, weight, and experience")
rs2 = rs.merge(seasons,how='left',left_on='SEASON',right_on='y1')
rs2['TEAM_SEASON'] = rs2['TeamID'].astype(str)+'_'+rs2['id']
rs2['EXP'] = rs2['EXP'].mask(rs2['EXP']=='R',0)
rs2['EXP'] = rs2['EXP'].astype(float)
rsh = rs2[['TEAM_SEASON','HEIGHT_INCHES','WEIGHT','EXP']].groupby('TEAM_SEASON').mean().reset_index()
t4 = t3.merge(rsh,how='left',on='TEAM_SEASON')

print("creating TEAM_SEASON in the playoff wins data")
print('create next season id')
years = pwins['YEAR'].str.split('-')
y1 = [int(x[0])+1 for x in years]
y2 = [str((int(x[0]))+2)[2:4] for x in years]
pwins['y1'] = y1
pwins['y2'] = y2
pwins['TEAM_NEXT_SEASON'] = pwins['TEAM_ID'].astype(str)+'_'+pwins['y1'].astype(str)+'-'+pwins['y2'].astype(str)
pwins = pwins.sort_values('TEAM_NEXT_SEASON')
t5 = t4.merge(pwins[['WIN_PCT','TEAM_NEXT_SEASON']],how='left',left_on='TEAM_SEASON',right_on='TEAM_NEXT_SEASON')
t5.drop('TEAM_NEXT_SEASON',axis=1,inplace=True)
t5 = t5.rename({'WIN_PCT':'LS_WIN_PCT'},axis=1)

print("BEGIN: adding_pwins.py")
t6 = adding_pwins.adding_pwins(t5,pwins)
print("END: adding_pwins.py")

print('adding in team name just to check stuff')
t7 = t6.copy()
ids = t7['TEAM_SEASON'].str.split('_')
t7['TEAM_ID'] = [x[0] for x in ids]
pw = pwins[['TEAM_ID','TEAM_NAME']].astype(str)
pw.drop_duplicates(inplace=True)
old_teams = ['Bobcats','SuperSonics']
pw = pw[~pw['TEAM_NAME'].isin(old_teams)&~((pw['TEAM_NAME']=='Hornets')&(pw['TEAM_ID']=='1610612740'))]
t7 = t7.merge(pw,how='left',on='TEAM_ID')

print('dropping the teams first records')
t8 = t7.dropna(subset=['LS_MIN'])

print("WRITING: /users/jordanwegner/Desktop/nba2/03_data/modeling_data.csv")
t8.to_csv('/users/jordanwegner/Desktop/nba2/03_data/modeling_data.csv',index=False)