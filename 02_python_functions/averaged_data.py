import pandas as pd
 
def averaged_data(data,game_ids):
    # takes the raw data and the game_ids as inputs
    # will need to update if new columns are added
    # player data is averaged by team and season
    # then, the averaged player data is averaged by team and season
    
    print("player data shape: {}".format(data.shape))
   
    print("merging seasons to the player data via game_id data frame")
    df2 = data.merge(gids[['GAME_ID','SEASON_YEAR']],how='left',on='GAME_ID').drop_duplicates()
    print("dropping duplicates")
    print("new shape (should match the old one): {}".format(df2.shape))
    drops = ['GAME_ID','TEAM_ABBREVIATION','TEAM_CITY','PLAYER_NAME','NICKNAME','START_POSITION','COMMENT']
    avg_columns = ['MIN','EFG_PCT','FTA_RATE','TM_TOV_PCT','OREB_PCT','OPP_FTA_RATE','OPP_TOV_PCT','OPP_OREB_PCT']
    print("columns to drop:")
    print(drops)
    print("columns to average:")
    print(avg_columns)
    df3 = df2.drop(drops,axis=1).copy()
    print("Formatting MIN column to float")
    df3['MIN'] = df3['MIN'].astype(str)
    df3['MIN'] = [x.split(':')[0] for x in df3['MIN']]
    df3['MIN'] = df3['MIN'].mask(df3['MIN']=='nan',0)
    df3['MIN'] = df3['MIN'].astype(float)
    print("creating ID column")
    df3['ID'] = df3['TEAM_ID'].astype(str)+'_'+df3['PLAYER_ID'].astype(str)+'_'+df3['SEASON_YEAR'].astype(str)
    df3.drop(['TEAM_ID','PLAYER_ID','SEASON_YEAR'],axis=1,inplace=True)
    print("averaging by team, player, and season IDs")
    df_avg = df3.groupby('ID').mean().reset_index()
    print("creating the team and season id column")
    id_split = df_avg['ID'].str.split('_')
    team_id = [x[0] for x in id_split]
    season_id = [x[2] for x in id_split]
    team_season = [x+'_'+y for x,y in zip(team_id,season_id)]
    df_avg['TEAM_SEASON'] = team_season
    df_avg.drop('ID',axis=1,inplace=True)
    print("averaging by team and season")
    df_avg2 = df_avg.groupby('TEAM_SEASON').mean().reset_index()
   
    return df_avg2