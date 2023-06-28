import pandas as pd
import numpy as np
import datetime
from datetime import timedelta
 
from nba_api.stats.endpoints import drafthistory
 
def get_new_draft():
    # no input
    old_draft = pd.read_csv("/users/jordanwegner/Desktop/nba2/03_data/draft.csv")
    new_draft = drafthistory.DraftHistory().get_data_frames()[0]
    if old_draft.shape[0]>=new_draft.shape[0]:
        print ("No new teams to add. No update required.")
    else:
        old_file_id = "/users/jordanwegner/Desktop/nba2/03_data/00_archive/draft_"+ (datetime.datetime.today() - timedelta(1)).strftime('%Y%m%d')+".csv"
        old_draft.to_csv(old_file_id, index=False)
        new_draft = new_draft[~new_draft['SEASON'].isin(old_draft['SEASON'])].copy()
        updated_draft = pd.concat([old_draft, new_draft])
        print ("{} new players added to the data set.".format(new_draft.shape[0]))
        print ("draft.csv now has {} players.".format(updated_draft.shape[0]))
        updated_draft.to_csv('/users/jordanwegner/Desktop/nba2/03_data/draft.csv',index=False)
 
