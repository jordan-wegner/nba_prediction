import pandas as pd 

def lagged_data(data):
    # takes the averaged data as input 
    # will need to update if new columns are added 
    
    hold = data.copy()
    
    print("averaged data shape: {}".format(data.shape))
    
    print("creating the team, season, and player id") 
    ids = data['ID'].str.split('_')
    team_id = [x[0] for x in ids]
    player_id = [x[1] for x in ids]
    season_id = [x[2] for x in ids]
    data['TEAM_ID'] = team_id
    data['PLAYER_ID'] = player_id
    data['SEASON_YEAR'] = season_id
    data['PLAYER_SEASON'] = data['PLAYER_ID'] + '_' + data['SEASON_YEAR']
    data.drop(['TEAM_ID','PLAYER_ID','SEASON_YEAR'],axis=1)
    
    print('averaging data for those players who were traded')
    avg_cols = ['PLAYER_SEASON','MIN','EFG_PCT','FTA_RATE','TM_TOV_PCT','OREB_PCT','OPP_EFG_PCT','OPP_FTA_RATE','OPP_TOV_PCT','OPP_OREB_PCT']
    data_temp = data[avg_cols].copy()
    
    noavg_cols = []
    for x in list(data.columns):
        if x not in avg_cols:
            noavg_cols.append(x)
    
    print('no averaging columns:')
    print(noavg_cols)
    noavg = data[noavg_cols].copy()
    
    print('creating the average')
    data_temp = data_temp.groupby('PLAYER_SEASON').mean().reset_index()
    
    data = data_temp.copy()
    
    lag_cols = ['PLAYER_ID','MIN','EFG_PCT','FTA_RATE','TM_TOV_PCT','OREB_PCT','OPP_EFG_PCT','OPP_FTA_RATE','OPP_TOV_PCT','OPP_OREB_PCT']
    
    print('recreating SEASON_YEAR and PLAYER_ID')
    ids = data['PLAYER_SEASON'].str.split('_')
    player_id = [x[0] for x in ids]
    season_id = [x[1] for x in ids]
    data['PLAYER_ID'] = player_id
    data['SEASON_YEAR'] = season_id
    
    print("sorting data") 
    data = data.sort_values(['PLAYER_ID','SEASON_YEAR']).copy()

    print("lag columns and PLAYER_ID:") 
    print(lag_cols)
    
    nolag_cols = []
    for x in list(data.columns):
        if x not in lag_cols:
            nolag_cols.append(x)
    
    tolag = data[lag_cols].copy()
    nolag = data[nolag_cols].copy()
    
    print("no lag columns")
    print(nolag.columns)
    
    print("lagging the data") 
    lagged = tolag.groupby('PLAYER_ID').shift(1)
    
    print("adding LAST_YEAR_ prefix to column names")
    lagged = lagged.add_prefix("LS_")
    
    print('adding back the other columns')
    lagged_and = pd.concat([lagged,nolag],axis=1)
    
    print('recreating PLAYER_ID')
    ids = lagged_and['PLAYER_SEASON'].str.split('_')
    player_id = [x[0] for x in ids]
    lagged_and['PLAYER_ID'] = player_id
    
    print('adding back the previous year team')
    ids = hold['ID'].str.split('_')
    team_id = [x[0] for x in ids]
    player_id = [x[1] for x in ids]
    season_id = [x[2] for x in ids]
    hold['TEAM_ID'] = team_id
    hold['PLAYER_ID'] = player_id
    hold['SEASON_YEAR'] = season_id
    hold['PLAYER_SEASON'] = hold['PLAYER_ID'] + '_' + hold['SEASON_YEAR']
    hold.drop(['TEAM_ID','PLAYER_ID','SEASON_YEAR'],axis=1)
    
    hold = hold.sort_values('PLAYER_SEASON')
    hold = hold.groupby('PLAYER_SEASON').tail(1)
    
    print('merging')
    lagged_final = lagged_and.merge(hold[['PLAYER_SEASON','TEAM_ID']],how='left',on='PLAYER_SEASON')
    
    return lagged_final