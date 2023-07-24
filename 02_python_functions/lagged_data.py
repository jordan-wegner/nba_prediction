import pandas as pd
 
def lagged_data(data):
    # takes the averaged data as input
    # will need to update if new columns are added
    
    print("averaged data shape: {}".format(data.shape))
   
    print("creating the team and season id")
    ids = data['TEAM_SEASON'].str.split('_')
    team_id = [x[0] for x in ids]
    season_id = [x[1] for x in ids]
    data['TEAM_ID'] = team_id
    data['SEASON_YEAR'] = season_id
   
    lag_cols = ['TEAM_ID','MIN','EFG_PCT','FTA_RATE','TM_TOV_PCT','OREB_PCT','OPP_EFG_PCT','OPP_FTA_RATE','OPP_TOV_PCT','OPP_OREB_PCT']
   
    print("sorting data")
    data = data.sort_values(['TEAM_SEASON','SEASON_YEAR']).copy()
   
    print("lag columns and TEAM_SEASON:")
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
    lagged = tolag.groupby('TEAM_ID').shift(1)
   
    print("adding LAST_YEAR_ prefix to column names")
    lagged = lagged.add_prefix("LS_")
   
    print('adding back the other columns')
    lagged_and = pd.concat([lagged,nolag],axis=1)
   
    return lagged_and