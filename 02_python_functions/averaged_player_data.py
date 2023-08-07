import pandas as pd 
import numpy as np 

def averaged_player_data(data,game_ids,year,season_data,roster_data):
    # takes the raw data and the game_ids as inputs
    # will need to update if new columns are added 
    # player data is averaged by team and season
    # then, the averaged player data is averaged by team and season 
    
    print("player data shape: {}".format(data.shape))
    
    print("merging seasons to the player data via game_id data frame") 
    df2 = data.merge(game_ids[['GAME_ID','SEASON_YEAR']],how='left',on='GAME_ID').drop_duplicates()
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
    #print("creating the team and season id column") 
    #id_split = df_avg['ID'].str.split('_')
    #team_id = [x[0] for x in id_split]
    #season_id = [x[2] for x in id_split]
    #team_season = [x+'_'+y for x,y in zip(team_id,season_id)]
    #df_avg['TEAM_SEASON'] = team_season
    #df_avg.drop('ID',axis=1,inplace=True)
    #print("averaging by team and season") 
    #df_avg2 = df_avg.groupby('TEAM_SEASON').mean().reset_index()
    
    print('adding in next season rosters')
    rs2 = roster_data.merge(season_data,how='left',left_on='SEASON',right_on='y1')
    rs2 = rs2[rs2['SEASON']==2023][['TeamID','PLAYER_ID','id']].copy()
    rs2['ID'] = rs2['TeamID'].astype(str)+'_'+rs2['PLAYER_ID'].astype(str)+'_'+rs2['id'].astype(str)
    new_season_df = pd.DataFrame({'ID':rs2['ID'],
                       'MIN':np.repeat(np.nan,len(rs2['ID'])),
                       'EFG_PCT':np.repeat(np.nan,len(rs2['ID'])),
                       'FTA_RATE':np.repeat(np.nan,len(rs2['ID'])),
                       'TM_TOV_PCT':np.repeat(np.nan,len(rs2['ID'])),
                       'OREB_PCT':np.repeat(np.nan,len(rs2['ID'])),
                       'OPP_EFG_PCT':np.repeat(np.nan,len(rs2['ID'])),
                       'OPP_FTA_RATE':np.repeat(np.nan,len(rs2['ID'])),
                       'OPP_TOV_PCT':np.repeat(np.nan,len(rs2['ID'])),
                       'OPP_OREB_PCT':np.repeat(np.nan,len(rs2['ID']))})
    avg_final = pd.concat([df_avg,new_season_df])
    
    
    return avg_final