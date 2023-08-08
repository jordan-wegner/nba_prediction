import pandas as pd

def adding_pwins(data,playoff_wins):
    # takes the lagged data and the playoff wins as input 
    # outputs playoff wins in with the data set 
    
    print("creating TEAM_SEASON in the playoff wins data")
    playoff_wins['TEAM_SEASON'] = playoff_wins['TEAM_ID'].astype(str)+'_'+playoff_wins['YEAR']
    print("merging with the lagged data set")
    data_and_target = data.merge(playoff_wins[['TEAM_SEASON','PO_WINS']],how='left',on='TEAM_SEASON')
    
    return data_and_target