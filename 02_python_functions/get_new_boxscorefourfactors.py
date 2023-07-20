import pandas as pd
import time
import datetime
from datetime import timedelta
from nba_api.stats.endpoints import boxscorefourfactorsv2

def get_new_boxscorefourfactors(gs):
    # takes the game id data as input 
    # returns the four factors data for each player in each game
    h1 = {'Host': 'stats.nba.com', 
               'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:72.0) Gecko/20100101 Firefox/72.0', 
               'Accept': 'application/json, text/plain, */*', 'Accept-Language': 'en-US,en;q=0.5', 
               'Accept-Encoding': 'gzip, deflate, br', 
               'x-nba-stats-origin': 'stats', 
               'x-nba-stats-token': 'true', 
               'Connection': 'keep-alive', 
               'Referer': 'https://stats.nba.com/', 
               'Pragma': 'no-cache', 
               'Cache-Control': 'no-cache'}
    old_bsff = pd.read_csv("/users/jordanwegner/Desktop/nba2/03_data/box_score_four_factors.csv")
    if len(gs[~gs['GAME_ID'].isin(old_bsff['GAME_ID'])])<=0:
        print("No new games to scrape. No update required.")
    else: 
        old_file_id = "/users/jordanwegner/Desktop/nba2/03_data/00_archive/box_score_four_factors_"+ (datetime.datetime.today() - timedelta(1)).strftime('%Y%m%d')+".csv"
        old_bsff.to_csv(old_file_id, index=False)
        bsffs = []
        count = 0
        gs = gs[~gs['GAME_ID'].isin(old_bsff['GAME_ID'])]
        for i in set(gs['GAME_ID']):
            print("Starting: {}".format(i))
            bsff = boxscorefourfactorsv2.BoxScoreFourFactorsV2(game_id=i[1:],headers = h1, timeout=60).get_data_frames()[0]
            bsffs.append(bsff)
            print("Finished: {}".format(i))
            count = count+1
            rem = len(set(gs['GAME_ID']))-count
            print("Remaining: {}".format(rem))
            time.sleep(.6)
        BSFF = pd.concat(bsffs)
        BSFF['GAME_ID'] = 'G'+BSFF['GAME_ID']
        final = pd.concat([old_bsff,BSFF])
        final.to_csv('/users/jordanwegner/Desktop/nba2/03_data/boxscorefourfactors.csv',index=False)
        