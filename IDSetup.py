def IDSetup(gids_data,rosters_data):
    # takes the gids data and rosters data as input 
    # outputs the rosters with the game ids 
    
    # team season id to the rosters data 
    rosters_data['TEAM_SEASON'] = rosters_data['TeamID'].astype(str)+'_'+rosters_data['SEASON'].astype(str)
    # need to go from long to wide on the game id table 
    # season to the gids data 
    gids_data['y1'] = [i[0:4] for i in gids_data['SEASON_YEAR']]
    # team season id to the gids data 
    gids_data['TEAM_SEASON'] = gids_data['TEAM_ID'].astype(str)+'_'+gids_data['y1']
    # adding a game number to the game id data 
    gids_data['TSI'] = gids_data.groupby('TEAM_SEASON').cumcount()+1
    # adds GAME_ prefix to the game number 
    gids_data['GAME_NUMBER'] = 'GAME_'+gids_data['TSI'].astype(str)
    # pivots the game id data to wide form for merging  
    gids_data_wide = pd.pivot(data=gids_data,index='TEAM_SEASON',columns='GAME_NUMBER',values='GAME_ID')
    # merges with roster data 
    rosters_gids = rosters_data.merge(gids_data_wide,how='left',on='TEAM_SEASON')
    # returns the rosters with the game ids 
    return rosters_gids
