import pandas as pd

def averaged_team_data(data):
    # takes the lagged and averaged player data as input 
    print('creating ids and dropping old ones')
    data['TEAM_SEASON'] = data['TEAM_ID']+'_'+data['SEASON_YEAR']
    data.drop(['TEAM_ID','PLAYER_ID','SEASON_YEAR','PLAYER_SEASON'],axis=1,inplace=True)
    print('averaging by TEAM_SEASON')
    df_avg = data.groupby('TEAM_SEASON').mean().reset_index()

    return df_avg 