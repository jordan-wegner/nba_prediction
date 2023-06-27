import pandas as pd
from nba_api.stats.endpoints import boxscorefourfactorsv2

def hit_boxscorefourfactorsv2(gs):
    # takes the game id data as input 
    # returns the four factors data for each player in each game
    bsffs = []
    for i in gs['GAME_ID']:
        bsff = boxscorefourfactorsv2.BoxScoreFourFactorsV2(game_id=i[1:]).get_data_frames()[0]
        bsffs.append(bsff)
    BSFF = pd.concat(bsffs)
    BSFF['GAME_ID'] = 'G'+BSFF['GAME_ID']
    return BSFF    
